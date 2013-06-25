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
 import haxe.Timer;
 import prime.signals.Signal0;
 import prime.gui.display.IDisplayObject;
 import prime.gui.effects.EffectProperties;
 import prime.gui.states.EffectStates;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;


/**
 * Base class for an effect that is currently playing.
 * See interface IEffectInstance for descriptions of the properties.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 01, 2010
 */
class EffectInstance<TargetType, PropertiesType:prime.gui.effects.IEffect> 
				implements IEffectInstance<TargetType, PropertiesType> 
{
	public var started		(default, null)				: Signal0;
	public var ended		(default, null)				: Signal0;
	public var state		(default, null)				: EffectStates;
	
	public var isReverted	(default, set_isReverted)	: Bool;
	public var effect		(default, null)				: PropertiesType;
	
	private var target			: TargetType;
	private var prevTween		: feffects.Tween;
	private var delayTimer		: Timer;
	
#if (flash9 || nme)
	private var cachedFilters	: Array<flash.filters.BitmapFilter>;
#end
	
	
	public function new (newTarget:TargetType, newEffect:PropertiesType)
	{
		target		= newTarget;
		effect		= newEffect;
		
		started		= new Signal0();
		ended		= new Signal0();
		
		state		= EffectStates.initialized;
		isReverted	= newEffect.isReverted;
	}
	
	
	public function dispose ()
	{
		if (isDisposed())
			return;
		
		stop();
		started.dispose();
		ended.dispose();
		
		started		= null;
		ended		= null;
		delayTimer	= null;
		prevTween	= null;
		state		= null;
		target		= null;
	}
	
	
	public #if !noinline inline #end function isDisposed ()			: Bool		{ return state == null; }
	public function setValues( v:EffectProperties ) : Void		{ Assert.abstractMethod(); }
	private function initStartValues()				: Void		{ Assert.abstractMethod(); }
	private function tweenUpdater( tweenPos:Float )	: Void		{ Assert.abstractMethod(); }
	private function calculateTweenStartPos ()		: Float		{ Assert.abstractMethod(); return 0; }

	
	
	public #if !noinline inline #end function revert ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
		isReverted = !isReverted;
		play( withEffect, directly );
	}
	
	
	public function play ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
	//	Assert.that(!isDisposed());
		if (isDisposed() || state == EffectStates.waiting && !directly)
			return;
		
		stopDelay();
		stopTween();
		hideFilters();

		if (directly || effect.delay <= 0)
		{
			if (withEffect)		playWithEffect();
			else				playWithoutEffect();
		}
		else
		{
			state		= EffectStates.waiting;
			delayTimer	= withEffect ? Timer.delay( playWithEffect, effect.delay ) : Timer.delay( playWithoutEffect, effect.delay );
		}
	}
	
	
	public function stop () : Void
	{
		Assert.that(!isDisposed());
		stopDelay();
		stopTween();
		applyFilters();
		
		if (isPlaying())
			state = EffectStates.finished;
	}
	
	
	public function reset ()
	{
		Assert.that(!isDisposed());
		stop();
		tweenUpdater( isReverted ? 1 : 0 );
	}
	
	
	
	//
	// PERFORM EFFECT
	//
	
	public function playWithEffect ()
	{
		stopDelay();
		started.send();
		
		//calculate the tweens end and start position
		initStartValues();
		var calcStartPos	= calculateTweenStartPos();
		var startPos		= isReverted ? 1.0 : 0.0;
		var endPos			= isReverted ? 0.0 : 1.0;
		
		//use current start pos, even when it's reversed
		if (calcStartPos > 0 && state != EffectStates.initialized)
			startPos = calcStartPos;
		
		//if the effect is playing for the first time, give the target its start position
	//	if (state == EffectStates.initialized)
	//		tweenUpdater( startPos );	<-- done within the effect instance implementation 'initStartValues'
		
		state = EffectStates.playing;
#if (debug && flash9)
		if (frozen)	return;
#end
		if (startPos == endPos || calcStartPos == -1)
		{
			onTweenReady();
		}
		else
		{
			//calculate tween duration
			var valDiff:Float			= startPos > endPos ? startPos - endPos : endPos - startPos;
			var calcDuration:Int		= ( effect.duration * valDiff ).roundFloat();
#if (debug && flash9)
			if (slowMotion)			calcDuration *= 20;
#end
			prevTween = new feffects.Tween( startPos, endPos, calcDuration, effect.easing );
		//	prevTween.setTweenHandlers( tweenUpdater, onTweenReady );	<-- feffects 1.2.0
			prevTween.onUpdate(tweenUpdater).onFinish(onTweenReady);
			prevTween.start();
		}
	}
	
	
	public function playWithoutEffect ()
	{
		started.send();
		stopDelay();
		state = EffectStates.playing;
		
		//call the effect handler once to make sure it's hidden
		tweenUpdater( isReverted ? 0 : 1 );
		onTweenReady();
	}
	
	
	private function onTweenReady ()
	{
		state = EffectStates.finished;
		applyFilters();
		ended.send();
	}
	
	
	private inline function hideFilters ()
	{
#if (flash9 || nme)
		if (effect.autoHideFilters && target != null && target.is(IDisplayObject))
		{
			var d = target.as(IDisplayObject);
			if (d.filters != null) {
				cachedFilters	= cast d.filters;
				d.filters		= null;
			}
		}
#end
	}
	
	
	private inline function applyFilters ()
	{
#if (flash9 || nme)
		if (effect.autoHideFilters && target != null && target.is(IDisplayObject) && cachedFilters != null)
		{
			var d = target.as(IDisplayObject);
			d.filters		= cast cachedFilters;
			cachedFilters	= null;
		}
#end
	}
	
	
	private inline function stopDelay ()
	{
		if (isWaiting())
		{
			delayTimer.stop();
			delayTimer = null;
		}
	}
	
	
	private inline function stopTween ()
	{
		if (prevTween != null)
		{
			prevTween.stop();
		//	prevTween.setTweenHandlers(null, null);
			prevTween.onUpdate(null).onFinish(null);
			prevTween = null;
		}
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	public #if !noinline inline #end function isPlaying () : Bool	{ return state == EffectStates.playing || state == waiting; }
	public #if !noinline inline #end function isWaiting () : Bool	{ return delayTimer != null; }

	
	private function set_isReverted (v:Bool)
	{
		return isReverted = v;
	}
	
	
#if (debug && flash9)
	@:keep static public function __init__ () {
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, 
			function(e) { switch (e.keyCode) {
				case flash.ui.Keyboard.SHIFT: 	slowMotion = true;
				case flash.ui.Keyboard.TAB: 	frozen = true;
			}});
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, 
			function(e) { switch (e.keyCode) {
				case flash.ui.Keyboard.SHIFT: 	slowMotion = false;
				case flash.ui.Keyboard.TAB: 	frozen = false;
			}});
	}
	static public var slowMotion = false;
	static public var frozen = false;
#end
}