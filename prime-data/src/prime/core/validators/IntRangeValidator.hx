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
package prime.core.validators;
 import prime.signals.Signal0;
 import prime.types.Number;
 import prime.utils.NumberUtil;
  using prime.utils.NumberUtil;
  using prime.utils.NumberUtil.IntUtil;


/**
 * This class can constraint the value of an int to the given min and max value.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class IntRangeValidator implements IValueValidator <Int>
{
	public var change (default, null)	: Signal0;
	
	public var min		(default, setMin)	: Int;
	public var max		(default, setMax)	: Int;
	public var scale	(default, null)		: Float;
	
	
	public function new( min:Int = Number.INT_NOT_SET, max:Int = Number.INT_NOT_SET )
	{
		scale		= 1;
		this.min	= min;
		this.max	= max;
		change		= new Signal0();
	}
	
	
	public #if !noinline inline #end function dispose ()
	{
		change.dispose();
		change = null;
	}
	
	
	public #if !noinline inline #end function getDiff ()
	{
		return min.isSet() && max.isSet() ? max - min : 0;
	}
	
	
	private inline function setMin (v)
	{
		if (v != min) {
			min = scale == 1 || v.notSet() ? v : (v * scale).roundFloat();
			broadcastChange();
		}
		return v;
	}
	
	
	private inline function setMax (v)
	{
		if (v != max) {
			max = scale == 1 || v.notSet() ? v : (v * scale).roundFloat();
			broadcastChange();
		}
		return v;
	}
	
	
	public function setValues (min:Int, max:Int) : Void
	{
		var changed = min != this.min || max != this.max;
		(untyped this).min = min;
		(untyped this).max = max;
		
		if (changed)
			broadcastChange();
	}
	
	
	private inline function broadcastChange ()
	{
		if (change != null && (min.isSet() || max.isSet()))
			change.send();
	}
	
	
	public function validate (v:Int) : Int
	{
	//	if (v.notSet())
	//		return v;
		
		if (min.isSet() && max.isSet())		v = v.within( min, max );
		else if (min.isSet())				v = v.getBiggest( min );
		else if (max.isSet())				v = v.getSmallest( max );
	//	trace("validate "+v+"; min/max: "+min+", "+max);
		return v;
	}
	
	
	public function rescale (newScale:Float) : Void
	{
		if (scale != newScale)
		{
			if (min.isSet())	(untyped this).min = (min / scale) * newScale;
			if (max.isSet())	(untyped this).max = (max / scale) * newScale;
			scale = newScale;
			broadcastChange();
		}
	}
	
	
#if debug
	public function toString ()
	{
		return "IntValidator ( " + min + ", " + max + " )";
	}
#end
}