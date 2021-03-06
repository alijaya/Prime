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
  using prime.signals.Wire;
  using prime.utils.BitUtil;
  using prime.utils.IfUtil;

/**
 * Signal with 4 arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal4 <A,B,C,D> extends Signal<A->B->C->D->Void> implements ISender4<A,B,C,D> implements INotifier<A->B->C->D->Void>
{
	public function new() enabled = true;
	
	public #if !debug inline #end function send( _1:A, _2:B, _3:C, _4:D ) if (enabled)
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
			 	w.handler(_1,_2,_3,_4);
#if (flash9 && debug) } catch (e : flash.errors.Error) { throw "Handler error ("+ e +") for " + w+";\n\tstacktrace: "+e.getStackTrace()+"\n"; } #end
				
			if (w.flags.has(Wire.SEND_ONCE))
			 	w.dispose();
			w = nextSendable; // Next node
		}
		nextSendable = null;
	}
	
	public #if !noinline inline #end function bind            (owner:Dynamic, handler:A->B->C->D->Void #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, handler, Wire.ENABLED                                           #if debug, pos #end);
	public #if !noinline inline #end function bindOnce        (owner:Dynamic, handler:A->B->C->D->Void #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, handler, Wire.ENABLED | Wire.SEND_ONCE                          #if debug, pos #end);
	public #if !noinline inline #end function bindDisabled    (owner:Dynamic, handler:A->B->C->D->Void #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, handler, 0                                                      #if debug, pos #end);
	public #if !noinline inline #end function observe         (owner:Dynamic, handler:Void->Void       #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER                  #if debug, pos #end);
	public #if !noinline inline #end function observeOnce     (owner:Dynamic, handler:Void->Void       #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER | Wire.SEND_ONCE #if debug, pos #end);
	public #if !noinline inline #end function observeDisabled (owner:Dynamic, handler:Void->Void       #if debug, ?pos : haxe.PosInfos #end)  return Wire.make( this, owner, cast handler, Wire.VOID_HANDLER                                 #if debug, pos #end);
}