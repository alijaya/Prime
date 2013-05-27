package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

//import prime.tools.CSSParserMain;
//import prime.tools.StyleSheet.tpl;
//import prime.tools.CSSParser;
import prime.bindable.collections.PriorityList;
import prime.core.traits.IPrioritizable;
import prime.gui.filters.BevelFilter;
import prime.gui.filters.BitmapFilter;
import prime.gui.filters.BitmapFilterType;
import prime.gui.filters.BlurFilter;
import prime.gui.filters.DropShadowFilter;
import prime.gui.filters.GlowFilter;
import prime.gui.filters.GradientBevelFilter;
import prime.gui.filters.GradientGlowFilter;
import prime.gui.filters.IBitmapFilter;
import prime.tools.Manifest;
import prime.tools.StopWatch;
import prime.tools.generator.CodeGenerator;
import prime.tools.generator.ICodeFormattable;
import prime.tools.generator.ICodeGenerator;
import prime.tools.generator.ICSSFormattable;
import prime.tools.generator.Instance;
import prime.tools.generator.InstanceType;
import prime.tools.generator.ValueType;
import prime.tools.generator.output.HaxeOutputUtil;
import prime.types.SimpleDictionary;
import prime.gui.styling.ApplicationStyle;
import prime.gui.styling.EffectsCollection;
import prime.gui.styling.EffectsStyle;
import prime.gui.styling.FilterCollectionType;
import prime.gui.styling.FilterFlags;
import prime.gui.styling.FiltersCollection;
import prime.gui.styling.FiltersStyle;
import prime.gui.styling.GraphicFlags;
import prime.gui.styling.GraphicsCollection;
import prime.gui.styling.GraphicsStyle;
import prime.gui.styling.IIconOwner;
import prime.gui.styling.IStyleBlock;
import prime.gui.styling.IUIElementStyle;
import prime.gui.styling.LayoutCollection;
import prime.gui.styling.LayoutStyle;
import prime.gui.styling.LayoutStyleFlags;
import prime.gui.styling.StatesCollection;
import prime.gui.styling.StatesStyle;
import prime.gui.styling.StyleBlock;
import prime.gui.styling.StyleBlockBase;
import prime.gui.styling.StyleBlockType;
import prime.gui.styling.StyleChildren;
import prime.gui.styling.StyleCollectionBase;
import prime.gui.styling.StyleFlags;
import prime.gui.styling.StyleState;
import prime.gui.styling.StyleStateFlags;
import prime.gui.styling.StyleSubBlock;
import prime.gui.styling.StyleTypes;
import prime.gui.styling.TextStyle;
import prime.gui.styling.TextStyleCollection;
import prime.gui.styling.TextStyleFlags;
import prime.gui.styling.UIElementStyle;

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