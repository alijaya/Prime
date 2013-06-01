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
package prime.layout.algorithms.tile;
 import prime.core.geom.space.Direction;
 import prime.core.geom.space.Horizontal;
 import prime.core.geom.space.Vertical;
 import prime.layout.algorithms.floating.HorizontalFloatAlgorithm;
 import prime.layout.algorithms.floating.VerticalFloatAlgorithm;
 import prime.layout.algorithms.DynamicLayoutAlgorithm;
 import prime.layout.LayoutFlags;
 

/**
 * Base class for tile algorithms
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class TileAlgorithmBase extends DynamicLayoutAlgorithm implements ITileAlgorithm
{
	/**
	 * Defines in which direction the layout will start calculating.
	 * @default		Direction.horizontal
	 */
	public var startDirection			(default, set_startDirection)	: Direction;
	
	
	public function new( ?startDir:Direction, ?horDirection:Horizontal, ?verDirection:Vertical ) 
	{
		super();
		horAlgorithm = new HorizontalFloatAlgorithm( horDirection );
		verAlgorithm = new VerticalFloatAlgorithm( verDirection );
		
		horizontalDirection	= horAlgorithm.direction;
		verticalDirection	= verAlgorithm.direction;
		startDirection		= startDir == null ? Direction.horizontal : startDir;
	}
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private function set_startDirection (v) {
		if (v != startDirection) {
			startDirection = v;
			invalidate( false );
		}
		return v;
	}
	
	
#if CSSParser
	override public function toCode (code:prime.tools.generator.ICodeGenerator)
	{
		code.construct( this, [ startDirection, horizontalDirection, verticalDirection ] );
	}
#end
}