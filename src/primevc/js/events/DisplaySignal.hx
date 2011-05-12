package primevc.js.events;

import primevc.js.events.DOMSignal1;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

typedef DisplayEvent =
{
	>DOMEvent,
	/*
	attrChange constants
	
	ADDITION 		= 2; 
	MODIFICATION 	= 1; 
	REMOVAL 		= 3; 
	*/
	
	public var attrChange	(default, null):Int; // The type of change which triggered the event.
	public var attrName		(default, null):String; // The name of the modified attribute.
	public var newValue		(default, null):String; // The new value of the modified attribute.
	public var prevValue	(default, null):String; // The previous value of the modified attribute.
	public var relatedNode	(default, null):Dynamic; // A secondary element related to the event. 
}


class DisplaySignal extends DOMSignal1<DisplayEvent>
{
	override private function dispatch(event:Event) 
	{
		send(cast event);
	}
}
