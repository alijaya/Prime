package prime.js.events;
 import prime.signals.Signals;
 import prime.gui.events.UserEventTarget;


/**	
 * @author Stanislav Sopov
 * @author Ruben Weijers
 * @since  May 3, 2011
 */
class GestureEvents extends Signals
{
	private var eventDispatcher : UserEventTarget;
	
	public var start	(get_start,	null) : GestureSignal;
	public var change	(get_change,null) : GestureSignal;
	public var end		(get_end,	null) : GestureSignal;
	

	public function new(eventDispatcher:Dynamic)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}

	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}

	
	private inline function get_start 	() { if (start	== null) { createStart();	} return start; }
	private inline function get_change	() { if (change	== null) { createChange();	} return change; }
	private inline function get_end		() { if (end 	== null) { createEnd();		} return end; }
	
	private inline function createStart	() { start 	= new GestureSignal(eventDispatcher, "gesturestart"); }
	private inline function createChange() { change = new GestureSignal(eventDispatcher, "gesturechange"); }
	private inline function createEnd	() { end	= new GestureSignal(eventDispatcher, "gestureend"); }
}