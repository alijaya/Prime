

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
package prime.gui.core;
#if !CSSParser


/**
 * Interface for a skin.
 * 
 * Order of execution of methods of a skin:
 * 	- IUIComponent creates skin
 * 	- ISkin->constructor
 * 		- createStates()
 * 		- createChildren()
 * 	- IUIComponent.createChildren()
 * 	- IUIComponent -> ISkin.setupSkin()
 * 
 * @author Ruben Weijers
 * @creation-date Aug 03, 2010
 */
interface ISkin 
		implements prime.core.traits.IDisposable
	,	implements prime.gui.traits.IBehaving
{
//	public var skinState		(default, null)		: prime.gui.states.SkinStates;
//	public var owner			(default, setOwner) : OwnerClass;
	public function changeOwner	(o:IUIComponent)	: Void;
	
	
	/**
	 * Method for adding extra state objects to the skin
	 */
//	private function createStates ()		: Void;
	
	/**
	 * Creates the default graphical data of a UIComponent
	 */
//	public function drawGraphics ()		: Void;
	
	/**
	 * A skin can have children, despite the fact that it isn't a IDisplayable 
	 * object. It will add its children to the child-list of its owner.
	 * After this method, the owner will creates its children.
	 */
	public function createChildren ()		: Void;
	
	/**
	 * This method is called after the owner has created its children. It can 
	 * be used e.g. to place them in a different container or change their 
	 * depts or values.
	 */
	public function childrenCreated ()		: Void;
	
	
	/**
	 * Dispose method for all the extra states that where created for this skin.
	 */
//	private function removeStates ()		: Void;
	
	/**
	 * Dispose all the children of this skin. This can happen when the owner 
	 * is disposed or when the owner changes its skin.
	 */
	public  function disposeChildren ()		: Void;
	
	
	/**
	 * Method is called when the owner is validated and allows the skin to
	 * update itself after some properties have changed.
	 */
	public function validate (changes:Int)	: Void;
	
	/**
	 * Method indicating wether the skin is disposed or not
	 */
	public function isDisposed ()			: Bool;
	
	
	
	/**
	 * Abstract method.
	 * Is called by the owner when an object wants to check if the owner has
	 * focus. The skin can check if the target is one of its children and then
	 * return true or false.
	 */
	public function isFocusOwner (target:prime.gui.events.UserEventTarget) : Bool;
}
#else
interface ISkin implements prime.gui.traits.IBehaving, implements prime.core.traits.IDisposable {}
#end