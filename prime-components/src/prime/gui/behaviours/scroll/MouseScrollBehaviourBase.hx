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
 import prime.signal.Wire;
 import prime.gui.events.MouseEvents;
 import prime.gui.layout.IScrollableLayout;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;
#end


/**
 * Base class for scrolling behaviours that react on the mouseposition.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class MouseScrollBehaviourBase extends BehaviourBase<IScrollable>, implements IScrollBehaviour
{
#if !CSSParser
	private var scrollLayout		: IScrollableLayout;
	private var activateBinding		: Wire < Dynamic >;
	private var deactivateBinding	: Wire < Dynamic >;
	private var calcScrollBinding	: Wire < Dynamic >;
	
	
	override private function init ()
	{
		Assert.isNotNull( target.scrollableLayout, "target.layout of "+target+" must be a IScrollableLayout" );
		target.enableClipping();
		var mouse = target.container.userEvents.mouse;
		scrollLayout = target.scrollableLayout;
		activateBinding		= activateScrolling		.on( mouse.rollOver, this );
		deactivateBinding	= deactivateScrolling	.on( mouse.rollOut, this );
		calcScrollBinding	= calculateScroll		.on( mouse.move, this );
		deactivateBinding.disable();
		calcScrollBinding.disable();
	}
	
	
	override private function reset ()
	{
		scrollLayout = null;
		calcScrollBinding.dispose();
		activateBinding.dispose();
		deactivateBinding.dispose();
		activateBinding		= null;
		deactivateBinding	= null;
		calcScrollBinding	= null;
		target.disableClipping();
	}


	private function activateScrolling (mouseObj:MouseState) {
		if (!target.isScrollable)
			return;
		
		activateBinding.disable();
		deactivateBinding.enable();
		calcScrollBinding.enable();
		
		calculateScroll( mouseObj );
	}


	private function deactivateScrolling () {
		calcScrollBinding.disable();
		deactivateBinding.disable();
		activateBinding.enable();
	}
	
	
	private function calculateScroll (mouseObj:MouseState) {
	#if debug
		throw "Method calculateScrollPosition should be overwritten";
	#end
	}
#end
}