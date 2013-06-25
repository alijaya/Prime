package prime.js.events;
#if js
import prime.js.events.DOMSignal1;
import js.html.Event;
import js.html.TransitionEvent;

/**
 * @author	Stanislav Sopov
 * @since 	April 7, 2011
 */
class TransitionSignal extends DOMSignal1<TransitionEvent>
{
	override private function dispatch(e:Event)
	{
		send(cast e);
	}
}
#end
