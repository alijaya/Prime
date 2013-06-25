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
package prime.types;

/**
 * Defines the min and max values of integers
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
extern class Number // FIXME: should be extern, but can't be because of FLOAT_NOT_SET
{
	//floats can actually be a lot bigger (64 bit) but this will work for now
	public static inline var FLOAT_MIN:Float		= -3.40282346638528e+38;
	public static inline var FLOAT_MAX:Float		=  3.40282346638528e+38;
	
	public static inline var INT_MIN:Int			= 0x80000000;
	public static inline var INT_MAX:Int			= 0x7fffffff;

#if (flash9 || js) //breaks CPP
	public static inline var UINT_MIN:UInt			=  0;
	public static inline var UINT_MAX:UInt			=  0xffffffff; //4294967295;		//<-- not working, since value is seen as Float
#end
	
	/**
	 * Value defining an undefined Int. Useful for AVM2 since there's no value like
	 * Math.NaN for integers..
	 */
	public static inline var INT_NOT_SET:Int		=  INT_MIN; //#if flash9 INT_MIN #else null #end;
	public static inline var FLOAT_NOT_SET:Float	=  0/0;
	
	/**
	 * Integer-value to indicate a value is set but doesn't have a value. 
	 * If for example the height is set to 'none' in the css, it wil become 
	 * NONE. This way the style-object won't look in other style-classes.
	 */
	public static inline var EMPTY:Int				= -2147483640;
}