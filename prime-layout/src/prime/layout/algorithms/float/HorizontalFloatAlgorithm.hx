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
package prime.layout.algorithms.float;
 import prime.core.geom.space.Horizontal;
 import prime.core.geom.IRectangle;
 import prime.layout.algorithms.HorizontalBaseAlgorithm;
 import prime.layout.algorithms.IHorizontalAlgorithm;
 import prime.layout.AdvancedLayoutClient;
 import prime.types.Number;
 import prime.utils.NumberUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;
 

/**
 * Floating algorithm for horizontal layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class HorizontalFloatAlgorithm extends HorizontalBaseAlgorithm, implements IHorizontalAlgorithm
{
	public #if !noinline inline #end function validate ()
	{
		if (group.children.length == 0)
			return;

		validateHorizontal();
		validateVertical();
	}
	
	
	/**
	 * Method will return the total width of all the children.
	 */
	public function validateHorizontal ()
	{
		var width:Int	= 0;
		var children	= group.children;
		
		if (group.childWidth.notSet())
		{
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (!child.includeInLayout)
					continue;
				
				width += child.outerBounds.width;
			}
		}
		else
			width = group.childWidth * group.childrenLength;
		
		setGroupWidth(width);
	}


	override public function apply ()
	{
		switch (direction) {
			case Horizontal.left:		applyLeftToRight();
			case Horizontal.center:		applyCentered();
			case Horizontal.right:		applyRightToLeft();
		}
		super.apply();
	}
	
	
	private inline function applyLeftToRight (next:Int = -1) : Void
	{
		if (group.children.length > 0)
		{
			if (next == -1)
				next = getLeftStartValue();
			
			var children = group.children;
			Assert.that(next.isSet());
			
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	= next;
					next					= child.outerBounds.right;
				}
			} 
			else
			{
				if (group.fixedChildStart.isSet())
					next += group.fixedChildStart * group.childWidth;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	 = next;
					next					+= group.childWidth;
				}
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		applyLeftToRight( getHorCenterStartValue() );
	}
	
	
	private inline function applyRightToLeft () : Void
	{
		if (group.children.length > 0)
		{
			var next		= getRightStartValue();
			var children	= group.children;
			Assert.that(next.isSet(), "beginvalue can't be unset for "+group+". Make sure the group has a width.");
			
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.right	= next;
					next					= child.outerBounds.left;
				}
			}
			else
			{
				next -= group.childWidth;
				if (group.fixedChildStart.isSet())
					next -= group.fixedChildStart * group.childWidth;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	= next;
					next					= child.outerBounds.left - group.childWidth;
				}
			}
		}
	}

	
	public #if !noinline inline #end function getDepthForBounds (bounds:IRectangle) : Int
	{
		return switch (direction) {
			case Horizontal.left:		getDepthForBoundsLtR(bounds);
			case Horizontal.center:		getDepthForBoundsC(bounds);
			case Horizontal.right:		getDepthForBoundsRtL(bounds);
		}
	}
	
	
	private inline function getDepthForBoundsLtR (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= bounds.left - getLeftStartValue();
		var centerX:Int	= bounds.centerX;
		var children	= group.children;
		
		if (group.childWidth.isSet())
		{
			depth = (posX / group.childWidth).roundFloat();
		}
		else
		{
			//if pos <= 0, the depth will be 0
			if (posX > 0)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var groupWidth = group.width;
				if (group.is(AdvancedLayoutClient))
					groupWidth = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
				
				var halfW = groupWidth >> 1; //* .5;
				if (posX < halfW) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerX <= child.outerBounds.right && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= children.reversedIterator();
					depth	= children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerX >= child.outerBounds.right)
							break;
						
						depth--;
					}
				}
			}
		}
		return depth;
	}
	
	
	private inline function getDepthForBoundsC (bounds:IRectangle) : Int
	{
		Assert.abstractMethod( "Wrong implementation since the way centered layouts behave is changed");
		return 0;
	/*	var depth:Int	= 0;
		var posX:Int	= bounds.left - getHorCenterStartValue();
		var centerX:Int	= bounds.left + (bounds.width >> 1); // * .5).roundFloat();
		var children	= group.children;
		
		var groupWidth	= group.width;
		if (group.is(AdvancedLayoutClient))
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );

		var halfW = groupWidth >> 1; // * .5;
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.includeInLayout 
				&& (
						(centerX <= child.outerBounds.right && centerX >= halfW)
					||	(centerX >= child.outerBounds.right && centerX <= halfW)
				)
			)
				break;

			depth++;
		}
		return depth;*/
	}
	
	
	private inline function getDepthForBoundsRtL (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= bounds.left - getRightStartValue();
		var centerX:Int	= bounds.centerX; //* .5).roundFloat();
		
		var children	= group.children;
		var groupWidth	= group.width;
		var emptyWidth	= 0;
		if (group.is(AdvancedLayoutClient))
		{
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
			//check if there's any width left. This happens when there's an explicitWidth set.
			emptyWidth	= IntMath.max( 0, group.width - groupWidth );
		}
		
		if (group.childWidth.isSet())
		{
			depth = children.length - ((posX - emptyWidth) / group.childWidth).roundFloat();
		}
		else
		{
			//if pos <= emptyWidth, the depth will be at the end of the list
			if (posX <= emptyWidth)
				depth = children.length;
			
			//if bounds.right < maximum group width, then the depth is at the beginning of the list
			else if (bounds.right < IntMath.max(group.width, groupWidth))
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfW = groupWidth >> 1; //* .5;

				if (posX > (emptyWidth + halfW)) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= children.reversedIterator();
					depth	= children.length - 1;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerX <= child.outerBounds.right)
							break;

						depth--;
					}
				}
			}

		}
		return depth;
	}
	
	
	override public function getDepthOfFirstVisibleChild ()	: Int
	{
		if (group.childWidth.notSet())
			return 0;
		
		Assert.that(group.is(IScrollableLayout), group+" should be scrollable");
		var group	= group.as(IScrollableLayout);
		var childW	= group.childWidth;
		
		var depth	= switch (direction) {
			case Horizontal.left:	(group.scrollPos.x / childW).floorFloat();
			case Horizontal.center:	0;
			case Horizontal.right:	(group.scrollableWidth / childW).floorFloat();
		};
		return (depth - group.invisibleBefore).within(0, group.childrenLength);
	}
	
	
	override public function getMaxVisibleChildren () : Int
	{
		var g = this.group;
		if (g.childWidth.isSet())
		    return g.width.isSet()
		    	? IntMath.min( (g.width / g.childWidth).ceilFloat() + group.invisibleBefore + group.invisibleAfter, g.childrenLength)
		    	: 0;
	    else
	        return g.childrenLength;
	}
	
	
	override public function scrollToDepth (depth:Int)
	{
	    if (!group.is(IScrollableLayout))
	        return;
	    
	    var group       = this.group.as(IScrollableLayout);
	    var childW      = group.childWidth;
	    var scrollX     = Number.INT_NOT_SET;
	    var children    = group.children;
	    
	    switch (direction)
	    {
			case Horizontal.left:
			    if (childW.isSet()) {
			        scrollX = getLeftStartValue() + (depth * childW);
		        } else {
#if debug	        Assert.that( depth >= group.fixedChildStart, depth+" >= "+group.fixedChildStart );
			        Assert.that( depth <  group.fixedChildStart + children.length, depth+" < "+group.fixedChildStart+" + "+children.length ); #end
			        
			        scrollX = children.getItemAt( depth - group.fixedChildStart ).outerBounds.left;
			    }
			    
			
			case Horizontal.center:
			    Assert.abstractMethod();
			
			
			case Horizontal.right:
			    if (childW.isSet()) {
			        scrollX = getRightStartValue() + ((depth + 1) * childW);
		        } else {
#if debug	        Assert.that( depth >= group.fixedChildStart, depth+" >= "+group.fixedChildStart );
			        Assert.that( depth <  group.fixedChildStart + children.length, depth+" < "+group.fixedChildStart+" + "+children.length ); #end
			        
			        scrollX = children.getItemAt( depth - group.fixedChildStart ).outerBounds.left;
			    }
		}
		
		if (scrollX.isSet())
		    group.scrollPos.x = scrollX;
	}
	
	
#if (CSSParser || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "float-hor (" + direction + ", " + vertical + ")";
	}
#end
}