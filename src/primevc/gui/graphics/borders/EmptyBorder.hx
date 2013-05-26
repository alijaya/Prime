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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.graphics.borders;
#if CSSParser
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.IGraphicProperty;
 import primevc.gui.traits.IGraphicsOwner;


/**
 * FIXME, find a better solution to do this.
 * 
 * @author Ruben Weijers
 * @creation-date May 4, 2011
 */
class EmptyBorder extends GraphicElement implements IGraphicProperty implements IBorder
{
	public var weight		(default, set_weight)		: Float;
	public var innerBorder	(default, set_innerBorder)	: Bool;
	
	
	public #if !noinline inline #end function begin (target:IGraphicsOwner, bounds:IRectangle)
	{
		Assert.abstractMethod('this class is supposed to be ignored');
	}
	
	
	public #if !noinline inline #end function end (target:IGraphicsOwner, bounds:IRectangle)
	{
		Assert.abstractMethod('this class is supposed to be ignored');
	}
	
	
	private inline function set_weight (v:Float)			{ return 0; }
	private inline function set_innerBorder (v:Bool)		{ return false; }
	
	
#if CSSParser
	override public function toCSS (prefix:String = "")		{ return "none"; }
	override public function toCode (code:ICodeGenerator)	{ code.construct( this, [] ); }
#end
}