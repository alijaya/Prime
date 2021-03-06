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
package prime.avm2.events;
#if	(flash9 || nme)
 import flash.events.AsyncErrorEvent;
 import flash.events.IEventDispatcher;
 import flash.events.IOErrorEvent;
 import prime.signals.Signals;


/**
 * Event group for the NetStream object.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class NetStreamEvents extends Signals
{
	public var asyncError	(default, null)	: ErrorSignal;
	public var ioError		(default, null)	: TextSignal;
	public var netStatus	(default, null)	: NetStatusSignal;
//	public var cuePoint		(default, null)	: //TODO
//	public var imageData	(default, null)	: //TODO
//	public var metaData		(default, null)	: //TODO
//	public var XMPData		(default, null)	: //TODO
	
	
	public function new (dispatcher:IEventDispatcher)
	{
		super();
		asyncError	= new ErrorSignal( dispatcher, AsyncErrorEvent.ASYNC_ERROR );
		ioError		= new TextSignal( dispatcher, IOErrorEvent.IO_ERROR );
		netStatus	= new NetStatusSignal( dispatcher );
	}
}
#end
