/*
 * Copyright (c) 2013, The PrimeVC Project Contributors
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
 *  Danny Wilson	<danny @ prime.vc>
 */
package prime.perceptor;
 import prime.perceptor.remoting.Specimen;
 import prime.signals.Signal0;

#if prime_display
	import prime.gui.display.Window;
#end

private class Perceptor extends haxe.remoting.AsyncProxy<prime.perceptor.remoting.Perceptor> {
}

/**
 * Use me to establish a remoting connection to Perceptor.
 * 
 * @author Danny Wilson
 * @creation-date Mar 20, 2013
 */
class Client implements Specimen
{
	static public var connected : Signal0 = new Signal0();

	static public function connect(host : String = "127.0.0.1", port : Int = 1337) : Client
	{
		Assert.that(port < 65536);
	  #if flash9
		var socket = new flash.net.XMLSocket();
		socket.addEventListener(flash.events.Event.CONNECT, function(e){ connected.send(); });
		socket.connect(host, port);
	  #else #error
	  #end

		return new Client(socket);
	}


	///
	// Client implementation
	///

	var perceptor : Perceptor;

	private function new(transport) {
		var context = new haxe.remoting.Context();
		context.addObject("client", this);
		var scnx = haxe.remoting.SocketConnection.create(transport, context);
		perceptor = new Perceptor(scnx.api);
	}


#if prime_display
	var window : Window;

	public function withWindow(window : Window) : Client {
		this.window = window;
		return this;
	}

	private function getDisplayList() {
		return window.children;
	}
#end
}
