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
 import primevc.core.traits.QueueingInvalidatable;
 import primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil;


/**
 * Integer Rectangle implementation
 * 
 * @author Ruben Weijers
 * @creation-date Aug 03, 2010
 */
class IntRectangle extends QueueingInvalidatable, implements IRectangle
{
	public var centerX	(get_centerX, set_centerX)	: Int;
	public var centerY	(get_centerY, set_centerY)	: Int;
	
	@:isVar public var left		(get_left, set_left)		: Int;
	@:isVar public var right	(get_right, set_right)		: Int;
	@:isVar public var top		(get_top, set_top)			: Int;
	@:isVar public var bottom	(get_bottom, set_bottom)	: Int;
	
	@:isVar public var width	(get_width, set_width)		: Int;
	@:isVar public var height	(get_height, set_height)	: Int;
	
	
	public function new ( x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0 )
	{
		super();
#if debug
		id = counter++;
#end
		invalidatable = false;
		this.top	= y;
		this.left	= x;
		this.width	= width;
		this.height	= height;
		invalidatable = true;
	}
	
	
	public function clone () : IBox
	{
		return new IntRectangle( left, top, width, height );
	}
	
	
	public function resize (newWidth:Int, newHeight:Int) : Void
	{
		var c	= invalidatable;
		invalidatable = false;
		width	= newWidth;
		height	= newHeight;
		invalidatable = c;
	}
	
	
	public function move (newX:Int, newY:Int) : Void
	{
		var c	= invalidatable;
		invalidatable = false;
		top		= newX;
		left	= newY;
		invalidatable = c;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function set_width (v:Int)
	{
		if (v != width) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			width	= v;
			right	= left + v;
			invalidate( RectangleFlags.WIDTH );
			invalidatable = c;
		}
		return v;
	}
	
	
	private inline function set_height (v:Int)
	{
		if (v != height) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			height	= v;
			bottom	= top + v;
			invalidate( RectangleFlags.HEIGHT );
			invalidatable = c;
		}
		return v;
	}
	
	
	private inline function set_top (v:Int)
	{
		if (v != top) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			top		= v;
			bottom	= v + height;
			invalidate( RectangleFlags.TOP );
			invalidatable = c;
		}
		return v;
	}
	
	
	private function set_bottom (v:Int)
	{
		if (v != bottom) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			bottom	= v;
			top		= v - height;
			invalidate( RectangleFlags.BOTTOM );
			invalidatable = c;
		}
		
		return v;
	}
	
	
	private inline function set_left (v:Int)
	{
		if (v != left) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			left	= v;
			right	= v + width;
			invalidate( RectangleFlags.LEFT );
			invalidatable = c;
		}
		return v;
	}
	
	
	private function set_right (v:Int)
	{
		if (v != right) {
#if debug	Assert.that( v.isSet() ); #end
			var c = invalidatable;
			invalidatable = false;
			right	= v;
			left	= v - width;
			invalidate( RectangleFlags.RIGHT );
			invalidatable = c;
		}
		return v;
	}
	
	
	private inline function set_centerX (v:Int)
	{	
#if debug	Assert.that( v.isSet() ); #end
			left = v - (width >> 1); //* .5).roundFloat();
			return v;
	}
	
	
	private inline function set_centerY (v:Int)
	{	
#if debug	Assert.that( v.isSet() ); #end
			top = v - (height >> 1); //* .5)).roundFloat();
			return v;
	}
	
	
	
	private inline function get_left ()		{ return left; }
	private inline function get_right ()	{ return right; }
	private inline function get_top ()		{ return top; }
	private inline function get_bottom ()	{ return bottom; }
	private inline function get_width ()	{ return width; }
	private inline function get_height ()	{ return height; }
	
	private inline function get_centerX ()	{ return left + (width >> 1); } // * .5).roundFloat(); }
	private inline function get_centerY ()	{ return top + (height >> 1); } // * .5).roundFloat(); }
	
	
	public function isEmpty ()
	{
		return width <= 0 || height <= 0;
	}
	
	
	/**
	 * Method to check if the given rectangle intersects with this rectangle
	 * @param rect IntRectangle
	 * @return Bool
	 */
	public function intersectsWith (rect:IntRectangle) : Bool
	{
		var maxLeft		= IntMath.max( rect.left, left );
		var minRight	= IntMath.min( rect.right, right );
		var maxTop		= IntMath.max( rect.top, top );
		var minBottom	= IntMath.min( rect.bottom, bottom );
		return maxLeft < minRight && maxTop < minBottom;
	}
	
	
	
	/**
	 * Method will make sure that the values of this rectangle stay within
	 * the boundaries of the given boundaries.
	 * 
	 * @return returns false if the intrectangle is changed.
	 */
	public function stayWithin (bounds:IntRectangle) : Bool
	{
		var c = invalidatable;
		invalidatable	= false;
		var isChanged	= false;
		
		if		(left	< bounds.left)		{ left		= bounds.left;		isChanged = true; }
		else if (right	> bounds.right)		{ right		= bounds.right;		isChanged = true; }
		if		(top	< bounds.top)		{ top		= bounds.top;		isChanged = true; }
		else if (bottom > bounds.bottom)	{ bottom	= bounds.bottom;	isChanged = true; }
		
		invalidatable = c;
		return !isChanged;
	}


	public #if !noinline inline #end function containsPoint (x:Int, y:Int) : Bool
	{
		return x >= left && x <= right && y >= top && y <= bottom;
	}
	
	
#if debug
	private static var counter : Int = 0;
	private var id : Int;
	public function toString ()
	{
		return "IntRect"+id+" (x=" + left + ", y=" + top + ", width=" + width + ", height=" + height + ", r=" + right + ", b=" + bottom+" )";
	}
	
	
	public function readChanges ()
	{
		return RectangleFlags.readProperties(changes);
	}
#end
}