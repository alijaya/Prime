

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
 import prime.types.Asset;
  using prime.utils.Bind;


/**
 * DataButton is a button that can be used as an ItemRenderer. Every time its
 * vo property changes, it will try to update the data.value of the button by
 * calling the method "getLabelForVO".
 * 
 * If the 'vo' value is empty, it will set the "defaultValue" string as value
 * of 'data.value' and add the styleClass 'empty'.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 11, 2011
 */
class DataButton <DataType> extends Button, implements IItemRenderer <DataType>
{
	// IItemRenderer Properties
	public var vo				(default, null)				: Bindable<DataType>;
	
	/**
	 * Method which should be set externally. The given method can return a
	 * correct string which should be displayed as label in the button
	 * (i.e. the selected value label).
	 */
	public var getLabelForVO								: DataType -> String;
	public var defaultLabel		(default, setDefaultLabel)	: String;
	
	private var updateLabelBinding							: Wire<Dynamic>;
	
	
	public function new (id:String = null, defaultLabel:String = null, icon:Asset = null, vo:DataType = null)
	{
		super(id, defaultLabel, icon);
		Assert.isNotNull(this.data);
		this.defaultLabel	= defaultLabel;
		this.vo				= new Bindable<DataType>(vo);
	}
	
	
	override public function dispose ()
	{
		if (updateLabelBinding != null) {
			updateLabelBinding.dispose();
			updateLabelBinding = null;
		}
		
		vo.value = null;
		super.dispose();
		vo.dispose();
		vo = null;
	}
	
	
	override private function init ()
	{
		super.init();
		updateLabelBinding = updateLabel.on( vo.change, this );
		updateLabel();
	}
	
	
	public function updateLabel ()
	{
		var v 		= vo.value;
		var oldVal  = data.value;

		//don't use data.value ==> if data is a RevertableBindable, updating the label won't cause any errors
		var newVal = v != null ? (getLabelForVO == null ? Std.string(v) : getLabelForVO(v)) : null;

		if (newVal == null || newVal == "")		//FIXME: is "" a correct value to apply the defaultLabel??
			newVal = defaultLabel;
		data.set(newVal);

		if (oldVal != newVal) {
			if (oldVal == defaultLabel)		styleClasses.remove("empty");
			if (newVal == defaultLabel)		styleClasses.add("empty");
		//	trace((newVal == defaultLabel)+"; "+(oldVal == defaultLabel)+"; "+oldVal+" ========> "+newVal+"; "+defaultLabel+"; "+styleClasses);
		}
	//	trace(v+": "+oldVal+" => "+newVal+"; "+styleClasses);

		data.change.send( newVal, null );
	}
	
	
	private function setDefaultLabel (v:String) : String
	{
		if (v != defaultLabel)
		{
			if (data.value == defaultLabel)
				data.value = v;
			
			defaultLabel = v;
		}
		return v;
	}
}