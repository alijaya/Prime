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
 */
package prime.signals;
  using prime.core.ListNode;
  using prime.utils.IfUtil;
  using prime.utils.TypeUtil;
  using prime.signals.Wire;

/**
 * Abstract internal base class for all Signals.
 *  
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal <FunctionSignature> extends WireList<FunctionSignature> implements IUnbindable<FunctionSignature> implements prime.core.traits.IDisposable implements prime.core.traits.IDisablable
{
	static public #if !noinline inline #end function notifyEnabled<T>(s:Signal<T>, w:Wire<T>) : Void
	{
		Assert.isNotNull(s);
		Assert.isNotNull(w);
		
		if (s.is(IWireWatcher)) {
			var x:IWireWatcher<T> = cast s;
			x.wireEnabled(w);
		}
	}

	static public #if !noinline inline #end function notifyDisabled<T>(s:Signal<T>, w:Wire<T>) : Void
	{
		if (s.is(IWireWatcher)) {
			var x:IWireWatcher<T> = cast s;
			x.wireDisabled(w);
		}
	}
	
	public var enabled : Bool;
	
	
	/**
	 * Reference is set during the send method of the signal and is a reference 
	 * to the wire that will be called after the current wire.handler is done.
	 * 
	 * Saving a reference in the signal is needed for when an owner with 2 or 
	 * more handlers for this signal is unbinded in Signal.unbind. Each wire will
	 * update this reference when it's disabled (or disposed) to prevent the
	 * Signal.send method to lose its reference to next usable wire.
	 */
	public var nextSendable : Wire<FunctionSignature>;
	
	
	public #if !noinline inline #end function  enable()   enabled = true;
	public #if !noinline inline #end function disable()   enabled = false;
	public #if !noinline inline #end function isEnabled() return enabled;
	
	
	/**
	 *  @see IUnbindable.unbind
	 */
	public function unbind( listener : Dynamic, ?handler : Null<FunctionSignature> ) : Void
	{
		Assert.isNotNull(listener);
		
		var b = this.n; //, count = 0;
		
		while (b.notNull()) {
			var x = b.next();
			if( b.isBoundTo(listener, handler) ) {
				b.dispose();
		//		++count;
			}
			b = x;
		}
	//	return count;
	}
	
	/**
	 *  Unbind all handlers.
	 */
	public #if !noinline inline #end function dispose()
	{
		unbindAll();
	}
	
	
	public function unbindAll()
	{
		var b = this.n;
		while(b.notNull()) {
			var x = b.next();
			b.dispose();
			b = x;
		}
	}


	public #if !noinline inline #end function hasListeners () : Bool
	{
		return n.notNull();
	}
	
	
	public #if !noinline inline #end function hasListener( owner : Dynamic, ?handler : Null<FunctionSignature> ) : Bool
	{
		var b = this.n;
		
		var found = false;
		while (b.notNull()) {
			if ( b.isBoundTo(owner, handler) ) { b = null; found = true; }
			else b = b.next();
		}
		return found;
	}
	
	
	/** Identify where the event is called (nice for debugging) ** /
	public #if !noinline inline #end function source(?pos:haxe.PosInfos)
	{
	  #if debug
		Event.callPos = pos;
	  #end
		return this;
	}
	
	/**
	 * Performance tests and optimization notes:
	 * 
	 * - Calling:
	 *  	var send (default,null) : FunctionSignature;
	 *	 is 4 times slower than:
	 *  	public function send( FunctionSignature );
	 * 
	 * - haxe.rtti.Generic not required for Signal subclasses
	 *	  Signal0,1,2,3 and 4  hardly (if at all) got a few ms faster calling send() 2 000 000 times.
	 */
}