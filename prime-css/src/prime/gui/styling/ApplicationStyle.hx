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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package prime.gui.styling;
  using prime.utils.BitUtil;


/**
 * Stylesheet instance that is used by UIWindow.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class ApplicationStyle extends UIElementStyle
{
#if (flash9 || nme)
	override private function init ()
	{
		trace("StyleSheet version: " + StyleSheet.version);
		var sheet			= new StyleSheet();
		filledProperties	= filledProperties.set( sheet.allFilledProperties );
		parentStyle			= this;
		styles.add(sheet);
		enableStyleListeners();

	#if (flash9 && debug)
		// Connect to stylesheet watcher
		var context = haxe.remoting.Context.share("reload", this);
		
		var s = new flash.net.XMLSocket();
		s.timeout = 1000;
		s.addEventListener(flash.events.Event.CONNECT, function(e){trace(e); scnx.api.hi.call([]); });
		s.addEventListener(flash.events.Event.CLOSE, function(e){trace(e); s.connect("localhost", 8888); });
		s.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e){ s.connect("localhost", 8888); });
		s.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, function(e){ s.connect("localhost", 8888); });
		flash.system.Security.allowDomain('*');
		
		scnx = haxe.remoting.SocketConnection.create(s,context);
		scnx.setErrorHandler(function(e) { trace("Client error: " + e); });
		trace("Connecting to StyleSheet watcher");
		s.connect("localhost", 8888);
	#end
	}

  #if (flash9 && debug)
	var scnx : haxe.remoting.SocketConnection;

	public function reload (uri : String, className : String)
	{
		trace("Reloading StyleSheet from file: " + uri + " named " + className);
		var ldr = prime.gui.display.Loader.get();
		ldr.events.load.completed.observe(this, function()
		{
			var styleClass = ldr.info.applicationDomain.getDefinition(className);
			trace("New Stylesheet version: " + styleClass.version);
			var sheet : prime.gui.styling.StyleBlock = Type.createInstance(styleClass, []);
			filledProperties	= filledProperties.set( sheet.allFilledProperties );
			parentStyle			= this;
			styles.removeAll();
			styles.add(sheet);
			updateStyles();
			scnx.api.loaded.call([className]);
		});
		ldr.load(new prime.types.URI(uri), new flash.system.LoaderContext(flash.system.ApplicationDomain.currentDomain));
	}

  #end
#end
}
