package prime.js.events;
#if js
 import prime.gui.events.KeyboardEvents;
 import prime.gui.events.KeyModState;
 import js.html.KeyboardEvent;
 import js.html.Event;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class KeyboardSignal extends DOMSignal1<KeyboardState>
{	
	override private function dispatch(e:Event)
	{
		send( stateFromEvent(cast e) );
	}
	

	static inline public function stateFromEvent( e:KeyboardEvent ) : KeyboardState
	{
		var e : KeyboardEvent = cast e;
		/*
			charCode				keyCode					keyLocation		KeyMod
			FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
		*/
		
		var flags;

		Assert.that(e.charCode	< 16384); // 14 bits available in AVM2
		Assert.that(e.keyCode	<  1024);
		
		flags = (e.altKey?	KeyModState.ALT : 0)
			| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
			| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		
		flags |= cast(e.keyLocation, UInt) << 4;
		flags |= (e.charCode << 18);
		flags |= (e.keyCode << 8);

		return new KeyboardState(flags, cast e.target);
	}
}
#end
