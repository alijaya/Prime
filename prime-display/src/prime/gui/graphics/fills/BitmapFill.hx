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
package prime.gui.graphics.fills;
 import prime.core.geom.IRectangle;
 import prime.core.geom.Matrix2D;
 import prime.gui.display.BitmapData;
 import prime.gui.graphics.GraphicElement;
 import prime.gui.graphics.GraphicFlags;
 import prime.gui.graphics.IGraphicProperty;
 import prime.gui.traits.IGraphicsOwner;
 import prime.types.Asset;
 import prime.types.Factory;
  using prime.utils.Bind;


/**
 * Bitmap fill
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class BitmapFill extends prime.gui.graphics.GraphicElement implements prime.gui.graphics.IGraphicProperty 
{
	public var asset		(default, set_asset)		: Asset;
	public var assetFactory	(default, set_assetFactory)	: Factory<Dynamic>;
	public var matrix		(default, set_matrix)		: Matrix2D;
	public var smooth		(default, set_smooth)		: Bool;
	public var repeat		(default, set_repeat)		: Bool;
	public var isFinished	(default, null)				: Bool;
	public var data			(default, null)				: BitmapData;
	
	
	public function new (assetFactory:Factory<Dynamic>, asset:Asset = null, matrix:Matrix2D = null, repeat:Bool = true, smooth:Bool = false)
	{
		super();
		this.assetFactory	= assetFactory;
		this.asset			= asset;
		this.matrix			= matrix; //matrix == null ? new Matrix2D() : matrix;
		this.repeat			= repeat;
		this.smooth			= smooth;
		isFinished			= false;
	}
	
	
	override public function dispose ()
	{
		if (asset != null) {
			asset.dispose();
		//	untyped asset = null;
		}
		if (matrix != null)
			untyped matrix = null;
		
#if (flash9 || nme)
		data = null;
#end
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERES
	//
	
	private inline function set_asset (v)
	{
		if (v != asset)
		{
#if (flash9 || nme)
			if (asset != null)
				asset.state.change.unbind(this);
			
			asset = v;
			
			if (v != null)
			{
				handleAssetStateChange.on( v.state.change, this );
				smooth = v.type != AssetType.bitmapData;
				if (v.isReady())	data = v.toBitmapData();
	//			else				v.load();
			}
			else
				data = null;
#else
			asset = v;
#end
		}
		return v;
	}
	
	
	private inline function set_assetFactory (v)
	{
		if (v != assetFactory)
		{
			if (assetFactory != null)
				asset = null;
			
			assetFactory = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function set_matrix (v:Matrix2D)
	{
		if (v != matrix) {
			matrix = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function set_smooth (v:Bool)
	{
		if (v != smooth) {
			smooth = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function set_repeat (v:Bool)
	{
		if (v != repeat) {
			repeat = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
#if (flash9 || nme)
	private inline function setData (v:BitmapData)
	{
		if (v != data)
		{
			data = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
#end
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private inline function handleAssetStateChange (newState:AssetStates, oldState:AssetStates)
	{
		switch (newState) {
			case AssetStates.ready:
#if (flash9 || nme)		data = asset.toBitmapData(); #end
			
			case AssetStates.empty:
#if (flash9 || nme)		data = null; #end
			default:
		}
	}
	
	
	
	//
	// IFILL METHODS
	//
	
	public /*inline*/ function begin (target:IGraphicsOwner, bounds:IRectangle)
	{	
#if (flash9 || nme)
		isFinished = true;
		if (assetFactory == null && asset == null)
			return;
		
		if (asset == null)
			asset = Asset.fromFactory( assetFactory );
		
		if (asset.isLoadable())
			asset.load();
		
		if (!asset.isReady())
			return;
		
		var m:Matrix2D = null;
		
		if (repeat == false) {
			m = matrix == null ? new Matrix2D() : matrix;
			m.scale( bounds.width / data.width, bounds.height / data.height );
		}
		
		if (asset.isReady())
			target.graphics.beginBitmapFill( data, m, repeat, smooth );
		
#end
	}
	
	
	public #if !noinline inline #end function end (target:IGraphicsOwner, bounds:IRectangle)
	{	
		isFinished = false;
#if (flash9 || nme)
		if (asset != null && asset.isReady())
			target.graphics.endFill();
#end
	}
	
	
#if CSSParser
	override public function toString ()										{ return "BitmapFill( " + asset + ", " + smooth + ", " + repeat + " )"; }
	override public function toCSS (prefix:String = "")							{ return asset + " " + repeat; }
	override public function toCode (code:prime.tools.generator.ICodeGenerator)	{ code.construct( this, [ assetFactory, asset, matrix, repeat, smooth ] ); }
#end
}