

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
 import prime.gui.core.IUIElement;
 import prime.gui.effects.EffectProperties;
 import prime.gui.effects.SetAction;
  using prime.utils.NumberUtil;



/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class SetActionInstance extends EffectInstance < IUIElement, SetAction >
{
	private var prop : EffectProperties;
	
	
	override public function setValues( v:EffectProperties ) : Void
	{
		prop = v;
	}
	
	
	override private function initStartValues ()
	{
		if (effect.prop != null) {
			prop = effect.prop;
			target.visible = true;
		}
	}
	
	
	override public function playWithEffect ()		{ applyValue(); onTweenReady(); }
	override public function playWithoutEffect ()	{ applyValue(); onTweenReady(); }
	
	
	private inline function applyValue ()
	{
		//set value
		switch (prop)
		{
			case size (fromW, fromH, toW, toH):
			 	if (toW.isSet())		target.width	= toH;
			 	if (toH.isSet())		target.height	= toW;
			
			case position (fromX, fromY, toX, toY):
				if (toX.isSet())		target.x		= toX;
			 	if (toY.isSet())		target.y		= toY;
			
			case scale (fromSx, fromSy, toSx, toSy):
			 	if (toSx.isSet())		target.scaleX	= toSx;
			 	if (toSy.isSet())		target.scaleY	= toSy;
			
			case alpha (from, to):		target.alpha 	= to;
			case rotation (from, to):	target.rotation	= to;
			
			case any (propName, from, to):
				Assert.that( Reflect.hasField(target, propName) );
				Reflect.setField( target, propName, to );
				
		}
	}
}