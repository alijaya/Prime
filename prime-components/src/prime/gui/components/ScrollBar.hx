

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
 import prime.core.geom.space.Direction;
 import prime.gui.core.UIElementFlags;
 import prime.gui.events.MouseEvents;
 import prime.layout.LayoutFlags;
 import prime.fsm.states.ValidateStates;
 import prime.gui.traits.IScrollable;
 import prime.utils.NumberUtil;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using Std;


/**
 * Scrollbar component looks a lot like the slider, with a few exceptions:
 * 		- size of the dragBtn is based on the size of the viewport of the target
 * 		- changing the percentage of the slider should update the 
 * 			scroll-position of the targets viewport.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 04, 2011
 */
class ScrollBar extends SliderBase
{
	/**
	 * Object on which the scrollbars apply
	 */
	public var target (default, set_target)	: IScrollable;
	
	/**
	 * Reference to the wire that listens to changes in the scroll-x or y values
	 * of the target (depends on the direction property).
	 */
	private var scrollBinding				: Wire<Dynamic>;
	/**
	 * Reference to the wire that listens to changes in the size of the target.
	 */
	private var resizeBinding				: Wire<Dynamic>;
	/**
	 * Reference to the wire that will update the target scrollposition when
	 * the data-value changes.
	 */
	private var updateTargetBinding			: Wire<Dynamic>;
	/**
	 * Reference to the wire that is triggered when the user uses the mouse-
	 * scroll-wheel on the target
	 */
	private var scrollWheelBinding			: Wire<Dynamic>;
	
	
	
	
	//
	// METHODS
	//
	
	
	public function new ( id:String = null, target:IScrollable, direction:Direction )
	{
		super( id, 0, 0, 0, direction );
		this.target = target;
	}
	
	
	override public function dispose ()
	{
		removeTargetBindings();
		target = null;
		super.dispose();
	}
	
	
	override public function validate ()
	{
		var changes = this.changes;
		super.validate();
		if (changes.has( UIElementFlags.DIRECTION | UIElementFlags.TARGET ))
			createTargetBindings();
	}
	
	
	private function removeTargetBindings ()
	{
		if (scrollBinding != null)			{ scrollBinding.dispose();			scrollBinding = null; }
		if (resizeBinding != null)			{ resizeBinding.dispose();			resizeBinding = null; }
		if (updateTargetBinding != null)	{ updateTargetBinding.dispose();	updateTargetBinding = null; }
		if (scrollWheelBinding != null)		{ scrollWheelBinding.dispose();		scrollWheelBinding = null; }
	}
	
	
	
	private function createTargetBindings ()
	{
		removeTargetBindings();
		Assert.isNotNull( direction );
		
		if (target != null)
		{
			var l				= target.scrollableLayout;
			var scrollProp		= direction == horizontal ? l.scrollPos.xProp	: l.scrollPos.yProp;
			var resizeBtn		= direction == horizontal ? updateBtnWidth		: updateBtnHeight;
			var updateTarget	= direction == horizontal ? updateTargetScrollX : updateTargetScrollY;
			
			data.value			= scrollProp.value;
			scrollBinding		= handleScrollChange	.on( scrollProp.change, this );
			resizeBinding		= resizeBtn				.on( l.changed, this );
			updateTargetBinding	= updateTarget			.on( data.change, this );
			scrollWheelBinding	= handleScrollWheel		.on( target.container.userEvents.mouse.scroll, this );
			
			//force update on everything
			resizeBtn( -1 );
			updateChildren();
		}
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	
	private function handleScrollChange (newVal:Int, oldVal:Int) : Void
	{
		updateTargetBinding.disable();
		data.value = newVal;
		updateTargetBinding.enable();
	}
	
	
	private function handleScrollWheel (mouseObj:MouseState)
	{
		if (direction == vertical)
			data.value = data.validator.validate( data.value - mouseObj.scrollDelta() * 3 );
	}
	
	
	/**
	 * Eventhandler which is called when the size of the target changes and the
	 * direction is horizontal.
	 * 
	 * @param	layoutChanges	bit-flags with all the changes of the targets layout
	 */
	private function updateBtnWidth (layoutChanges:Int)
	{
		if (layoutChanges == -1 || layoutChanges.has( LayoutFlags.WIDTH_PROPERTIES ))
		{
			var l			= target.scrollableLayout;
			var scrollable	= l.horScrollable();
			dragBtn.visible	= dragBtn.layout.includeInLayout = scrollable;
			dragBtn.layout.percentWidth	= scrollable ? FloatMath.min( l.width / l.measuredWidth, 1 ) : 0;
			updateChildren();	// forces the button to jump to the right position
			
			if (scrollable)
				data.validator.setValues( l.minScrollXPos, l.minScrollXPos + l.scrollableWidth );
		}
	}
	
	
	/**
	 * Eventhandler which is called when the size of the target changes and the
	 * direction is vertical.
	 * 
	 * @param	layoutChanges	bit-flags with all the changes of the targets layout
	 */
	private function updateBtnHeight (layoutChanges:Int)
	{
	//	trace(target.scrollableLayout.verScrollable()+"; "+dragBtn.layout.percentHeight+"; "+layoutChanges.has( LayoutFlags.HEIGHT_PROPERTIES )+"; "+layoutChanges);
		if (layoutChanges == -1 || layoutChanges.has( LayoutFlags.HEIGHT_PROPERTIES ))
		{
			var l			= target.scrollableLayout;
			var scrollable	= l.verScrollable();
			dragBtn.visible	= dragBtn.layout.includeInLayout = scrollable;
			dragBtn.layout.percentHeight = scrollable ? FloatMath.min( l.height / l.measuredHeight, 1 ) : 0;
			updateChildren();	// forces the button to jump to the right position

			if (scrollable)
				data.validator.setValues( l.minScrollYPos, l.minScrollYPos + l.scrollableHeight );
		}
	}
	
	
	private function updateTargetScrollX ()	{ scrollBinding.disable(); target.scrollableLayout.scrollPos.x = data.value.int(); scrollBinding.enable();  }
	private function updateTargetScrollY ()	{ scrollBinding.disable(); target.scrollableLayout.scrollPos.y = data.value.int(); scrollBinding.enable();  }
	
	
	
	//
	// SETTERS
	//
	
	private inline function set_target (newTarget:IScrollable) : IScrollable
	{
		if (newTarget != target)
		{
			removeTargetBindings();
			target = newTarget;
			invalidate(UIElementFlags.TARGET);
		}
		
		return newTarget;
	}
	
	
	override private function set_direction (v:Direction)
	{
		if (v != direction)
		{
			#if prime_css styleClasses.remove( direction.string()+"ScrollBar" ); #end
			super.set_direction(v);
			#if prime_css styleClasses.add( direction.string()+"ScrollBar" ); #end
		}
		return v;
	}
}