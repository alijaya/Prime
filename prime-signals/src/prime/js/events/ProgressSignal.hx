package prime.js.events;
#if js
import prime.signals.IWireWatcher;
import prime.signals.Signal2;
import prime.signals.Wire;
import prime.core.events.CommunicationEvents;		// needed for ProgressHandler typedef

import js.html.XMLHttpRequest;
import js.html.ProgressEvent;

/**
 * @author	Stanislav Sopov
 * @since	April 6, 2011
 */
class ProgressSignal extends Signal2<Int, Int> implements IWireWatcher <ProgressHandler> 
{
	
	var request:XMLHttpRequest;
	var event:String;
	
	
	public function new (r:XMLHttpRequest, e:String)
	{
		super();
		
		this.request = r;
		this.event = e;
	}
	
	public function wireEnabled(wire:Wire<ProgressHandler>) : Void 
	{
		Assert.isNotNull(n);
		
		if (n.next() == null) // First wire connected
		{
			request.addEventListener(event, dispatch, false);
		}
	}
	
	public function wireDisabled(wire:Wire<ProgressHandler>):Void 
	{
		if (n == null) // No more wires connected
		{
			request.removeEventListener(event, dispatch, false);
		}
	}
	
	private function dispatch(e:ProgressEvent)
	{	
		send(e.loaded, e.total);
	}
}
#end
