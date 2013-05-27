

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
 import prime.core.events.ActionEvent;
 import prime.core.geom.space.Direction;
 import prime.core.geom.IntPoint;
 import prime.core.geom.Point;
 import prime.core.math.PercentageHelper;
 import prime.bindable.Bindable;
 import prime.gui.components.Button;
 import prime.gui.core.UIElementFlags;
 import prime.gui.core.UIDataContainer;
 import prime.gui.events.MouseEvents;
  using prime.gui.utils.UIElementActions;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;



/**
 * Slider component
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class SliderBase extends UIDataContainer <PercentageHelper>
{
	/**
	 * Defines if the slider is horizontal or vertical
	 * @default		horizontal
	 */
	public var direction	(default, set_direction)	: Direction;
	
	/**
	 * Eventgroup with events that are dispatched when the user starts sliding
	 * the slider.
	 */
	public var sliding		(default, null)				: ActionEvent;
	
	
	private var mouseMoveBinding		: Wire < MouseState -> Void >;
	private var mouseBgDownBinding		: Wire < MouseState -> Void >;
	private var mouseBtnDownBinding		: Wire < MouseState -> Void >;
	private var mouseUpBinding			: Wire < MouseState -> Void >;
	
	
	
	
	public function new (id:String = null, value:Float = 0.0, minValue:Float = 0.0, maxValue:Float = 1.0, direction:Direction = null)
	{
		super(id, new PercentageHelper(value, minValue, maxValue));
		(untyped this).inverted		= false;
	//	(untyped this).showButtons	= false;
		this.direction				= direction == null ? horizontal : direction;
		sliding						= new ActionEvent();
	}
	
	
	override public function dispose ()
	{
		if (data != null)					data.dispose();
		if (mouseMoveBinding != null)		mouseMoveBinding.dispose();
		if (mouseUpBinding != null)			mouseUpBinding.dispose();
		if (mouseBgDownBinding != null)		mouseBgDownBinding.dispose();
		if (mouseBtnDownBinding != null)	mouseBtnDownBinding.dispose();
		
		mouseBgDownBinding	= mouseBtnDownBinding = mouseUpBinding = mouseMoveBinding = null;
		(untyped this).data = null;
		sliding.dispose();
		
		if (isInitialized())
		{
			dragBtn.dispose();
			dragBtn = null;
		}
		
		sliding	= null;
		direction = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		super.init();
		
		mouseBgDownBinding	= jumpToPosition	.on( userEvents.mouse.down, this );
		mouseBtnDownBinding	= enableMoveWires	.on( dragBtn.userEvents.mouse.down, this );
		mouseUpBinding		= fakeMouseUpEvent	.on( window.mouse.events.up, this );
		mouseUpBinding.disable();

		disableMoveWires.on( userEvents.mouse.up, this );

		createMouseMoveBinding();
	}
	
	
	override private function initData ()
	{
		invalidatePercentage.on( data.perc.change, this );
		updateChildren();
	}
	
	
	override private function removeData ()
	{
		data.perc.change.unbind( this );
	}
	
	
	override public function validate ()
	{
		var changes = this.changes;
		super.validate();
		
		if (changes.has(UIElementFlags.PERCENTAGE))
			updateChildren();	// <-- don't invalidate PERCENTAGE again.. this can cause infinite loops!
		/*	if (!updateChildren())		//updating children fails if the width or height in layout isn't set yet
				invalidate(UIElementFlags.PERCENTAGE);*/
		
		if (changes.has(UIElementFlags.DIRECTION))
			createMouseMoveBinding();
	}
	
	
	private inline function createMouseMoveBinding ()
	{
		if (mouseMoveBinding != null)
		{
			mouseMoveBinding.dispose();
			mouseMoveBinding = null;
		}
		
		if (window != null && direction != null)
		{
			var calculateValue	= direction == horizontal ? calculateHorValue : calculateVerValue;
			mouseMoveBinding	= calculateValue.on( window.mouse.events.move, this );
			mouseMoveBinding.disable();
		}
	}
	
	
	private function invalidatePercentage ()
	{
		invalidate( UIElementFlags.PERCENTAGE );
	}
	
	
	
	//
	// CHILDREN
	//
	
	public var dragBtn		(default, null)	: Button;
	
	
	override private function createChildren ()
	{
		attach( dragBtn = new Button( id.value + "Btn" ) );
	//	dragBtn.layout.includeInLayout = false;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function set_direction (v)
	{
		if (direction != v)
		{
			direction = v;
			invalidate(UIElementFlags.DIRECTION);
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private var originalPos		: IntPoint;
	private var mouseStartPos	: Point;
	
	
	/**
	 * Method is called when the user clicks somewhere on the slider but not
	 * on the dragBtn.
	 * The dragBtn should jump to the mouseposition and follow the cursor
	 * as long as the mouseBtn stays down.
	 */
	private function jumpToPosition (mouseObj:MouseState)
	{
		if (mouseObj.target != this)
			return;
		
		//jump to position
		var curMouse		= getLocalMousePos( mouseObj );
		data.percentage		= (direction == horizontal)
								? ((curMouse.x - layout.padding.left) / layout.width).within(0, 1)
								: ((curMouse.y - layout.padding.top) / layout.height).within(0, 1);
		
		dragBtn.layout.includeInLayout = false;
		validate();
		
		//enable dragging as long as the mouse is down
		enableMoveWires(mouseObj);
	}
	
	
	private function enableMoveWires (mouseObj:MouseState)
	{
		originalPos		= new IntPoint( dragBtn.layout.x, dragBtn.layout.y );
		mouseStartPos	= getLocalMousePos( mouseObj );
		
		mouseBtnDownBinding.disable();
		mouseBgDownBinding.disable();
		mouseUpBinding.enable();
		mouseMoveBinding.enable();
		
	//	calculateValue( mouseObj );
	//	dragBtn.mouseEnabled				= false;
		dragBtn.layout.includeInLayout		= false;
		sliding.begin.send();
	}
	
	
	private function disableMoveWires (mouseObj:MouseState)
	{
		mouseStartPos	= null;
		originalPos		= null;
		
		mouseBtnDownBinding.enable();
		mouseBgDownBinding.enable();
		mouseUpBinding.disable();
		mouseMoveBinding.disable();
		
	//	calculateValue( mouseObj );
		if (direction == horizontal)	dragBtn.layout.relative.left 		= dragBtn.layout.x;
		else							dragBtn.layout.relative.top 		= dragBtn.layout.y;
		dragBtn.mouseEnabled				= true;
		dragBtn.layout.includeInLayout		= true;
		sliding.apply.send();
	}


	private function fakeMouseUpEvent (mouseObj:MouseState)
	{
		if (mouseObj.target != this) {
			//fake a mouse-up event is the mouse was released outside the slider
			userEvents.mouse.up.send(mouseObj);
		}
	}
	
	
	private inline function getLocalMousePos (mouseObj:MouseState)
	{
		return (mouseObj.target == this) ? mouseObj.local : globalToLocal(mouseObj.stage);
	}
	
	
	/**
	 * Method is called after the position of the dragButton is changed or
	 * when the user clicked somewhere in the background
	 */
	private function calculateHorValue (mouseObj:MouseState)
	{
		var curMouse	= getLocalMousePos( mouseObj );
		var min			= layout.padding.left;
		var maxMouse	= layout.width + min;
		var max			= maxMouse - dragBtn.layout.outerBounds.width;
		
		if (!curMouse.x.isWithin( min, maxMouse ))
			return;
		
		var newX		= (originalPos.x + curMouse.x - mouseStartPos.x).within( min, max );
		data.percentage	= ((newX - min) / (max - min)).within(0, 1);
	}
	
	
	private function calculateVerValue (mouseObj:MouseState)
	{
		var curMouse	= getLocalMousePos( mouseObj );
		var min			= layout.padding.top;
		var maxMouse	= layout.height + min;
		var max			= maxMouse - dragBtn.layout.outerBounds.height;
		
		if (!curMouse.y.isWithin( min, maxMouse ))
			return;
		
		var newY		= (originalPos.y + curMouse.y - mouseStartPos.y).within( min, max );
		data.percentage	= (newY / max).within(0, 1);
	}
	
	
	private function updateChildren () : Bool
	{
		if (direction == horizontal)
		{
			if (layout.width.notSet())
				return false;
			
			dragBtn.x			= layout.padding.left + ( data.percentage * ( layout.width - dragBtn.layout.outerBounds.width ) );
			dragBtn.layout.x	= dragBtn.layout.relative.left = dragBtn.x.roundFloat();
		}
		else
		{
			if (layout.height.notSet())
				return false;
			
			dragBtn.y			= layout.padding.top + ( data.percentage * (layout.height - dragBtn.layout.outerBounds.height) );
			dragBtn.layout.y	= dragBtn.layout.relative.top = dragBtn.y.roundFloat();
		}
		return true;
	}
	
	
#if debug
	override public function toString ()	{ return id.value+"( "+direction+" )"; }
#end
}