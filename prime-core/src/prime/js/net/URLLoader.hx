package prime.js.net;
#if js
 import prime.core.events.LoaderEvents;
 import prime.net.ICommunicator;
 import prime.net.CommunicationType;
 import prime.net.RequestMethod;
 import prime.bindable.Bindable;
 import prime.types.URI;
 import haxe.io.BytesData;
 import js.html.XMLHttpRequest;
 import js.html.Event;
 import js.Lib;


/**
 * Possible state values (XMLHttpRequest.readyState)
 * 
 * Name				Value	Description	
 * UNSENT				0		The object has been constructed. 
 * OPENED				1		The open() method has been successfully invoked. During this state request headers can be set using setRequestHeader() and the request can be made using the send() method. 
 * HEADERS_RECEIVED	2		All redirects (if any) have been followed and all HTTP headers of the final response have been received. Several response members of the object are now available. 
 * LOADING				3		The response entity body is being received. 
 * DONE				4		The data transfer has been completed or something went wrong during the transfer (e.g. infinite redirects). 
 * 
 * Possible status values (XMLHttpRequest.status)
 * 
 * Name				Value	Description	
 * OK					200		The request has succeeded.
 * Bad Request			400 	The request could not be understood by the server due to malformed syntax.
 * Unauthorized		401		The request requires user authentication. 
 * Forbidden			403 	The server understood the request, but is refusing to fulfill it. 
 * Not Found			404		The server has not found anything matching the Request-URI.
 * 
 * For a complete status value reference see http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 * 
 * Possible header request values
 * 
 * HTTP/1.1 200 OK
 * Server: Microsoft-IIS/4.0
 * Cache-Control: max-age=172800
 * Expires: Sat, 06 Apr 2002 11:34:01 GMT
 * Date: Thu, 04 Apr 2002 11:34:01 GMT
 * Content-Type: text/html
 * Accept-Ranges: bytes
 * Last-Modified: Thu, 14 Mar 2002 12:06:30 GMT
 * ETag: "0a7ccac50cbc11:1aad"
 * Content-Length: 52282
 * 
 * Events available in Webkit
 * 
 * Name				Description
 * readystatechange	XMLHttpRequest.readyState has changed
 * progress			In progress.
 * loadstart			Progression has begun. 
 * load				Progression successful.
 * error				Progression has failed.
 * abort				Progression has terminated.
 * timeout				Progression has timed out.
 * loadend				Progression has stopped. 
 */

/**
 * JS URLrequest implementation
 * 
 * @author	Stanislav Sopov
 * @since	April 4, 2011
 */

class URLLoader implements ICommunicator
{
	public var state		(get_state, null)		: Int;
	public var data			(get_data, null)		: Dynamic;
	public var dataFormat	(get_dataFormat, null)	: String;
	public var bytes		(get_bytes,	set_bytes)	: BytesData;
	public var bytesProgress(default, null)			: Int;
	public var bytesTotal	(default, null)			: Int;
	public var events		(default, null)			: LoaderSignals;
	public var request		(default, null) 		: XMLHttpRequest;
	public var isStarted	(default, null) 		: Bool;
	public var type			(default, null)			: CommunicationType;
	public var length		(default, never)		: Null<Bindable<Int>>;

	public function new(?url:URI)
	{	
		request	= new XMLHttpRequest();
		isStarted = false;
		untyped request.onreadystatechange = onReadyStateChange;
		untyped request.onprogress = onLoadProgress;
		
		events = new LoaderEvents(request);
		
		if (url != null)
		{
//			load(url);
		}
	}
	
	private function get_state():Int { return request.readyState; }
	private function get_status():Int { return request.status; }
	private function get_data():Dynamic { return request.responseText; }
	private function get_dataFormat():String { return request.getResponseHeader("Content-Type"); }
	// TODO: check what exactly this value represents with different data types
	//private function getBytesTotal():Int { return Std.parseInt(request.getResponseHeader("Content-Length")); } 
	
	private function onLoadProgress(event:Event) 
	{
		untyped 
		{
			if (event.lengthComputable)
			{
				bytesProgress = event.loaded;
				bytesTotal = event.total;
			}
		}
	}
	
	private function onReadyStateChange(event:Event)
	{
		//untyped console.log(event);
		if (request.readyState == 4)
		{
			//trace("Ready state: " + request.readyState + ", status: "+ request.status); // + ", statusText: " + request.statusText);
		
			events.httpStatus.send(request.status);
			events.load.completed.send();
		}
	}
	
	public function dispose()
	{
		close();
		events.dispose();
		events	= null;
		request	= null;
	}
	
	public function requestBinary (uri:URI, method:RequestMethod) return switch (method) {
		case get:  binaryGET (uri);
		case post: sendBinary(uri);
		default:   throw "unsupported: " + method;
	}

	public function binaryGET(uri:URI)
	{
		this.type = CommunicationType.loading;

		var request = this.request;
		request.open("GET", uri.toString(), true);
		
		// This tells the browser not to parse the data, getting raw unprocessed bytes.
		request.overrideMimeType('text/plain; charset=x-user-defined');
		request.send(null);
		this.isStarted = true;
	}
	
	public function sendBinary(uri:URI, mimetype:String = "application/octet-stream")
	{
		this.type = CommunicationType.sending;
		
		request.open("POST", uri.toString(), true);
		request.overrideMimeType(mimetype);
		request.send(bytes.toString());
		this.isStarted = true;
	}
	
	public function load(uri:URI)
	{
		this.type = CommunicationType.loading;

		var request = this.request;
		request.open("GET", uri.toString(), true);
		request.send(null);
		this.isStarted = true;
	}
	
	public #if !noinline inline #end function close() { this.isStarted = false; return request.abort(); }

	private var _isBinary : Bool;
	public #if !noinline inline #end function isBinary ()		: Bool	{ return true; }
	public #if !noinline inline #end function isCompleted()	: Bool	{ return request.readyState == 4; }
	public #if !noinline inline #end function isInProgress()	: Bool	{ return isStarted && request.readyState != 4; }
	
	private inline function get_bytes ()	{ return data; }
	public  inline function getRawData ()	{ return data; }

	private inline function set_bytes (v:BytesData)
	{
		data = v;
		
		if (v != null)
			bytesProgress = bytesTotal = v.length;
		
		return v;
	}
}
#end