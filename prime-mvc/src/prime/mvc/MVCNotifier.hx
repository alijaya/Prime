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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package prime.mvc;
 import prime.core.traits.IDisposable;
  using prime.utils.BitUtil;


/**
 * Base class for controllers, mediators and proxies. It defines that the objects
 * can send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class MVCNotifier implements IMVCNotifier
{
	private var state : Int;
	
	
	public function new (enabled = true)
	{
#if !flash9
		state = 0;
#end
		if (enabled)
			enable();
	}
	
	
	public function dispose ()
	{
		if (isDisposed())	return;
		if (isEnabled())	disable();
		state = state.set( MVCFlags.DISPOSED );
	}
	
	
	
	public function enable ()				{ state = state.set( MVCFlags.ENABLED ); }
	public function disable ()				{ state = state.unset( MVCFlags.ENABLED ); }
	public #if !noinline inline #end function isDisposed ()	{ return state.has( MVCFlags.DISPOSED ); }
	public #if !noinline inline #end function isEnabled ()		{ return state.has( MVCFlags.ENABLED ); }
}