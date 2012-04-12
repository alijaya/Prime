package prime.js.events;
 private typedef TouchSignal = prime.js.events.TouchSignal; // override import
 import prime.gui.events.TouchEvents;
 import prime.gui.events.UserEventTarget;

/**	
 * @creation-date mar 2, 2011
 * @author Stanislav Sopov
 * @author Ruben Weijers
 */
class TouchEvents extends TouchSignals
{
	private var eventDispatcher : UserEventTarget;
	
	
	public function new(eventDispatcher:UserEventTarget)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}

	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}
	
	
	override private function createStart ()		{ start		= new TouchSignal(eventDispatcher, "touchstart"); }
	override private function createEnd ()			{ end		= new TouchSignal(eventDispatcher, "touchend"); }
	override private function createMove ()			{ move		= new TouchSignal(eventDispatcher, "touchmove"); }
	override private function createCancel () 		{ cancel	= new TouchSignal(eventDispatcher, "touchcancel"); }


/*	var eventDispatcher:HtmlDom;
	
	public var orientationchange(getOrientationchange,	null):TouchSignal;
	public var touchstart		(getTouchstart, 		null):TouchSignal;
	public var touchmove		(getTouchmove,			null):TouchSignal;
	public var touchend			(getTouchend,			null):TouchSignal;
	public var touchcancel		(getTouchcancel,		null):TouchSignal;
	public var gesturestart		(getGesturestart,		null):TouchSignal;
	public var gesturechange	(getGesturechange,		null):TouchSignal;
	public var gestureend		(getGestureend,			null):TouchSignal;
	
	public var start	(getStart, 	null):TouchSignal;
	public var move		(getMove,	null):TouchSignal;
	public var end		(getEnd,	null):TouchSignal;
	public var cancel	(getCancel,	null):TouchSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getStart	() { if (start 	== null) { createStart();	} return start; }
	private inline function getMove		() { if (move 	== null) { createMove();	} return move; }
	private inline function getEnd		() { if (end 	== null) { createEnd();		} return end; }
	private inline function getCancel	() { if (cancel == null) { createCancel(); 	} return cancel; }
	
	private function createStart	() { start 	= new TouchSignal(eventDispatcher, "touchstart"); }
	private function createMove		() { move 	= new TouchSignal(eventDispatcher, "touchmove"); }
	private function createEnd		() { end 	= new TouchSignal(eventDispatcher, "touchend"); }
	private function createCancel	() { cancel = new TouchSignal(eventDispatcher, "touchcancel"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).start	!= null ) start.dispose();
		if ( (untyped this).move	!= null ) move.dispose();
		if ( (untyped this).end		!= null ) end.dispose();
		if ( (untyped this).cancel	!= null ) cancel.dispose();
		
		start =
		move =
		end =
		cancel =
		null;
	}*/
}