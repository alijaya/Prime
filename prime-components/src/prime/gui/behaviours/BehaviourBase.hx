/****
* 
****/

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
 

/**
 * Base class for a behaviour
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class BehaviourBase < TargetType > implements IBehaviour < TargetType >
{
	public var target			(default, setTarget)	: TargetType;
	public var initialized		(default, null)			: Bool;
	
	public function new( newTarget:TargetType )			{ initialized = false; target = newTarget; }
	public function dispose ()							{ target = null; }	// setting the target to null will trigger the reset method
	private function init()								{ Assert.abstractMethod(this+""); }
	private function reset()							{ Assert.abstractMethod(this+""); }
	
	
	public #if !noinline inline #end function initialize ()
	{
		if (!initialized)
		{
			init();
			initialized = true;
		}
	}
	
	
	private inline function setTarget (newTarget:TargetType) : TargetType
	{
		var isInit = initialized;
		if (target != null && isInit) {
			reset();
			initialized = false;
		}
		
		target = newTarget;
		
		if (target != null && isInit)
			init();
		
		return target;
	}
	
	
#if debug
	public function toString ()
	{
		var className = Type.getClassName( Type.getClass( this ) );
		return className.split(".").pop() + " ( "+target+" )";
	}
#end
}