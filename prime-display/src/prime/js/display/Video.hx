package prime.js.display;

import js.Dom;
import js.Lib;

/**
 * @since	November 14, 2011
 * @author	Stanislav Sopov 
 */
class Video extends DOMElem
{	
    /**
     * Load the entire video when the page loads.
     */
    public static inline var PRELOAD_AUTO = "auto";
    
	/**
	 * Load only metadata when the page loads.
	 */
    public static inline var PRELOAD_METADATA = "metadata"; 	
    
    /**
     * Do not load the video when the page loads.
     */
    public static inline var PRELOAD_NONE = "none"; 
    
	public var src		        (default, set_src):String;
    public var preload          (default, set_preload):String;
	override public var width	(default, set_width):Int;
	override public var height	(default, set_height):Int;
	
	public function new() {
		super("video");
        elem.controls = "controls";
        //elem.poster = "black_screen.gif";
        
        //untyped {
        //    elem.addEventListener("emptied", function(e) { console.log("video emptied"); });
        //}
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
    
	private function set_src(v:String):String
	{
		if (src != v) {
			elem.src = v;
		}
		return src;
	}
    
    private function set_preload(v:String):String
	{
		if (preload != v) {
			elem.preload = v;
		}
		return preload;
	}
    
    public function reload() {
        //elem.src = src;
        //elem.controls = "controls";
        //elem.load();
        //elem.play();
    }
}