import js.html.Event;
import js.html.Element;

extern class Hammer {
  public function on(gesture:String, callback:HammerEvent->Void):Element;
  static public inline function time(element:Element, ?options : HammerOptions):Hammer {
    return untyped __js__("Hammer(element, options)");
  }
  public function off(gesture:String, callback:HammerEvent->Void):Element;
  public function enable(toggle:Bool):Element;
  public function trigger(gesture:String, eventData:Event):Element;
}

typedef HammerOptions = {
  var drag: Bool;
  var drag_block_horizontal: Bool;
  var drag_block_vertical: Bool;
  var drag_lock_to_axis: Bool;
  var drag_max_touches: Int;
  var drag_min_distance: Int;
  var hold: Bool;
  var hold_threshold: Int;
  var hold_timeout: Int;
  var prevent_default: Bool;
  var prevent_mouseevents: Bool;
  var release: Bool;
  var show_touches: Bool;
  var stop_browser_behavior: {
    userSelect: String,
    touchAction: String,
    touchCallout: String,
    contentZooming: String,
    userDrag: String,
    tapHighlightColor: String
  };
  var swipe: Bool;
  var swipe_max_touches: Int;
  var swipe_velocity: Float;
  var tap: Bool;
  var tap_always: Bool;
  var tap_max_distance: Int;
  var tap_max_touchtime: Int;
  var doubletap_distance: Int;
  var doubletap_interval: Int;
  var touch: Bool;
  var transform: Bool;
  var transform_always_block: Bool;
  var transform_min_rotation: Int;
  var transform_min_scale: Float;
}

typedef HammerTouch = {
  identifier:Int, 
  pageX:Int, 
  pageY:Int, 
  target:String
}

typedef Center = {
  pageX: Int,
  pageY: Int
}

typedef StartEvent = {
  var center: Center;
  var eventType: String;
  var pointerType: String;
  var srcEvent: Event;
  var target: String;
  var timestamp: Int;
  var touches: Array<HammerTouch>;

  function preventDefault():Void;
  function stopDetect():Void;
  function stopPropagation():Void;
}

typedef HammerEvent = {
  /** time the event occurred */
  var timestamp:   Int;
  /** target element */
  var target:      String;
  /** touches (fingers; mouse) on the screen */
  var touches:     Array<HammerTouch>;
  /** kind of pointer that was used. matches Hammer.POINTER_MOUSE|TOUCH */
  var pointerType: String;
  /** center position of the touches. contains pageX and pageY */
  var center:      Center;
  /** the total time of the touches in the screen */
  var deltaTime:   Int;
  /** the delta on x axis we haved moved */
  var deltaX:      Int;
  /** the delta on y axis we haved moved */
  var deltaY:      Int;
  /** the velocity on the x */
  var velocityX:   Int;
  /** the velocity on y */
  var velocityY:   Int;
  /** the angle we are moving */
  var angle:       Int;
  /** the direction we are moving. matches Hammer.DIRECTION_UP|DOWN|LEFT|RIGHT */
  var direction:   String;
  /** the distance we haved moved */
  var distance:    Int;
  /** scaling of the touches, needs 2 touches */
  var scale:       Int;
  /** rotation of the touches, needs 2 touches * */
  var rotation:    Int;
  /** matches Hammer.EVENT_START|MOVE|END */
  var eventType:   String;
  /** the source event, like TouchStart or MouseDown * */
  var srcEvent:    Event;
  /** contains the same properties as above,
  but from the first touch. this is used to calculate
  distances, deltaTime, scaling etc */
  var startEvent:  StartEvent;
}