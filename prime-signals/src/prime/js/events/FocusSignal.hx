package prime.js.events;
#if js
 import prime.gui.events.FocusState;
 import prime.js.events.DOMSignal1;
 import js.html.Event;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class FocusSignal extends DOMSignal1<FocusState>
{
	override private function dispatch(e:Event) 
	{
		send(cast e); //TODO: FIXME
	}
}
#end
