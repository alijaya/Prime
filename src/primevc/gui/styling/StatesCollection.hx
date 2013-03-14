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
package primevc.gui.styling;
 import primevc.core.dispatcher.Signal1;
 import primevc.gui.styling.StyleCollectionBase;
  using primevc.utils.BitUtil;

private typedef Flags = StyleStateFlags;


/**
 * @author Ruben Weijers
 * @creation-date Okt 20, 2010
 */
class StatesCollection extends StyleCollectionBase < StatesStyle >
{
	public var change				(default, null)	: Signal1 < Int >;
	
	
	public function new (elementStyle:UIElementStyle)
	{
		change = new Signal1();
		super( elementStyle, StyleFlags.STATES );
	}
	
	
	override public function forwardIterator ()					{ return new StatesCollectionForwardIterator( elementStyle, propertyTypeFlag); }
	override public function reversedIterator ()				{ return new StatesCollectionReversedIterator( elementStyle, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	override public function dispose ()
	{
		super.dispose();
		change.dispose();
		change = null;
	}
	
	
	/**
	 * when the states of any style changes, broadcast the change..
	 */
	override public function invalidateCall ( changeFromSender:Int, sender )
	{
		changes = changes.set(changeFromSender);
		apply();
	}
	
	
	override public function apply ()
	{
		if (changes > 0)
		{
			change.send(changes);
			changes = 0;
		}
	}
}


class StatesCollectionForwardIterator extends StyleCollectionForwardIterator < StatesStyle >
{
	override public function next ()	{ return setNext().data.states; }
}


class StatesCollectionReversedIterator extends StyleCollectionReversedIterator < StatesStyle >
{
	override public function next ()	{ return setNext().data.states; }
}
