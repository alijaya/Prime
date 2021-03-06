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
 *  Danny Wilson	<danny @ prime.vc>
 */
package prime.bindable;

/**
 * Read/write interface for 'data-binding'.
 * 
 * @see Bindable
 * @author Danny Wilson
 * @creation-date Jun 25, 2010
 */
//#if flash9 @:generic #end
interface IBindable<T> extends IBindableReadonly<T>
	#if prime_data extends prime.core.traits.IEditableValueObject #end
{
	/**
	 * Value property with write access.
	 */
	public var value	(default, set_value)	: T;
	
	/**
	 * Makes sure this value is (and remains) equal
	 * to otherBindable.value
	 *	
	 * In other words: 
	 * - update this.value when otherBindable changes
	 */
	public function bind( otherBindable:IBindableReadonly<T> ) : Void;
	
	/**
	 * Internal function which tells this IBindable, another bindable is writing to it.
	 */
	@:keep private function registerBoundTo( otherBindable:IBindableReadonly<T> ) : Void;
	
	/** 
	 * Makes sure this Bindable and otherBindable always have the same value.
	 * 
	 * In other words: 
	 * - update this when otherBindable.value changes
	 * - update otherBindable when this.value changes
	 */
	public function pair( otherBindable:IBindable<T> ) : Void;
}