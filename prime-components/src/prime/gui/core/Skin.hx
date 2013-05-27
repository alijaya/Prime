

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
 import prime.gui.behaviours.BehaviourList;
 import prime.gui.events.UserEventTarget;
 import prime.gui.states.UIElementStates;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


/**
 * Base Skin class.
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class Skin <OwnerClass:IUIComponent> implements ISkin
{
	public var owner			(default, set_owner) : OwnerClass;
//	public var skinState		(default, null)		: SkinStates;
	public var behaviours		(default, null)		: BehaviourList;
	
	
	public function new()
	{
		behaviours        = new BehaviourList();
	//	skinState         = new SkinStates();
	//	skinState.current = skinState.constructed;
	}
	
	
	public function dispose ()
	{
		if (isDisposed())
			return;
		
		owner		= null;	// <-- should trigger removeBehaviours and removeChildren
		behaviours	= null;
	//	skinState	= null;
	}
	
	
	public function changeOwner (newOwner:IUIComponent)
	{
		try {
			this.owner = cast newOwner;
		}
		catch (e:Dynamic) {}
	}
	
	
	/**
	 * Abstract method.
	 * Is called by the owner when an object wants to check if the owner has
	 * focus. The skin can check if the target is one of its children and then
	 * return true or false.
	 */
	public function isFocusOwner (target:UserEventTarget) : Bool
	{
		return false;
	}
	
	
	public #if !noinline inline #end function isDisposed ()
	{
		return behaviours == null;
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function set_owner (newOwner:OwnerClass)
	{
		if (owner != null)
		{
			if (owner.state != null)
				owner.state.initialized.entering.unbind(this);
			
			if (owner.isInitialized())
				disposeChildren();
			
			removeBehaviours();
	//		removeStates();
		}
		
		(untyped this).owner = newOwner;
		
		if (newOwner != null)
		{
	//		createStates();
			createBehaviours();
	//		drawGraphics();
			
			if (newOwner.isInitialized()) {
				createChildren();
				childrenCreated();
				behaviours.init();
			}
			else
				behaviours.init.onceOn( owner.state.initialized.entering, this );
			//	behaviours.init.onceOn( owner.displayEvents.addedToStage, this );
		}
		
		return newOwner;
	}
	
	
	
	
	//
	// METHODS
	//
	
	//TODO RUBEN - enable Assert.abstractMethod
//	private function createStates     ()    : Void {} //	{ Assert.abstractMethod(); }
	private function createBehaviours ()    : Void {} //	{ Assert.abstractMethod(); }
//	public  function drawGraphics     ()    : Void {} //	{ Assert.abstractMethod(); }
	public  function createChildren   ()    : Void {} //	{ Assert.abstractMethod(); }
	public  function childrenCreated  ()    : Void {}
	
//	private function removeStates     ()    : Void {} //	{ Assert.abstractMethod(); }
	public  function disposeChildren  ()    : Void {} //	{ Assert.abstractMethod(); }
	public  function validate (changes:Int) : Void {}
	
	private function removeBehaviours ()
	{
		behaviours.removeAll();
	//	behaviours = null;
	}
}