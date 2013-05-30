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
package prime.gui.graphics.fills;
 import prime.core.geom.IRectangle;
 import prime.core.geom.Matrix2D;
 import prime.gui.graphics.GraphicFlags;
 import prime.gui.traits.IGraphicsOwner;
  using prime.utils.Color;
  using prime.utils.FastArray;
  using prime.utils.RectangleUtil;
  using prime.utils.Formulas;
  using prime.utils.TypeUtil;

#if flash9
typedef FlashGradientType = flash.display.GradientType;
#end


/**
 * Gradient fill.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class GradientFill extends prime.gui.graphics.GraphicElement implements prime.gui.graphics.IGraphicProperty 
{
	public var gradientStops	(default, null)					: FastArray <GradientStop>;
	public var type				(default, set_type)				: GradientType;
	public var spread			(default, set_spread)			: SpreadMethod;
	public var focalPointRatio	(default, set_focalPointRatio)	: Float;
	public var isFinished		(default, null)					: Bool;
	
	/**
	 * gradient rotation in degrees
	 */
	public var rotation			(default, set_rotation)	: Int;
	
	private var lastBounds		: IRectangle;
	private var lastMatrix		: Matrix2D;
	
	
	public function new (type:GradientType = null, spread:SpreadMethod = null, focalPointRatio:Float = 0, rotation:Int = 0)
	{
		super();
		gradientStops			= FastArrayUtil.create();
		this.type				= type == null ? GradientType.linear : type;
		this.spread				= spread == null ? SpreadMethod.normal : spread;
		this.focalPointRatio	= focalPointRatio;
		this.rotation			= rotation;
		isFinished				= false;
	}
	
	
	override public function dispose ()
	{
		for (fill in gradientStops)
			fill.dispose();
		
		gradientStops	= null;
		lastBounds		= null;
		lastMatrix		= null;
		
		super.dispose();
	}
	
	
	
	//
	// SETTERS
	//
	
	private inline function set_rotation ( v:Int )
	{
		if (v != rotation) {
			lastMatrix	= null;
			rotation	= v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
	private inline function set_type (v:GradientType)
	{
		if (v != type) {
			type = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function set_spread (v:SpreadMethod)
	{
		if (v != spread) {
			spread = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function set_focalPointRatio (v:Float)
	{
		if (v != focalPointRatio) {
			focalPointRatio = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
	
	
	//
	// FILL METHODS
	//
	
	public #if !noinline inline #end function begin (target:IGraphicsOwner, bounds:IRectangle)
	{
		Assert.that( gradientStops.length >= 2, "There should be at least be two fills in an gradient.");
			
#if flash9
		if (lastMatrix == null || bounds != lastBounds || !bounds.isEqualTo(lastBounds))
			lastMatrix = createMatrix(bounds);
		
		//TODO: MORE EFFICIENT TO CACHE THIS? MEMORY vs. SPEED
		var colors	= new Array();
		var alphas	= new Array();
		var ratios	= new Array();
		
		for (fill in gradientStops) {
			colors.push( fill.color.rgb() );
			alphas.push( fill.color.alpha().float() );
			ratios.push( fill.position );
		}
		
		target.graphics.beginGradientFill( getFlashType(), colors, alphas, ratios, lastMatrix, getSpreadMethod(), flash.display.InterpolationMethod.RGB, focalPointRatio  );
#end
		isFinished = true;
	}
	
	
	public #if !noinline inline #end function end (target:IGraphicsOwner, bounds:IRectangle)
	{
#if flash9
		target.graphics.endFill();
#end
		isFinished = false;
	}
	
	
#if flash9
	public #if !noinline inline #end function createMatrix (bounds:IRectangle) : Matrix2D
	{
		var m = new Matrix2D();
		m.createGradientBox( bounds.width, bounds.height, rotation.degreesToRadians() );
		lastBounds = bounds.clone().as(IRectangle);
		return m;
	}
#end
	

#if flash9
	public #if !noinline inline #end function getFlashType () : FlashGradientType
	{
		return (type == GradientType.linear) ? FlashGradientType.LINEAR : FlashGradientType.RADIAL;
	}
	
	public function getSpreadMethod () : flash.display.SpreadMethod {
		return switch (spread) {
			case SpreadMethod.normal:	flash.display.SpreadMethod.PAD;
			case SpreadMethod.reflect:	flash.display.SpreadMethod.REFLECT;
			case SpreadMethod.repeat:	flash.display.SpreadMethod.REPEAT;
		}
	}
#end
	
	
	
	//
	// LIST METHODS
	//
	
	public function add ( fill:GradientStop, depth:Int = -1 )
	{
		gradientStops.insertAt( fill, depth );
		fill.invalidated.bind(this, invalidateCall);
		invalidate( GraphicFlags.FILL );
	}
	
	
	public function remove ( fill:GradientStop )
	{
		gradientStops.removeItem(fill);
		fill.dispose();
		invalidate( GraphicFlags.FILL );
	}
	
	
#if CSSParser
	override public function toCSS (prefix:String = "")
	{
		var colorStr = gradientStops.join(", ");
		if (type == GradientType.linear)
			return "linear-gradient( " + rotation + "deg, " + colorStr + ", " + spread + " )";
		else
			return "radial-gradient( " + focalPointRatio + ", " + colorStr + ", " + spread + " )";
	}
	
	
	override public function toCode (code:prime.tools.generator.ICodeGenerator)
	{
		code.construct( this, [ type, spread, focalPointRatio, rotation ] );
		for (stop in gradientStops)
			code.setAction( this, "add", [ stop ] );
	}
#end
}