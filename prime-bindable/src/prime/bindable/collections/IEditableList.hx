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
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.bindable.collections;

/**
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
//#if (flash9 || cpp) @:generic #end
interface IEditableList<T> extends IReadOnlyList<T>
	#if prime_data extends prime.core.traits.IEditEnabledValueObject #end
{
	//
	// LIST MANIPULATION METHODS
	//
	
	/**
	 * Method will add the item on the given position. It will add the 
	 * item at the end of the childlist when the value is equal to -1.
	 * 
	 * @param	item
	 * @param	pos		default-value: -1
	 * @return	item
	 */
	public function add		(item:T, pos:Int = -1)						: T;
	/**
	 * Method will try to remove the given item from the childlist.
	 * 
	 * @param	item
	 * @return	item
	 */
	public function remove	(item:T, oldPos:Int = -1)					: T;
	/**
	 * Method will change the depth of the given item.
	 * 
	 * @param	item
	 * @param	newPos
	 * @param	curPos	Optional parameter that can be used to speed up the 
	 * 					moving process since the list doesn't have to search 
	 * 					for the original location of the item.
	 * @return	item
	 */
	public function move	(item:T, newPos:Int, curPos:Int = -1)		: T;
	
	public function removeAll ()										: Void;
}