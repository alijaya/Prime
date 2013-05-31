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
#if !CSSParser
 import prime.gui.effects.effectInstances.IEffectInstance;
  using prime.types.Reference;
#end
  using prime.utils.NumberUtil;


/**
 * Base class for every effect
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class Effect <TargetType, EffectClass:IEffect> extends prime.core.traits.Invalidatable implements IEffect
{
#if (debug || CSSParser)
	public var _oid				(default, null)	: Int;
#end
	
	public var easing			(default, set_easing)			: Easing;
	public var delay			(default, set_delay)			: Int;
	public var duration			(default, set_duration)			: Int;
	public var autoHideFilters	(default, set_autoHideFilters)	: Bool;
	public var isReverted		(default, set_isReverted)		: Bool;
	
	
	public function new (newDuration:Int = 350, newDelay:Int = 0, newEasing:Easing = null, isReverted:Bool = false) 
	{
		super();
#if (debug || CSSParser)
		_oid			= prime.utils.ID.getNext();
#end
		duration		= newDuration.notSet()	? 350 : newDuration;
		delay			= newDelay <= 0			? prime.types.Number.INT_NOT_SET : newDelay;
		this.isReverted = isReverted;
#if (flash9 || nme)
		easing			= newEasing == null 	? feffects.easing.Linear.easeNone : newEasing;
#elseif CSSParser
		easing 			= newEasing;
#end
		autoHideFilters	= false;
	}
	
	
	override public function dispose ()
	{
		easing = null;
		super.dispose();
		//dispose all effect instances?
	}
	
	
	public function clone () : IEffect
	{
		Assert.abstractMethod(); return null;
	}
	
	
	public function setValues( v:EffectProperties ) : Void
	{
		Assert.abstractMethod();
	}
	
	
#if !CSSParser
	/**
	 * Method will start a new effect on the given target and return the 
	 * playing effect instance.
	 */
	public function play (target:TargetType, withEffect:Bool = true, playDirectly:Bool = false) : IEffectInstance < TargetType, EffectClass >
	{
		Assert.that(target != null && duration > 0);
		var c = createEffectInstance(target);
		c.play(withEffect, playDirectly);
		return c;
	}
	
	
	public function createEffectInstance (target:TargetType) : IEffectInstance < TargetType, EffectClass >
	{
		Assert.abstractMethod();
		return null;
	}
#end
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function set_delay (v:Int) : Int
	{
		Assert.that(v >= 0 || v.notSet(), "delay should be 0 or larger.. it is: "+v);
		if (delay != v) {
			delay = v;
			invalidate( EffectFlags.DELAY );
		}
		return v;
	}
	
	
	private inline function set_easing (v:Easing) : Easing
	{
		if (easing != v) {
			easing = v;
			invalidate( EffectFlags.EASING );
		}
		return v;
	}
	
	
	private inline function set_duration (v:Int) : Int
	{
		if (duration != v) {
			duration = v;
			invalidate( EffectFlags.DURATION );
		}
		return v;
	}
	
	
	private inline function set_isReverted (v:Bool)
	{
		if (isReverted != v) {
			isReverted = v;
			invalidate( EffectFlags.IS_REVERTED );
		}
		return v;
	}
	
	
	private inline function set_autoHideFilters (v:Bool) : Bool
	{
		if (autoHideFilters != v) {
			autoHideFilters = v;
			invalidate( EffectFlags.AUTO_HIDE_FILTERS );
		}
		return v;
	}
	
	
#if CSSParser
	public function toString ()						{ return toCSS(); }
	public function toCSS (prefix:String = "")		{ Assert.abstractMethod(); return null; }
	public function isEmpty () : Bool				{ return duration <= 0; }
	public function cleanUp ()						{}
	public function toCode (code:prime.tools.generator.ICodeGenerator)
		Assert.abstractMethod()
#end
}