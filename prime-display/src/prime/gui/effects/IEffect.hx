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

/**
 * @author Ruben Weijers
 * @creation-date Oct 02, 2010
 */
interface IEffect
				extends prime.core.traits.IDisposable
				extends prime.core.traits.IInvalidatable	
#if CSSParser	extends prime.tools.generator.ICSSFormattable
				extends prime.tools.generator.ICodeFormattable		#end
				extends prime.core.traits.IClonable < IEffect >
{
	/**
	 * The easing type that the effect should use
	 * @default		null
	 * @see			feffects.easing
	 */
	public var easing			(default, set_easing)			: Easing;
	
	/**
	 * Number of milliseconds to wait before starting the effect
	 * @default		0
	 */
	public var delay			(default, set_delay)			: Int;
	
	/**
	 * Effect duration
	 * @default		350
	 */
	public var duration			(default, set_duration)			: Int;
	
	/**
	 * Flag indicating if the targets filters should be hidden when the effect
	 * is running.
	 * @default	false
	 */
	public var autoHideFilters	(default, set_autoHideFilters)	: Bool;
	
	/**
	 * Flag indicating if the effect is supposed to be playing backwards
	 * @default false
	 */
	public var isReverted		(default, set_isReverted)		: Bool;
	
	/**
	 * Method to set the explicit start and end values of the effect
	 * @see	EffectProperties
	 */
	public function setValues( v:EffectProperties ) : Void;
}