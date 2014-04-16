package prime.js.display;
#if js
import js.Lib;
import prime.js.events.TouchEvents;
import prime.js.events.TouchSignal;

/**
 * @since	June 15, 2011
 * @author	Stanislav Sopov 
 */
class Link extends DOMElem
{	
	public var href				(default, set_href):String;
	public var action			(default, set_action):Void -> Void;
	public var touches			(default, null):TouchEvents;
	
	public function new()
	{
		super("a");
		
		touches = new TouchEvents(elem);
	}
	
	private function set_action(v:Void -> Void):Void -> Void
	{
		action = v;
		touches.end.bind(this, applyAction);
		return action;
	}
	
	private function set_href(v:String):String
	{
		elem.href = v;
		elem.target = "_blank";
		return href = v;
	}
	
	private function applyAction(e)
	{
		action();
	}
}
#end
