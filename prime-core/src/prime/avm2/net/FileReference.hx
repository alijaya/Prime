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

 import haxe.io.BytesData;

 import prime.core.events.LoaderEvents;
 import prime.bindable.Bindable;
 import prime.net.CommunicationType;
 import prime.net.FileFilter;
 import prime.net.ICommunicator;
 import prime.net.IFileReference;
 import prime.net.URLVariables;

 import prime.gui.events.SelectEvents;
 import prime.types.URI;
  using prime.utils.Bind;
  using prime.utils.FileUtil;
  using Std;



private typedef FlashFileRef = flash.net.FileReference;


/**
 * AVM2 FileReference implementation
 * 
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class FileReference extends SelectEvents implements ICommunicator implements IFileReference
{
	public var events			(default,				null)		: LoaderSignals;
	
	public var bytesProgress	(get_bytesProgress,		null)		: Int;
	public var bytesTotal		(get_bytesTotal,		null)		: Int;
	@:isVar public var bytes	(get_bytes,				set_bytes)	: BytesData;
	public var type				(default,				null)		: CommunicationType;
	public var length			(default,				null)		: Bindable<Int>;
	public var isStarted		(default,				null)		: Bool;
	
	public var creationDate		(get_creationDate,	 	never)		: Date;
	public var creator			(get_creator,		 	never)		: String;
	public var modificationDate	(get_modificationDate,	never)		: Date;
	public var name				(get_name,				never)		: String;
	public var fileType			(get_fileType,			never)		: String;
	
	private var loader			: FlashFileRef;
	
	
	public function new (loader:FlashFileRef = null)
	{
		this.loader	= loader != null ? loader : new FlashFileRef();
		events		= new LoaderEvents(this.loader);
		super(this.loader);
		
		var e = events.load;
		updateProgress	.on( e.progress,			this );
		
		setStarted		.on( e.started, 			this );
		unsetStarted	.on( e.completed, 			this );
		unsetStarted	.on( e.error, 				this );
		unsetStarted	.on( events.unloaded,		this );
		unsetStarted	.on( events.uploadComplete,	this );
	}
	
	
	public function dispose2 ()	// FIXME can't override dispose -> runtime error:  "VerifyError: Error #1053: Illegal override of dispose in prime.avm2.net.FileReference."
	{
		close();
		events.dispose();
		events	= null;
		type	= null;
		loader	= null;
		super.dispose();
	}
	
	
	public #if !noinline inline #end function close ()				if (isStarted)	{ isStarted = false; loader.cancel(); events.uploadCanceled.send(); }
	public #if !noinline inline #end function browse (?types:Array<FileFilter>)	{ return loader.browse(types); }
	
	
	public function load () : Void
	{
		Assert.isNotNull(loader);
		if (isStarted)
			close();
		
		isStarted 	= true;
		type		= CommunicationType.loading;
		loader.load();
	}
	
	
	public /*inline*/ function upload (uri:URI, vars:URLVariables, uploadDataFieldName:String = "file")
	{
		if (isStarted)
			close();
		
		isStarted	 	= true;
		type			= CommunicationType.sending;
		
		var request		= uri.toRequest();
		request.method	= flash.net.URLRequestMethod.POST;
		request.data	= vars;
		bytesProgress	= 0;
		
		loader.upload(request, uploadDataFieldName);
	}
	
	
	/**
	 * Method will offer the user a file-window to download the given data. If
	 * the data is 'null', it will offer the user 'this.bytes'.
	 * 
	 * @param	filename	suggested filename for the file
	 */
	public #if !noinline inline #end function save (filename:String, data:BytesData = null)
	{
		if (isStarted)
			close();
		
		if (data == null)
			data = bytes;
		
#if flash10			loader.save( data, filename );
#elseif flash9		Assert.abstractMethod('not possible in flash-9');		#end
	}
	
	
	/**
	 * Method offers the option to download a file from the given URI
	 */
	public #if !noinline inline #end function download (uri:URI, filename:String)
	{
		if (isStarted)
			close();
		
		bytesProgress = 0;
		loader.download( uri.toRequest(), filename );
	}
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function get_bytesProgress ()	{ return bytesProgress; }
	private inline function get_bytesTotal ()		{ return loader.size.int(); }
	private inline function get_bytes ()			{ return bytes != null ? bytes : loader.data; }
	private inline function set_bytes (v)			{ return bytes = v; }
//	private inline function get_length ()			{ return 1; }
	
	private inline function get_modificationDate ()	{ return loader.modificationDate; }
	private inline function get_creationDate ()		{ return loader.creationDate; }
	private inline function get_creator ()			{ return loader.creator; }
	private inline function get_name ()				{ return loader.name; }
	
	/**
	 * Method will return the FileReference.type variable when it's not null or 
	 * the extension of the file
	 */
	private inline function get_fileType ()			{ return loader.type == null ? name.getExtension() : loader.type; }
	public #if !noinline inline #end function isCompleted ()			{ return bytesTotal > 0 && bytesProgress >= bytesTotal; }
	public #if !noinline inline #end function isInProgress ()			{ return isStarted && !isCompleted(); }
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateProgress (loaded:UInt, total:UInt)
	{
	//	trace(loaded+"/"+total);
		this.bytesProgress = loaded;
	//	this.bytesTotal = total;
	}
	
	
	private function setStarted ()		{ isStarted = true; }
	private function unsetStarted ()	{ isStarted = false; }
	
	
#if debug
	public function toString ()
	{
		return "FileReference( "+type+" => "+bytesProgress + " / " + bytesTotal + " - started? "+ isStarted +"; type: "+type+" )";
	}
#end
}