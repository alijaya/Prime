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
 import prime.signals.Wire;
 

/**
 * SimpleStateMachine is another implementation of the FiniteStateMachine 
 * design-pattern but simpler. It doesn't use State objects to define the
 * state but just uses enum values to change the currentState.
 * 
 * Instead firing 3 signals when the state changes (exiting old state, changing
 * states) there will be only one event, the change event.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
//#if (flash9 || cpp) @:generic #end
class SimpleStateMachine<StateType> implements prime.core.traits.IDisposable
{
	public var current		(default, set_current)		: StateType;
	public var defaultState	(default, set_defaultState)	: StateType;
	
	/**
	 * Change event, dispatched when the state changes
	 * @param	1. new state
	 * @param	2. old state
	 */
	public var change		(default, null)			: Signal2<StateType, StateType>;
	
	
	public function new(defaultState:StateType, currentState:StateType = null)
	{
		this.change					= new Signal2();
		(untyped this).current		= currentState == null ? defaultState: currentState;
		(untyped this).defaultState	= defaultState;
	}
	
	
	public function dispose ()
	{
		(untyped this).defaultState	= null;
		(untyped this).current		= null;
		change.dispose();
		change = null;
	}
	
	
	private inline function set_defaultState (v:StateType)
	{
		defaultState = v;
		if (current == null)
			current = v;
		
		return v;
	}
	
	
	private /*inline*/ function set_current (v:StateType)
	{
		if (current != v) {
			var old	= current;
			current	= v;
			change.send( v, old );
		}
		return v;
	}
	
	
	public #if !noinline inline #end function is (state : StateType) : Bool
	{
		return current == state;
	}

	
	public function changeTo (toState:StateType) : Void -> Void
	{
		var self = this;
		return function () { self.set_current( toState ); };
	}
	
	
#if debug
	public inline function toString () return current;
#end
}



/**
 * @author 	Ruben Weijers
 * @creation-date Dec 16, 2011
 */
class StateMachineUtil
{
	public static function onceOnEntering<StateType>( fn:Void->Void, fsm:SimpleStateMachine<StateType>, searchedState:StateType, owner:Dynamic ):Wire<Dynamic>
	{
		if (fsm.current == searchedState) {
			fn();
			return null;
		}
		var w = fsm.change.bind( owner, null );
		var f = function (newState:StateType, oldState:StateType) {
			if (newState == searchedState) {
				w.dispose();
				fn();
			}
		}
		w.setArgsHandler(f);
		return w;
	}
	

	public static function onceOnExiting<StateType>( fn:Void->Void, fsm:SimpleStateMachine<StateType>, searchedState:StateType, owner:Dynamic ):Wire<Dynamic>
	{
		var w = fsm.change.bind( owner, null );
		var f = function (newState:StateType, oldState:StateType) {
			if (oldState == searchedState) {
				w.dispose();
				fn();
			}
		}
		w.setArgsHandler(f);
		return w;
	}


	public static function onEntering<StateType>( fn:Void->Void, fsm:SimpleStateMachine<StateType>, searchedState:StateType, owner:Dynamic ):Wire<Dynamic>
	{
		var f = function (newState:StateType, oldState:StateType) {
			if (newState == searchedState)
				fn();
		}
		if (fsm.current == searchedState)
			fn();
		return fsm.change.bind( owner, f );
	}
	

	public static function onExiting<StateType>( fn:Void->Void, fsm:SimpleStateMachine<StateType>, searchedState:StateType, owner:Dynamic ):Wire<Dynamic>
	{
		var f = function (newState:StateType, oldState:StateType) {
			if (oldState == searchedState)
				fn();
		}
		return fsm.change.bind( owner, f );
	}
}