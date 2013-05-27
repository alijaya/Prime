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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.avm2.display;
 import flash.display.DisplayObject;
 import prime.core.geom.IntRectangle;
#if dragEnabled
 import prime.gui.behaviours.drag.DragInfo;
#end
 import prime.gui.display.DisplayDataCursor;
 import prime.gui.display.DisplayList;
 import prime.gui.display.IDisplayContainer;
 import prime.gui.display.IDisplayObject;
 import prime.gui.display.ISprite;
 import prime.gui.display.Window;
 import prime.gui.events.DisplayEvents;
 import prime.gui.events.UserEventTarget;
 import prime.gui.events.UserEvents;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;

 
/**
 * AVM2 sprite implementation
 * 
 * @author	Danny Wilson
 * @author	Ruben Weijers
 */
class Sprite extends flash.display.Sprite implements ISprite
{
	/**
	 * List with all the children of the sprite
	 */
	public var children			(default, null)			: DisplayList;
	
	public var window			(default, set_window)	: Window;
	public var container		(default, default)		: IDisplayContainer;
	
	public var userEvents		(default, null)			: UserEvents;
	public var displayEvents	(default, null)			: DisplayEvents;
	
	public var rect				(default, null)			: IntRectangle;
#if dragEnabled
	public var isDragging		: Bool;
#end
	
	
	
	public function new ()
	{
		super();
		children		= new DisplayList( this );
		userEvents		= new UserEvents( this );
		displayEvents	= new DisplayEvents( this );
		rect			= new IntRectangle( x.roundFloat(), y.roundFloat(), width.roundFloat(), height.roundFloat() );
	}
	
	
	public function dispose ()
	{
		if (userEvents.isNull())
			return;		// already disposed
		
		if (container.notNull())
			detachDisplay();
		
		window 			= null;
		children 	 .dispose();
		userEvents 	 .dispose();
		displayEvents.dispose();
		rect 		 .dispose();
		
		children		= null;
		userEvents		= null;
		displayEvents	= null;
		rect			= null;
	}
	
	
	public #if !noinline inline #end function isObjectOn (otherObj:IDisplayObject) : Bool
	{
		return otherObj.isNull() || otherObj.as(DisplayObject).hitTestObject( this.as(DisplayObject) );
	}
	
	
	public function isFocusOwner (target:UserEventTarget) : Bool
	{
		return target == this;
	}
	
	
	public #if !noinline inline #end function focussed ()		{ return window.notNull() && window.focus == this; }
	public #if !noinline inline #end function setFocus ()		{ if (window.notNull())		{ window.focus = this; } }
	public #if !noinline inline #end function removeFocus ()	{ if (focussed())			{ window.focus = null; } }
	
	
	
#if !CSSParser
	public function getDisplayCursor			() : DisplayDataCursor											{ return new DisplayDataCursor(this); }
	public #if !noinline inline #end function attachDisplayTo		(target:IDisplayContainer, pos:Int = -1)	: IDisplayObject	{ target.children.add( this, pos ); return this; }
	public #if !noinline inline #end function detachDisplay		()											: IDisplayObject	{ container.children.remove( this ); return this; }
	public #if !noinline inline #end function changeDisplayDepth	(newPos:Int)								: IDisplayObject	{ container.children.move( this, newPos ); return this; }
	
	
	#if dragEnabled
	public function createDragInfo () : DragInfo
	{
		return new DragInfo( this );
	}
	#end
#end
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/*private inline function setContainer (newV:IDisplayContainer)
	{
		if (container != newV)
		{
			var oldV	= container;
			container	= newV;
			
			if (container.notNull()) {
				//if the container property is set and the sprite is not yet in the container, add the sprite to the container
			//	if (!container.children.has(this))
			//		container.children.add(this);
				
				window = container.window;
			}
			
			//if the container prop is set to null, remove the sprite from its previous container and set the window prop to null.
			else if (oldV.notNull()) {
			//	if (oldV.children.has(this))
			//		oldV.children.remove(this);
				
				window = null;
			}
		}
		return newV;
	}*/
	
	
	private inline function set_window (v)
	{
		if (window != v)
		{
			window = v;
			
			Assert.isNotNull(children);
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (child.notNull())
					child.window = v;
			}
		}
		return v;
	}
}
