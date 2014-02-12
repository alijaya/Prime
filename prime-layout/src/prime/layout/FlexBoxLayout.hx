package prime.layout;
 import prime.signals.Signal0;
 import prime.types.Number;

 
/**
 * ...
 * @author EzeQL
 */
class FlexBoxLayout implements prime.core.traits.IDisposable	
#if CSSParser	implements prime.tools.generator.ICSSFormattable
				implements prime.tools.generator.ICodeFormattable		#end
{
	
#if CSSParser
	public var _oid					(default, null)	: Int;
#end

	@:isVar public var order(default, set_order):Int = Number.INT_NOT_SET;

	@:isVar public var flexGrow(default, set_flexGrow):Float = 0;
	
	@:isVar public var flexShrink(default, set_flexShrink):Float = 1;
	
	@:isVar public var flexBasis(default, set_flexBasis):Int = Number.INT_NOT_SET;
	
	@:isVar public var alignSelf(default, set_alignSelf):prime.layout.FlexBoxEnum.AlignItems; /* missing auto value*/
	
	/**
	 * Signal to notify listeners that a property of the relative layout is 
	 * changed.
	 */
	public var change				(default, null) : Signal0;
	
	
	
	public function new()
	{
		this.change		= new Signal0();
	}
	
	private function set_order(v:Int)
	{
		if(v!=order)
		{
			order = v;
			change.send();	
		}
		return order;
	}
	
	private function set_flexGrow(v:Float)
	{
		if (v != flexGrow)
		{
			flexGrow = v;
			change.send();
		}
		return flexGrow;
	}
	
	private function set_flexShrink(v:Float)
	{
		if (v != flexShrink)
		{
			flexShrink = v;
			change.send();
		}
		return flexShrink;
	}
	
	
	private function set_flexBasis(v:Int)
	{
		if (v != flexBasis)
		{
			flexBasis = v;
			change.send();
		}
		return flexBasis;
	}
	
	private function set_alignSelf(v:prime.layout.FlexBoxEnum.AlignItems)
	{
		if (v != alignSelf)
		{
			alignSelf = v;
			change.send();
		}
		return alignSelf;
	}
}