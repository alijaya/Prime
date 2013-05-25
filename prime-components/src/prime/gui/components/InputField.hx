

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
 import prime.bindable.RevertableBindable;
 import prime.gui.core.UITextField;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


private typedef Flags = prime.gui.core.UIElementFlags;


/**
 * InputField component
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class InputField <VOType> extends DataButton <VOType>
{
	public var hasFocus				(default, null)			: Bool;
	
	/**
	 * Method that should be injected into the InputField. The method is
	 * responsible for validating the value of the inputfield and updating
	 * the data object.
	 * 
	 * The method is called when:
	 * 		- the inputfield loses focus
	 * 		- the user presses enter while the inputfield has focus
	 */
	public var updateVO				(default, setUpdateVO)	: Void -> Void;
	/**
	 * @see flash.text.TextField#maxChars
	 */
	public var maxChars				(default, setMaxChars)	: Int;
	/**
	 * @see flash.text.TextField#restrict
	 */
	public var restrict				(default, setRestrict)	: String;
	
	/**
	 * Reference to the textfield.
	 * Property is set by the InputFieldSkin
	 */
	public var field				(default, null)			: UITextField;

	private var fieldBinding		: Wire<Dynamic>;
	
	
	public function new (id:String = null, defaultLabel:String = null, icon = null, vo:VOType = null)
	{
		var d = new RevertableBindable<String>("");
		d.dispatchAfterCommit();
		d.updateAfterCommit();
		data = d;

		super(id, defaultLabel, icon, vo);
		updateVO 	= doNothing;
	}
	
	
	override private function init ()
	{
		handleFocus	.on( userEvents.focus, this );
		handleBlur	.on( userEvents.blur, this );
		
		fieldBinding = updateVO.on(data.change, this);
		if (!hasFocus)
			fieldBinding.disable();
		
		super.init();
	}
	
	
	override public function dispose ()
	{
		(untyped this).updateVO = null;
		
		if (fieldBinding != null) {
			fieldBinding.dispose();
			fieldBinding = null;
		}
		super.dispose();
	}
	
	
	private inline function getRevertableData ()	return cast( data, RevertableBindable<String>)

	
	//
	// SETTERS
	//
	
	
	private inline function setRestrict (v:String) : String
	{
		if (restrict != v) {
			restrict = v;
			invalidate( Flags.RESTRICT );
		}
		return v;
	}
	
	
	private inline function setMaxChars (v:Int) : Int
	{
		if (maxChars != v) {
			maxChars = v;
			invalidate( Flags.MAX_CHARS );
		}
		return v;
	}


	private inline function setUpdateVO (v:Void -> Void)
	{
		if (v != updateVO)
		{
			updateVO = v == null ? doNothing : v;
			if (fieldBinding != null)
				fieldBinding.setVoidHandler(updateVO);
		}
		return v;
	}


	/*public #if !noinline inline #end function pair (data:Bindable<VOType>)
	{
		var d = getRevertableData();
		d.beginEdit();
		var b = d.pair(data);
		d.commitEdit();
		return b;
	}*/
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function doNothing () {
		#if debug throw "You need to define a method 'updateVO' to commit changes of the inputField"; #end
	}

	
	private function handleFocus ()
	{
		if (hasFocus)
			return;
		
		hasFocus = true;
		updateLabel();
		if (data.value == defaultLabel) {
			data.set("");
			data.change.send("", null);
			styleClasses.remove("empty");
		}
		
		getRevertableData().beginEdit();
		fieldBinding.enable();
	}
	
	
	private function handleBlur ()
	{
		if (!hasFocus)
			return;
		
	//	Assert.isNotNull( vo.value );
		fieldBinding.disable();
		var d = getRevertableData();
		if (d.isEditable())	// <-- not the case when cancelInput is called.
		{
			updateLabelBinding.disable();
			updateVO();
			d.commitEdit();
			updateLabelBinding.enable();
		}
		
		hasFocus = false;
		updateLabel();
	}
	
	
	/**
	 * Method will set the current input as value of the VO without losing
	 * focus.
	 * Method is called From InputFieldSkin.
	 */
	public function applyInput () if (hasFocus)
	{
		field.removeFocus();
	}
	
	
	/**
	 * Method will set the current input to the original value before the user
	 * typed in stuff.
	 * Method is called From InputFieldSkin.
	 */
	public function cancelInput () if (hasFocus)
	{
		getRevertableData().cancelEdit();
		field.removeFocus();
	}
}