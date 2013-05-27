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
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.avm2.display;
 import flash.display.DisplayObjectContainer;
 import prime.gui.display.IDisplayContainer;
 import prime.gui.display.IDisplayObject;
 import prime.gui.display.DisplayList;
 import prime.gui.display.DisplayDataCursor;
 import prime.gui.display.DisplayObject;
 import prime.gui.events.DisplayEvents;
 import prime.gui.display.Window;
 import prime.core.geom.IntRectangle;
 import prime.gui.events.UserEvents;
 import prime.gui.events.UserEventTarget;
   using prime.utils.TypeUtil;


/**
 * IDisplayContainer implementation for flash.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 22, 2010
 */
class DisplayContainer extends DisplayObjectContainer, implements IDisplayContainer, implements IDisplayObject
{
	public var children			(default, null)				: DisplayList;
	public var displayEvents	(default, null)				: DisplayEvents;
	public var container		(default, default)			: IDisplayContainer;
	public var window			(default, setWindow)		: Window;
	public var rect				(default, null)				: IntRectangle;
	
	private function setWindow(w:Window):Window { window = w; return window; }

	public function new ()
	{
		super();
		children = new DisplayList( this );
	}
	
	public function dispose() : Void { Assert.abstractMethod(); }
	
#if !CSSParser
	public #if !noinline inline #end function isObjectOn 		(otherObj:IDisplayObject) 				: Bool 				{ return otherObj == null ? false : otherObj.as(DisplayObject).hitTestObject( this.as(DisplayObject) ); }
	public #if !noinline inline #end function getDisplayCursor	() 										: DisplayDataCursor	{ return new DisplayDataCursor(this); }
	public #if !noinline inline #end function attachDisplayTo	(target:IDisplayContainer, pos:Int = -1): IDisplayObject	{ target.children.add( this, pos ); return this; }
	public #if !noinline inline #end function detachDisplay		()										: IDisplayObject	{ container.children.remove( this ); return this; }
	public #if !noinline inline #end function changeDisplayDepth(newPos:Int)							: IDisplayObject	{ container.children.move( this, newPos ); return this; }
#end

	// IInteractive interface
	public var userEvents		(default, null)				: UserEvents;
	public function setFocus ()		: Void { Assert.abstractMethod(); }
	public function removeFocus ()	: Void { Assert.abstractMethod(); }
	public function isFocusOwner ( target: UserEventTarget ) : Bool { Assert.abstractMethod(); return false; }
}