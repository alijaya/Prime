package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

#if flash
import prime.avm2.layout.StageLayout;
#end
import prime.layout.utils.LayoutUtil;
import prime.core.RangeIterator;
import prime.layout.AdvancedLayoutClient;
import prime.layout.IAdvancedLayoutClient;
import prime.layout.ILayoutClient;
import prime.layout.ILayoutContainer;
import prime.layout.IScrollableLayout;
import prime.layout.LayoutClient;
import prime.layout.LayoutContainer;
import prime.layout.LayoutFlags;
import prime.layout.RelativeLayout;
import prime.layout.VirtualLayoutContainer;
import prime.layout.algorithms.DynamicLayoutAlgorithm;
import prime.layout.algorithms.HorizontalBaseAlgorithm;
import prime.layout.algorithms.IHorizontalAlgorithm;
import prime.layout.algorithms.ILayoutAlgorithm;
import prime.layout.algorithms.IVerticalAlgorithm;
import prime.layout.algorithms.LayoutAlgorithmBase;
import prime.layout.algorithms.RelativeAlgorithm;
import prime.layout.algorithms.VerticalBaseAlgorithm;
import prime.layout.algorithms.circle.HorizontalCircleAlgorithm;
import prime.layout.algorithms.circle.VerticalCircleAlgorithm;
import prime.layout.algorithms.floating.HorizontalFloatAlgorithm;
import prime.layout.algorithms.floating.VerticalFloatAlgorithm;
import prime.layout.algorithms.tile.DynamicTileAlgorithm;
import prime.layout.algorithms.tile.FixedTileAlgorithm;
import prime.layout.algorithms.tile.ITileAlgorithm;
import prime.layout.algorithms.tile.SimpleTileAlgorithm;
import prime.layout.algorithms.tile.TileAlgorithmBase;
import prime.layout.algorithms.tile.TileContainer;
#if flash
import examples.layout.LayoutExample1;
#end
import examples.layout.LayoutExample2;
import examples.layout.LayoutExample3;
import examples.layout.LayoutExample4;
import examples.styles.layoutExample4.StyleSheet;

//import cases.LayoutAlgorithmUnitTests;
/**
* Auto generated MassiveUnit Test Class 
*/
class AllClassesTest 
{
	
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(true);
	}
}