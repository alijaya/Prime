

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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package prime.gui.components;
 import prime.bindable.Bindable;
 import prime.gui.core.UIContainer;
 import prime.gui.events.MouseEvents;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


/**
 * ToggleGroup contains a group of buttons. Only one button can be active within
 * this group.
 * 
 * @author Ruben Weijers
 * @creation-date May 26, 2011
 */
class ToggleGroup extends UIContainer
{
	public var selected (default, null)	: Bindable<Button>;
	
	
	public function new (id:String = null)
	{
		super(id);
		selected = new Bindable<Button>();
		#if prime_css setStyles.on( selected.change, this ); #end
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		selected.dispose();
		selected = null;
		super.dispose();
	}
	
	
	public function add (button:Button, depth:Int = -1) : Button
	{
		Assert.that( !children.has(button) );
		setActive.on( button.userEvents.mouse.click, this );
		
		#if prime_css button.styleClasses.add( "toggleBtn" ); #end
		button.attachTo(this, depth);
		return button;
	}
	
	
	public function remove (button:Button) : Button
	{
		Assert.that( children.has(button) );
		button.userEvents.mouse.click.unbind(this);
		#if prime_css button.styleClasses.remove( "toggleBtn" ); #end
		button.detach();
		return button;
	}
	
	
	public #if !noinline inline #end function select (btn:Button) : Void
	{
		selected.value = btn;
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function setActive (mouseEvt:MouseState) : Void
	{
		select(mouseEvt.target.as(Button));
	}
	
#if prime_css
	private function setStyles (newVal:Button, oldVal:Button)
	{
		if (oldVal != null)		oldVal.styleClasses.remove("active");
		if (newVal != null)		newVal.styleClasses.add("active");
	}
#end
}