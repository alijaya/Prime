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
package prime.gui.styling;
 import prime.core.traits.IDisposable;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.FastArray;


/**
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
class StyleState implements IDisposable
{
	public var current		(default, setCurrent)	: Int;
	public var elementStyle	(default, null)			: UIElementStyle;
	
	
	public function new (elementStyle:UIElementStyle, current:Int = 0)
	{
		this.elementStyle	= elementStyle;
		this.current		= current;
		
	//	checkStateStyles.on ( styleSheet.change, this );
	}
	
	
	public function dispose ()
	{
	//	styleSheet.change.unbind( this );
		current			= StyleStateFlags.NONE;
		elementStyle	= null;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getStates ()
	{
		return elementStyle.states;
	}
	
	
	private function setCurrent (v:Int) : Int
	{
		if (v != current)
		{
		//	trace(elementStyle.target+".setCurrentState "+StyleStateFlags.stateToString( current )+" => "+StyleStateFlags.stateToString( v ));
			Assert.that( elementStyle != null );
			var changes = 0;
			if (current != 0) {
				changes = changes.set( removeStyles() );
				
				if (v == 0)
					elementStyle.currentStates.removeItem( this );
			}
			else
				elementStyle.currentStates.push( this );
			
			current = v;
			
			if (current != 0)
				changes = changes.set( setStyles() );
			
		//	trace(elementStyle.target+"setCurrentState "+v+"; all-states: "+elementStyle.readStates()+"; changedProperties "+elementStyle.readProperties(changes));
			elementStyle.broadcastChanges( changes );
		}
		return v;
	}
	
	
	//
	// METHODS
	//
	
	/**
	 * Method will look in all the available state-lists to find every 
	 * styledefinition for the requested state. If a style-definition is found,
	 * it will be added to the parent.
	 * 
	 * @return all the changes in the UIElementStyle that are caused by adding the styles
	 */
	public function setStyles () : Int
	{
		if (current == 0 || getStates().filledProperties.hasNone( current ))
			return 0;
		
		var changes		= 0;
		var iterator	= getStates().reversed();
		for (stateGroup in iterator)
			if (stateGroup.has( current ))
				changes = changes.set( elementStyle.addStyle( stateGroup.get( current ) ) );
		
		return changes;
	}
	
	
	/**
	 * Method will loop over every style of the current states and will remove
	 * them from the UIElementStyle object.
	 * 
	 * @return all the changes in the UIElementStyle that are caused by removing the styles
	 */
	public function removeStyles () : Int
	{
		if (current == 0 || getStates().filledProperties.hasNone( current ))
			return 0;
		
		var changes = 0;
		for (stateGroup in getStates())
			if (stateGroup.has( current )) {
				var style = stateGroup.get( current );
				var cell = elementStyle.styles.getCellForItem( style );
				
				if (cell != null)	// <-- sometimes multiple blocks have the same state style.. this means the state-style can already be removed in a previous loop round
					changes = changes.set( elementStyle.removeStyleCell( cell ) );
			}
		
		return changes;
	}
	

#if debug
	public function toString ()
	{
		return StyleStateFlags.stateToString( current );
	}
#end
}