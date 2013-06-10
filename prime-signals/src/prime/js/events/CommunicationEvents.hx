package prime.js.events;

import prime.core.events.CommunicationEvents;
import js.html.XMLHttpRequest;
import prime.signals.Signal0;

/**
 * @author	Danny Wilson
 * @since 	April 14, 2011
 */

class CommunicationEvents extends CommunicationSignals
{
	public function new (request:XMLHttpRequest)
	{
		super();
		started		= new Signal0();
		progress	= new ProgressSignal();
		init		= new Signal0();
		completed	= new Signal0();
		error		= new ErrorSignal();
	}
}