package prime.js.events;
#if js
 import prime.core.geom.Point;
 import prime.gui.events.KeyModState;
 import prime.gui.events.MouseEvents;
 import prime.gui.events.UserEventTarget;
 import js.html.MouseEvent;
 import js.html.Event;

/**
 * @author Stanislav Sopov
 * @author Ruben Weijers
 * @creation-date march 2, 2010
 */
class MouseSignal extends DOMSignal1<MouseState>
{
	var clickCount:Int;


	public function new (d:UserEventTarget, e:String, cc:Int)
	{
		super(d,e);
		this.clickCount = cc;
	}


	override private function dispatch(e:Event) 
	{
		var e : MouseEvent = cast e;
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*/
#if debug
		Assert.that(clickCount >=  0);
		Assert.that(clickCount <= 15);
#end
	//	flags = e.delta << 16
		var flags = 2 << 16			// FIXME: figure out how to use javascript mouse deltaX, deltaY, deltaZ
				| (clickCount & 0xF) << 4
				| (e.button > 0? 	0x0100 : 0)
				| (e.altKey?		KeyModState.ALT : 0)
				| (e.ctrlKey?		KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?		KeyModState.SHIFT : 0);
		
		send(new MouseState(flags, cast e.target, new Point(e.clientX, e.clientY), new Point(e.screenX, e.screenY), (untyped e).relatedTarget));
	}
}
#end
