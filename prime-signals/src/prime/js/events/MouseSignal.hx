package prime.js.events;
 import prime.core.geom.Point;
 import prime.gui.events.KeyModState;
 import prime.gui.events.MouseEvents;
 import prime.gui.events.UserEventTarget;
 import js.Dom;


/**
 * @author Stanislav Sopov
 */
typedef MouseEvent = 
{
	>Event,
//	public var altKey 			(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered.
//	public var button			(default, null):Int; // The mouse button pressed. 0, 1, 2 are respectively left, middle and right buttons.
//	public var clientX			(default, null):Int; // The x-coordinate relative to the viewport (excludes scroll offset)
//	public var clientY			(default, null):Int; // The y-coordinate relative to the viewport (excludes scroll offset)
//	public var ctrlKey 			(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var fromElement 		(default, null):Dynamic; // The element the mouse comes from. This is interesting to know in case of mouseover.
	public var metaKey			(default, null):Bool; // Indicates whether the META key was pressed when the event was triggered.
	public var offsetX			(default, null):Int; // The x-coordinate relative to the target.
	public var offsetY			(default, null):Int; // The y-coordinate relative to the target.
	public var relatedTarget	(default, null):Dynamic; // A secondary event target related to the event. 
//	public var screenX			(default, null):Int; // Relative to the screen.
//	public var screenY			(default, null):Int; // Relative to the screen.
//	public var shiftKey 		(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered.
	public var x				(default, null):Int;
	public var y				(default, null):Int;
}

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
		var e = cast(e, MouseEvent);
		
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
		
		send(new MouseState(flags, e.target, new Point(e.clientX, e.clientY), new Point(e.screenX, e.screenY), (untyped e).relatedTarget));
	}
}
