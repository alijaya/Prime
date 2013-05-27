package prime.js.events;
 import prime.signals.Signals;
 import prime.gui.events.UserEventTarget;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class FocusEvents extends Signals
{
	private var eventDispatcher : UserEventTarget;
	
	public var focus		(get_focus,		 null) : FocusSignal;
	public var focusIn		(get_focusIn,	 null) : FocusSignal;
	public var DOMFocusIn	(get_DOMFocusIn, null) : FocusSignal;
	public var blur			(get_blur,		 null) : FocusSignal;
	public var focusOut		(get_focusOut,	 null) : FocusSignal;
	public var DOMFocusOut	(get_DOMFocusOut, null) : FocusSignal;
	

	public function new(eventDispatcher)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}

	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}

	
	private inline function get_focus			() { if (focus		 == null) { createFocus();		 } return focus; }
	private inline function get_focusIn			() { if (focusIn 	 == null) { createFocusIn();	 } return focusIn; }
	private inline function get_DOMFocusIn		() { if (DOMFocusIn	 == null) { createDOMFocusIn();	 } return DOMFocusIn; }
	private inline function get_blur			() { if (blur 		 == null) { createBlur();		 } return blur; }
	private inline function get_focusOut		() { if (focusOut 	 == null) { createFocusOut();	 } return focusOut; }
	private inline function get_DOMFocusOut		() { if (DOMFocusOut == null) { createDOMFocusOut(); } return DOMFocusOut; }
	
	private inline function createFocus			() { focus			= new FocusSignal(eventDispatcher, "focus"); }
	private inline function createFocusIn		() { focusIn		= new FocusSignal(eventDispatcher, "focusin"); }
	private inline function createDOMFocusIn	() { DOMFocusIn		= new FocusSignal(eventDispatcher, "DOMFocusIn"); }
	private inline function createBlur			() { blur			= new FocusSignal(eventDispatcher, "blur"); }
	private inline function createFocusOut		() { focusOut		= new FocusSignal(eventDispatcher, "focusout"); }
	private inline function createDOMFocusOut	() { DOMFocusOut	= new FocusSignal(eventDispatcher, "DOMFocusOut"); }
}



	





