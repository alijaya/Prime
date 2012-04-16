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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components;
 import primevc.core.dispatcher.Wire;
 import primevc.core.RevertableBindable;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.events.MouseEvents;
 import primevc.types.Asset;
 import primevc.types.RGBA;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


//private typedef DataType = RevertableBindable<RGBA>;


/**
 * @author			Ruben Weijers
 * @creation-date	Feb 14, 2011
 */
class ColorPicker extends UIDataComponent<RevertableBindable<RGBA>>
{
	private var beginBinding	: Wire<Dynamic>;
	private var updateBinding	: Wire<Dynamic>;
	private var stopBinding		: Wire<Dynamic>;
	
	private var moveToColorWire	: Wire<Dynamic>;
	private var spectrum		: Asset;
	private var selection 		: UIGraphic;
	
	
	public function new (id:String = null, d:RevertableBindable<RGBA> = null)
	{
		if (d == null) {
			d = new RevertableBindable<RGBA>(0x00);
			d.dispatchAfterCommit();
			d.updateBeforeCommit();
			d.beginEdit();		//force the data to be always editable..
		}
		super(id, d);
		children.disable();
	}
	
	
	override public function dispose ()
	{
		if (moveToColorWire != null) {
			moveToColorWire.dispose();
			moveToColorWire = null;
		}

		if (isInitialized()) {
			beginBinding.dispose();
			updateBinding.dispose();
			stopBinding.dispose();
			spectrum.dispose();
			
			spectrum		= null;
			beginBinding	= updateBinding = stopBinding = null;
		}
		super.dispose();
	}
	
	
/*	override private function init ()
	{
		super.init();
#if debug
		Assert.notNull( graphicData.fill, "Make sure you set a bitmapfill with a colorspectrum as background" );
		Assert.that( graphicData.fill.is(BitmapFill), "Make sure you set a bitmapfill with a colorspectrum as background" );
#end
	}*/
	
	
	override private function init ()
	{
		super.init();
		beginBinding	= beginUpdating	.on( userEvents.mouse.down, this );
		updateBinding	= updateColor	.on( userEvents.mouse.move, this );
		stopBinding		= stopUpdating	.on( userEvents.mouse.up, this );
		
		beginBinding.enable();
		updateBinding.disable();
		stopBinding.disable();

		selection = new UIGraphic("selection");
		children.add(selection);

		Assert.notNull(data);
		moveToColorWire = moveToColor.on( data.change, this );
	//	moveToColor.onceOn( displayEvents.enterFrame, this );
	}
	
	
	private inline function getColorAt( x:Float, y:Float ) : RGBA 
	{
#if flash9
	//	var l = layout.innerBounds;
	//	var b = new BitmapDataType( l.width, l.height, false );
	//	b.draw(this);
	//	addChild( new flash.display.Bitmap(b));
	//	trace(l.width+", "+l.height+"; "+b.getPixel( x.roundFloat(), y.roundFloat() ).uintToString() );
	//	return b.getPixel( x.roundFloat(), y.roundFloat() ).rgbToRgba();
	//	trace( spectrum.data.)
		
		return getSpectrum().getPixel( x.roundFloat(), y.roundFloat() ).rgbToRgba();
#end
	}


	private inline function getSpectrum () {
		if (spectrum == null) {
		//	trace(layout.width+", "+layout.height);
			//not sure if this is the best way but using the original bitmapdata from the fill doesnt give correct results since it's unscaled.
		//	spectrum = Asset.createEmpty( layout.width, layout.height, false );
		//	spectrum.draw(this);
			spectrum = Asset.fromDisplayObject(this);
			spectrum.toBitmapData(null, false);
		}
		return spectrum.toBitmapData();
	}


	
	/**
	 * method wil find the new color-value in the spectrum and move the selection-circle around
	 */
	public function moveToColor ()
	{
		if (!isInitialized() || width == 0 || height == 0) {
			moveToColor.onceOn( displayEvents.enterFrame, this );
			return;
		}
		
		var b = getSpectrum();
		var w = b.width;
		var h = b.height;
		var newX = 0, newY = 0;

		var color = data.value.rgb();
		var found = false;
		
		for (newY in 0...h) {
			for (newX in 0...w)
				if (b.getPixel(newX,newY) == color) {
				//	trace(color.rgbToString() + "==> "+newX+", "+newY);
					found = true;
					selection.move(newX, newY);
					break;
				}
			
			if (found)
				break;
		}
		
		Assert.that(found, color.rgbToString() + " isn't in the spectrum :-O");
	}
	
	
	
	//
	// EVENTHANDLERS FOR UPDATING SELECTED COLOR
	//
	
	
	private function beginUpdating (mouse:MouseState) : Void
	{
		setFocus();
		moveToColorWire.disable();
		beginBinding.disable();
		updateBinding.enable();
		stopBinding.enable();
		
		updateColor( mouse );
	}
	
	
	private function updateColor (mouse:MouseState) : Void
	{
		var padding = layout.padding;
		var mouseX  = mouse.local.x.within( padding.left, padding.left + width - padding.right ).roundFloat();
		var mouseY  = mouse.local.y.within( padding.top, padding.top + height - padding.bottom ).roundFloat();
		//get color underneath mouse
		data.value = data.value.setRgb( getColorAt( mouseX, mouseY ) );
		selection.move( mouseX, mouseY );
	}
	
	
	private function stopUpdating (mouse:MouseState) : Void 
	{
		beginBinding.enable();
		updateBinding.disable();
		stopBinding.disable();
		
		data.commitEdit();
		moveToColorWire.enable();
		data.beginEdit();
	//	setFocus();
	}


	public inline function isPicking ()
		return updateBinding != null && updateBinding.isEnabled()
}