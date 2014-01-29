package prime.js.display;
#if js
 import prime.js.display.DisplayList;

/**
 * @since	April 22, 2011
 * @author	Stanislav Sopov 
 */
 
class DOMElem
{
	public var children		(default, null):DisplayList;
	public var className	(default, set_className):String;
	public var elem			(default, null):Dynamic;
	public var height		(default, set_height):Int;
	public var id			(default, set_id):String;
	public var matrix		(default, null):Dynamic;//WebKitCSSMatrix;
	public var parent		:DOMElem;
	public var scale		(default, set_scale):Float;
	public var style		(get_style, null):js.html.CSSStyleDeclaration;
	public var type			(default, null):String;
	public var visible		(default, set_visible):Bool;
	public var width		(default, set_width):Int;
	public var x			(default, set_x):Int;
	public var y			(default, set_y):Int;
	
	public function new(type:String)
	{
		elem = js.Browser.document.createElement(type);
		
		children = new DisplayList(this);
#if onlinetouch
		matrix = nl.onlinetouch.viewer.view.managers.js.Transform.getMatrix(elem);	//<-- WTF Stan?!@%
#end
		(untyped this).x = 0;
		(untyped this).y = 0;
		(untyped this).scale = 1;
	}
	
	private function set_width(v:Int):Int
	{
		if (width != v)
		{
			width = v;
			elem.style.width = v + "px";
		}
		return width;
	}
	
	private function set_height(v:Int):Int
	{
		if (height != v)
		{
			height = v;
			elem.style.height = v + "px";
		}
		return height;
	}
	
	inline private function set_x(v:Int):Int
	{
		if (x != v)
		{
			x = v;
			applyTransforms();
		}
		return x;
	}
	
	inline private function set_y(v:Int):Int
	{
		if (y != v)
		{
			y = v;
			applyTransforms();
		}
		return y;
	}
	
	inline public function moveTo(x:Int, y:Int)
	{
		(untyped this).x = x;
		(untyped this).y = y;
		applyTransforms();
	}
	
	inline private function set_scale(v:Float):Float
	{
		if (scale != v)
		{
			scale = v;
			applyTransforms();
		}
		return scale;
	}
	
	inline private function set_id(v:String):String
	{
		id = v;
		elem.id = v;
		return id;
	}
	
	inline private function get_style()
	{
		return elem.style;
	}
	
	inline private function set_className(v:String):String
	{
		className = v;
		elem.className = v;
		return className;
	}
	
	inline private function set_visible(v:Bool):Bool
	{
		if (visible != v)
		{
			visible = v;
			elem.style.visibility = v ? "visible" : "hidden";
		}
		return visible;
	}
	
	inline private function applyTransforms()
	{
		//elem.style.webkitTransform = "translate3d(" + x + "px," + y + "px,0) scale3d(" + scale + "," + scale + ",1)";
		elem.style.webkitTransform = "translate(" + x + "px," + y + "px) scale(" + scale + ")";
	/*	var m = matrix;
		m.a = m.d = scale;
		m.e = x;
		m.f = y;
		elem.style.webkitTransform = m;
	*/
	}
}
#end