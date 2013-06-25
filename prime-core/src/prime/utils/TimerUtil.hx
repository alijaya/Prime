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
package prime.utils;
  using Std;

/**
 * @author Ruben Weijers
 * @creation-date May 03, 2011
 */
extern class TimerUtil
{
#if (flash || js || cs || java)
	public static inline function after (method:Dynamic, delayMs:Int) : Void
	{
		haxe.Timer.delay( method, delayMs );
	}
#end
	
	
	/**
	 * Method returns a timestamp in ms
	 */
	public static inline function stamp () : Float
	{
		return (haxe.Timer.stamp() * 1000); //.int();
		/*#if		flash	return Date.now().getTime().int();
		#elseif	neko	return (neko.Sys.cpuTime() * 1000).int(); //Date.now().getTime().int(); //(neko.Sys.time() * 1000).int();
		#elseif php		return (php.Sys.time()).int();
		#elseif js		return Date.now().getTime().int();
		#elseif cpp		return untyped (__global__.__time_stamp() * 1000).int();
		#else			return 0; #end*/
	}
}