import js.html.Event;
import js.html.Element;

@:enum
abstract HammerDirection(String)
{
  var up    = "up";
  var down  = "down";
  var left  = "left";
  var right = "right";
}


extern class Hammer {
  public function on(gesture:String, callback:GestureEvent->Void):Element;
  static public inline function time(element:Element, ?options : HammerOptions):Hammer {
    return untyped __js__("Hammer")(element, options);
  }
  public function off(gesture:String, callback:GestureEvent->Void):Element;
  public function enable(toggle:Bool):Element;
  public function trigger(gesture:String, eventData:Event):Element;
}

typedef HammerOptions = {
  ?drag: Bool,
  ?drag_block_horizontal: Bool,
  ?drag_block_vertical: Bool,
  ?drag_lock_to_axis: Bool,
  ?drag_max_touches: Int,
  ?drag_min_distance: Int,
  ?hold: Bool,
  ?hold_threshold: Int,
  ?hold_timeout: Int,
  ?prevent_default: Bool,
  ?prevent_mouseevents: Bool,
  ?release: Bool,
  ?show_touches: Bool,
  ?stop_browser_behavior: {
    ?userSelect: String,
    ?touchAction: String,
    ?touchCallout: String,
    ?contentZooming: String,
    ?userDrag: String,
    ?tapHighlightColor: String
  },
  ?swipe: Bool,
  ?swipe_max_touches: Int,
  ?swipe_velocity: Float,
  ?tap: Bool,
  ?tap_always: Bool,
  ?tap_max_distance: Int,
  ?tap_max_touchtime: Int,
  ?doubletap_distance: Int,
  ?doubletap_interval: Int,
  ?touch: Bool,
  ?transform: Bool,
  ?transform_always_block: Bool,
  ?transform_min_rotation: Int,
  ?transform_min_scale: Float,
}

typedef HammerTouch = {
  identifier:Int, 
  pageX:Int, 
  pageY:Int, 
  target:Element
}

typedef Center = {
  pageX: Int,
  pageY: Int
}

typedef HammerEvent = {
  /** center position of the touches. contains pageX and pageY */
  var center:      Center;
  /** matches Hammer.EVENT_START|MOVE|END */
  var eventType:   String;
  /** kind of pointer that was used. matches Hammer.POINTER_MOUSE|TOUCH */
  var pointerType: String;
  /** the source event, like TouchStart or MouseDown * */
  var srcEvent:    Event;
  /** A reference to the target to which the event was originally dispatched. */
  var target(default,null) : js.html.EventTarget;
  /** The time that the event was created. */
  var timeStamp(default,null) : Int;
  /** touches (fingers; mouse) on the screen */
  var touches:     Array<HammerTouch>;

  function preventDefault():Void;
  function stopDetect():Void;
  function stopPropagation():Void;
}

extern class GestureEvent extends Event
{
  var gesture: HammerGesture;
}

typedef HammerGesture = {>HammerEvent,
  /** the total time of the touches in the screen */
  var deltaTime:   Int;
  /** the delta on x axis we haved moved */
  var deltaX:      Float;
  /** the delta on y axis we haved moved */
  var deltaY:      Float;
  /** the velocity on the x */
  var velocityX:   Float;
  /** the velocity on y */
  var velocityY:   Float;
  /** the angle we are moving */
  var angle:       Float;
  /** the direction we are moving */
  var direction:   HammerDirection;
  /** the distance we haved moved */
  var distance:    Float;
  /** scaling of the touches, needs 2 touches */
  var scale:       Float;
  /** rotation of the touches, needs 2 touches * */
  var rotation:    Float;
  /** contains the same properties as above,
  but from the first touch. this is used to calculate
  distances, deltaTime, scaling etc */
  var startEvent:  HammerEvent;

  var interimAngle: Float;
  var interimDirection: HammerDirection;
}
