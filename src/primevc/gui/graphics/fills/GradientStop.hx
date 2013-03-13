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
package primevc.gui.graphics.fills;
#if CSSParser
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.types.RGBA;
#if (debug || CSSParser)
  using primevc.utils.Color;
  using primevc.utils.NumberUtil;
#end


/**
 * Defines a color-position in a gradient.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class GradientStop extends GraphicElement
{
	public var color		(default, set_color)	: RGBA;
	public var position		(default, set_position)	: Int;
	
	
	public function new (color:RGBA, position:Int)
	{
		super();
		this.color		= color;
		this.position	= position;
	}
	
	
	private inline function set_color (v:RGBA)
	{
		if (v != color) {
			color = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
	private inline function set_position (v:Int)
	{
		if (v != position) {
			position = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
#if CSSParser
	override public function toCSS (prefix:String = "")		{ return color.string() + " " + ((position / 255) * 100).roundFloat() + "%"; }
	override public function toCode (code:ICodeGenerator)	{ code.construct( this, [ color, position ] ); }
#end
}