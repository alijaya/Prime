

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
package prime.gui.components.skins;
 import prime.gui.components.Image;
  using prime.utils.BitUtil;


/**
 * Skin for a button with only an icon.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 19, 2011
 */
class ButtonIconSkin extends prime.gui.core.Skin<prime.gui.components.Button>
{
	public var iconGraphic (default, null) : Image;
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new prime.gui.behaviours.components.DirectToolTipBehaviour( owner, owner.data ) );
	}
	

	override public function createChildren ()
	{
		if (owner.layoutContainer.algorithm == null)
			owner.layoutContainer.algorithm = new prime.layout.algorithms.float.HorizontalFloatAlgorithm(prime.core.geom.space.Horizontal.center, prime.core.geom.space.Vertical.center);
		owner.attach( iconGraphic = new Image(#if debug owner.id.value + "Icon" #else null #end, owner.icon) );
		iconGraphic.maintainAspectRatio = true;
	}
	

	override public  function disposeChildren ()
	{
		if (iconGraphic != null)
		{
			iconGraphic.detach();
			iconGraphic.dispose();
			iconGraphic = null;
		}
	}


	override public function validate (changes:Int)
	{
		if (changes.has( prime.gui.core.UIElementFlags.ICON ))			iconGraphic.data = owner.icon;
		if (changes.has( prime.gui.core.UIElementFlags.ICON_FILL ))		iconGraphic.colorize( owner.iconFill );
	}
}