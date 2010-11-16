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
package primevc.gui.graphics;
  using primevc.utils.BitUtil;


/**
 * Collection of all available flags.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class GraphicFlags
{
	public static inline var FILL		: Int = 1;
	public static inline var BORDER		: Int = 2;
	public static inline var SHAPE		: Int = 4;
	public static inline var LAYOUT		: Int = 8;
	public static inline var PROPERTIES	: Int = 16;
	
	
#if debug
	public static function readProperties (flags:UInt) : String
	{
		var output	= [];
		
		if (flags.has( FILL ))			output.push("fill");
		if (flags.has( BORDER ))		output.push("border");
		if (flags.has( SHAPE ))			output.push("shape");
		if (flags.has( LAYOUT ))		output.push("layout");
		if (flags.has( PROPERTIES ))	output.push("properties");
		
		return "properties: " + output.join(", ");
	}
#end
}