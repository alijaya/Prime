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
 import prime.types.Number;
  using prime.utils.NumberUtil;


/**
 * @since	mar 22, 2010
 * @author	Ruben Weijers
 */
class Box
				implements IBox
#if CSSParser,	implements prime.tools.generator.ICSSFormattable
			,	implements prime.tools.generator.ICodeFormattable		#end
{
	@:isVar public var left		(get_left, set_left)	: Int;
	@:isVar public var right	(get_right, set_right)	: Int;
	@:isVar public var top		(get_top, set_top)		: Int;
	@:isVar public var bottom	(get_bottom, set_bottom): Int;
	
#if CSSParser
	public var _oid		(default, null)			: Int;
#end
	
	
	public function new ( top:Int = 0, right:Int = Number.INT_NOT_SET, bottom:Int = Number.INT_NOT_SET, left:Int = Number.INT_NOT_SET )
	{
#if CSSParser
		this._oid	= prime.utils.ID.getNext();
#end
		this.top	= top;
		this.right	= (right.notSet())  ? this.top 	 : right;
		this.bottom	= (bottom.notSet()) ? this.top 	 : bottom;
		this.left	= (left.notSet()) 	? this.right : left;
	}
	
	
	public function clone () : IBox			{ return new Box( top, right, bottom, left ); }
	
	private inline function get_left ()		{ return left; }
	private inline function get_right ()		{ return right; }
	private inline function get_top ()		{ return top; }
	private inline function get_bottom ()	{ return bottom; }
	private inline function set_left (v)		{ return this.left = v; }
	private inline function set_right (v)	{ return this.right = v; }
	private inline function set_top (v)		{ return this.top = v; }
	private inline function set_bottom (v)	{ return this.bottom = v; }
	
	
#if (debug && flash9)
	public function toString () { return "Box ( "+top+"px "+right+"px "+bottom+"px "+left+"px )"; }
#elseif CSSParser
	public function toString () { return toCSS(); }


	public function isEmpty () : Bool
	{
		return top.notSet()
			&& left.notSet()
			&& bottom.notSet()
			&& right.notSet();
	}
	
	
	public function toCSS (prefix:String = "") : String
	{
		return getCSSValue(top) + " " + getCSSValue(right) + " " + getCSSValue(bottom) + " " + getCSSValue(left);
	}
	
	
	private inline function getCSSValue (v:Int) { return v == 0 ? "0" : v + "px"; }
	public function cleanUp () : Void			{}

	#if prime_css
	public function toCode (code:prime.tools.generator.ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ top, right, bottom, left ] );
	}
	#end

#end
}