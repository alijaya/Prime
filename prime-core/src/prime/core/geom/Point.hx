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
package prime.core.geom;

/**
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
#if (flash9 || nme)
typedef Point = flash.geom.Point;
#else


class Point
{
	public var x (default, default)	: Float;
	public var y (default, default)	: Float;
/*	#if js
		private static function __init__() : Void untyped {
		if( __js__("WebKitPoint") )
			prime.core.geom["Point"] = __js__("WebKitPoint");
	}
	#end
*/

	
	public function new(x:Float = 0, y:Float = 0)
	{
		this.x = x;
		this.y = y;
	}
	
	public #if !noinline inline #end function clone ()					return new Point( x, y )
	public #if !noinline inline #end function subtract (v:Point)		return new Point( x - v.x, y - v.y )
	public #if !noinline inline #end function add (v:Point)			return new Point( x + v.x, y + v.y )
	public #if !noinline inline #end function isEqualTo (v:Point) 		return x == v.x && y == v.y
	public #if !noinline inline #end function setTo (v:Point) 		{ 	x = v.x; y = v.y; }
#if debug
	public #if !noinline inline #end function toString ()				return "Point( "+x+", "+y+" )"
#end
}
#end