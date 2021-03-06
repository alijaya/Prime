

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
#if !CSSParser
 import prime.signals.Wire;
 import prime.gui.events.MouseEvents;
 import prime.layout.LayoutFlags;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;
  using prime.utils.BitUtil;
  using Std;
#end


/**
 * Base class for scrolling behaviours that react on the mouseposition.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class MouseScrollBehaviourBase extends prime.gui.behaviours.BehaviourBase<prime.gui.traits.IScrollable> implements IScrollBehaviour
{
#if !CSSParser
	private var activateBinding		: Wire < Dynamic >;
	private var deactivateBinding	: Wire < Dynamic >;
	private var calcScrollBinding	: Wire < Dynamic >;
	
	// Scrolling is based on AdvancedLayoutClient::measuredWidth and AdvancedLayoutClient::width (plus their height dimension counterparts).
	// These things can change but scrolling will not update until the mouse is moved which can result in large jumps. So listen to those changes
	// and recalculate scroll position in response. Also listen to target position changes, which can also move content under a stationary mouse.
	private var layoutScrollBinding	: Wire < Int->Void >;
	private var lastMouseObj:MouseState;
	
	/**
	 * Flag indicating if the target already was clipped before the behaviour was applied. Needed for resetting
	 */
	private var hadClipping 		: Bool;
	
	override private function init ()
	{
		Assert.isNotNull( target.scrollableLayout, "target.layout of "+target+" must be a IScrollableLayout" );

		if (target.container == null)
			addListeners.onceOn(target.displayEvents.addedToStage, this);
		else
			addListeners();
	}


	private function addListeners ()
	{
		hadClipping = target.getScrollRect() != null;
		if (!hadClipping)
			target.enableClipping();

		var mouseEvt 		= target.container.userEvents.mouse;
		activateBinding		= mouseEvt.rollOver.bind(this, activateScrolling);
		deactivateBinding	= mouseEvt.rollOut.observeDisabled(this, deactivateScrolling);
		calcScrollBinding	= mouseEvt.move.bindDisabled(this, calculateScroll);

		layoutScrollBinding = target.scrollableLayout.changed.bindDisabled(this, layoutValidated);
		
		var mouse = target.container.globalToLocal(target.window.mouse.pos);
		if (target.rect.containsPoint(mouse.x.int(), mouse.y.int()))
			activateScrolling.bind(new MouseState(0, cast target, mouse, target.window.mouse.pos, cast target)).onceOn(target.displayEvents.enterFrame, this);
	}
	
	
	override private function reset ()
	{
		target.displayEvents.addedToStage.unbind(this);
		calcScrollBinding.dispose();
		activateBinding.dispose();
		deactivateBinding.dispose();
		layoutScrollBinding.dispose();
		activateBinding		= null;
		deactivateBinding	= null;
		calcScrollBinding	= null;
		layoutScrollBinding = null;
		if (!hadClipping)
			target.disableClipping();
	}

	private function layoutValidated( changes:Int )
	{
		if ( changes.has( LayoutFlags.SIZE_PROPERTIES | LayoutFlags.POSITION ) )
			calculateScroll( lastMouseObj );
	}
	
	private function activateScrolling (mouseObj:MouseState) if (target.isScrollable)
	{
		lastMouseObj = mouseObj.clone();
		
		activateBinding.disable();
		deactivateBinding.enable();
		calcScrollBinding.enable();
		layoutScrollBinding.enable();
		calculateScroll( mouseObj );
	}

	private function deactivateScrolling () {
		calcScrollBinding.disable();
		deactivateBinding.disable();
		layoutScrollBinding.disable();
		activateBinding.enable();
	}
	
	private function calculateScroll (mouseObj:MouseState) {
	#if debug
		throw "Method calculateScrollPosition should be overwritten";
	#end
	}
#end
}