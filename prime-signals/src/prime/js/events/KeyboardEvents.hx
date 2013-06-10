package prime.js.events;
#if js
 import prime.gui.events.KeyboardEvents;
 import prime.gui.events.UserEventTarget;


/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 * @author Ruben Weijers
 */
class KeyboardEvents extends KeyboardSignals
{
	private var eventDispatcher : UserEventTarget;
	

	public function new(eventDispatcher:UserEventTarget)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	

	//override private function createDown() down = new KeyboardSignal(eventDispatcher, "keydown");
	//override private function createUp()   up   = new KeyboardSignal(eventDispatcher, "keyup");
	//override private function createKeyPress()	{ keyPress	= new KeyboardSignal(eventDispatcher, "keypress"); }
	
	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}
}
#end
