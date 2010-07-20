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
package primevc.gui.layout;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.core.Number;


/**
 * The relative layout class describes the wanted settings of a layout client
 * in relation with the layout-parent.
 * 
 * In a relative layout it's possible to set the prop 
 * 		horizontalCenter = 0
 * to make sure the layout is always centered in relation with it's layout
 * parent.
 * 
 * The parent can choose to apply or ignore the relative properties depending 
 * on the layout-algorithm that is uses. When the algorithm is positionating 
 * every layout-child next to eachother, the horizontalCenter will be ignored
 * for example.
 * 
 * This class is not meant for standalone use but should always be placed in
 * the LayoutClient.relative property.
 * 
 * @see		primevc.gui.layout.LayoutClient
 * 
 * @creation-date	Jun 22, 2010
 * @author			Ruben Weijers
 */
class RelativeLayout implements IDisposable
{
	/**
	 * Flag indicating if the relative-properties are enabled or disabled.
	 * When the value is false, it will still be possible to change the
	 * values but there won't be fired a change signal to let the layout-
	 * client now that it's changed.
	 * 
	 * @default	true
	 */
	public var enabled				: Bool;
	
	/**
	 * Signal to notify listeners that a property of the relative layout is 
	 * changed.
	 */
	public var changed				(default, null) : Signal0;
	
	
	//
	// CENTERING PROPERTIES
	//
	
	/**
	 * Defines at what horizontal-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.hCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px right from the 
	 * center of the parent.
	 * 
	 * @default		Number.NOT_SET
	 */
	public var hCenter		(default, setHCenter)	: Int;
	
	/**
	 * Defines at what vertical-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.vCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px below the 
	 * center of the parent.
	 * 
	 * @default		Number.NOT_SET
	 */
	public var vCenter		(default, setVCenter)	: Int;
	
	
	
	
	//
	// BOX PROPERTIES
	//
	
	/**
	 * Property defines the relative left position in relation with the parent.
	 * @example		
	 * 		client.relative.left = 10;	//left side of client will be 10px from the left side of the parent
	 * @default		Number.NOT_SET
	 */
	public var left					(default, setLeft)				: Int;
	/**
	 * Property defines the relative right position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var right				(default, setRight)				: Int;
	/**
	 * Property defines the relative top position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var top					(default, setTop)				: Int;
	/**
	 * Property defines the relative bottom position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var bottom				(default, setBottom)			: Int;
	
	
	public function new ( top:Int = -100000, right:Int = -100000, bottom:Int = -100000, left:Int = -100000 )
	{
		this.changed	= new Signal0();
		this.hCenter	= Number.NOT_SET;
		this.vCenter	= Number.NOT_SET;
		this.top		= (top == -100000)		? Number.NOT_SET : top;
		this.right		= (right == -100000)	? Number.NOT_SET : right;
		this.bottom		= (bottom == -100000)	? Number.NOT_SET : bottom;
		this.left		= (left == -100000)		? Number.NOT_SET : left;
	}
	
	
	public function dispose ()
	{
		changed.dispose();
		changed = null;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setHCenter (v) {
		//unset left and right
		if (v != Number.NOT_SET)
			left = right = Number.NOT_SET;
		
		if (v != hCenter) {
			hCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private function setVCenter (v) {
		//unset top and bottom
		if (v != Number.NOT_SET)
			top = bottom = Number.NOT_SET;
		
		if (v != vCenter) {
			vCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	
	
	private inline function setLeft (v) {
		if (v != Number.NOT_SET)
			hCenter = Number.NOT_SET;
		
		if (v != left) {
			left = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setRight (v) {
		if (v != Number.NOT_SET)
			hCenter = Number.NOT_SET;
		
		if (v != right) {
			right = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setTop (v) {
		if (v != Number.NOT_SET)
			vCenter = Number.NOT_SET;
		
		if (v != top) {
			top = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setBottom (v) {
		if (v != Number.NOT_SET)
			vCenter = Number.NOT_SET;
		
		if (v != bottom) {
			bottom = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	
#if debug
	public function toString () {
		return "RelativeLayout - t: "+top+"; r: "+right+"; b: "+bottom+"; l: "+left+"; hCenter: "+hCenter+"; vCenter: "+vCenter;
	}
#end
}