

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
package prime.gui.effects;
  using prime.utils.NumberUtil;
#if CSSParser
  using prime.types.Reference;
#end


/**
 * Class to set the specified property to the specified value in the target.
 * This is usable to change a specific property of the target during a 
 * Parallel- or Sequence effect.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 01, 2010
 */
class SetAction extends #if CSSParser Effect<Dynamic, Dynamic> #else Effect<prime.gui.core.IUIElement, SetAction> #end
{
	public var prop : EffectProperties;
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null, isReverted:Bool = false, prop:EffectProperties = null)
	{
		super(duration, delay, easing, isReverted);
		this.prop = prop;
	}
	
	
	override public function setValues (v:EffectProperties)	{ prop = v; }
	override public function clone ()						{ return new SetAction( duration, delay, easing, isReverted, prop ); }
#if !CSSParser
	override public function createEffectInstance (target)	{ return new prime.gui.effects.effectInstances.SetActionInstance(target, this); }
#else

	override public function toCSS (prefix:String = "") : String
	{
		var props = [];
		
		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easing.toCSS() );
		if (prop != null)			props.push( propToCSS() );
		if (isReverted)				props.push( "reverted" );
		
		return "set-action " + props.join(" ");
	}
	
	
	private function propToCSS () : String
	{
		var propStr = switch (prop) 
		{
			case alpha(from, to):
				"alpha(" + from + ", " + to + ")";
			
			case any(propName, from, to):
				"any(" + propName + ", " + from + ", " + to + ")";
			
			case position(fromX, fromY, toX, toY):
				"position(" + fromX + ", " + fromY + ", " + toX + ", " + toY + ")";
			
			case rotation(from, to):
				"rotation(" + from + ", " + to + ")";
			
			case scale(fromSx, fromSy, toSx, toSy):
				"scale(" + fromSx + ", " + fromSy + ", " + toSx + ", " + toSy + ")";
			
			case size(fromW, fromH, toW, toH):
				"size(" + fromW + ", " + fromH + ")";
			
			default: "";
		}
		
		return propStr;
	}
	
	
	override public function isEmpty ()
	{
		return false;
	}


	override public function toCode (code:prime.tools.generator.ICodeGenerator) : Void
	{
		if (!isEmpty())
			code.construct( this, [ duration, delay, isReverted, easing, prop ] );
	}
#end
}