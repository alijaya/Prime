/*
 * Copyright (c) 2013, The PrimeVC Project Contributors
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
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UIContainer;
// import primevc.gui.core.UIGraphic;
  using primevc.utils.Bind;


/**
 * Demo to show how you can switch between layout algorithms
 *
 * @author			Ruben Weijers
 * @creation-date	Mar 26, 2013
 */
class ChangeLayoutAlgorithm extends primevc.gui.core.UIWindow
{
	public static function main ()
		primevc.gui.display.Window.startup(function (stage) { return new ChangeLayoutAlgorithm(stage); })


	private var holder 	: UIContainer;
	private var menu    : UIComponent;
	private var content : UIComponent;
	private var footer  : UIComponent;
	private var hasStyle2 = false;


	override private function createChildren () {
		holder = new UIContainer("holder");
		holder.attach(menu    = new UIComponent("menu"));
		holder.attach(content = new UIComponent("content"));
		holder.attach(footer  = new UIComponent("footer"));
		attach(holder);

		changeAlgorithm.on(userEvents.mouse.click, this);
	}


	private function changeAlgorithm ()
	{
		trace("change " + hasStyle2);
		if (hasStyle2)	styleClasses.remove("style2");
		else 			styleClasses.add("style2");
		hasStyle2 = !hasStyle2;
	}
}