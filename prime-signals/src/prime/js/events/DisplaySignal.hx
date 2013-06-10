package prime.js.events;
#if js
 import prime.js.events.DOMSignal1;
 import js.html.Event;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
typedef DisplayEvent = js.html.MutationEvent;

class DisplaySignal extends DOMSignal1<DisplayEvent>
{
	override private function dispatch(event:Event) 
	{
		send(cast event);
	}
}
#end
