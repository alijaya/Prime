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
package prime.signal;
  using prime.core.ListNode;
  using prime.signal.Wire;
  using prime.utils.BitUtil;
  using prime.utils.IfUtil;

/**
 * Signal with 1 argument to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal1 <A> extends Signal<A->Void>, implements ISender1<A>, implements INotifier<A->Void>
{
	public function new() enabled = true
	
	public #if !debug inline #end function send( _1:A ) if (enabled)
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var w = this.n;
		
		while (w.notNull())
		{
			nextSendable = w.next();
			Assert.that(w.isEnabled());
			Assert.notEqual(w, nextSendable);
			Assert.notEqual(w.flags, 0);
				
			if (w.flags.has(Wire.SEND_ONCE))
				w.disable();
			
#if (flash9 && debug) try { #end
			if (w.flags.has(Wire.VOID_HANDLER))
				w.sendVoid();
			else
				w.handler(_1);
#if (flash9 && debug) } catch (e : flash.errors.TypeError) { throw "Wrong argument type ("+ e +") for " + w+" - \nwith handler "+w.handler+"; \nparams:"+_1+";\n\tstacktrace: "+e.getStackTrace()+"\n"; } #end
			
			if (w.flags.has(Wire.SEND_ONCE))
				w.dispose();
			w = nextSendable; // Next node
		}
		nextSendable = null;
	}
	
	public #if !noinline inline #end function bind 			(owner:Dynamic, handler:A->Void) 		return Wire.make( this, owner, handler, Wire.ENABLED )
	public #if !noinline inline #end function bindOnce 		(owner:Dynamic, handler:A->Void) 		return Wire.make( this, owner, handler, Wire.ENABLED | Wire.SEND_ONCE)
	public #if !noinline inline #end function bindDisabled 	(owner:Dynamic, handler:A->Void)		return Wire.make( this, owner, handler, 0)
	public #if !noinline inline #end function observe 			(owner:Dynamic, handler:Void->Void)		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER)
	public #if !noinline inline #end function observeOnce 		(owner:Dynamic, handler:Void->Void)		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER | Wire.SEND_ONCE)
	public #if !noinline inline #end function observeDisabled	(owner:Dynamic, handler:Void->Void)		return Wire.make( this, owner, cast handler, Wire.VOID_HANDLER)
	
#if DebugEvents
	static function __init__()
		test()	//call test.. otherwise compile error: Signal1.hx:105: lines 105-232 : You can't have a local variable referenced from a closure inside __init__ (FP 10.1.53 crash)

	static function test ()
	{
		trace("DebugEvents");
		// Unit tests
		var num=0, b1:Wire<String->Void>=null, b2:Wire<String->Void>=null, b3:Wire<String->Void>=null, b4:Wire<String->Void>=null, b5:Wire<String->Void>=null;

		var handlersCalled = 0;

		var d = new Signal1<String>();
		var name = function(l) {
			return if (l == b1) "B1";
			else   if (l == b2) "B2";
			else   if (l == b3) "B3";
			else   if (l == b4) "B4";
			else   if (l == b5) "B5";
		}

		var linkedWires = function() {
			var count = 0;
			var l = d.n;
			var linked = "";
			while (l != null) {
				++count;
				linked += name(l) + ", ";
				l = l.next();
			}
			trace(linked);
			return count;
		}
		var handler = function(s) { trace("b12 handler(): "+linkedWires()); handlersCalled++; }

		var o = {};

		b1 = d.bind(o, handler); Assert.isEqual(b1.signal, d);
		b1.dispose();
		b1 = d.bind(o, handler); Assert.isEqual(b1.signal, d);
		b2 = d.bind(o, handler); Assert.isEqual(b2.signal, d);
		
		Assert.that(b1.isEnabled());
		Assert.that(b2.isEnabled());
		
		handlersCalled = 0; trace("0");
		d.send("a");
		Assert.isEqual(handlersCalled, 2);
		
		b2.disable();
		Assert.not(b2.isEnabled());
		handlersCalled = 0; trace("0 - b");
		d.send("a");
		Assert.isEqual(handlersCalled, 1);
		
		b2.enable();
		Assert.that(b2.isEnabled());
		handlersCalled = 0; trace("0 - c");
		d.send("a");
		Assert.isEqual(handlersCalled, 2);

		// Disable in handler test
		var disablingHandler = null;
		disablingHandler = function(s) { trace("b3 disablingHandler(): "+linkedWires()); handlersCalled++; b3.disable(); Assert.notEqual(d.n, b3); }
		b3 = d.bind(o, disablingHandler);

		handlersCalled = 0; trace("1");
		d.send("a");
		Assert.isEqual(handlersCalled, 3);
		d.send("a");
		Assert.isEqual(handlersCalled, 5);
		d.send("a");
		Assert.isEqual(handlersCalled, 7);

		var enablingHandler = null;
		enablingHandler = function(s) { trace("b4 enablingHandler(): "+linkedWires()); handlersCalled++; b3.enable(); Assert.isEqual(d.n, b3); }
		b4 = d.bind(o, enablingHandler);

		handlersCalled = 0; trace("2 ----------------");
		d.send("a");
		Assert.isEqual(handlersCalled, 3);
		trace(": 2b --------------");
		d.send("a");
		Assert.isEqual(handlersCalled, 7);
		trace(": 2c --------------");
		d.send("a");
		Assert.isEqual(handlersCalled, 11);
		
		var togglingHandler = null;
		togglingHandler = function(s) { 
			trace("togglingHandler()");
			handlersCalled++;
			Assert.that(b5.isEnabled());
			Assert.isEqual(d.n, b5);

			b5.disable();
			Assert.notEqual(d.n, b5);
			Assert.that(!b5.isEnabled());

			b5.enable();
			Assert.isEqual(d.n, b5);
			Assert.that(b5.isEnabled());
		}
		b5 = d.bind(o, togglingHandler);

		handlersCalled = 0; trace("3");
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.isEqual(num, 5);
		d.send("a");
		Assert.isEqual(handlersCalled, 5);

		handlersCalled = 0; trace("4");
		Assert.that(b1.isEnabled());
		Assert.that(b2.isEnabled());
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.isEqual(num, 5);
		d.send("a");
		Assert.isEqual(handlersCalled, 5);

		handlersCalled = 0; trace("5");
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.isEqual(num, 5);
		d.send("a");
		Assert.isEqual(handlersCalled, 5);
		
		trace("Pass!");
	}
#end
}