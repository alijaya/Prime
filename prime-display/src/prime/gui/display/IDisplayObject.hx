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
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.gui.display;
 import prime.core.geom.Point;
 import prime.core.geom.Rectangle;


/**
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
interface IDisplayObject 
				extends prime.gui.traits.IDisplayable
				extends prime.gui.traits.IPositionable
				extends prime.gui.traits.IScaleable
				extends prime.gui.traits.ISizeable
#if (flash9 || nme)
				extends flash.display.IBitmapDrawable #end
{
	
	public function isObjectOn			(otherObj:IDisplayObject)					: Bool;
#if !CSSParser
	public function getDisplayCursor	()											: DisplayDataCursor;
	
	/**
	 * Method will attach this IDisplayObject to the given Sprite.
	 * @return own-instance
	 */
	public function attachDisplayTo		(target:IDisplayContainer, pos:Int = -1)	: IDisplayObject;
	
	/**
	 * Method will detach this IDisplayObject from its parent sprite.
	 * @return own-instance
	 */
	public function detachDisplay		()											: IDisplayObject;
	
	public function changeDisplayDepth	(newDepth:Int)								: IDisplayObject;
#end

	public function globalToLocal 	(point : Point) 					: Point;
	public function localToGlobal 	(point : Point) 					: Point;
	public function getBounds 	  	(other:DisplayObject)				: Rectangle;

#if flash9
	public var alpha				: Float;
	
	public var mouseX				(default, never)		: Float;
	public var mouseY				(default, never)		: Float;
	
	public var filters				: Array<flash.filters.BitmapFilter>;
	public var name					: String;
	public var scrollRect			: flash.geom.Rectangle;
	public var parent 				(default, null) 					: flash.display.DisplayObjectContainer;
	
#elseif nme
	public var filters(get_filters, set_filters):Array<Dynamic>; //FIXME: flash.filters.BitmapFilter
	public var scrollRect(get_scrollRect, set_scrollRect):Rectangle;

  #if html5
	public var alpha:Float;

	public var mouseX(get_mouseX, never):Float;
	public var mouseY(get_mouseY, never):Float;

	public var name:String;
	public var parent(default, set_parent):flash.display.DisplayObjectContainer;

  #elseif cpp
	public var alpha(get_alpha, set_alpha):Float;

	public var mouseX(get_mouseX, null):Float;
	public var mouseY(get_mouseY, null):Float;

	public var name(get_name, set_name):String;
	public var parent(get_parent, null):flash.display.DisplayObjectContainer;

  #end
#else
	public var parent                             : IDisplayContainer;
	public var visible (get_visible, set_visible) : Bool;
	public var alpha   (get_alpha,   set_alpha)   : Float;
#end
}