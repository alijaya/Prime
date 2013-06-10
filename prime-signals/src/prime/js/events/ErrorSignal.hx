package prime.js.events;
#if js

import js.html.Event;

/**
 * @author	Stanislav Sopov
 * @since	April 6, 2011
 */
class ErrorSignal extends DOMSignal1<String>
{
	override private function dispatch(e:Event) 
	{
		send("error");
	}
}
#end
