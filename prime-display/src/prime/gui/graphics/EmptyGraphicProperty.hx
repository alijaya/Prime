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
package prime.gui.graphics;
 import prime.core.geom.IRectangle;
 import prime.gui.traits.IGraphicsOwner;


/**
 * FIXME, find a better solution to do this.
 * 
 * @author Ruben Weijers
 * @creation-date Mar 14, 2011
 */
class EmptyGraphicProperty extends GraphicElement implements IGraphicProperty
{
	public #if !noinline inline #end function begin (target:IGraphicsOwner, bounds:IRectangle)
	{
		Assert.abstractMethod('this class is supposed to be ignored');
	}
	
	
	public #if !noinline inline #end function end (target:IGraphicsOwner, bounds:IRectangle)
	{
		Assert.abstractMethod('this class is supposed to be ignored');
	}
	
	
#if CSSParser
	override public function toCSS (prefix:String = "")							{ return "none"; }
	override public function toCode (code:prime.tools.generator.ICodeGenerator)	{ code.construct( this, [] ); }
#end
}