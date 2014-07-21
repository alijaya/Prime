

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
package prime.gui.components;
 import prime.signals.Wire;
 import prime.bindable.Bindable;

 import prime.gui.core.UITextField;
 import prime.gui.core.Skin;
 import prime.gui.events.KeyboardEvents;
 import prime.gui.events.UserEventTarget;
 import prime.gui.input.Keyboard;
 import prime.gui.input.KeyCodes;

  using prime.gui.input.KeyCodes;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;


private typedef Flags = prime.gui.core.UIElementFlags;


/**
 * TODO: TextArea component displays a multiline textfield and adds the posibility
 * to divide the text of the component in multiple columns.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 27, 2011
 */
class TextArea<VOType> extends InputField<VOType>
{
	override private function createChildren ()
	{
		field = UITextField.createLabelField(id.value + "TextField", data, this, layoutContainer);
#if (flash9 || nme)
		handleKeyDown.on( field.userEvents.key.down, this );
        field.makeEditable();
        field.mouseEnabled = field.tabEnabled = true;
        field.multiline    = true;
#end
		attachDisplay(field);
		Assert.isNull( layoutContainer.algorithm );
		Assert.isNull( skin );
	}


	override public  function disposeChildren ()
	{
		field.dispose();
		field = null;
	}


	override public function validate ()
	{
		var c = changes;
		super.validate();
		if (c.has( Flags.TEXTSTYLE )) {
			field.embedFonts	= embedFonts;
			field.wordWrap		= wordWrap;
			field.textStyle 	= textStyle;
		}
		if (c.has( Flags.RESTRICT ))		field.restrict	= restrict;
		if (c.has( Flags.MAX_CHARS ))		field.maxChars	= maxChars;
	}
	

#if (flash9 || nme)
	override public function isFocusOwner (target:UserEventTarget)
	{
		return target == this || field.isFocusOwner(target);
	}


	private function updateScroll ()
	{
		updateLayoutScrollY();
		updateLayoutScrollX();
	}


	private function handleKeyDown (k:KeyboardState)
	{
		switch (k.keyCode()) {
			case KeyCodes.LEFT, KeyCodes.RIGHT:		updateLayoutScrollX();
			case KeyCodes.UP, 	KeyCodes.DOWN:		updateLayoutScrollY();
			default:
		}
	}



	//
	// SCROLLING
	//

    private var scrollX 	: Wire<Dynamic>;
    private var scrollY 	: Wire<Dynamic>;


	override public function enableClipping ()
	{
        var s   = layoutContainer.scrollPos;
        scrollX = applyLayoutScrollX.on( s.xProp.change, this );
        scrollY = applyLayoutScrollY.on( s.yProp.change, this );
        updateScroll.on( layout.changed, true );
	}


	override public function disableClipping ()
	{
		scrollX.dispose();
		scrollY.dispose();
		scrollX = scrollY = null;
		layout.changed.unbind(this, cast updateScroll);
	}


    private function updateLayoutScrollX ()
    {
    	Assert.isNotNull(field);
    	Assert.isNotNull(layoutContainer);
    	Assert.isNotNull(layoutContainer.scrollPos);
    	Assert.isNotNull(scrollX);
    	var f = field, l = layoutContainer;			//	a      =        b - 1  		 /    c - 1            * d
    	if (f.maxScrollH > 1) { scrollX.disable(); l.scrollPos.x = (((f.scrollH - 1) / (f.maxScrollH - 1)) * l.scrollableWidth).floorFloat(); scrollX.enable(); }
    }


    private function updateLayoutScrollY ()
    {
    	Assert.isNotNull(field);
    	Assert.isNotNull(layoutContainer);
    	Assert.isNotNull(layoutContainer.scrollPos);
    	Assert.isNotNull(scrollY);
    	var f = field, l = layoutContainer;			//	a      =        b - 1    	 /    c - 1            * d
    	if (f.maxScrollV > 1) { scrollY.disable(); l.scrollPos.y = (((f.scrollV - 1) / (f.maxScrollV - 1)) * l.scrollableHeight).floorFloat(); scrollY.enable(); }
    }


    /** @see updateScrollY **/
    private function applyLayoutScrollX (newV:Int, oldV:Int)
    {
        var f = field, l = layoutContainer;
        f.scrollH = (((l.scrollPos.x / l.scrollableWidth) * (f.maxScrollH - 1)) + 1).floorFloat();
    }
    
    
    private function applyLayoutScrollY (newV:Int, oldV:Int)
    {
        var f = field, l = layoutContainer;

    /*  var a = l.scrollPos.y;
        var c = f.maxScrollV;
        var d = l.scrollableHeight;
    	a =  ((b - 1) / (c - 1)) * d
        (b - 1) / (c - 1) = (a / d)
        (b - 1) = (a / d) * (c - 1)
        b       = ((a / d) * (c - 1)) + 1 */
        f.scrollV = (((l.scrollPos.y / l.scrollableHeight) * (f.maxScrollV - 1)) + 1).floorFloat();
    }
#end
}