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
package prime.net;
 import prime.bindable.Bindable;
 import prime.core.events.LoaderEvents;
 import prime.core.traits.IDisposable;

private typedef BytesData = #if (flash9 || nme)  flash.utils.ByteArray  #else  haxe.io.BytesData  #end;

/**
 * Interface to describe objects that communicate with another resource and
 * are able to give status updates about it.
 * 
 * @author Ruben Weijers
 * @creation-date Mar 28, 2011
 */
interface ICommunicator extends IDisposable
{
	public var events		(default,				null)		: LoaderSignals;
	public var bytes		(get_bytes,				set_bytes)	: BytesData;
	public var type			(default,				null)		: CommunicationType;
	
	/**
	 * Total bytes loaded/send for all processes together
	 */
	public var bytesProgress	(#if (!nme && js) default #else get_bytesProgress #end,	never)		: Int;
	/**
	 * Total number of bytes to load/send for all processes together
	 */
	public var bytesTotal		(#if (!nme && js) default #else get_bytesTotal #end,		never)		: Int;
	
	/**
	 * Indicates the number of process going on within the communicator
	 */
	public var length			(default,			null)		: Null<Bindable<Int>>;
	
	
	/**
	 * Flag indicating wether the process is started
	 */
	public var isStarted		(default, null)					: Bool;
	
	/**
	 * Flag indicating wether the process is completed (true when a COMPLETE 
	 * event is fired or when the bytesProgress are equal to the bytesTotal)
	 */
	public function isCompleted ()			: Bool;
	public function isInProgress ()			: Bool;
	
	
	/**
	 * Method will stop all communications
	 */
	public function close () : Void;
}