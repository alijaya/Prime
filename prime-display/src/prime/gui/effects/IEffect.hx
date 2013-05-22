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
#if CSSParser
 import prime.tools.generator.ICodeFormattable;
 import prime.tools.generator.ICSSFormattable;
#end
 import prime.core.traits.IClonable;
 import prime.core.traits.IInvalidatable;
 import prime.core.traits.IDisposable;


/**
 * @author Ruben Weijers
 * @creation-date Oct 02, 2010
 */
interface IEffect
				implements IDisposable
			,	implements IInvalidatable	
#if CSSParser,	implements ICSSFormattable
			,	implements ICodeFormattable		#end
			,	implements IClonable < IEffect >
{
	/**
	 * The easing type that the effect should use
	 * @default		null
	 * @see			feffects.easing
	 */
	public var easing			(default, setEasing)			: Easing;
	
	/**
	 * Number of milliseconds to wait before starting the effect
	 * @default		0
	 */
	public var delay			(default, setDelay)				: Int;
	
	/**
	 * Effect duration
	 * @default		350
	 */
	public var duration			(default, setDuration)			: Int;
	
	/**
	 * Flag indicating if the targets filters should be hidden when the effect
	 * is running.
	 * @default	false
	 */
	public var autoHideFilters	(default, setAutoHideFilters)	: Bool;
	
	/**
	 * Flag indicating if the effect is supposed to be playing backwards
	 * @default false
	 */
	public var isReverted		(default, setIsReverted)		: Bool;
	
	/**
	 * Method to set the explicit start and end values of the effect
	 * @see	EffectProperties
	 */
	public function setValues( v:EffectProperties ) : Void;
}