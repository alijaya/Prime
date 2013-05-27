

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
package prime.gui.managers;
 import prime.gui.traits.IPropertyValidator;
 import prime.gui.traits.IValidatable;
  using prime.utils.TypeUtil;


/**
 * Manager object which can be called by every IInvalidating object. When an
 * IInvalidating object calls InvalidationManager.invalidate( obj ), the
 * manager will add the object to a queue of objects and starts listening for
 * the next ENTER_FRAME event (flash).
 * 
 * When an ENTER_FRAME event comes, the manager will loop through the queue of
 * invalid objects and call their 'validate' method.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class InvalidationManager extends QueueManager
{
	override private function validateQueue ()
	{
		if (first == null) // Nothing to validate.
			return;

		isValidating = true;
#if debug
		var i = 0;
		if (traceQueues)
			trace("\n\tbegin validating layout; first: "+first+"; last: "+last);
#end
		while (first != null)
		{
#if (debug && !embed_perceptor)	
			if (i++ > 20000) { trace("ERROR: INVALIDATION is stuck on "+first+" -> "+first.nextValidatable); first = null; break; } 
#elseif embed_perceptor
			// embedded perceptor easily surpasses the 200 limit
			var n:String = first + "";
			if ( n.indexOf( "Inspector" ) == -1 )
				if (i++ > 20000) 
				{
					trace("ERROR: INVALIDATION is stuck on " + first + " -> " + first.nextValidatable); 
					first = null; 
					break; 
				} 
#end

			var obj	= first.as(IPropertyValidator);
			obj.validate();

#if debug	if (traceQueues)	trace("\n\t\t"+i+". validate "+obj+"; next: "+obj.nextValidatable+"; first: "+first+"; isFirst? "+(obj == first)+"; isNext? "+(obj == obj.nextValidatable)); #end
			
			// During validation the queue can change (adding/removing items).
			// The 'first' property will be the correct value if the current 
			// validating object was removed from the queue during its own 
			// validation (that means its nextValidatable is already 'null').
			if (obj.nextValidatable != null)
				first = obj.nextValidatable;
			
			// Exit the loop if the current validating item is the last item 
			// and the nextValidatable is 'null' and the 'first' value isn't 
			// changed during validation.
			else if (obj == first)
			 	first = null;
			
			obj.nextValidatable = obj.prevValidatable = null;
		}
		
#if debug if (traceQueues)	trace("\n\tfinished validating layout; first: "+first+"; last: "+last+"; loops: "+i); #end
		
		last = null;
		isValidating = false;
	}
	
	
#if debug
	override public function toString () { return "InvalidationManager"; }
#end
}