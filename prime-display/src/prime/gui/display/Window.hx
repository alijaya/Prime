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
package prime.gui.display;
 import prime.signals.Signal0;
 import prime.core.geom.IntRectangle;
 import prime.core.traits.IDisablable;
#if flash9
 import flash.display.InteractiveObject;
 import flash.events.Event;
 import prime.avm2.events.FlashSignal0;
 import prime.core.geom.Point;
 import prime.gui.events.UserEventTarget;
#end
#if !CSSParser
 import prime.gui.display.IInteractiveObject;
 import prime.gui.events.DisplayEvents;
 import prime.gui.events.UserEvents;
 import prime.gui.input.Mouse;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;
#end


/**
 * Window is wrapper class for the stage. It provides each Sprite and Shape 
 * with the ability to talk with the stage in a platform-indepedent way.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
#if !CSSParser
class Window implements IDisplayContainer implements IDisablable
{
	public static #if !noinline inline #end function startup<WindowInstance>(windowClassFactory : Stage -> WindowInstance) : WindowInstance
	{
		var stage:Stage = null;
#if flash9
		stage = flash.Lib.current.stage;
		stage.scaleMode	= flash.display.StageScaleMode.NO_SCALE;
	
	#if (debug && FlashTrace)
		haxe.Log.trace	= prime.utils.DebugTrace.trace;
	
	#elseif (debug && Monster2Trace)
		var monster		= new nl.demonsters.debugger.MonsterDebugger(flash.Lib.current);
		haxe.Log.trace	= prime.utils.DebugTrace.trace;
		haxe.Log.clear	= nl.demonsters.debugger.MonsterDebugger.clearTraces;
	
	#elseif (debug && Monster3Trace)
		com.demonsters.debugger.MonsterDebugger.initialize( flash.Lib.current );
		haxe.Log.trace	= prime.utils.DebugTrace.trace;
		haxe.Log.clear	= com.demonsters.debugger.MonsterDebugger.clear;
	
	#elseif (debug && AlconTrace)
		haxe.Log.trace	= prime.utils.DebugTrace.trace;
		haxe.Log.clear	= com.hexagonstar.util.debug.Debug.clear;
		com.hexagonstar.util.debug.Debug.monitor( stage );
	#elseif (debug && CC)
		haxe.Log.trace	= prime.utils.DebugTrace.trace;
		//haxe.Log.clear	= com.junkbyte.console.Cc.clear
		com.junkbyte.console.Cc.startOnStage(stage);
	
	#end
#end
#if debug
		haxe.Log.clear();
		haxe.Log.setColor(0xc00000);
		trace("started");
#end
		var inst = windowClassFactory(stage);
	#if profiling
		stage.addChild( new net.jpauclair.FlashPreloadProfiler() );
	#end
		return inst;
	//	return Type.createInstance( windowClass, [ stage ] );
	}
	
	
	//
	// IDISPLAYCONTAINER PROPERTIES
	//
	
	/**
	 * Target is the original, platform-specific, root object. Although this
	 * property is set as public, it's not recommended to use this property
	 * directly!
	 */
	public var target			(default, null)			: Stage;
	public var children			(default, null)			: DisplayList;
	
	//
	// IDISPLAYABLE PROPERTIES
	//
	
	public var window			(default, set_window)	: Window;
	public var container		(default, default)		: IDisplayContainer;
	public var rect				(default, null)			: IntRectangle;
	public var displayEvents	(default, null)			: DisplayEvents;
	
	public var userEvents		(default, null)			: UserEvents;
	public var mouse			(default, null)			: Mouse;
	
	
	/**
	 * Event dispatched when the window loses focus
	 */
	public var deactivated		(default, null)			: Signal0;
	/**
	 * Event dispatched when the window gets focus
	 */
	public var activated		(default, null)			: Signal0;
	
#if flash9
	public var focus			(get_focus, set_focus)	: IInteractiveObject;
#end
	
	
	public function new (target:Stage)
	{
		this.target		= target;
		window			= this;
		container		= this;
		
		rect			= new IntRectangle();
		children		= new DisplayList( target, this );
		displayEvents	= new DisplayEvents( target );
		userEvents		= new UserEvents( target /*, true*/ );
		mouse			= new Mouse( this );
		
		target.doubleClickEnabled = true;
#if flash9 /*&& debug)*/
		deactivated	= new FlashSignal0( target, Event.DEACTIVATE );
		activated	= new FlashSignal0( target, Event.ACTIVATE );
		disable	.on( deactivated, this );
		enable	.on( activated, this );
#end
	}
	
	
	public function dispose ()
	{
		if (displayEvents == null)
			return;
		
		children.dispose();
		displayEvents.dispose();
		userEvents.dispose();
		
		children		= null;
		displayEvents	= null;
		userEvents		= null;
	}
	
	
	public function invalidate ()
	{
		target.invalidate();
	//	target.focus = target;
	}
	
	
	
	//
	// IINTERACTIVE OBJECT PROPERTIES
	//
	
	public var mouseEnabled			: Bool;
#if flash9	
	public var doubleClickEnabled	: Bool;
	public var tabEnabled			: Bool;
	public var tabIndex				: Int;
	
	
	public #if !noinline inline #end function globalToLocal (point:Point) : Point		{ return target.globalToLocal(point); }
	public #if !noinline inline #end function localToGlobal (point:Point) : Point		{ return target.localToGlobal(point); }
	
	public function isFocusOwner (target:UserEventTarget)			{ return target == this.target; }
	
	public function enable ()										{ mouseEnabled = tabEnabled = children.mouseEnabled = children.tabEnabled = true; }		//use local mouseEnabled and tabEnabled since Stage doesn't have these properties
	public function disable ()										{ mouseEnabled = tabEnabled = children.mouseEnabled = children.tabEnabled = false; }	//use local mouseEnabled and tabEnabled since Stage doesn't have these properties
	public #if !noinline inline #end function isEnabled ()								{ return mouseEnabled; }
	
	private inline function set_focus (child:IInteractiveObject)	{ target.focus = child.as(InteractiveObject); return child; }
	private inline function get_focus ()	: IInteractiveObject	{ return target.focus.as(IInteractiveObject); }

//	@:getter(scrollRect)
	// FIXME => won't be called since scrollRect can't be defined as (getScrollRect, setScrollRect)
//	private function getScrollRect ()								{ return target.scrollRect; }
//	@:setter(scrollRect)
//	private function setScrollRect (v:Rectangle)					{ return target.scrollRect = v; }
#end
	
	/**
	 * Method will give the acti focus to the stage.
	 * FIXME better naming -> looks alot like set_focus (the setter)
	 */
	public #if !noinline inline #end function setFocus ()		{ target.focus = target; }
	public #if !noinline inline #end function removeFocus ()	{ if (target.focus == target) { target.focus = null; } }
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	
	private inline function set_window (v)		{ return window = this; }
//	private inline function setContainer (v)	{ return container = this; }
}

#else
class Window implements IDisplayContainer
{
	public function new () {}
}
#end