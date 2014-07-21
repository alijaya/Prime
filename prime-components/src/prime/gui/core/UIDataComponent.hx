

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
package prime.gui.core;
 import prime.bindable.collections.DataCursor;
 import prime.bindable.collections.IEditableList;
 import prime.core.traits.IValueObject;
  using prime.utils.BitUtil;
  using prime.utils.TypeUtil;
 

/**
 * UIDataComponent is an UIComponent with a bindable vo property of the given
 * type. The DataComponent will default create a bindable object of the 
 * requested type which can be used to update other values in the component.
 * 
 * It's possible to change or read the value of the bindable directly by calling
 *  v = component.data; and component.data = newValue;
 * 
 * @see				prime.gui.core.UIComponent
 * @see				prime.gui.core.IUIComponent
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class UIDataComponent <DataType> extends UIComponent implements IUIDataElement <DataType>
{
	@borrowed public var data (default, set_data) : DataType;
	
	
	public function new (id:String = null, data:DataType = null)
	{
		super(id);
		if (data != null)
			this.data = data;
	}
	
	@manual
	override public function dispose ()
	{
		if (data != null)
			data = null;
		
		super.dispose();
	}
	
	
	//
	// METHODS
	//
	
	override public function validate ()
	{
		if (changes.has( UIElementFlags.DATA ))
			if (data != null && !dataInitialized) {
				initData();
				dataInitialized = true;
			}
		
		super.validate();
	}
	
	
	private var dataInitialized : Bool;
	/**
	 * Method in which childcomponents can be bound to the data of the component.
	 * This method can be called on two moments:
	 * 		- component has created children and the data is already set
	 * 		- data is set and the component-state is already initialized
	 */
	private function initData () : Void		{}
	private function removeData () : Void	{}
	
	
	public function getDataCursor ()
	{
		var cursor = new DataCursor<DataType>(data);
		
		var parent = null;
		if (container != null && container.is(IUIDataElement))
			parent = container.as(IUIDataElement);
		
		if (parent != null && parent.data.is(IEditableList))
			cursor.list = cast parent.data;
		
		return cursor;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Public setter so that it can be used as event-handler
	 */
	public function set_data (v:DataType)
	{
		if (v != data)
		{
			if (dataInitialized && data != null) {// && window != null)
#if debug		Assert.that(isInitialized()); #end
				dataInitialized = false;
				removeData();
			}
			
			data = v;
			invalidate( UIElementFlags.DATA );
		}
		
		return v;
	}


	public #if !noinline inline #end function unsetData ()
	{
		data = null;
	}
	
	
//	private inline function getData () : DataType	{ return vo.value; }
//	private inline function setData (v:DataType)	{ return vo.value = v; }
}