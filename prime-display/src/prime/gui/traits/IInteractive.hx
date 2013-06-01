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
package prime.gui.traits;


interface IInteractive
{
#if !CSSParser
	var userEvents		(default, null)				: prime.gui.events.UserEvents;
#end
	
	/**
	 * Method will set the focus to the sprite
	 */
	public function setFocus ()		: Void;
	
	/**
	 * Method will remove the focus from the sprite
	 */
	public function removeFocus ()	: Void;
	
	
#if (flash9 || nme)
	/**
	 * Method returns true if the given target (which has focus) makes the 
	 * IInteractive object the focus owner.
	 * This is usefull when a Label with a textfield loses its focus to the
	 * textfield, but is still the focus-owner.
	 */
	public function isFocusOwner (target:prime.gui.events.UserEventTarget) : Bool;

  #if !cpp
	var tabEnabled									: Bool;
  #end

  #if flash9
	var doubleClickEnabled							: Bool;
	var mouseEnabled								: Bool;
	var tabIndex									: Int;

  #elseif (nme && html5)
	public var tabIndex(get_tabIndex, set_tabIndex):Int;
  #end
	
#elseif !neko
	var mouseEnabled								: Bool;
//	var mouseEnabled	(default, set_enabled)		: Bool;
#end
}