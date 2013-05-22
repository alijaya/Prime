/*
 * Copyright (c) 2012, The PrimeVC Project Contributors
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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package examples.layout;
 import prime.gui.core.UIComponent;
 import prime.gui.core.UIGraphic;
 import prime.gui.core.UIWindow;
 import prime.gui.display.Window;
 import prime.gui.graphics.fills.SolidFill;
 import prime.gui.graphics.shapes.RegularRectangle;
  using prime.utils.Bind;


/**
 * LayoutExample3 is identical to LayoutExample2 but uses the prime.gui.core package instead
 * of prime.gui.display.
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
class LayoutExample3 extends UIWindow
{
	public static function main ()
		Window.startup(function (stage) { return new LayoutExample3(stage); })


	override private function createChildren ()
	{
		stylingEnabled = false;
		// ----
		// Some example layout-algorithms - uncomment to try em out.
		// ----
	//	layoutContainer.algorithm = new prime.layout.algorithms.tile.SimpleTileAlgorithm(vertical);
		layoutContainer.algorithm = new prime.layout.algorithms.tile.SimpleTileAlgorithm();
	//	layoutContainer.algorithm = new prime.layout.algorithms.DynamicLayoutAlgorithm( function () { return new prime.layout.algorithms.circle.HorizontalCircleAlgorithm(); }, function () { return new prime.layout.algorithms.circle.VerticalCircleAlgorithm(); } );
	//	layoutContainer.algorithm = new prime.layout.algorithms.DynamicLayoutAlgorithm( function () { return new prime.layout.algorithms.floating.HorizontalFloatAlgorithm(); }, function () { return new prime.layout.algorithms.circle.VerticalCircleAlgorithm(); } );

		// create children
		for (i in 0...20)	attach( new Box() );
		for (i in 0...20)	attach( new InteractiveBox() );
		for (i in 0...20)	attach( new Box() );
	}
}


/**
 * A simple Box which is positioned by the layout code in LayoutExample2
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
private class Box extends UIGraphic
{
	public function new () 
	{
		super();
		stylingEnabled 		= false;
		visible 			= true;
		graphicData.fill	= new SolidFill(0xffaaaaff);
		graphicData.shape	= new RegularRectangle();
		layout.margin		= new prime.core.geom.Box(20,5);
		layout.resize( 30, 50 );
	}
}


/**
 * A simple Box with mouse hover interactions which is positioned by the layout code in LayoutExample3
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
private class InteractiveBox extends UIComponent
{
	private var normalFill	: SolidFill;
	private var hoverFill	: SolidFill;


	public function new () 
	{
		super();
		stylingEnabled 		= false;
		hoverFill 			= new SolidFill(0xeeaaddff);
		visible 			= true;
		graphicData.fill 	= normalFill = new SolidFill(0xffaaaaff);
		graphicData.shape 	= new RegularRectangle();
		layout.margin 		= new prime.core.geom.Box(20,5);
		layout.resize( 30, 50 );
	}
	

	override private function createBehaviours () {
		makeBigger.on( userEvents.mouse.rollOver, this );
		makeNormal.on( userEvents.mouse.rollOut, this );
	}


	private function makeNormal ()	{ layout.resize(30,50); graphicData.fill = normalFill; }
	private function makeBigger ()	{ layout.resize(80,80); graphicData.fill = hoverFill; }
}
