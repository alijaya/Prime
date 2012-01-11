package primevc.js.events;

import primevc.core.dispatcher.Signals;
import Html5Dom;

/**	
 * @since  march 2, 2011
 * @author Stanislav Sopov
 */

class TouchEvents extends Signals
{
	var eventDispatcher:HTMLElement;
	
	public var orientationchange(getOrientationchange,	null):TouchSignal;
	public var touchstart		(getTouchstart, 		null):TouchSignal;
	public var touchmove		(getTouchmove,			null):TouchSignal;
	public var touchend			(getTouchend,			null):TouchSignal;
	public var touchcancel		(getTouchcancel,		null):TouchSignal;
	public var gesturestart		(getGesturestart,		null):TouchSignal;
	public var gesturechange	(getGesturechange,		null):TouchSignal;
	public var gestureend		(getGestureend,			null):TouchSignal;
	
	
	public function new(eventDispatcher:HTMLElement)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	
	private inline function getOrientationchange()	{ if (orientationchange == null) { createOrientationchange(); } return orientationchange; }
	private inline function getTouchstart()			{ if (touchstart 		== null) { createTouchstart(); }		return touchstart; }
	private inline function getTouchmove()			{ if (touchmove 		== null) { createTouchmove(); }			return touchmove; }
	private inline function getTouchend()			{ if (touchend 			== null) { createTouchend(); }			return touchend; }
	private inline function getTouchcancel()		{ if (touchcancel 		== null) { createTouchcancel(); }		return touchcancel; }
	private inline function getGesturestart()		{ if (gesturestart 		== null) { createGesturestart(); }		return gesturestart; }
	private inline function getGesturechange()		{ if (gesturechange 	== null) { createGesturechange(); }		return gesturechange; }
	private inline function getGestureend()			{ if (gestureend 		== null) { createGestureend(); }		return gestureend; }
	
	
	private function createOrientationchange() { orientationchange 	= new TouchSignal(eventDispatcher, "orientationchange"); }
	private function createTouchstart		() { touchstart 		= new TouchSignal(eventDispatcher, "touchstart"); }
	private function createTouchmove		() { touchmove 			= new TouchSignal(eventDispatcher, "touchmove"); }
	private function createTouchend			() { touchend 			= new TouchSignal(eventDispatcher, "touchend"); }
	private function createTouchcancel		() { touchcancel 		= new TouchSignal(eventDispatcher, "touchcancel"); }
	private function createGesturestart		() { gesturestart 		= new TouchSignal(eventDispatcher, "gesturestart"); }
	private function createGesturechange	() { gesturechange 		= new TouchSignal(eventDispatcher, "gesturechange"); }
	private function createGestureend		() { gestureend			= new TouchSignal(eventDispatcher, "gestureend"); }
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).orientationchange	!= null ) orientationchange.dispose();
		if ( (untyped this).touchstart			!= null ) touchstart.dispose();
		if ( (untyped this).touchmove			!= null ) touchmove.dispose();
		if ( (untyped this).touchend			!= null ) touchend.dispose();
		if ( (untyped this).touchcancel			!= null ) touchcancel.dispose();
		if ( (untyped this).gesturestart		!= null ) gesturestart.dispose();
		if ( (untyped this).gesturechange		!= null ) gesturechange.dispose();
		if ( (untyped this).gestureend			!= null ) gestureend.dispose();
		
		orientationchange =
		touchstart =
		touchmove =
		touchend =
		touchcancel =
		gesturestart =
		gesturechange =
		gestureend =
		null;
	}
}
