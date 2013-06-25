

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
 import prime.core.geom.space.Direction;
 import prime.gui.behaviours.components.DirectToolTipBehaviour;
 import prime.gui.behaviours.UpdateMaskBehaviour;
 import prime.gui.core.UIGraphic;
 import prime.gui.display.VectorShape;
  using prime.utils.NumberUtil;
  using Std;

/**
 * Slider component with a filling background to indicate which part of the
 * slider is slided.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class Slider extends SliderBase
{
	override private function init ()
	{
		super.init();
		behaviours.add( new UpdateMaskBehaviour( maskShape, this ) );
		dragBtn.behaviours.add( new DirectToolTipBehaviour( dragBtn, dragBtn.data ) );
	}
	
	
	//
	// CHILDREN
	//
	
	private var background			: UIGraphic;
	/**
	 * Shape that is used to fill the part of the slider that is slided
	 */
	private var maskedBackground	: UIGraphic;
	private var maskShape			: VectorShape;
	
	
	override private function createChildren ()
	{
		maskShape			= new VectorShape();
		background			= new UIGraphic( #if debug id.value + "Background" #end );
		maskedBackground	= new UIGraphic( #if debug id.value + "MaskedBackground" #end );
	
	#if prime_css
		background.styleClasses.add("background");
		maskedBackground.styleClasses.add("maskedBackground");
	#end
		
		attach( background ).attach( maskedBackground );
		maskShape.attachDisplayTo( this );
		maskedBackground.mask = maskShape;

		super.createChildren();
	}
	
	
	override private function updateChildren ()
	{
		maskedBackground.mask = maskShape;
	//	trace(maskedBackground.layout.percentWidth+"; "+layout.readChanges()+"; "+layout.state.current);
		if (direction == horizontal)	maskedBackground.layout.percentWidth  = data.percentage;
		else							maskedBackground.layout.percentHeight = data.percentage;
		
	//	trace(maskedBackground.layout.percentWidth+"; "+layout.readChanges()+"; "+layout.state.current);
		dragBtn.data.value = (data.value * 100).roundFloat() + "%";
		return super.updateChildren();
	}
	
#if prime_css
	override private function set_direction (v)
	{
		if (direction != v)
		{
			if (direction != null)
				styleClasses.remove( direction.string()+"Slider" );
			
			super.set_direction(v);
			
			if (v != null)
				styleClasses.add( direction.string()+"Slider" );
		}
		return v;
	}
#end
}
