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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package prime.fsm;
 import prime.signals.Signal2;
 import prime.utils.FastArray;


/**
 * @author Ruben Weijers
 * @creation-date Jun 08, 2010
 */
@:autoBuild(prime.utils.MacroUtils.autoInstantiate("IState", "prime.fsm.State", true))
@:autoBuild(prime.utils.MacroUtils.autoDispose())
class FiniteStateMachine implements IFiniteStateMachine
{
	@manual public var current		(default, set_current)		: IState;
	@manual public var defaultState	(default, set_defaultState)	: IState;
	
//	public var states		(default, null) : FastArray <IState>;
	public var change		(default, null)	: Signal2 < IState, IState >;
	public var enabled		(default, null)	: Bool;
	
	
	public function new ()
	{
	//	states	= FastArrayUtil.create();
		enabled	= true;
		change	= new Signal2();
	}
	
	
	public function dispose ()
	{
		(untyped this).defaultState	= null;
		(untyped this).current		= null;
		
	//	while(states.length > 0)
	//		states.pop().dispose();
		
		change.dispose();
		change = null;
	//	states = null;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	/**
	 * Setter will let the old state dispatch an exiting event and the new 
	 * state will dispatch an entering event.
	 * 
	 * The StateGroup itself will also dispatch an change event containing
	 * both the old and new state.
	 * 
	 * @private
	 */
	private function set_current (newState:IState) : IState
	{
		if (newState == null)
			newState = defaultState;
		
		if (!enabled)				return current;	//can't change states when we're not enabled
		if (current == newState)	return current;	//don't need to change since we're already in this state
	//	if (!has(newState))			return current;	//can't go to a state that isn't part of this FSM
		
		//dispathc exiting event
		if (current != null)
			current.exiting.send();
		
		//set new state and dispatch change event
		var old	= current;
		current	= newState;
		change.send( newState, old );
		
		//dispatch entering event
		if (current != null)
			current.entering.send();
		
		return current;
	}
	
	
	/**
	 * Setter for the defaultstate. When the currentstate is empty,
	 * it will be set to the default-state.
	 * @private
	 */
	private inline function set_defaultState (newState:IState) : IState
	{
		defaultState = newState;

		if (current == null)
			current = defaultState;
		
		return defaultState;
	}
	
	
	
	
	//
	// METHODS
	//
	
	public #if !noinline inline #end function is (otherState:IState)			{ return current == otherState; }
	
	/**
	 * Method checks of the given state exists in this FSM instance.
	 * FIXME: check if looking up if a state is a property of an FSM is more efficient with reflection
	 */
//	public #if !noinline inline #end function has (state:IState)				{ return state != null && states[ state.id ] == state; }
	
	public #if !noinline inline #end function enable ()						{ enabled = true; }
	/**
	 * Disabling the FSM means that the current state can't change until it's
	 * enabled again. Before the FSM is disabled, the currentState is changed to
	 * the default-state.
	 */
	public #if !noinline inline #end function disable ()						{ if (enabled) { current = defaultState; enabled = false; } }
	public #if !noinline inline #end function isEnabled ()						{ return enabled; }
	
	
	public #if !noinline inline #end function changeTo (toState:IState) : Void -> Void
	{
		return function () { this.set_current( toState ); };
	}
}