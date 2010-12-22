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
package primevc.gui.behaviours.layout;
 import primevc.gui.behaviours.ValidatingBehaviour;
 import primevc.gui.core.UIWindow;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IPropertyValidator;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


/**
 * @author Ruben Weijers
 * @creation-date Jul 26, 2010
 */
class WindowLayoutBehaviour extends ValidatingBehaviour < UIWindow >, implements IPropertyValidator
{
	override private function init ()
	{
		Assert.that(target.layout != null, "Layout of "+target+" can't be null for "+this);
		
#if debug
		target.layout.name = target.id.value+"Layout";
#end
		
		layoutStateChangeHandler.on( target.layout.state.change, this );
		//trigger the event handler for the current state as well
		layoutStateChangeHandler( target.layout.state.current, null );
		
#if flash9
		updateBgSize.on( target.layout.changed, this );
	//	updateBgSize();
#end
	}


	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		target.layout.state.change.unbind( this );
		super.reset();
	}

	
	private function layoutStateChangeHandler (newState:ValidateStates, oldState:ValidateStates)
	{
		if (newState == ValidateStates.invalidated)
			invalidate();
	}
	
	
	public inline function invalidate ()			{ target.invalidationManager.add(this); }
	public inline function validate ()				{ target.layout.validate(); }
	override private function getValidationManager ()	{ return cast target.invalidationManager; }
	
	
#if flash9
	private function updateBgSize (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH | LayoutFlags.HEIGHT ))
			return;
		
		var l = target.layout;
	//	trace(target+".updateBgSize "+l.outerBounds);
	/*	if (!target.graphicData.isEmpty())
		{
			target.bgShape.width	= l.width.value;
			target.bgShape.height	= l.height.value;
		}*/
		target.rect.width		= l.width.value;
		target.rect.height		= l.height.value;
	}	
#end
}