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
  using prime.utils.BitUtil;
  using Type;


/**
 * Base class for (sub-)style declarations
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleBlockBase extends prime.core.traits.Invalidatable implements IStyleBlock
{
#if (debug || CSSParser)
	public var _oid					(default, null)		: Int;
#end
	
	/**
	 * Flag with properties that are set for this style-block.
	 */
	public var filledProperties		(default, null)		: Int;
	/**
	 * Combination of filledProperties and inheritedProperties
	 */
	public var allFilledProperties	(default, null)		: Int;
	/**
	 * Flag with the styleproperties that are inherited and not set in this
	 * style-block
	 */
	public var inheritedProperties	(default, null)		: Int;
	
	
	public function new (filled:Int = 0)
	{
		super();
#if (debug || CSSParser)
		_oid = prime.utils.ID.getNext();
#end
		filledProperties	= filled;
		inheritedProperties	= 0;
		allFilledProperties	= filled;
	}
	
	
	override public function dispose ()
	{
#if (debug || CSSParser)
		_oid				= -1;
#end
		filledProperties	= 0;
		inheritedProperties	= 0;
		allFilledProperties	= 0;
		super.dispose();
	}
	
	
	public function markProperty ( propFlag:Int, isSet:Bool ) : Void
	{
		if (isSet)	filledProperties = filledProperties.set( propFlag );
		else		filledProperties = filledProperties.unset( propFlag );
		
		//Now it's unknown if the property that is changed, is somewhere in
		//the list with super / extended styles, so the object must rebuild 
		//these flags.
		if (isSet)	allFilledProperties = allFilledProperties.set( propFlag );
		else		updateAllFilledPropertiesFlag();
		
	//	trace("markProperty "+readProperties(propFlag)+" = "+isSet);
#if !CSSParser
		invalidate( propFlag );
#end
	}
	
	
	public #if !noinline inline #end function has (propFlag:Int) : Bool		{ return allFilledProperties.has( propFlag ); }
	public #if !noinline inline #end function doesntHave (propFlag:Int) : Bool	{ return allFilledProperties.hasNone( propFlag ); }
	public #if !noinline inline #end function owns (propFlag:Int) : Bool		{ return filledProperties.has( propFlag ); }
	public #if !noinline inline #end function doesntOwn (propFlag:Int) : Bool	{ return filledProperties.hasNone( propFlag ); }
	public function isEmpty () : Bool						{ return filledProperties == 0; }
	
	
	public function updateAllFilledPropertiesFlag () : Void									{ Assert.abstractMethod(); }
	public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool) : Int	{ Assert.abstractMethod(); return 0; }
	
	
#if debug
	public function readProperties ( flags:Int = -1 )	: String	{ Assert.abstractMethod(); return null; }
	public #if !noinline inline #end function readAll () : String						{ return readProperties( allFilledProperties ); }
	#if !CSSParser
	public function toString ()
	{
		var name = this.getClass().getClassName();
		var dot	 = name.lastIndexOf(".");
		return name.substr(dot)+"( "+_oid + " ) -> " +readProperties();
	}
	#end
#end
	
#if (CSSParser || debug)
		public var cssName : String;
#end
#if CSSParser
	#if	debug
		public function toString ()						{ return cssName; }
	#else
		public function toString ()						{ return toCSS(); }
	#end
	
#end
#if (CSSParser || debug)
	public function toCSS (prefix:String = "") 								{ Assert.abstractMethod(); return ""; }
#end
#if CSSParser
	public function cleanUp ()												{ Assert.abstractMethod(); }
	public function toCode (code:prime.tools.generator.ICodeGenerator)	{ Assert.abstractMethod(); }
#end
}