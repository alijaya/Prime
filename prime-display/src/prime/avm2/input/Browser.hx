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
package prime.avm2.input;
 import com.asual.swfaddress.SWFAddress;
 import com.asual.swfaddress.SWFAddressEvent;
 import flash.external.ExternalInterface;
 import flash.net.URLRequest;
 import flash.system.Capabilities;
 import prime.gui.events.BrowserEvents;
 import prime.types.URI;


/**
 * Browser defines method to interact with the browser like reading/writing
 * the url.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 24, 2011
 */
class Browser
{
	public static var instance (get_instance, null)		: Browser;
		private static inline function get_instance ()	{ return instance == null ? instance = new Browser() : instance; }
	
	
	public var events		(default,		null)		: BrowserEvents;
	public var address		(get_address,	set_address): String;
	public var history		(get_history,	set_history): Bool;
	public var title		(get_title,		set_title)	: String;
	public var status		(get_status,	set_status)	: String;
	public var strict		(get_strict,	set_strict)	: Bool;
	/**
	 * indicating if the application is currently running in the browser
	 */
	public var available	(get_available,	never)		: Bool;
	
	/**
	 * property with flashvars as an dynamic object
	 */
	public var variables	(default,		null)		: Dynamic;
	
	
	/**
	 * Returns the flash-player version
	 */
	public var flashVersion	(get_flashVersion,	never)	: String;
	public var isFlashDebug	(get_isFlashDebug,	never)	: Bool;
	
	/**
	 * Returns the operatingsystem the user has
	 */
	public var os			(get_os,			never)	: String;
	
	/**
	 * Returns the name of the browser
	 */
	public var name			(get_name,			null)	: String;
	public var screenWidth	(get_screenWidth,	never)	: Float;
	public var screenHeight	(get_screenHeight,	never)	: Float;
	
	
	
	//
	// BROWSER METHODS
	//
	
	public #if !noinline inline #end function openURI (uri:URI, target:String = "_self")
	{
		openUrl( uri.toString(), target );
	}
	
	
	public #if !noinline inline #end function openUrl (url:String, target:String = "_self")
	{
		if (!available)		flash.Lib.getURL( new URLRequest(url), target);
		else				SWFAddress.href( url, target );
	}
	
	
	public #if !noinline inline #end function openPopup (uri:URI, name:String = "", options:String = "")
	{
		SWFAddress.popup( uri.toString(), name, options );
	}
	
	
	public #if !noinline inline #end function sendMail (to:String, subject:String, body:String)
	{
		openUrl( "mailto:"+to+"?subject="+subject+"&body="+StringTools.urlEncode( body ) );
	//	if (!available)		openUrl( url );
	//	else				ExternalInterface.call("function sendMail(link) { var a = window.unload; var b = window.onbeforeunload; window.onunload = window.onbeforeunload = null; window.alert(window.onbeforeunload); window.location = link; window.onbeforeunload = b; window.onunload = a; }", url);
	}
	
	
	/**
	 * Loads the previous URL in the history URL
	 */
	public #if !noinline inline #end function goBack ()			{ SWFAddress.back(); }
	/**
	 * Loads the next URL in the history lsit
	 */
	public #if !noinline inline #end function goForward ()			{ SWFAddress.forward(); }
	
	/**
	 * Loads a URL from the history list.
	 * @param Int represeting the relative position in the history list.
	 */
	public #if !noinline inline #end function goBackTo (pos:Int)	{ SWFAddress.go(pos); }
	
	
	
	//
	// JAVASCRIPT LISTENERS
	//
	
	
	/**
	 * Method will add a listener for javscript-method calls
	 * @return 		true when the externalinterface is available, else false
	 */
	public #if !noinline inline #end function addJsCallback (jsFunctionName:String, appMethod:Dynamic) : Bool
	{
		if (available)
			ExternalInterface.addCallback( jsFunctionName, appMethod );
		
		return available;
	}
	
	
	/**
	 * Method allows application to call a javascript method
	 * @return 	Whatever the method returns
	 */
	public #if !noinline inline #end function callJsMethod (jsFunctionName:String, ?info:haxe.PosInfos)
	{
		if (available)
			Reflect.callMethod( null, ExternalInterface.call, info.customParams );
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function get_address ()		{ return SWFAddress.getValue(); }
	private inline function set_address (v)		{ SWFAddress.setValue(v); return v; }
	
	private inline function get_history ()		{ return SWFAddress.getHistory(); }
	private inline function set_history (v)		{ SWFAddress.setHistory(v); return v; }
	
	private inline function get_title ()			{ return SWFAddress.getTitle(); }
	private inline function set_title (v)		{ SWFAddress.setTitle(v); return v; }
	
	private inline function get_strict ()		{ return SWFAddress.getStrict(); }
	private inline function set_strict (v)		{ SWFAddress.setStrict(v); return v; }
	
	private inline function get_status ()		{ return SWFAddress.getStatus(); }
	private inline function set_status (v)		{ SWFAddress.setStatus(v); return v; }
	
	private inline function get_available ()	{ return ExternalInterface.available; }
	
	private inline function get_flashVersion ()	{ return Capabilities.version; }
	private inline function get_isFlashDebug ()	{ return Capabilities.isDebugger; }
	private inline function get_os ()			{ return Capabilities.os; }
	private inline function get_screenWidth ()	{ return Capabilities.screenResolutionX; }
	private inline function get_screenHeight ()	{ return Capabilities.screenResolutionY; }
	
	/**
	 * Returns the name of the browser
	 */
	private function get_name ()
	{
		if (!available)		return "no browser";
		if (name != null)	return name;
		
		//check the version via external-interface
		var versionCheck = "function() { return navigator.appVersion; }";
		return name = ExternalInterface.call(versionCheck);
	}
	
	
	
	
	private function new ()
	{
		events = new BrowserEvents( untyped(SWFAddress)._dispatcher);
		
		if (available)
			variables = flash.Lib.current.loaderInfo.parameters;
	}
}