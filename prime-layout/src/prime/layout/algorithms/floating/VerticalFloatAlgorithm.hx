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
package prime.layout.algorithms.floating;
 import prime.core.geom.space.Vertical;
 import prime.core.geom.IRectangle;
 import prime.layout.AdvancedLayoutClient;
 import prime.layout.IScrollableLayout;
 import prime.types.Number;
 import prime.utils.NumberUtil;
  using prime.utils.NumberUtil;
  using prime.utils.NumberUtil.IntUtil;
  using prime.utils.TypeUtil;


/**
 * Floating algorithm for vertical layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class VerticalFloatAlgorithm extends prime.layout.algorithms.VerticalBaseAlgorithm implements prime.layout.algorithms.IVerticalAlgorithm
{
	/**
	 * Method will return the total height of all the children.
	 */
	public #if !noinline inline #end function validate ()
	{
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	public function validateVertical ()
	{
		var height = 0;
		if (group.childHeight.notSet())
			for (child in group.children) {
				if (child.includeInLayout)
					height += child.outerBounds.height;
			}
		else
			height = group.childHeight * group.childrenLength;

		setGroupHeight(height);
	}


	override public function apply ()
	{
		switch (direction) {
			case Vertical.top:		applyTopToBottom();
			case Vertical.center:	applyCentered();
			case Vertical.bottom:	applyBottomToTop();
		}
		super.apply();
	}
	
	
	private inline function applyTopToBottom (next:Int = -1) : Void
	{
		var group = this.group;
		if (group.children.length > 0)
		{
			if (next == -1)
				next = getTopStartValue();
			
			Assert.that(next.isSet());
			var children = group.children;
			
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.top	= next;
					next					= child.outerBounds.bottom;
				}
			}
			else
			{
				if (group.fixedChildStart.isSet())
					next += group.fixedChildStart * group.childHeight;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;

					child.outerBounds.top	 = next;
					next					+= group.childHeight;
				}
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		applyTopToBottom( getVerCenterStartValue() );
	}
	
	
	private inline function applyBottomToTop () : Void
	{
		var group = this.group;
		if (group.children.length > 0)
		{
			var next		= getBottomStartValue();
			var children	= group.children;
			Assert.that(next.isSet());
			
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.bottom	= next;
					next						= child.outerBounds.top;
				}
			}
			else
			{
				next -= group.childHeight;
				if (group.fixedChildStart.isSet())
					next -= group.fixedChildStart * group.childHeight;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.top	= next;
					next					= child.outerBounds.top - group.childHeight;
				}
			}
		}
	}


	/**
	 * 
	 */
	public #if !noinline inline #end function getDepthForBounds (bounds:IRectangle) : Int
	{
		return switch (direction) {
			case Vertical.top:		getDepthForBoundsTtB(bounds);
			case Vertical.center:	getDepthForBoundsC(bounds);
			case Vertical.bottom:	getDepthForBoundsBtT(bounds);
		}
	}


	private inline function getDepthForBoundsTtB (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= bounds.top - getTopStartValue();
		var centerY:Int	= bounds.centerY; //top + (bounds.height >> 1); // * .5).roundFloat();
		var children	= group.children;

		if (group.childHeight.isSet())
		{
			depth = (posY / group.childHeight).roundFloat();
		}
		else
		{
			//if pos <= 0, the depth will be 0
			if (posY > 0)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var groupHeight = group.height;
				if (group.is(AdvancedLayoutClient))
					groupHeight = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
				
				var halfH = groupHeight >> 1; // * .5;
				if (posY < halfH) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerY <= child.outerBounds.bottom && centerY >= child.outerBounds.top)
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
						if (child.includeInLayout && centerY >= child.outerBounds.bottom)
							break;

						depth--;
					}
				}
			}
		}
		return depth.within( 0, group.childrenLength - 1 );
	}


	private inline function getDepthForBoundsC (bounds:IRectangle) : Int
	{
		Assert.abstractMethod( "Wrong implementation since the way centered layouts behave is changed");
		return 0;
	/*	var depth:Int	= 0;
		var posY:Int	= bounds.top;
		var centerY:Int	= bounds.top + (bounds.height >> 1); // * .5).roundFloat();
		
		var groupHeight	= group.height;
		var children	= group.children;
		
		if (group.is(AdvancedLayoutClient))
			groupHeight	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
		
		var halfH = groupHeight >> 1; // * .5;
		
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.includeInLayout 
				&& (
						(centerY <= child.outerBounds.bottom && centerY >= halfH)
					||	(centerY >= child.outerBounds.bottom && centerY <= halfH)
				)
			)
				break;

			depth++;
		}
		return depth;*/
	}


	private inline function getDepthForBoundsBtT (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= bounds.top - getTopStartValue();
		var centerY:Int	= bounds.centerY; // + (bounds.height >> 1); // * .5).roundFloat();
		
		var children	= group.children;
		var groupHeight = group.height;
		var emptyHeight	= 0;
		
		if (group.is(AdvancedLayoutClient))
		{
			groupHeight = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
			//check if there's any width left. This happens when there's an explicitWidth set.
			emptyHeight	= IntMath.max( 0, group.height - groupHeight );
		}
		
		if (group.childHeight.isSet())
		{
			depth = children.length - ((posY - emptyHeight) / group.childHeight).roundFloat();
		}
		else
		{
			//if pos <= emptyHeight, the depth will be at the end of the list
			if (posY <= emptyHeight)
				depth = children.length;
			
			//if bounds.bottom < maximum group height, then the depth is at the beginning of the list
			else if (bounds.right < IntMath.max(group.height, groupHeight))
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfH = groupHeight >> 1; // * .5;

				if (posY > (emptyHeight + halfH)) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerY >= child.outerBounds.top)
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
						if (child.includeInLayout && centerY <= child.outerBounds.bottom)
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
		if (group.childHeight.notSet())
			return 0;
		
		Assert.that(group.is(IScrollableLayout), group+" should be scrollable");
		var group	= group.as(IScrollableLayout);
		var childH	= group.childHeight;
		
		var depth	= switch (direction) {
			case Vertical.top:		(group.scrollPos.y / childH).floorFloat();
			case Vertical.center:	0;
			case Vertical.bottom:	(group.scrollableHeight / childH).floorFloat();
		};
		return (depth - group.invisibleBefore).within(0, group.childrenLength);
	}
	
	
	override public function getMaxVisibleChildren () : Int
	{
		var g = this.group;
		if (g.childHeight.isSet())
		    return g.height.isSet()
		    	? IntMath.min( (g.height / g.childHeight).ceilFloat() + group.invisibleBefore + group.invisibleAfter, g.childrenLength)
		    	: 0;
		else
		    return g.childrenLength;
	}
	
	
	override public function scrollToDepth (depth:Int)
	{
	    if (!group.is(IScrollableLayout))
	        return;
	    
	    var group       = this.group.as(IScrollableLayout);
	    var childH      = group.childHeight;
	    var scroll      = Number.INT_NOT_SET;
	    var curScroll   = group.scrollPos.y;
	    var children    = group.children;
	    
	    switch (direction)
	    {
			case top:
			    var childPos = 0;
			    if (childH.isSet()) 
			    {
			        childPos    = getTopStartValue() + (depth * childH);
    		        scroll      = childPos > curScroll ? childPos - group.height + childH : childPos;
		        }
		        else
		        {
#if debug	        Assert.that( depth >= group.fixedChildStart, depth+" >= "+group.fixedChildStart );
			        Assert.that( depth <  group.fixedChildStart + children.length, depth+" < "+group.fixedChildStart+" + "+children.length ); #end
			        var child   = children.getItemAt( depth - group.fixedChildStart );
			        childPos    = child.outerBounds.top;
			        scroll      = childPos > curScroll ? child.outerBounds.bottom - group.height : childPos;
			    }
			
			case center:
			    Assert.abstractMethod();
			
			
			case bottom:
			    if (childH.isSet()) {
			        scroll = getBottomStartValue() + ((depth + 1) * childH);
		        } else {
#if debug	        Assert.that( depth >= group.fixedChildStart, depth+" >= "+group.fixedChildStart );
			        Assert.that( depth <  group.fixedChildStart + children.length, depth+" < "+group.fixedChildStart+" + "+children.length ); #end
			        
			        scroll = children.getItemAt( depth - group.fixedChildStart ).outerBounds.top;
			    }
		}
		
		if (scroll.isSet())
		    group.scrollPos.y = scroll;
	}
	
	
#if (CSSParser || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "float-ver (" + direction + ", " + horizontal + ")";
	}
#end
}