

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
package prime.gui.behaviours.scroll;
 import prime.gui.behaviours.BehaviourBase;
 import prime.gui.traits.IScrollable;
#if !CSSParser
 import prime.signals.Wire;
 import prime.core.geom.Point;
 import prime.gui.behaviours.drag.DragHelper;
 import prime.gui.display.ISprite;
 import prime.gui.events.MouseEvents;
 import prime.layout.LayoutFlags;
 import prime.gui.input.Mouse;
 import prime.layout.IScrollableLayout;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;
#end


/**
 * Behaviour to scroll by dragging the object.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
#if !dragEnabled
class DragScrollBehaviour extends BehaviourBase<IScrollable> implements IScrollBehaviour
{
	public function new()
	{
		super(null);
		Assert.abstractMethod("Dragging not enabled. Add -D dragEnabled");
	}
}
#else
class DragScrollBehaviour extends BehaviourBase<IScrollable> implements IScrollBehaviour
{
#if !CSSParser
	private var scrollLayout	: IScrollableLayout;
	private var lastMousePos	: Point;
	private var dragHelper		: DragHelper;
	private var moveBinding		: Wire < Dynamic >;
	
	
	override private function init ()
	{
		Assert.isNotNull( target.scrollableLayout, "target.scrollableLayout of "+target+" must be a IScrollableLayout" );
		Assert.that( Std.is( target, ISprite ), target+" must implement ISprite");

		target.enableClipping();
		
	//	trace(target+".init DragScrollBehaviour "+target.scrollRect);
		scrollLayout = target.scrollableLayout;
		checkScrollable.on( scrollLayout.changed, this );

		dragHelper		= new DragHelper( cast(target, ISprite), startScrolling, stopScrolling, dragAndScroll );
		moveBinding		= dragAndScroll.on( target.window.mouse.events.move, this );
		moveBinding.disable();
	}
	
	
	override private function reset ()
	{
		dragHelper.dispose();
		moveBinding.dispose();
		
		scrollLayout	= null;
		lastMousePos	= null;
		dragHelper		= null;
		moveBinding		= null;
		target.disableClipping();
	}
	
	
	private function checkScrollable (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH_PROPERTIES | LayoutFlags.HEIGHT_PROPERTIES ))
			return;
		
		if (!target.isScrollable || (!scrollLayout.horScrollable() && !scrollLayout.verScrollable()))
			target.userEvents.mouse.down.unbind( this );
		else
			dragHelper.start.on( target.userEvents.mouse.down, this );
	}
	
	
	private function startScrolling (mouseObj:MouseState)
	{
		moveBinding.enable();
		dragAndScroll(mouseObj);
	}


	private function stopScrolling (mouseObj:MouseState)
	{
		moveBinding.disable();
		lastMousePos = null;
	}
	
	
	private function dragAndScroll (mouseObj:MouseState)
	{
		if (mouseObj == null)
			return;
		
		var scrollHor = scrollLayout.horScrollable();
		var scrollVer = scrollLayout.verScrollable();
		
		if (!scrollHor && !scrollVer)
			return;
		
		if (lastMousePos == null) {
			lastMousePos = ScrollHelper.getLocalMouse(target, mouseObj);
			return;
		}
		
		var mousePos		= ScrollHelper.getLocalMouse(target, mouseObj);
		var mouseDiff		= lastMousePos.subtract(mousePos);
		var newScrollPos	= scrollLayout.scrollPos.clone();
		
		if (scrollHor)	newScrollPos.x += mouseDiff.x.roundFloat();
		if (scrollVer)	newScrollPos.y += mouseDiff.y.roundFloat();
		
		lastMousePos = mousePos;
		newScrollPos = scrollLayout.validateScrollPosition( newScrollPos );
		scrollLayout.scrollPos.setTo( newScrollPos );
	}
#end
}
#end
