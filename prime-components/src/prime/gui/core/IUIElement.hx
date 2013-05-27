

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
 import prime.core.traits.IIdentifiable;
 import prime.core.traits.IDisposable;

 import prime.gui.display.IDisplayContainer;
 import prime.gui.display.IDisplayObject;

 import prime.gui.effects.UIElementEffects;
 import prime.layout.ILayoutContainer;
 import prime.gui.managers.ISystem;
 import prime.gui.states.UIElementStates;
 
 import prime.gui.traits.IBehaving;
 import prime.gui.traits.ILayoutable;
 import prime.gui.traits.IPropertyValidator;
 import prime.gui.traits.IStylable;


/**
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
interface IUIElement	
				implements IDisplayObject
			,	implements ILayoutable
			,	implements IBehaving
			,	implements IIdentifiable
			,	implements IDisposable
			,	implements IStylable
			,	implements IPropertyValidator
{
	public var state	(default, null)		: UIElementStates;
	
	/**
	 * Collection of effects that are defined for this UIElement. The 
	 * UIElementEffects object won't be created by an UIElement but has to be
	 * set the first time an effect is added to the UIElement.
	 */
	public var effects	(default, default)	: UIElementEffects;
	
	/**
	 * Reference to the window manager objects
	 */
	public var system	(get_system, never)	: ISystem;
	
	
	public function isDisposed ()			: Bool;
	public function isInitialized ()		: Bool;
	
	
	/**
	 * function to tell other objects if the element can be resized
	 */
	public function isResizable ()			: Bool;
	
	
	//
	// ATTACH METHODS
	//
	
	
	/**
	 * Method will attach the layout-client of this UIElement to the given 
	 * ILayoutContainer.
	 * @return own-instance
	 */
	public function attachLayoutTo	(target:ILayoutContainer, pos:Int = -1)	: IUIElement;
	/**
	 * Method will detach the layout-client of this UIElement from its 
	 * layoutcontainer.
	 * @return own-instance
	 */
	public function detachLayout	()										: IUIElement;
	/**
	 * Method will attach this UIElement to the given IUIContainer, including
	 * its layout.
	 * @return own-instance
	 */
	public function attachTo		(target:IUIContainer, pos:Int = -1)		: IUIElement;
	/**
	 * Method will detach this UIElement from its parent, including its layout. If there's
	 * removed-from-stage effect, it will play first.
	 * @return own-instance
	 */
	public function detach			()										: IUIElement;
	/**
	 * Method will call attachDisplayTo method and then play the added-to-stage effect if one 
	 * is defined.
	 */
	public function attachToDisplayList (t:IDisplayContainer, pos:Int = -1)	: IUIElement;
	
	public function changeLayoutDepth(newPos:Int)							: IUIElement;
	public function changeDepth		(newPos:Int)							: IUIElement;
	
	
	
	//
	// ACTIONS
	//
	
	public function move (newX:Int, newY:Int)		: Void;
	public function resize (newW:Int, newH:Int)		: Void;
	public function rotate (newV:Float)				: Void;
	public function scale (newX:Float, newY:Float)	: Void;
	public function show ()							: Void;
	public function hide ()							: Void;
}