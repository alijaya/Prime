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
package primevc.gui.layout;
 import primevc.core.collections.ArrayList;
 import primevc.core.collections.IEditableList;
 import primevc.core.collections.ListChange;
 import primevc.core.geom.BindablePoint;
 import primevc.core.geom.IntPoint;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.validators.PercentIntRangeValidator;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.ValidateStates;
 import primevc.types.Number;
 import primevc.utils.FastArray;
 import primevc.utils.NumberUtil;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
  using primevc.utils.FastArray;
  using primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil.IntUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	Mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutContainer extends AdvancedLayoutClient implements ILayoutContainer implements IScrollableLayout
{
	public var algorithm			(default, set_algorithm)		: ILayoutAlgorithm;
	
	public var childWidth			(default, set_childWidth)		: Int;
	public var childHeight			(default, set_childHeight)		: Int;
	
	public var scrollPos			(default, null)					: BindablePoint;
	public var scrollableWidth		(get_scrollableWidth, never)	: Int;
	public var scrollableHeight		(get_scrollableHeight, never)	: Int;
	public var minScrollXPos		(default, set_minScrollXPos)	: Int;
	public var minScrollYPos		(default, set_minScrollYPos)	: Int;
	
	
	
	
	public function new (newWidth = primevc.types.Number.INT_NOT_SET, newHeight = primevc.types.Number.INT_NOT_SET)
	{
		super(newWidth, newHeight);
		(untyped this).childWidth	= Number.INT_NOT_SET;
		(untyped this).childHeight	= Number.INT_NOT_SET;
		
		childrenLength	= 0;
		children		= new ArrayList<LayoutClient>();
		scrollPos		= new BindablePoint();
		minScrollXPos	= minScrollYPos = 0;
		
		childrenChangeHandler.on( children.change, this );
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		if (algorithm.notNull()) {
			algorithm.dispose();
			(untyped this).algorithm = null;
		}
		scrollPos.dispose();
		children.dispose();
		children	= null;
		scrollPos	= null;
	}
	
	
	public #if !noinline inline #end function attach (target:LayoutClient, depth:Int = -1) : ILayoutContainer
	{
		children.add( target, depth );
		return this;
	}
	
	
	
	//
	// LAYOUT METHODS
	//
	
	override public function invalidateCall (childChanges:Int, sender:IInvalidatable) : Void
	{
		if (!sender.is(LayoutClient))
			return super.invalidateCall( childChanges, sender );
		
	//	var isInvalid = childChanges.has(Flags.INCLUDE);
		if (childChanges.has(Flags.INCLUDE))
			invalidate( Flags.LIST );
		
		if (childChanges.has(Flags.INCLUDE | Flags.ALGORITHM) || algorithm.isNull() || algorithm.isInvalid(childChanges))
		{
			var child = sender.as(LayoutClient);
			invalidate( Flags.CHILDREN_INVALIDATED );
			
			if (!child.isValidating())
				child.state.current = ValidateStates.parent_invalidated;
		}
		return;
	}
	
	
	
	private inline function checkIfChildGetsPercentageWidth (child:LayoutClient, widthToUse:Int) : Bool
	{
		return (
					changes.has( Flags.WIDTH | Flags.LIST ) 
				|| child.changes.has( Flags.PERCENT_WIDTH ) //|| child.width.notSet()
				||	( child.is(IAdvancedLayoutClient) && child.as(IAdvancedLayoutClient).explicitWidth.notSet() )
				)
				&& child.percentWidth.isSet()
				&& child.percentWidth >= 0
				&& widthToUse > 0;
	}
	
	
	private inline function checkIfChildGetsPercentageHeight (child:LayoutClient, heightToUse:Int) : Bool
	{
		return (
						changes.has( Flags.HEIGHT | Flags.LIST )
					|| 	child.changes.has( Flags.PERCENT_HEIGHT ) //|| child.height.notSet()
					||	( child.is(IAdvancedLayoutClient) && child.as(IAdvancedLayoutClient).explicitHeight.notSet() )
				)
				&& child.percentHeight.isSet()
				&& child.percentHeight >= 0
				&& heightToUse > 0;
	}
	
	
	/**
	 * Cached instance of the filling children list
	 */
	private var fillingChildrenCache 	: FastArray<LayoutClient>;
	/**
	 * temporary count of the number of children with a width-percentage
	 */
	private var percentWidthChildren 	: Int;
	/**
	 * temporary count of the number of children with a height-percentage
	 */
	private var percentHeightChildren 	: Int;

	
	override public function validateHorizontal ()
	{
		super.validateHorizontal();
		if (changes.hasNone( Flags.HORIZONTAL_INVALID ))
			return;

		if (algorithm.notNull())
			algorithm.prepareValidate();
		
		var curWidth 		 = width;
		var applyPercentSize = percentWidthChildren == 0 || explicitWidth.isSet();

		if (applyPercentSize)
			updateChildWidthPercentages();
		
		if (algorithm.notNull())
			algorithm.validateHorizontal();
		
		// if the width is changed and there are children with a percentage width, we need to update their width
		if (!applyPercentSize || (percentWidthChildren > 0 && width != curWidth && width.isSet()))
			updateChildWidthPercentages();

		super.validateHorizontal();
	}
	
	
	
	
	override public function validateVertical ()
	{
		super.validateVertical();
		if (changes.hasNone( Flags.VERTICAL_INVALID ))
			return;
		
		if (algorithm.notNull())
			algorithm.prepareValidate();
		
		var curHeight 		 = height;
		var applyPercentSize = percentHeightChildren == 0 || explicitHeight.isSet();

		if (applyPercentSize)
			updateChildHeightPercentages();
		
		if (algorithm.notNull())
			algorithm.validateVertical();
		
		// if the height is changed and there are children with a percentage height, we need to update their height
		if (!applyPercentSize || (percentHeightChildren > 0 && height != curHeight && height.isSet()))
			updateChildHeightPercentages();

		super.validateVertical();
	}
	
	
	override public function validated ()
	{
		if (changes == 0 || !isValidating())
			return;
		
		if (!isVisible())
			return super.validated();
		
		if (!hasValidatedWidth)		validateHorizontal();
		if (!hasValidatedHeight)	validateVertical();

		if (changes.has(Flags.SIZE_PROPERTIES) && (scrollPos.x > 0 || scrollPos.y > 0))
			validateScrollPosition( scrollPos );
		
		if (algorithm.notNull()) {
			algorithm.prepareValidate();
			
			if (height.isSet() && width.isSet())
				algorithm.apply();
		}
		
	//	var i = 0;
	//	while (i < children.length)		// use while loop instead of for loop since children can be removed during validation (== errors with a for loop)
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.includeInLayout)
				child.validated();
			
	//		i++;
		}
		
		// It's important that super.validated get's called after the children are validated.
		// The process of validating children could otherwise invalidate the object again
		// since the x&y of the children can change when they are validated.
		return super.validated();
	}
	
	

	


	private function updateChildWidthPercentages ()
	{
		if (fillingChildrenCache.isNull())
			fillingChildrenCache = FastArrayUtil.create();

		var fillingChildren	= fillingChildrenCache;
		var childrenWidth	= percentWidthChildren = 0;
		var isWidthChanged 	= changes.has(Flags.WIDTH | Flags.LIST) && width.isSet();

		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (!child.includeInLayout)
				continue;
			
			var oldI = child.invalidatable;
			child.invalidatable = false;
			if (isWidthChanged && child.widthValidator.notNull() && child.widthValidator.is( PercentIntRangeValidator ))
				child.widthValidator.as( PercentIntRangeValidator ).calculateValues( width );
			
			if (child.percentWidth.isSet())
			{
				percentWidthChildren++;
				if (child.percentWidth == Flags.FILL)
				{
					fillingChildren.push( child );
					child.width = Number.INT_NOT_SET;
				}
				
				//measure children with explicitWidth and no percentage size
				else if (checkIfChildGetsPercentageWidth(child, width))
					child.applyPercentWidth( width );
			}
			
			//measure children
			if (child.percentWidth != Flags.FILL)
			{
				child.validateHorizontal();
				childrenWidth += child.outerBounds.width;
			}

			child.invalidatable = oldI;
		}
		

		// set height of horizontally filling children
		var fillingLength:Int = fillingChildren.length;		//define as int! otherwise it will be treated as UInt -> 0 - 4112123333 something but no negatives..
		if (fillingLength > 0)
		{
			if (width.isSet() && (width - childrenWidth) > 0)
			{
				var sizePerChild = ( width - childrenWidth ).divFloor(fillingLength);
				
				while (fillingLength--> 0)
				{
					var child = fillingChildren.pop();
					child.outerBounds.width = sizePerChild;
					if (child.is(IAdvancedLayoutClient))
						(untyped child).explicitWidth = child.width;
					child.validateHorizontal();
				}
			}
			else
				fillingChildren.removeAll();
			
			Assert.equal(fillingChildren.length, 0);
		}
	}


	private function updateChildHeightPercentages ()
	{
		if (fillingChildrenCache.isNull())
			fillingChildrenCache = FastArrayUtil.create();

		var fillingChildren	= fillingChildrenCache;
		var childrenHeight	= percentHeightChildren = 0;
		var isHeightChanged	= changes.has(Flags.HEIGHT | Flags.LIST) && height.isSet();

		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (!child.includeInLayout)
				continue;
			
			var oldI = child.invalidatable;
			child.invalidatable = false;
			if (isHeightChanged && child.heightValidator.notNull() && child.heightValidator.is( PercentIntRangeValidator ))
				child.heightValidator.as( PercentIntRangeValidator ).calculateValues( height );
			
			if (child.percentHeight.isSet())
			{
				percentHeightChildren++;
				if (child.percentHeight == Flags.FILL)
				{
					fillingChildren.push( child );
					child.height = Number.INT_NOT_SET;
				}
				
				//measure children with explicitHeight and no percentage size
				else if (checkIfChildGetsPercentageHeight(child, height))
					child.applyPercentHeight(height);
			}
			
			//measure children
			if (child.percentHeight != Flags.FILL)
			{
				child.validateVertical();
				childrenHeight += child.outerBounds.height;
			}
			child.invalidatable = oldI;
		}
		

		// set height of vertically filling children
		var fillingLength:Int = fillingChildren.length;		//define as int! otherwise it will be treated as UInt -> 0 - 4112123333 something but no negatives..
		if (fillingLength > 0)
		{
			if (height.isSet() && (height - childrenHeight) > 0)
			{
				var sizePerChild = ( height - childrenHeight ).divFloor(fillingLength);
				
				while (fillingLength--> 0)
				{
					var child = fillingChildren.pop();
					child.outerBounds.height = sizePerChild;
					if (child.is(IAdvancedLayoutClient))
						(untyped child).explicitHeight = child.height;
					child.validateVertical();
				}
			}
			else
				fillingChildren.removeAll();
			
			Assert.equal(fillingChildren.length, 0);
		}
	}


	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private /*inline*/ function set_algorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm.notNull()) {
				if (algorithm.group == this)
					algorithm.group = null;
				
				algorithm.algorithmChanged.unbind(this);
				measuredWidth = measuredHeight = Number.INT_NOT_SET;
				hasValidatedHeight = hasValidatedWidth = false;
			}
			algorithm = v;
			
			if (v.notNull()) {
				v.group = this;
				algorithmChangedHandler.on( v.algorithmChanged, this );
			}
			
			invalidate(Flags.ALGORITHM);
		}
		return v;
	}


	private inline function set_childWidth (v)
	{
		if (v != childWidth)
		{
			childWidth = v;
			invalidate( Flags.CHILD_WIDTH | Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function set_childHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( Flags.CHILD_HEIGHT | Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}
	
	
	
	//
	// ISCROLLABLE LAYOUT IMPLEMENTATION
	//
	
	public  inline function horScrollable ()						{ return width.isSet()  && measuredWidth.isSet()  && measuredWidth  > width; }
	public  inline function verScrollable ()						{ return height.isSet() && measuredHeight.isSet() && measuredHeight > height; }
	private inline function get_scrollableWidth ()					{ return measuredWidth  - width; }
	private inline function get_scrollableHeight ()					{ return measuredHeight - height; }
	
	private inline function set_minScrollXPos (v:Int)				{ return minScrollXPos = v <= 0 ? v : 0; }
	private inline function set_minScrollYPos (v:Int)				{ return minScrollYPos = v <= 0 ? v : 0; }
	
	public #if !noinline inline #end function validateScrollPosition (pos:IntPoint)
	{
		pos.x = horScrollable() ? pos.x.within( 0, scrollableWidth ) : 0;
		pos.y = verScrollable() ? pos.y.within( 0, scrollableHeight ) : 0;
		return pos;
	}
	
	
	public function scrollTo (child:ILayoutClient)
	{
		if (horScrollable())	scrollPos.x = (child.outerBounds.centerX - (width >> 1)) .within(0, scrollableWidth);
		if (verScrollable())	scrollPos.y = (child.outerBounds.centerY - (height >> 1)).within(0, scrollableHeight);
	}
	
	
	public /*inline*/ function scrollToDepth( index:Int )
	{
	//	trace("depth: "+index+"; fixedStart: "+fixedChildStart+"; length: "+children.length);
	    if (index >= fixedChildStart && index < (fixedChildStart + children.length))
	        scrollTo( children.getItemAt( index - fixedChildStart ) );
	    else if (algorithm.notNull())
		    algorithm.scrollToDepth(index);
	}
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler ()	{ invalidate( Flags.ALGORITHM ); }
	
	
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
	 * @see LayoutContainer.setFixedChildLength
	 */
	public var childrenLength		(default, null)					: Int;
	public var fixedChildStart		(default, default)				: Int;
	public var invisibleBefore		(default, set_invisibleBefore)	: Int;
	public var invisibleAfter		(default, set_invisibleAfter)	: Int;
	
	/**
	 * Indicated wether the length of the children is fake d or not.
	 * 
	 * Layout-algorithms will only honor this property if the childWidth and 
	 * childHeight also have been set, otherwise it's impossible to calculate
	 * what the measured size of the container should be.
	 */
	public var fixedLength			(default, null)					: Bool;
	
	
	private function childrenChangeHandler ( change:ListChange <LayoutClient> ) : Void
	{
		switch (change)
		{
			case added( child, newPos ):
				child.parent = this;
				if (child.includeInLayout) {
					//check first if the bound properties are zero. If they are not, they can have been set by a tile-container
					if (child.outerBounds.left == 0)	child.outerBounds.left	= padding.left;
					if (child.outerBounds.top == 0)		child.outerBounds.top	= padding.top;
					invalidate( Flags.LIST );
				}
				child.invalidated.bind(this, invalidateCall);
				
				if (!fixedLength)
					childrenLength++;
			
			
			case removed( child, oldPos ):
				child.parent = null;
				child.invalidated.unbind(this);
				
				//reset boundary properties without validating
			/*	child.outerBounds.left	= 0;
				child.outerBounds.top	= 0;
				child.changes			= 0;*/
				
				if (!fixedLength)			childrenLength--;
				if (child.includeInLayout)	invalidate( Flags.LIST );
			
			
			case moved(child, newPos, oldPos):
				if (child.includeInLayout)
					invalidate( Flags.LIST );
				
			case reset:
				invalidate( Flags.LIST );
		}
	}



	public function removeAll ()
	{
		measuredHeight = Number.INT_NOT_SET;
		children.removeAll();
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
}