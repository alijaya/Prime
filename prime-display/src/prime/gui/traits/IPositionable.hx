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
package prime.gui.traits;

#if (flash9 || nme)
 import flash.geom.Transform;
#end

/**
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
interface IPositionable #if !CSSParser extends IDisplayable #end
{
#if flash9
	
	var x						: Float;
	var y						: Float;
	var rotation				: Float;
	var transform				: Transform;
	var visible					: Bool;
	
	#if flash10
	var rotationX				: Float;
	var rotationY				: Float;
	var rotationZ				: Float;
	var z						: Float;
	#end

#elseif nme
	public var x(get_x, set_x):Float;
	public var y(get_y, set_y):Float;
	public var rotation(get_rotation, set_rotation):Float;
  #if html5
	public var transform(default, set_transform):Transform;
  #else
	public var transform(get_transform, set_transform):Transform;
  #end
	public var visible(get_visible, set_visible):Bool;

#else
	var x			(get_x,		set_x) : Float;
	var y			(get_y,		set_y) : Float;
	var transform	(default, 	null) : prime.core.geom.Matrix2D;
#end
}