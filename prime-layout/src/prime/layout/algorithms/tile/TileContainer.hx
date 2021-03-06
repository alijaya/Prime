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
package prime.layout.algorithms.tile;
 import prime.bindable.collections.ArrayList;
 import prime.bindable.collections.IEditableList;
 import prime.bindable.collections.ListChange;
 import prime.core.traits.IInvalidatable;
 import prime.fsm.states.ValidateStates;
 import prime.layout.algorithms.ILayoutAlgorithm;
 import prime.layout.ILayoutContainer;
 import prime.layout.LayoutFlags;
 import prime.layout.LayoutClient;
 import prime.types.Number;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;
 

private typedef Flags = LayoutFlags;

/**
 * Group of tiles within a tile layout. Behaves as a LayoutContainer but without 
 * the properties of AdvancedLayoutContainer.
 * 
 * @creation-date	Jun 30, 2010
 * @author			Ruben Weijers
 */
class TileContainer extends LayoutClient implements ILayoutContainer
{
	public var algorithm	(default, set_algorithm)	: ILayoutAlgorithm;
	public var childWidth	(default, set_childWidth)	: Int;
	public var childHeight	(default, set_childHeight)	: Int;
	
	
	public function new( list:IEditableList<LayoutClient> = null )
	{
		super();
		children	= list == null ? new ArrayList<LayoutClient>() : list;
		childWidth	= Number.INT_NOT_SET;
		childHeight	= Number.INT_NOT_SET;
		
		childrenChangeHandler.on( children.change, this );
		
		if (children.length > 0)
			for (i in 0...children.length) {
				var child = children.getItemAt(i);
				if (child.includeInLayout)
					child.invalidated.bind( this, invalidateCall );
			}
		
		changes = 0;
	}
	
	
	override public function dispose ()
	{
		if (children != null)
		{
			while (children.length > 0) {
				var child = children.getItemAt(0);
				child.invalidated.unbind( this );
				children.remove(child);
			}
			
			if (children.change != null) {
				children.change.unbind(this);
				children.dispose();
			}
			children = null;
		}
		algorithm = null;
		
		super.dispose();
	}
	
	
	public function iterator () { return children.iterator(); }


	public #if !noinline inline #end function attach (target:LayoutClient, depth:Int = -1) : ILayoutContainer
	{
		children.add( target, depth );
		return this;
	}
	
	
	override public function invalidateCall ( childChanges:Int, sender:IInvalidatable ) : Void
	{
		if (!sender.is(LayoutClient)) {
			super.invalidateCall( childChanges, sender );
			return;
		}
		
		Assert.that(algorithm != null);
		algorithm.group = this;
		
		var child = sender.as(LayoutClient);
		if (!isValidating() && (childChanges.has(Flags.LIST | Flags.WIDTH * childWidth.notSet().boolCalc() | Flags.HEIGHT * childHeight.notSet().boolCalc()) || algorithm.isInvalid(childChanges)))
			invalidate( Flags.CHILDREN_INVALIDATED );
	}
	
	
	override public function validateHorizontal ()
	{
		super.validateHorizontal();
		if (changes.hasNone( Flags.WIDTH | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		Assert.that(algorithm != null);
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.changes > 0 && child.includeInLayout)
				child.validateHorizontal();
		}
		
		if (changes > 0)
		{
			algorithm.group = this;
			algorithm.validateHorizontal();
		}
		super.validateHorizontal();
	}
	
	
	override public function validateVertical ()
	{
		super.validateVertical();
		if (changes.hasNone( Flags.HEIGHT | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		Assert.that(algorithm != null);
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.changes > 0 && child.includeInLayout)
				child.validateVertical();
		}

		if (changes > 0)
		{
			algorithm.group = this;
			algorithm.validateVertical();
		}
		super.validateVertical();
	}
	
	
	override public function validated ()
	{
		if (changes == 0 || !isValidating())
			return;
		
		if (algorithm != null)
		{
			algorithm.group = this;
			algorithm.apply();
		}
		
		state.current	= ValidateStates.validated;
		changes			= 0;
	}
	
	
	override private function set_x (v)
	{
		if (v != x) {
			v = super.set_x(v);
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
			 	if (child.includeInLayout)
					child.outerBounds.left = innerBounds.left;
			}
		}
		return v;
	}
	
	
	override private function set_y (v)
	{
		if (v != y) {
			v = super.set_y(v);
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (child.includeInLayout)
					child.outerBounds.top = innerBounds.top;
			}
		}
		return v;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function set_algorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm != null) {
				algorithm.algorithmChanged.unbind(this);
				algorithm.group = null;
			}
			
			algorithm = v;
			invalidate( Flags.ALGORITHM );
			
			if (algorithm != null) {
				algorithmChangedHandler.on( algorithm.algorithmChanged, this );
				algorithm.group = this;
			}
		}
		return v;
	}


	private inline function set_childWidth (v)
	{
		if (v != childWidth)
		{
			childWidth = v;
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function set_childHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler () { invalidate( Flags.ALGORITHM ); }
	
	//
	// CHILDREN
	//
	
	public var children			(default, null) : IEditableList<LayoutClient>;
	
	/**
	 * Property with the actual length of the children list. Use this property
	 * instead of 'children.length' when an algorithm is calculating the 
	 * measured size, since the property can also be set fixed and thus have a 
	 * different number then children.length.
	 * 
	 * When applying an algorithm you should still use children.length since 
	 * the algorithm will only be applied on the actual children in the list.
	 * 
	 * @see LayoutContainer.setFixedLength
	 */
	public var childrenLength	(default, null) : Int;
	public var fixedChildStart					: Int;
	
	/**
	 * Indicated wether the length of the children is fake d or not.
	 * 
	 * Layout-algorithms will only honor this property if the childWidth and 
	 * childHeight also have been set, otherwise it's impossible to calculate
	 * what the measured size of the container should be.
	 */
	public var fixedLength		(default, null) : Bool;
	
	
	
	private function childrenChangeHandler ( change:ListChange < LayoutClient > ) : Void
	{
		switch (change)
		{
			case added( child, newPos ):
				child.outerBounds.left	= innerBounds.left;
				child.outerBounds.top	= innerBounds.top;
				child.invalidated.bind( this, invalidateCall );
				
				if (!fixedLength)			childrenLength++;
				if (child.includeInLayout)	invalidate( Flags.LIST );
			
			case removed( child, oldPos ):
				child.invalidated.unbind( this );
				
				if (!fixedLength)			childrenLength--;
				if (child.includeInLayout)	invalidate( Flags.LIST );
			
		
			case moved(child, newPos, oldPos):
				if (child.includeInLayout)	
					invalidate( Flags.LIST );
			
			case reset:
				invalidate( Flags.LIST );
		}
	}
	
	
	public #if !noinline inline #end function setFixedChildLength (length:Int)
	{
		fixedLength = true;
		if (childrenLength != length) {
			childrenLength = length;
			invalidate( Flags.LIST );
		}
	}
	
	
	public #if !noinline inline #end function unsetFixedChildLength ()
	{
		fixedLength = false;
		if (childrenLength != children.length) {
			childrenLength = children.length;
			invalidate( Flags.LIST );
		}
	}


	public var invisibleBefore		(default, set_invisibleBefore)	: Int;
	public var invisibleAfter		(default, set_invisibleAfter)	: Int;
	


	private inline function set_invisibleBefore (v:Int)
	{
		if (v != invisibleBefore)
		{
			invisibleBefore = v;
			invalidate(Flags.LIST);
		}
		return v;
	}


	private inline function set_invisibleAfter (v:Int)
	{
		if (v != invisibleAfter)
		{
			invisibleAfter = v;
			invalidate(Flags.LIST);
		}
		return v;
	}
	
#if debug
	override public function toString () { return "LayoutTileContainer( "+super.toString() + " ) - "/*+children*/; }
#end
}