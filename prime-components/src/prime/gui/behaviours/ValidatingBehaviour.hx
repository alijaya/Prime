

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
package prime.gui.behaviours;
 import prime.gui.managers.QueueManager;
 import prime.gui.traits.IValidatable;



/**
 * @author Ruben Weijers
 * @creation-date Nov 09, 2010
 */
class ValidatingBehaviour < TargetType:prime.gui.traits.IDisplayable > extends BehaviourBase < TargetType > implements IValidatable
{
	@borrowed public var prevValidatable : IValidatable;
	@borrowed public var nextValidatable : IValidatable;

	@manual override public function dispose()
	{
		removeFromQueue(); // unchain ourselves from the validation queue first
		super.dispose();
	}

	private function getValidationManager () : QueueManager
	{
		Assert.abstractMethod();
		return null;
	}
	
	
	override private function reset ()
	{
		removeFromQueue();
	}
	
	
	private inline function removeFromQueue ()
	{
		if (isOnStage())
			getValidationManager().remove( this );
	/*	else		// <-- this can corrupt the first or last value of the queue
		{
			if (prevValidatable != null)	prevValidatable.nextValidatable = nextValidatable;
			if (nextValidatable != null)	nextValidatable.prevValidatable = prevValidatable;
			
			prevValidatable = nextValidatable = null;
		}*/
	}
	
	
	public #if !noinline inline #end function isOnStage ()	{ return target.window != null; }
//	public #if !noinline inline #end function isQueued ()	{ return (nextValidatable != null && nextValidatable.isOnStage()) || (prevValidatable != null && prevValidatable.isOnStage()); }
	public #if !noinline inline #end function isQueued ()	{ return nextValidatable != null || prevValidatable != null; }
}