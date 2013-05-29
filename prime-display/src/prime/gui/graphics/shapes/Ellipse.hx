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
package prime.gui.graphics.shapes;
 import prime.core.geom.Corners;
 import prime.core.geom.IRectangle;
 import prime.gui.traits.IGraphicsOwner;
  using prime.gui.utils.GraphicsUtil;



/**
 * @author Ruben Weijers
 * @creation-date Aug 01, 2010
 */
class Ellipse extends ShapeBase, implements IGraphicShape
{
	public function draw (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners) : Void
	{
#if flash9
		target.graphics.drawEllipse( bounds.left, bounds.top, bounds.width, bounds.height );
#end
	}
	
	
	public function drawFraction (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners, percentage:Float) : Void
	{
		var radiusX = bounds.width * .5;
		var radiusY = bounds.height * .5;
#if flash9
		target.drawEllipseArc(bounds.left + radiusX, bounds.top + radiusY, radiusX, radiusY, percentage);
#end
	}
	
	
#if (CSSParser || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "ellipse";
	}
#end
}