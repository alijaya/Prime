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
package primevc.gui.components;
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IValueObject;
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.Bind;


/**
 * ListHolder is a ListView component where the listview is wrapped inside of this 
 * component.
 * By extending list, or by setting a skin for list, the chrome around a 
 * listview can be used.
 * 
 * Class parameters:
 * 		DataType:		Type of the data property (could be a string for example)
 * 		ListDataType:	Type of list-data
 * 
 * @author Ruben Weijers
 * @creation-date Feb 12, 2011
 */
class ListHolder <DataType, ListDataType> extends UIDataContainer <DataType>, implements IListHolder<ListDataType>
{
	public var list		(default, default)		: ListView<ListDataType>;
	public var listData	(default, setListData)	: IReadOnlyList < ListDataType >;
	public var childClick (default, null)		: Signal1<MouseState>;
	
	/**
	 * Injectable method which will create the needed itemrenderer
	 * 
	 * @param	item:ListDataType
	 * @param	pos:Int
	 * @return 	IUIDataElement
	 */
	public var createItemRenderer				(default, setCreateItemRenderer) : ListDataType -> Int -> IUIDataElement<ListDataType>;
	
	
	public function new (id:String, data:DataType = null, listData:IReadOnlyList<ListDataType> = null, list:ListView<ListDataType> = null)
	{
		super(id, data);
		styleClasses.add("listHolder");
		this.listData	= listData;
		this.list		= list;
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		childClick.dispose();
		
		childClick			= null;
		createItemRenderer	= null;
	}
	
	
	override private function createBehaviours ()
	{
		childClick = new Signal1<MouseState>();
	}
	
	
	override private function createChildren ()
	{
		//check if listview isn't created by a skin or super-class
		if (list == null)
			list = new ListView(id.value+"Content", listData);
		else {
			list.id.value   = id.value+"Content";
			list.data 		= listData;
		}
		
		list.setFocus.on( userEvents.focus, this );
		list.createItemRenderer = createItemRenderer;
		list.attachTo(this);
		
	//	mouseEnabled 	= false;
	//	mouseChildren 	= true;
		
		list.styleClasses.add("listContent");
		childClick.send.on( list.childClick, this );
	}
	
	
	override public  function disposeChildren ()
	{
		list.detach();
		list.dispose();
		list = null;
		super.disposeChildren();
	}
	

	//
	// GETTERS / SETTERS
	//
	
	private inline function setListData (v)
	{
		if (listData != v) {
			listData = v;
			if (list != null) {
				Assert.notNull(createItemRenderer);
				list.data = v;
			}
		}
		return v;
	}
	
	
	private inline function setCreateItemRenderer (v)
	{
		if (v != createItemRenderer) {
			createItemRenderer = v;
			if (list != null)
				list.createItemRenderer = v;
		}
		return v;
	}
}