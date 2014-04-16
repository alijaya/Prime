package prime.js.events;
#if js
 import Hammer;
 import prime.signals.Wire;
 import prime.signals.Signals;
 import prime.signals.Signal1;
 import prime.signals.IWireWatcher;
 import prime.gui.events.UserEventTarget;


typedef GestureEvent = Hammer.GestureEvent;

/**
 * Signal0<-->hammer.js Event Proxy implementation
 *
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class GestureSignal extends Signal1<GestureEvent> implements IWireWatcher<Void->Void>
{
	var hammer : Hammer;
	var event  : String;

	public function new (d:Hammer, e:String)
	{
		super();
		this.hammer = d;
		this.event  = e;
	}

	public function wireEnabled (wire:Wire<Void -> Void>) : Void {
		Assert.isNotNull(n);
		if (n.next() == null) // First wire connected
			hammer.on(event, send);
	}

	public function wireDisabled	(wire:Wire<Void -> Void>) : Void {
		if (n == null) // No more wires connected
			hammer.off(event, send);
	}
}


/**
 * @author Danny Wilson
 * @since  Jan 29, 2014
 */
class GestureEvents extends Signals
{
	var hold           (get, null) : GestureSignal;
	var tap            (get, null) : GestureSignal;
	var doubletap      (get, null) : GestureSignal;
	var drag           (get, null) : GestureSignal;
	var dragstart      (get, null) : GestureSignal;
	var dragend        (get, null) : GestureSignal;
	var dragup         (get, null) : GestureSignal;
	var dragdown       (get, null) : GestureSignal;
	var dragleft       (get, null) : GestureSignal;
	var dragright      (get, null) : GestureSignal;
	var swipe          (get, null) : GestureSignal;
	var swipeup        (get, null) : GestureSignal;
	var swipedown      (get, null) : GestureSignal;
	var swipeleft      (get, null) : GestureSignal;
	var swiperight     (get, null) : GestureSignal;
	var transform      (get, null) : GestureSignal;
	var transformstart (get, null) : GestureSignal;
	var transformend   (get, null) : GestureSignal;
	var rotate         (get, null) : GestureSignal;
	var pinch          (get, null) : GestureSignal;
	var pinchin        (get, null) : GestureSignal;
	var pinchout       (get, null) : GestureSignal;
	/** (gesture detection starts) */
	var touch          (get, null) : GestureSignal;
	/** (gesture detection ends) */
	var release        (get, null) : GestureSignal;

	private var eventDispatcher : Hammer;


	public function new (target : UserEventTarget)
	{
		super();
		this.eventDispatcher = Hammer.time(target, {transform_always_block: true});
	}

	private function get_hold           (){ if (hold           == null) hold           = new GestureSignal(eventDispatcher, "hold");           return hold;           }
	private function get_tap            (){ if (tap            == null) tap            = new GestureSignal(eventDispatcher, "tap");            return tap;            }
	private function get_doubletap      (){ if (doubletap      == null) doubletap      = new GestureSignal(eventDispatcher, "doubletap");      return doubletap;      }
	private function get_drag           (){ if (drag           == null) drag           = new GestureSignal(eventDispatcher, "drag");           return drag;           }
	private function get_dragstart      (){ if (dragstart      == null) dragstart      = new GestureSignal(eventDispatcher, "dragstart");      return dragstart;      }
	private function get_dragend        (){ if (dragend        == null) dragend        = new GestureSignal(eventDispatcher, "dragend");        return dragend;        }
	private function get_dragup         (){ if (dragup         == null) dragup         = new GestureSignal(eventDispatcher, "dragup");         return dragup;         }
	private function get_dragdown       (){ if (dragdown       == null) dragdown       = new GestureSignal(eventDispatcher, "dragdown");       return dragdown;       }
	private function get_dragleft       (){ if (dragleft       == null) dragleft       = new GestureSignal(eventDispatcher, "dragleft");       return dragleft;       }
	private function get_dragright      (){ if (dragright      == null) dragright      = new GestureSignal(eventDispatcher, "dragright");      return dragright;      }
	private function get_swipe          (){ if (swipe          == null) swipe          = new GestureSignal(eventDispatcher, "swipe");          return swipe;          }
	private function get_swipeup        (){ if (swipeup        == null) swipeup        = new GestureSignal(eventDispatcher, "swipeup");        return swipeup;        }
	private function get_swipedown      (){ if (swipedown      == null) swipedown      = new GestureSignal(eventDispatcher, "swipedown");      return swipedown;      }
	private function get_swipeleft      (){ if (swipeleft      == null) swipeleft      = new GestureSignal(eventDispatcher, "swipeleft");      return swipeleft;      }
	private function get_swiperight     (){ if (swiperight     == null) swiperight     = new GestureSignal(eventDispatcher, "swiperight");     return swiperight;     }
	private function get_transform      (){ if (transform      == null) transform      = new GestureSignal(eventDispatcher, "transform");      return transform;      }
	private function get_transformstart (){ if (transformstart == null) transformstart = new GestureSignal(eventDispatcher, "transformstart"); return transformstart; }
	private function get_transformend   (){ if (transformend   == null) transformend   = new GestureSignal(eventDispatcher, "transformend");   return transformend;   }
	private function get_rotate         (){ if (rotate         == null) rotate         = new GestureSignal(eventDispatcher, "rotate");         return rotate;         }
	private function get_pinch          (){ if (pinch          == null) pinch          = new GestureSignal(eventDispatcher, "pinch");          return pinch;          }
	private function get_pinchin        (){ if (pinchin        == null) pinchin        = new GestureSignal(eventDispatcher, "pinchin");        return pinchin;        }
	private function get_pinchout       (){ if (pinchout       == null) pinchout       = new GestureSignal(eventDispatcher, "pinchout");       return pinchout;       }
	private function get_touch          (){ if (touch          == null) touch          = new GestureSignal(eventDispatcher, "touch");          return touch;          }
	private function get_release        (){ if (release        == null) release        = new GestureSignal(eventDispatcher, "release");        return release;        }
}
#end
