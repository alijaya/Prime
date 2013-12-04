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
 *  EzeQL
 */

package prime.gui.graphics.shapes;
 import prime.core.geom.Corners;
 import prime.core.geom.IRectangle;
 import prime.gui.traits.IGraphicsOwner;
 import prime.utils.Formulas;
  using prime.gui.utils.GraphicsUtil;
  using prime.utils.Formulas;



/**
 * @author Ezequiel Moreno
 * @creation-date Nov 29, 2013
 */
class Saltire extends Line
{
	override public function draw (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners) : Void
	{
        super.draw(target, bounds, borderRadius);
#if (flash9 || nme)
        target.graphics.moveTo( bounds.right, bounds.top );
		target.graphics.lineTo( bounds.left, bounds.bottom );
#end
	}
	
	
#if (CSSParser || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "saltire";
	}
#end

}