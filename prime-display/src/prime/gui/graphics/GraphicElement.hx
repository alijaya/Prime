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
package prime.gui.graphics;


/**
 * Base class for all graphic elements.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class GraphicElement extends prime.core.traits.Invalidatable implements IGraphicElement 
{
#if (CSSParser || debug)
	public var _oid (default, null)	: Int;
	
	
	public function new ()
	{
		super();
		_oid = prime.utils.ID.getNext();
	}
	
	
	override public function dispose ()
	{
		_oid = 0;
		super.dispose();
	}
#end

#if CSSParser	
	public function toCode (code:prime.tools.generator.ICodeGenerator) { Assert.abstractMethod(); }
#end


#if (CSSParser || debug)
	public function toString () : String				{ return toCSS(); }
	public function toCSS (prefix:String = "") : String	{ /*Assert.abstractMethod();*/ return Std.string(Type.getClass(this)); }
	public function isEmpty () : Bool					{ return false; }
	public function cleanUp () : Void					{}
#end

#if (neko && prime_css)
	public function toCode (code:prime.tools.generator.ICodeGenerator) { Assert.abstractMethod(); }
#end
}