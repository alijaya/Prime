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
package prime.layout.algorithms;
 import prime.layout.IAdvancedLayoutClient;
 import prime.layout.ILayoutContainer;
 import prime.layout.LayoutClient;
 import prime.signals.Signal0;
 import prime.types.Number;
 import prime.utils.NumberUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;
 

/**
 * Base class for algorithms
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutAlgorithmBase 
				implements prime.core.traits.IDisposable
#if CSSParser	implements prime.tools.generator.ICodeFormattable		#end
{
#if debug public static var created		: Int = 0; #end
#if debug public static var disposed	: Int = 0; #end
	public var algorithmChanged 		(default, null)				: Signal0;
	@borrowed public var group			(default, set_group)		: ILayoutContainer;
	
#if CSSParser
	public var _oid						(default, null)				: Int;
#end
	public var validatePrepared			(default, null)				: Bool;
	
	
	public function new()
	{
#if debug		created++; #end
#if CSSParser	_oid		= prime.utils.ID.getNext(); #end
		algorithmChanged	= new Signal0();
		validatePrepared	= false;
	}
	
	
	public function dispose ()
	{
#if debug	disposed++;							#end
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setGroupHeight (h:Int)
	{
		if (h <= 0)
			h = Number.INT_NOT_SET;
		
		if (group.is(IAdvancedLayoutClient))
			group.as(IAdvancedLayoutClient).measuredHeight = h;
		else
			group.height = h;
	}
	
	
	private inline function setGroupWidth (w:Int)
	{
		if (w <= 0)
			w = Number.INT_NOT_SET;
		
		if (group.is(IAdvancedLayoutClient))
			group.as(IAdvancedLayoutClient).measuredWidth = w;
		else
			group.width = w;
	}
	
	
	private function set_group (v)		{ return group = v; }
	public function prepareValidate ()	{ validatePrepared = true; }
	
	
	
	
	//
	// START VALUES
	//

	private inline function getTopStartValue ()		: Int
	{
		var top:Int = 0;
	//	if (group.margin != null)	top += group.margin.top;
		if (group.padding != null)	top += group.padding.top;
		return top;
	}
	
	
	private inline function getVerCenterStartValue ()	: Int
	{
		var start:Int = 0;
		
		if (group.is(AdvancedLayoutClient))
		{
			var group = group.as(AdvancedLayoutClient);
			if (group.explicitHeight.isSet() && group.measuredHeight.isSet())
				start = IntMath.max( group.explicitHeight - group.measuredHeight, 0 ).divCeil( 2 );
		}
		
		return start += getTopStartValue();
	}


	private inline function getBottomStartValue ()	: Int
	{
		var start = group.height;
		
		if (group.is(AdvancedLayoutClient))
			start = IntMath.max(group.as(AdvancedLayoutClient).measuredHeight, start);
		
		return start += getTopStartValue();
	}
	
	
	private inline function getLeftStartValue ()	: Int
	{
		var start:Int = 0;
	//	if (group.margin != null)	start += group.margin.left;
		if (group.padding != null)	start += group.padding.left;
		return start;
	}
	
	
	private inline function getHorCenterStartValue ()	: Int
	{
		var start:Int = 0;
		
		if (group.is(AdvancedLayoutClient))
		{
			var group = group.as(AdvancedLayoutClient);
			if (group.explicitWidth.isSet() && group.measuredWidth.isSet())
				start = IntMath.max( group.explicitWidth - group.measuredWidth, 0 ).divCeil( 2 );
		}
		
		return start += getLeftStartValue();
	}


	private inline function getRightStartValue ()	: Int
	{
		var start = group.width;
		
		if (group.is(AdvancedLayoutClient))
			start = IntMath.max(group.as(AdvancedLayoutClient).measuredWidth, start);
		
		return start += getLeftStartValue();
	}
	
	
	public function getDepthOfFirstVisibleChild ()	: Int
	{
		return 0;
	}
	
	public function getMaxVisibleChildren () : Int
	{
		return group.children.length;
	}
	
	
	public function scrollToDepth (depth:Int) { Assert.abstractMethod(); }
	
	
	
#if (CSSParser || debug)
	public function toString () : String				{ return toCSS(); }
	public function toCSS (prefix:String = "") : String	{ Assert.abstractMethod(); return ""; }
	public function isEmpty () : Bool					{ return false; }
#end
	
#if CSSParser
	public function cleanUp () : Void {}
	public function toCode (code:prime.tools.generator.ICodeGenerator) code.construct( this );
#end
}