package prime.layout.algorithms;
 import prime.core.geom.IRectangle;
 import prime.layout.algorithms.LayoutAlgorithmBase;
 import prime.layout.algorithms.ILayoutAlgorithm;
 import prime.layout.FlexBoxEnum;
  using prime.utils.BitUtil;

private typedef Flags = LayoutFlags;

/**
 * ...
 * @author EzeQL
 */
class FlexBoxAlgorithm extends LayoutAlgorithmBase implements ILayoutAlgorithm
{

	private var sortedChildren:Array<LayoutClient>;
	
	@:isVar public var flexDirection(default, set_flexDirection) :FlexDirection;
	@:isVar public var flexWrap(default, set_flexWrap):FlexWrap;
	@:isVar public var justifyContent(default, set_justifyContent):JusfityContent;
	@:isVar public var alignItems(default, set_alignItems):AlignItems;
	@:isVar public var alignContent(default, set_alignContent):AlignContent;
	
	private function set_flexDirection(v:FlexDirection)
	{
		
		if ( v != flexDirection) 
		{
			flexDirection = v;
			algorithmChanged.send();
		}
		return flexDirection;
	}

	private function set_flexWrap(v:FlexWrap)
	{
		if (v != flexWrap)
		{
			flexWrap = v;
			algorithmChanged.send();
		}
		return flexWrap;
	}
	
	
	private function set_justifyContent(v:JusfityContent)
	{
		if (v != justifyContent)
		{
			v = justifyContent;
			algorithmChanged.send();
		}
		return justifyContent;
	}

	private function set_alignItems(v:AlignItems)
	{
		if (v != alignItems)
		{
			alignItems = v;
			algorithmChanged.send();
		}
		return alignItems;
	}


	private function set_alignContent(v:AlignContent)
	{
		if (v != alignContent)
		{
			alignContent = v;
			algorithmChanged.send();
		}
		return alignContent;
	}

	
	public #if !noinline inline #end function isInvalid (changes:Int)
	{
		return changes.has( Flags.WIDTH | Flags.HEIGHT | Flags.X | Flags.Y | Flags.FLEXBOX | Flags.LIST);
	}
	
	
	override public function prepareValidate ()
	{
		initialSetup();
		validatePrepared = true;
	}
	

	
	/*9.1 Initial Setup
	Generate anonymous flex items as described in the Flex Items section.
	Re-order the flex items and absolutely positioned flex container children according to their order. The flex items with the lowest (most negative) order values are first in the ordering. If multiple flex items share an order value, they’re ordered by document order. This effectively changes the order of their boxes in the box-tree, and how the rest of this algorithm deals with the generated flex items.
	*/
	private inline function initialSetup()
	{
		var sortFun = function(a:LayoutClient, b:LayoutClient) 
		{
			if (a.flexbox != null)
			{
				if (b.flexbox != null)
				{
					trace("bien");
					return a.flexbox.order - b.flexbox.order;
				}
				else
				{
					return -1;
				}
			}
			else
			{
				if (b.flexbox != null)
				{
					return 1;
				}
				else
				{
					return 0;
				}
			}
		}
		
		sortedChildren = Lambda.array(group.children);
		sortedChildren.sort( sortFun);
		
	}
	
	
	private inline function  determinateLineLength()
	{
		/*Determine the available main and cross space for the flex items. For each dimension, 
		 * if that dimension of the flex container’s content box is a definite size, use that; 
		 * otherwise, subtract the flex container’s margin, border, and padding from the space available to the flex container in that dimension and use that value.
		 * This might result in an infinite value.*/
		
		var mainSpace:Float;
		var crossSpace:Float;
		 
		if ( flexDirection == row || flexDirection == rowReverse )
		{
			mainSpace  = getGroupWidth();
			crossSpace = getGroupHeight();
		}
		else
		{
			mainSpace  = getGroupHeight();
			crossSpace = getGroupWidth();
		}
		
		for (c in sortedChildren)
		{
			//flexBaseSize = 
		}
	}
	
	private inline function getGroupWidth()
	{
		return group.width;
	}
	
	private inline function getGroupHeight()
	{
		return group.height;
	}


	/* INTERFACE prime.layout.algorithms.ILayoutAlgorithm */
	
	public function validate():Void 
	{
		
	}
	
	public function validateHorizontal():Void 
	{
		
	}
	
	public function validateVertical():Void 
	{
		
	}
	
	public function apply():Void 
	{
		
	}
	
	public function getDepthForBounds(bounds:prime.core.geom.IRectangle):Int 
	{
		return 0;
	}
#if (CSSParser || debug)
	override public function toString () : String
	{
		return toCSS();
	}
	
	override public function toCSS (prefix:String = "") : String
	{
		return "flex";
	}
#end
}