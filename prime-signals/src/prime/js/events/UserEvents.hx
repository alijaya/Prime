package prime.js.events;
#if js
 import prime.gui.events.UserEventTarget;
 import prime.gui.events.UserEvents.UserSignals;


/**	
 * @since  march 2, 2011
 * @author Stanislav Sopov
 */
class UserEvents extends UserSignals
{
	private var eventDispatcher : UserEventTarget;

	public var touch	(get_touch,		null)	: TouchEvents;
	public var gesture	(get_gesture,	null)	: GestureEvents;

	
	public function new(eventDispatcher)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	override private function createMouse   ()  mouse   = new MouseEvents(eventDispatcher);
	private function createTouch   ()  touch   = new TouchEvents(eventDispatcher);
	private function createGesture ()  gesture = new GestureEvents(eventDispatcher);
	//private function createFocus   ()  focus   = new FocusEvents(eventDispatcher);
	//private function createFocus   ()  blur    = new BlurEvents(eventDispatcher);
	override private function createKey     ()  key     = new KeyboardEvents(eventDispatcher);
	
	private inline function get_touch 	() { if (touch == null)		{ createTouch();	} return touch; }
	private inline function get_gesture () { if (gesture == null)	{ createGesture();	} return gesture; }
}
#end
