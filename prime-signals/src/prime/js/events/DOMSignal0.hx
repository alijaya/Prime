package prime.js.events;
#if js
import prime.signals.Wire;
import prime.signals.Signal0;
import prime.signals.IWireWatcher;
import js.html.Event;

/**
 * @author	Stanislav Sopov
 * @since 	April 6, 2011
 */
class DOMSignal0 extends Signal0 implements IWireWatcher<Void->Void>
{
	var eventDispatcher:Dynamic;
	var event:String;
	
	public function new (eventDispatcher:Dynamic, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	public function wireEnabled (wire:Wire<Void->Void>):Void
	{	
		Assert.isNotNull(n);
		
		if (n.next() == null) // First wire connected
		{
			untyped eventDispatcher.addEventListener(event, dispatch, false);
		}
	}
	
	public function wireDisabled (wire:Wire<Void->Void>):Void
	{	
		if (n == null) // No more wires connected
		{
			untyped eventDispatcher.removeEventListener(event, dispatch, false);
		}
	}
	
	private function dispatch(e:Event) 
	{
		Assert.abstractMethod();
	}
}
#end
