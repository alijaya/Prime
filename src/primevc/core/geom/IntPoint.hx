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
package primevc.core.geom;
 import primevc.core.traits.IClonable;
#if CSSParser
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.tools.generator.ICSSFormattable;
 import primevc.utils.ID;
#end
  using primevc.utils.NumberUtil;
 

/**
 * Simple point class
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class IntPoint	implements IClonable <IntPoint>	
#if CSSParser,	implements ICSSFormattable
			,	implements ICodeFormattable		#end
{
	public static #if !noinline inline #end function fromFloat (x:Float, y:Float)	: IntPoint	{ return new IntPoint( x.roundFloat(), y.roundFloat() ); }
	public static #if !noinline inline #end function fromPoint (p:Point)			: IntPoint	{ return new IntPoint( p.x.roundFloat(), p.y.roundFloat() ); }
	
	@:isVar public var x		(get_x, set_x)	: Int;
	@:isVar public var y		(get_y, set_y)	: Int;
	
#if CSSParser
	public var _oid		(default, null) : Int;
#end
	
	
	
	
	public function new(x = 0, y = 0)
	{
#if CSSParser
		this._oid	= ID.getNext();
#end
		this.x		= x;
		this.y		= y;
	}
	
	
	public function clone () {
		return new IntPoint( x, y );
	}
	
	
	private function get_x()	{ return x; }
	private function set_x(v)	{ return x = v; }
	private function get_y()	{ return y; }
	private function set_y(v)	{ return y = v; }
	
	
	public #if !noinline inline #end function subtract (v:IntPoint) {
		return new IntPoint(
			x - v.x,
			y - v.y
		);
	}
	
	
	public #if !noinline inline #end function add (v:IntPoint) {
		return new IntPoint(
			x + v.x,
			y + v.y
		);
	}
	
	
	public #if !noinline inline #end function isEqualTo (v:IntPoint) : Bool {
		return x == v.x && y == v.y;
	}
	
	
	public #if !noinline inline #end function setTo (v:IntPoint) : Void {
		x = v.x;
		y = v.y;
	}
	
	
#if CSSParser
	public #if !noinline inline #end function toString () { return "IntPoint( "+x+", "+y+" )"; }
	public function toCSS (prefix:String = "")		{ return x + "px, " + y + "px"; }
	public function cleanUp () : Void				{}
	public function toCode (code:ICodeGenerator)	{ code.construct( this, [ x, y ] ); }
	public function isEmpty ()						{ return x.notSet() && y.notSet(); }
#end
}