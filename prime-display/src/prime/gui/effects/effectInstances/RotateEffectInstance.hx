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
package prime.gui.effects.effectInstances;
  using prime.gui.utils.DisplayUtil;
  using prime.utils.NumberUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class RotateEffectInstance extends EffectInstance < prime.gui.display.IDisplayObject, prime.gui.effects.RotateEffect >
{
	/**
	 * start rotation value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startValue	: Float;
	/**
	 * rotation end-value
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endValue	: Float;
	
	
	public function new (target, effect)
	{
		super(target, effect);
		startValue = endValue = prime.types.Number.FLOAT_NOT_SET;
	}


	override public function setValues ( v:prime.gui.effects.EffectProperties ) 
	{
		switch (v) {
			case rotation(from, to):
				startValue	= from;
				endValue	= to;
			default:
				return;
		}
	}
	

	override private function initStartValues ()
	{
		if (effect.startValue.isSet())	startValue = effect.startValue;
		else							startValue = target.rotation;
		
		if (effect.endValue.isSet())	endValue = effect.endValue;
		else							endValue = 1;
		
		target.rotateAroundCenter(startValue);
		target.visible	= true;
	}


	override private function tweenUpdater ( tweenPos:Float )
	{
		target.rotateAroundCenter( (endValue * tweenPos) + (startValue * (1 - tweenPos)) );
	}


	override private function calculateTweenStartPos () : Float
	{
		return (target.rotation - startValue) / (endValue - startValue);
	}
}