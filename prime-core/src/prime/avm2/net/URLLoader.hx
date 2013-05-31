/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.avm2.net;
 import flash.net.URLLoaderDataFormat;
 import flash.net.URLRequest;

 private typedef BytesData = #if (flash9 || nme) flash.utils.ByteArray  #else haxe.io.BytesData #end;

 import prime.bindable.Bindable;
 import prime.core.events.LoaderEvents;

 import prime.net.CommunicationType;
 import prime.net.ICommunicator;
 import prime.net.RequestMethod;
 import prime.net.URLVariables;

 import prime.types.Number;
 import prime.types.URI;
 import prime.utils.FastArray;
#if debug
  using prime.net.HttpStatusCodes;
#end
  using prime.utils.Bind;
  using prime.utils.FastArray;
  using prime.utils.NumberUtil;
  using Std;


private typedef FlashLoader = flash.net.URLLoader;


/**
 * AVM2 URLLoader implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 04, 2010
 */
class URLLoader implements ICommunicator
{
	//
	// URLLOADER QUEUE
	//
	
	/**
	 * queue with urlloaders that are waiting to load until other URLLoaders
	 * are finished (FIFO).
	 */
	private static var queue:FastArray<URLLoader>	= FastArrayUtil.create();
	/**
	 * max URLLoaders loading at the same time. If this number is reached, the
	 * other URLLoaders will wait in the queue
	 */
	private static inline var MAX_CONNECTIONS		= 30;
	/**
	 * number of active load processes
	 */
	private static		  var CONNECTIONS			= 0;
	
	
	private static inline function loadSlotAvailable () 		: Bool	{ return CONNECTIONS < MAX_CONNECTIONS; }
	private static inline function queueIsEmpty ()				: Bool	{ return queue.length == 0; }
	private static inline function openNextConnection ()		: Void	{ if (!queueIsEmpty() && loadSlotAvailable()) { var n = queue.shift(); n.loadRequest(n.lastRequest); } }
	private static inline function addToQueue (l:URLLoader)		: Void	{ queue.push(l); }
	private static inline function removeFromQueue (l:URLLoader): Void	{ queue.removeItem(l); }
	private static inline function addConnection ()				: Void	{ CONNECTIONS++; }
	private static inline function removeConnection ()			: Void	{ CONNECTIONS--; openNextConnection(); }
	
	
	
	//
	// URLLOADER IMPLEMENTATION
	//
	
	public static inline var STARTED	= 1 << 0;
	public static inline var QUEUED		= 1 << 1;
	public static inline var LOADING	= 1 << 2;
	public static inline var COMPLETED	= 1 << 3;
	
	public  var events			(default,			null)			: LoaderSignals;
	public  var bytesProgress	(get_bytesProgress,	null)			: Int;
	public  var bytesTotal		(get_bytesTotal,	null)			: Int;
	public  var length			(default,			never)			: Null<Bindable<Int>>;
	public  var type			(default,			null)			: CommunicationType;
	
	public  var isQueued		(default,			null)			: Bool;
	public  var isStarted		(default,			null)			: Bool;
	private var isFinished											: Bool;
	
	@:isVar public  var data	(get_data,			set_data)		: Dynamic;
	public  var bytes			(get_bytes,			set_bytes)		: BytesData;
	public  var dataFormat		(get_dataFormat,	set_dataFormat)	: URLLoaderDataFormat;
	private var loader			: FlashLoader;
#if debug
	private var uri				: URI;
#end
	
	
	public function new (loader:FlashLoader = null)
	{
		if (loader == null)
		{
			this.loader = new FlashLoader();
			setBinary();
		}
		else
		{
			this.loader	= loader;
		}
		
		bytesProgress	= bytesTotal = Number.INT_NOT_SET;
		events			= new LoaderEvents(this.loader);
		
		setStarted	.on( events.load.started, 	 this );
		setFinished	.on( events.load.completed,  this );
		unsetStarted.on( events.load.error, 	 this );
		unsetStarted.on( events.unloaded,		 this );
		
//#if debug	trackError.on( events.load.error, this ); #end
//#if debug	trackHttpStatus.on( events.httpStatus, this ); #end		
//#if debug	trackCompleted.on( events.load.completed, this ); #end
	}
	
	
	public function dispose ()
	{
		if (isStarted)
			close();
		
		if (isQueued)
			removeFromQueue(this);
		
		events.dispose();
		events	= null;
		type	= null;
		loader	= null;
		(untyped this).data	= null;
#if debug	uri	= null; #end
	}
	
	public function requestBinary (uri:URI, method:RequestMethod = null) 
	{
		setBinary();
		request(uri, method);
	}

	
	public function sendBinary		(uri:URI, mimetype:String = "application/octet-stream")
	{
			this.type	= CommunicationType.sending;
#if debug	this.uri	= uri; #end
		
		var request		= uri.toRequest(RequestMethod.post);
		request.data	= bytes;
		request.requestHeaders.push(new flash.net.URLRequestHeader("Content-type", mimetype));
		request.requestHeaders.push(new flash.net.URLRequestHeader("Cache-Control", "no-cache"));
	//	request.requestHeaders.push(new flash.net.URLRequestHeader("Content-Length", bytes.length.string()));	<-- not allowed in as3
		
		loadRequest(request);
	}
	
	
	public function postForm 		(uri:URI, vars:URLVariables)
	{
			this.type	= CommunicationType.sending;
#if debug	this.uri	= uri; #end
		
		var request		= uri.toRequest(RequestMethod.post);
		request.requestHeaders.push(new flash.net.URLRequestHeader("Content-type", "multipart/form-data"));
		request.data   = vars;
		
		setBinary();
		loadRequest(request);
	}
	
	
	public #if !noinline inline #end function request (v:URI, method:RequestMethod = null)
	{
#if debug
		var total:Int = (untyped this).bytesTotal;
		Assert.that(total.notSet() || total == 0, this.toString()+"; "+v );
	 	uri	= v;
#end
		this.type = CommunicationType.loading;
		return loadRequest(v.toRequest());
	}
	
	
	private var lastRequest : URLRequest;
	
	private function loadRequest(request:URLRequest)
	{
		if (isStarted)
			close();
		
		isFinished = false;
		if (isQueued) {
			removeFromQueue(this);
			isQueued = false;
		}
		
		if (loadSlotAvailable())
		{
			isStarted = true;
			addConnection();
			loader.load(request);
		}
		else
		{
			lastRequest = request;
			addToQueue(this);
			isQueued = true;
		}
		
	//	trace(CONNECTIONS + " / "+MAX_CONNECTIONS+"; queue: "+queue.length+"; "+request.url+isQueued);
	}
	
	
	public function close ()
	{
		//loader will throw an error if it wasn't loading
		try {
			loader.close();
		} catch(e:Dynamic) {}

		isStarted	= false;
		bytesTotal	= bytesProgress = Number.INT_NOT_SET;
		type		= null;
#if debug	uri		= null; #end
		events.unloaded.send();
	}
	
	
	public #if !noinline inline #end function isCompleted ()			{ return isFinished; } //bytesTotal > 0 && bytesProgress >= bytesTotal; } <-- unreliabable since loaded bytes can be correct before the completed event is fired
	public #if !noinline inline #end function isInProgress ()			{ return isStarted && !isCompleted(); }
	
	public #if !noinline inline #end function isBinary ()		: Bool	{ return loader.dataFormat == URLLoaderDataFormat.BINARY; }
	public #if !noinline inline #end function isText ()		: Bool	{ return loader.dataFormat == URLLoaderDataFormat.TEXT; }
	public #if !noinline inline #end function isVariables ()	: Bool	{ return loader.dataFormat == URLLoaderDataFormat.VARIABLES; }
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function get_bytesProgress ()	{ return bytesProgress.isSet()	? bytesProgress	: loader.bytesLoaded; }
	private inline function get_bytesTotal ()		{ return bytesTotal.isSet()  	? bytesTotal	: loader.bytesTotal; }
	private inline function get_data ()				{ return data != null			? data			: loader.data; }
	public  inline function get_rawData ()			{ return loader.data; }
//	private inline function get_length ()			{ return 1; }
	
	private inline function get_dataFormat ()		{ return loader.dataFormat; }
	private inline function set_dataFormat (v)		{ return loader.dataFormat  = v; }
	
	
	private  function set_data (v)
	{
		if (data != v)
		{
			if (data != null && isStarted)
				close();
			
			data = v;
			
			if (v != null) {
				if		(Std.is(v, URLVariables))	setVariables();
				else if (Std.is(v, BytesData))		setBinary();
				else								setText();
			}
			bytesProgress = bytesTotal = Number.INT_NOT_SET;
		}
		return v;
	}
	
	
	private inline function get_bytes () : BytesData	{ return isBinary() ? cast(data, BytesData) : null; }
	private inline function set_bytes (v:BytesData)
	{
		data = v;
		
		if (v != null)
			bytesProgress = bytesTotal = v.length;
		
		return v;
	}
	
	
	public #if !noinline inline #end function setBinary ()		: Void		{ loader.dataFormat = URLLoaderDataFormat.BINARY; }
	public #if !noinline inline #end function setText ()		: Void		{ loader.dataFormat = URLLoaderDataFormat.TEXT; }
	public #if !noinline inline #end function setVariables ()	: Void		{ loader.dataFormat = URLLoaderDataFormat.VARIABLES; }
	
	
	//
	// EVENTHANDLERS
	//
	
	private inline function setStarted ()	{ isStarted = true; }
	private inline function setFinished ()	{ unsetStarted(); isFinished = true; }
	private inline function unsetStarted ()	{ isStarted = false; removeConnection(); }
	
#if debug
	public function toString ()
	{
		return "URLLoader("+bytesProgress+" / "+bytesTotal + (isStarted ? " - started" : "") + (isCompleted() ? " - completed" : "") + (isInProgress() ? " - progress" : "") + "; " + loader.dataFormat + "; "+uri+")";
	}
	
//	private function trackError ()		{ trace(loader.data); }
//	private function trackHttpStatus (status:Int)		{ trace(status.read()+" => "+uri+"[ "+bytesProgress+" / "+ bytesTotal+" ]; type: "+type+"; format: "+dataFormat+"; "+loader.data); }
//	private function trackCompleted ()					{ trace(uri+"[ "+bytesProgress+" / "+ bytesTotal+" ]; type: "+type+"; format: "+dataFormat+"; "+loader.data); }
#end
}