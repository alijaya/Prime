package prime.js.events;
#if js
 import prime.signals.Wire;
 import prime.signals.Signal1;
 import prime.signals.IWireWatcher;
 import prime.gui.events.UserEventTarget;
 import js.html.Event;

/**
 * @author Stanislav Sopov
 * @creation-date march 2, 2010
 */
class DOMSignal1<Type> extends Signal1<Type> implements IWireWatcher<Type->Void>
{
	var eventDispatcher:UserEventTarget;
	var event:String;
	
	
	public function new (eventDispatcher:UserEventTarget, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	

	public function wireEnabled (wire:Wire<Type->Void>) : Void
	{
		Assert.isNotNull(n);
		
		if (n.next() == null) // First wire connected
		{
		//	trace(eventDispatcher.id+" - "+js.Lib.isIE+" - "+event);
		/*	if (js.Lib.isIE) 	(untyped eventDispatcher).attachEvent(event, dispatch, false);
			else			*/ 	(untyped eventDispatcher).addEventListener(event, dispatch, false);
		}
	}
	
	
	public function wireDisabled (wire:Wire<Type->Void>) : Void
	{
		if (n == null) // No more wires connected
		{
		/*	if (js.Lib.isIE) 	(untyped eventDispatcher).detachEvent(event, dispatch);
			else			*/	(untyped eventDispatcher).removeEventListener(event, dispatch, false);
		}
	}
	
	
	private function dispatch(e:Event)	Assert.abstractMethod();
}
#end
