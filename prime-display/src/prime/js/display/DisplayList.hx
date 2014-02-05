package prime.js.display;
#if js

/**
 * @author 	Stanislav Sopov
 * @since 	March 22, 2011	
 */

class DisplayList 
{
	public var target(default, null):DOMElem;
	
	public function new (object:DOMElem)
	{
		target = object;
	}
	
	public #if !noinline inline #end function add(object:DOMElem)
	{
		if (object.parent != target)
		{
			if (object.elem.parentNode != null) object.elem.parentNode.removeChild(object.elem);
			object.style.display = "block";
			object.parent = target;
			target.elem.appendChild(object.elem);
		}
	}
	
	public #if !noinline inline #end function remove(object:DOMElem)
	{
		if (object.parent == target)
		{
			// --- Reduce reflows by hiding from DOM, instead of removing an element immediately:
			//target.elem.removeChild(object.elem);
			// ---
			object.style.display = "none";
			object.parent = null;
		}
	}
}
#end
