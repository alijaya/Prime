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
	
	public #if !noinline inline #end function add(object:DOMElem, ?before:Dynamic)
	{
		if (object.parent != target)
		{
			if (object.elem.parentNode != null) object.elem.parentNode.removeChild(object.elem);
			object.style.display = null;//"block";
			object.parent = target;
			if (before == null) target.elem.appendChild(object.elem);
			else target.elem.insertBefore(object.elem, before);
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
