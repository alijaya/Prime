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
package prime.tools.valueobjects;
 import prime.bindable.collections.IEditableList;
  using prime.bindable.collections.ListChange;
  using prime.utils.TypeUtil;
  using Reflect;
  using Std;
  using Type;


/**
 * Utility providing methods to deal with ListChange or PropertyChange values
 * (to undo/redo them).
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
class ChangesUtil
{
	public static function undo<T> (changes:ChangeSet) : Void
	{
	//	trace("undo changes "+Date.fromTime(changes.timestamp) + ", " + changes);

		if (changes.is(ObjectChangeSet))
		{
			var vo = changes.as(ObjectChangeSet).vo;
			vo.beginEdit();
			
			var change = changes.next;
			while (change != null)
			{
				if (change.is(ListChangeVO))	undoListChanges( 	change.as(ListChangeVO), 		vo);
				else							undoPropertyChange( change.as(PropertyValueChangeVO), 	vo);
				
				change = change.next;
			}
			
			vo.commitEdit();
		}

		else if (changes.is(GroupChangeSet))
		{
			var change = changes.nextSet;
			while (change != null) {
				undo(change);
				change = change.nextSet;
			}
		}
	}
	
	
	public static function redo<T> (changes:ChangeSet) : Void
	{
	//	trace("redo changes "+Date.fromTime(changes.timestamp) + ", " + changes);
		if (changes.is(ObjectChangeSet))
		{
			var vo = changes.as(ObjectChangeSet).vo;
			vo.beginEdit();
			
			var change = changes.next;
			while (change != null)
			{
				if (change.is(ListChangeVO))	redoListChanges( 	change.as(ListChangeVO), 		vo);
				else							redoPropertyChange( change.as(PropertyValueChangeVO), 	vo);
				
				change = change.next;
			}
			vo.commitEdit();
		}

		else if (changes.is(GroupChangeSet))
		{
			var change = changes.nextSet;
			while (change != null) {
				redo(change);
				change = change.nextSet;
			}
		}
	}
	
	
	
	
	private static inline function undoListChanges<T> (changesVO:ListChangeVO<T>, owner:ValueObjectBase) : Void
	{
		var list		= owner.getPropertyById( changesVO.propertyID ).as(IEditableList);
		var changes 	= changesVO.changes;
		
		for (i in 0...changes.length)
			list.undoListChange( cast changes[i] );
	}
	
	
	private static function redoListChanges<T> (changesVO:ListChangeVO<T>, owner:ValueObjectBase) : Void
	{
		var list	= owner.getPropertyById( changesVO.propertyID ).as(IEditableList);
		var changes = changesVO.changes;
		
		for (i in 0...changes.length)
			list.redoListChange( cast changes[i] );
	}
	
	
	
	
	private static function undoPropertyChange (change:PropertyValueChangeVO, owner:ValueObjectBase) : Void
	{
		owner.setPropertyById(change.propertyID, change.oldValue);
	}
	
	
	private static function redoPropertyChange (change:PropertyValueChangeVO, owner:ValueObjectBase) : Void
	{
		owner.setPropertyById(change.propertyID, change.newValue);
	}
	
	
	/**
	 * Method will return the property name based on the given property-id. 
	 * Since there's no clean way to get the name of a property when only the
	 * property-id is available, the method will loop over all properties 
	 * within the given object until the property is found
	 * 
	 * @param owner			object containing the property
	 * @param propertyId 	id of property
	 * @return property name
	 */
	public static #if !noinline inline #end function propertyIdToString (owner:ValueObjectBase, propertyId:Int) : String
	{
		var propFlags:Dynamic = owner.getClass();
		return propFlags.hasField('propertyIdToString') ? propFlags.propertyIdToString(propertyId) : null;
	}
	
	
	
	public static #if !noinline inline #end function findChangedVOOfClass (change:ObjectChangeSet, classType:Class<Dynamic>)
	{
		var vo:prime.core.traits.IValueObject = null;
		if (change.vo.is(classType))
		{
			vo = change.vo;
		}
		else
		{
			// a property of the shapestylevo is changed or a property of a 
			// property etc.. In order to find the ShapeStyleVO that is changed,
			// we walk down all the parents until we find one.
			var path = change.parent;
			while (path != null && !path.object.is(classType))
				path = path.parent;
		
			Assert.isNotNull(path);
			vo = path.object;
		}
		return vo;
	}
}