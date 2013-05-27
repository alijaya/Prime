package prime.js.events;
 import prime.signals.Signals;


/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */
class TransitionEvents extends Signals
{
	private var eventDispatcher : Dynamic;
	public  var end 			(get_end, null) : TransitionSignal;

	
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

	
	private inline function get_end() { if (end == null) { createEnd(); } return end; }
	private inline function createEnd() { end = new TransitionSignal(eventDispatcher, "webkitTransitionEnd"); }
}