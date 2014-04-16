package prime.js.display;
#if js
 import prime.signals.Signal1;
 import prime.js.events.DisplayEvents;
 import prime.js.events.DisplaySignal;
  using prime.utils.Bind;

/**
 * @since	March 11, 2011
 * @author	Stanislav Sopov 
 */
class Image extends DOMElem {
    
	public var src 				(default, set_src):String;
	public var events			(default, null):DisplayEvents;
	public var isDisplayed		(default, null):Bool;
	public var loaded			(default, null):Signal1<Image>;
	
	public function new() {
		super("img");
		
		initEvents();
	}
	
	private function initEvents() {
		events = new DisplayEvents(elem);
		
		events.addedToStage.bind(this, onInsertedIntoDoc);
		events.removedFromStage.bind(this, onRemovedFromDoc);
		
		loaded = new Signal1();
		untyped elem.addEventListener("load", onLoad, false);
	}
	
	override private function set_width(v:Int):Int {
		if (width != v) {
			width = v;
			elem.width = v;
		}
		return width;
	}
	
	override private function set_height(v:Int):Int {
		if (height != v) {
			height = v;
			elem.height = v;
		}
		return height;
	}
	
	private function set_src(v:String):String {
		if (src != v) {
			src = v;
			if (isDisplayed) { 
                load(); 
            }
		}
		return src;
	}
	
	private function onInsertedIntoDoc() {
		isDisplayed = true;
		load();
	}
	
	private function onRemovedFromDoc() {
		isDisplayed = false;
		elem.src = "";
	}
	
	private function onLoad(event) {
		loaded.send(this);
	}
	
	inline public function load() {
		if (src != null && elem.src != src) { 
            elem.src = src;
        }
	}

    inline public function unload() {
        elem.src = "";
    }
}
#end
