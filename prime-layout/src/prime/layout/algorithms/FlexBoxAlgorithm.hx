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
	private var mainSpace:Float;
	private var crossSpace:Float;
	private var mainSize:Float;
	
	@:isVar public var flexDirection(default, set_flexDirection) :FlexDirection;
	@:isVar public var flexWrap(default, set_flexWrap):FlexWrap;
	@:isVar public var justifyContent(default, set_justifyContent):JusfityContent;
	@:isVar public var alignItems(default, set_alignItems):AlignItems;
	@:isVar public var alignContent(default, set_alignContent):AlignContent;
	
	public function new()
	{
		super();
		flexDirection = FlexDirection.row;
		flexWrap = FlexWrap.nowrap;
	}
	
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
		if ( validatePrepared) return;
		initialSetup();
		determinateLineLength();
		validatePrepared = true;
	}
	

	
	/*9.1 Initial Setup
	Generate anonymous flex items as described in the Flex Items section.
	Re-order the flex items and absolutely positioned flex container children according to their order. The flex items with the lowest (most negative) order values are first in the ordering. If multiple flex items share an order value, they’re ordered by document order. This effectively changes the order of their boxes in the box-tree, and how the rest of this algorithm deals with the generated flex items.
	*/
	private function initialSetup()
	{
		var sortFun = function(a:LayoutClient, b:LayoutClient) 
		{
			if (a.flexbox != null)
			{
				if (b.flexbox != null)
				{
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
	
	
	private function  determinateLineLength()
	{
		/*Determine the available main and cross space for the flex items. For each dimension, 
		 * if that dimension of the flex container’s content box is a definite size, use that; 
		 * otherwise, subtract the flex container’s margin, border, and padding from the space available to the flex container in that dimension and use that value.
		 * This might result in an infinite value.*/
		
		//for (c in sortedChildren)
		//{
			//If the item has a definite flex basis, that's the flex base size.
			//var flexBaseSize = c.width;
			//
		//}
		
		
		if ( flexDirection == row || flexDirection == rowReverse )
		{
			//2. Determine the available main and cross space for the flex items. For each dimension, if that dimension of the flex container’s content box is a definite size, use that; otherwise, subtract the flex container’s margin, border, and padding from the space available to the flex container in that dimension and use that value. This might result in an infinite value.
			mainSpace  = getAvailableWidth();
			crossSpace = getAvailableHeight();
			
			//4.Determine the main size of the flex container using the rules of the formatting context in which it participates. For this computation, auto margins on flex items are treated as 0
			mainSize = group.width;
			
			//9.3.5 Collect flex items into flex lines:
			if (flexWrap == nowrap)
			{
				//If the flex container is single-line, collect all the flex items into a single flex line.
				var lastX = 0;
				for (c in sortedChildren)
				{
					c.x = lastX;
					lastX += c.outerBounds.width;
				}
				//9.3.6 Resolve the flexible lengths of all the flex items to find their used main size (see section 9.7.).
				if (lastX > mainSize)
				{
					//shrink
				}
				else
				{
					lastX = 0;
					var scaledFlexFactorSum = 0.0;
					for (c in sortedChildren)
					{
						c.x = lastX;
						c.width = Std.int(c.width * c.flexbox.flexGrow);
						lastX += c.width;
						scaledFlexFactorSum += c.flexbox.flexShrink;
					}
					var freeSpace = mainSize - lastX;
					if (freeSpace > 0)
					{
						
						//Calculate desired free space. If the free space is zero or positive, then for each flex item on the line, its originally desired free space is the free space multiplied by the flex grow factor.
					}
					else
					{
						//Otherwise, if the free space is negative, then first sum the flex shrink factors of all the flex items on the line. If this number is greater than 1, set it to 1. Let this result be the scaled flex factor sum. For each flex item, multiply its flex shrink factor by its used based size. Then, renormalize each flex shrink factor so that their sum is the scaled flex factor sum. Then, multiple the flex shrink factor by the free space, and let the result be the originally desired free space.
						scaledFlexFactorSum = scaledFlexFactorSum > 1 ? 1 : scaledFlexFactorSum;
						
					}
					
					
					
				}
			}
		}
		else
		{
			mainSpace  = getAvailableHeight();
			crossSpace = getAvailableWidth();
			
			mainSize = group.height;
		}
		

		
		
	}

	
	private function getAvailableWidth()
	{
		return group.parent.width;
	}
	
	private function getAvailableHeight()
	{
		return group.parent.height;
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