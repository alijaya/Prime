

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
 import prime.gui.traits.IGraphicsValidator;
 import prime.gui.managers.ISystem;
  using prime.utils.TypeUtil;


/**
 * Manager obj to queue the rendering of all IRenderables until a render event
 * is fired.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class RenderManager extends QueueManager
{
	override private function validateQueue ()
	{
		if (first == null) // Nothing to validate.
			return;

		isValidating = true;
		
		if (owner.is(ISystem)) {
			Assert.isNull(owner.as(ISystem).invalidation.first, "InvalidationManager should validateQueue first!");
		}

		while (first != null)
		{
			var obj	= first.as(IGraphicsValidator);
			obj.validateGraphics();
			
			// if this object is still first, then it did not re-add itself for invalidation and holds the current
			// next, otherwise first value has already been updated to next validateable
			if ( obj == first )
			{
				first = obj.nextValidatable;
				if (first != null )
					first.prevValidatable = null;
				obj.nextValidatable = obj.prevValidatable = null;
			}
		}
		
		last = null;
		isValidating = false;
	}
	
#if debug
	override public function toString () { return "RenderManager"; }
#end
}