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
package primevc.gui.components.skins;
 import primevc.gui.components.Button;
 import primevc.gui.components.Image;
 import primevc.gui.core.UITextField;
 import primevc.gui.core.Skin;
 import primevc.gui.events.UserEventTarget;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;



private typedef Flags = primevc.gui.core.UIElementFlags;


/**
 * ButtonSkin for a button with a label and a icon.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 19, 2011
 */
class ButtonIconLabelSkin extends Skin<Button>
{
	private var iconGraphic		: Image;
	private var labelField		: UITextField;
	
	
	override public function createChildren ()
	{
		//create children
		iconGraphic	= new Image(#if debug owner.id.value + "Icon" #else null #end, owner.icon);
		iconGraphic.mouseEnabled = false;
		labelField	= UITextField.createLabelField(owner.id.value + "TextField", owner.data, owner);
		
		//change properties of new UIElements
		iconGraphic.maintainAspectRatio = true;
	//	if (owner.icon != null)
			owner.attach(iconGraphic);
		
		owner.attach(labelField);
	}
	
	
	override public  function disposeChildren ()
	{
		if (iconGraphic != null) {
			iconGraphic.dispose();
			iconGraphic = null;
		}
		
		if (labelField != null) {
			labelField.dispose();
			labelField	= null;
		}
	}
	
	
	override public function validate (changes:Int)
	{
#if debug
		Assert.notNull(iconGraphic, owner+"; "+iconGraphic+"; "+labelField+"; "+owner.isDisposed());
#end	if (changes.has( Flags.ICON )) {
			iconGraphic.data = owner.icon;
	/*		if 		(owner.icon == null)		iconGraphic.detach();
			else if (!iconGraphic.isOnStage()) 	iconGraphic.attachTo(owner, 0);
	*/	}
#if flash9
		if (changes.has( Flags.ICON_FILL ))		iconGraphic.colorize( owner.iconFill );

		if (changes.has( Flags.TEXTSTYLE )) {
			labelField.embedFonts	= owner.embedFonts;
			labelField.wordWrap		= owner.wordWrap;
			labelField.textStyle 	= owner.textStyle;
		}
#end
	}
	
	
#if flash9
	override public function isFocusOwner (target:UserEventTarget)
	{
		return labelField.isFocusOwner(target);
	}
#end
}