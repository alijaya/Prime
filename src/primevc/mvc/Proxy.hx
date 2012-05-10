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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 *  Ruben Weijers	<primevc @ rubenw.nl>
 */
package primevc.mvc;
 import primevc.core.traits.IValueObject;
  using primevc.utils.BitUtil;


/**
 * A Proxy manages a portion of the Model. Usually it manages a single value-object.
 * It exposes methods and properties to allow other MVC-actors to manipulate it.
 * 
 * A Proxy does not know anything outside of it's own world, and does not respond to signals.
 * It however does send signals, for example when the value-object changes.
 * 
 * @author Danny Wilson
 * @author Ruben Weijers
 * @creation-date Jun 22, 2010
 */
class Proxy<VOType:IValueObject, EventsTypedef> extends MVCNotifier
{
	public var vo		(default, setVO)	: VOType;
	public var events	(default, null)		: EventsTypedef;
	
	
	public function new( events:EventsTypedef, enabled = true )
	{
		Assert.isNotNull(events, "Events cannot be null");
		this.events = events;
		super(enabled);
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		events	= null;
		vo		= null;
	}


	private inline function setVO (v:VOType)
	{
		if (v != vo) {
			vo 		= v;
			state 	= v == null ? state.unset(MVCFlags.HAS_DATA) : state.set(MVCFlags.HAS_DATA);
		}
		return v;
	}


	public  inline function hasData ()		{ return  state  .has(MVCFlags.HAS_DATA); }

	public  inline function isLoading ()	{ return  state  .has(MVCFlags.LOADING); }
	private inline function setLoading ()	{ state = state  .set(MVCFlags.LOADING); }
	private inline function unsetLoading ()	{ state = state.unset(MVCFlags.LOADING); }

	public  inline function isSending ()	{ return state   .has(MVCFlags.SENDING); }
	private inline function setSending ()	{ state = state  .set(MVCFlags.SENDING); }
	private inline function unsetSending ()	{ state = state.unset(MVCFlags.SENDING); }
}
