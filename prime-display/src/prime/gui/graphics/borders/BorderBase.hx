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
package prime.gui.graphics.borders;
 import prime.core.geom.IRectangle;
 import prime.gui.graphics.GraphicElement;
 import prime.gui.graphics.GraphicFlags;
 import prime.gui.graphics.IGraphicProperty;
 import prime.gui.traits.IGraphicsOwner;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;


/**
 * Base class for borders
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class BorderBase <FillType:IGraphicProperty> extends GraphicElement implements IBorder
{
	public var weight		(default, set_weight)		: Float;
	public var fill			(default, set_fill)			: FillType;
	/**
	 * The capsstyle that is used at the end of lines
	 */
	public var caps			(default, set_caps)			: CapsStyle;
	/**
	 * The jointstyle that is used at angles
	 */
	public var joint		(default, set_joint)		: JointStyle;
	public var pixelHinting	(default, set_pixelHinting)	: Bool;
	/**
	 * Should this border be drawn on the inside of the parent shape (true) or
	 * on the outside of the parentshape.
	 */
	public var innerBorder	(default, set_innerBorder)	: Bool;
	
	
	
	public function new ( fill:FillType, weight:Float = 1.0, innerBorder:Bool = false, caps:CapsStyle = null, joint:JointStyle = null, pixelHinting:Bool = false )
	{
		super();
#if flash9
		Assert.isNotNull(fill);
#end
		this.fill			= fill;
		this.weight			= weight;
		this.caps			= caps != null ? caps : CapsStyle.NONE;
		this.joint			= joint != null ? joint : JointStyle.ROUND;
		this.innerBorder	= innerBorder;
		this.pixelHinting	= pixelHinting;
	}
	
	
	override public function dispose ()
	{
		fill = null;
		super.dispose();
	}
	
	
	public function begin (target:IGraphicsOwner, bounds:IRectangle)
	{
#if flash9
		if (!innerBorder && bounds.notNull())
		{
			var borderW		= (weight * target.scaleX).roundFloat();
			var borderH		= (weight * target.scaleY).roundFloat();
			
			bounds.move(	bounds.left - borderW,			bounds.top - borderH );
			bounds.resize(	bounds.width + (borderW * 2),	bounds.height + (borderH * 2) );
		}
#end
	}
	
	
	public function end (target:IGraphicsOwner, bounds:IRectangle)
	{
#if flash9
		target.graphics.lineStyle( 0, 0 , 0 );
		if (!innerBorder && bounds.notNull())
		{
			var borderW		= (weight * target.scaleX).roundFloat();
			var borderH		= (weight * target.scaleY).roundFloat();
			
			bounds.move(	bounds.left + borderW,			bounds.top + borderH );
			bounds.resize(	bounds.width - (borderW * 2),	bounds.height - (borderH * 2) );
		}	
#end
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function set_weight (v:Float)
	{
		if (v != weight) {
			weight = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}
	
	
	private inline function set_fill (v:FillType)
	{
		if (v != fill) {
			if (fill != null)
				fill.invalidated.unbind(this);
			
			fill = v;
			if (fill != null)
				fill.invalidated.bind(this, invalidateCall);
			
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function set_caps (v:CapsStyle)
	{
		if (v != caps) {
			caps = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function set_joint (v:JointStyle)
	{
		if (v != joint) {
			joint = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function set_pixelHinting (v:Bool)
	{
		if (v != pixelHinting) {
			pixelHinting = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function set_innerBorder (v:Bool)
	{
		if (v != innerBorder) {
			innerBorder = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}
	

#if (CSSParser || debug)
	override public function toCSS (prefix:String = "")
	{
		return fill + " " + weight + "px " + (innerBorder ? "inside" : "outside");
	}
#end
#if CSSParser
	override public function isEmpty () : Bool
	{
		return fill == null;
	}
	
	
	override public function toCode (code:prime.tools.generator.ICodeGenerator)
	{
		code.construct( this, [ fill, weight, innerBorder, caps, joint, pixelHinting ] );
	}
#end
}