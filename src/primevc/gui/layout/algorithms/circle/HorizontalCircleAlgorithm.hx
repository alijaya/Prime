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
package primevc.gui.layout.algorithms.circle;
 import apparat.math.FastMath;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.HorizontalBaseAlgorithm;
 import primevc.gui.layout.algorithms.IHorizontalAlgorithm;
 import primevc.utils.Formulas;
 import primevc.utils.NumberMath;
  using primevc.utils.Formulas;
  using primevc.utils.NumberUtil;
  using primevc.utils.NumberMath;
 

/**
 * Algorithm to place layoutClients in a horizontal circle
 * 
 * @creation-date	Jul 7, 2010
 * @author			Ruben Weijers
 */
class HorizontalCircleAlgorithm extends HorizontalBaseAlgorithm, implements IHorizontalAlgorithm
{
	/**
	 * isEllipse defines if the circle that is drawn can be an ellipse or should
	 * always be a complete circle (by using the same radius for both hor and
	 * vertical).
	 * 
	 * @default		true
	 */
	public var isEllipse	(default, null)			: Bool;
	
	
	public function new ( ?direction:Horizontal, ?vertical:Vertical = null, ?isEllipse:Bool = true )
	{
		super(direction, vertical);
		this.isEllipse = isEllipse;
	}
	
	
	
	//
	// LAYOUT
	//
	
	
	public inline function validate ()
	{
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	/**
	 * Method will return the total width of all the children.
	 */
	public inline function validateHorizontal ()
	{
	//	var width:Int = group.width.value;
	/*	if (group.childWidth.notSet())
		{
			for (child in group.children)
				if (child.includeInLayout)
					width += child.bounds.width;
		}
		else
		{
			width = group.childWidth * (group.children.length.divCeil(2) + 1);
		}
		*/
		setGroupWidth(group.width.value);
	}
	
	
	override public function apply ()
	{
		switch (direction) {
			case Horizontal.left:		applyLeftToRight();
			case Horizontal.center:		applyCentered();
			case Horizontal.right:		applyRightToLeft();
		}
		super.apply();
	}
	
	
	private inline function applyCircle (startRadians:Float)
	{
		if (group.children.length > 0)
		{
			var childAngle		= (360 / group.children.length).degreesToRadians();
			var angle:Float		= 0;
			var radius:Int		= getRadius();
			var i:Int			= 0;
			var pos:Int			= 0;
			var start			= getLeftStartValue() + getRadius();
			
			for (child in group.children) {
				if (!child.includeInLayout)
					continue;
				
				angle	= (childAngle * i) + startRadians;
				pos		= start + ( radius * FastMath.cos(angle) ).roundFloat();
				var halfChildWidth	= ( child.outerBounds.width * .5 ).roundFloat();
				var doCenter		= pos.isWithin( radius - halfChildWidth, radius + halfChildWidth );
				
				if		(doCenter)				child.outerBounds.centerX	= pos;
				else if	(pos > radius)			child.outerBounds.right		= pos;
				else							child.outerBounds.left		= pos;
				i++;
			}
		}
	}
	
	
	private inline function applyLeftToRight ()	: Void		{ applyCircle( 0 ); }					//   0 degrees
	private inline function applyCentered ()	: Void		{ applyCircle( -FastMath.HALVE_PI ); }	//- 90 degrees
	private inline function applyRightToLeft () : Void		{ applyCircle( -FastMath.PI ); }		//-180 degrees
	
	
	public inline function getDepthForBounds (bounds:IRectangle)
	{
		var childAngle		= (360 / group.children.length).degreesToRadians();
		var radius:Float	= getRadius();
		var posX:Float		= IntMath.max(0, bounds.left - getLeftStartValue()) - radius;
		var startRadians	= switch (direction) {
			case Horizontal.left:		0;
			case Horizontal.center:		-FastMath.HALVE_PI;
			case Horizontal.right:		-FastMath.PI;
		}
		
		//the formula of applyCircle reversed..
		var itemRadians = FastMath.acos(posX / radius) - startRadians;
		return ( itemRadians / childAngle ).roundFloat();
	}
	
	
	
	//
	// START VALUES
	//


	private inline function getRadius () : Int {
		return ( isEllipse ? group.width.value * .5 : Formulas.getCircleRadius(group.width.value, group.height.value) ).roundFloat();
	}
	
#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "ver-circle (" + direction + ", " + vertical + ")";
	}
#end
}