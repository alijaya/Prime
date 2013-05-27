package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

#if flash
import prime.avm2.display.BitmapShape;
import prime.avm2.display.DisplayContainer;
import prime.avm2.display.DisplayList;
import prime.avm2.display.Loader;
import prime.avm2.display.Sprite;
import prime.avm2.display.TextField;
import prime.avm2.display.VectorShape;
import prime.avm2.display.Video;
import prime.avm2.input.Browser;
#end

import prime.core.geom.Corners;
import prime.core.geom.InlineMatrix2D;
import prime.core.geom.Matrix2D;
import prime.core.geom.Corners;
import prime.gui.display.BitmapData;
import prime.gui.display.BitmapShape;
import prime.gui.display.DisplayDataCursor;
import prime.gui.display.DisplayList;
import prime.gui.display.DisplayObject;
import prime.gui.display.IDisplayContainer;
import prime.gui.display.IDisplayObject;
import prime.gui.display.IInteractiveObject;
import prime.gui.display.ISprite;
import prime.gui.display.ITextField;
import prime.gui.display.IVideo;
import prime.gui.display.Loader;
import prime.gui.display.Sprite;
import prime.gui.display.Stage;
import prime.gui.display.TextField;
import prime.gui.display.VectorShape;
import prime.gui.display.Video;
import prime.gui.display.Window;
import prime.gui.effects.AnchorScaleEffect;
import prime.gui.effects.CompositeEffect;
import prime.gui.effects.Easing;
import prime.gui.effects.Effect;
import prime.gui.effects.EffectFlags;
import prime.gui.effects.EffectProperties;
import prime.gui.effects.FadeEffect;
import prime.gui.effects.IEffect;
import prime.gui.effects.MoveEffect;
import prime.gui.effects.ParallelEffect;
import prime.gui.effects.ResizeEffect;
import prime.gui.effects.RotateEffect;
import prime.gui.effects.ScaleEffect;
import prime.gui.effects.SequenceEffect;
import prime.gui.effects.WipeEffect;
import prime.gui.effects.effectInstances.AnchorScaleEffectInstance;
import prime.gui.effects.effectInstances.CompositeEffectInstance;
import prime.gui.effects.effectInstances.EffectInstance;
import prime.gui.effects.effectInstances.FadeEffectInstance;
import prime.gui.effects.effectInstances.IEffectInstance;
import prime.gui.effects.effectInstances.MoveEffectInstance;
import prime.gui.effects.effectInstances.ParallelEffectInstance;
import prime.gui.effects.effectInstances.ResizeEffectInstance;
import prime.gui.effects.effectInstances.RotateEffectInstance;
import prime.gui.effects.effectInstances.ScaleEffectInstance;
import prime.gui.effects.effectInstances.SequenceEffectInstance;
import prime.gui.effects.effectInstances.WipeEffectInstance;
import prime.gui.graphics.ComposedGraphicProperties;
import prime.gui.graphics.ComposedGraphicProperty;
import prime.gui.graphics.EmptyGraphicProperty;
import prime.gui.graphics.GraphicElement;
import prime.gui.graphics.GraphicFlags;
import prime.gui.graphics.GraphicProperties;
import prime.gui.graphics.IComposedGraphicProperty;
import prime.gui.graphics.IGraphicElement;
import prime.gui.graphics.IGraphicProperty;
import prime.gui.graphics.borders.BitmapBorder;
import prime.gui.graphics.borders.BorderBase;
import prime.gui.graphics.borders.CapsStyle;
import prime.gui.graphics.borders.ComposedBorder;
import prime.gui.graphics.borders.EmptyBorder;
import prime.gui.graphics.borders.GradientBorder;
import prime.gui.graphics.borders.IBorder;
import prime.gui.graphics.borders.JointStyle;
import prime.gui.graphics.borders.SolidBorder;
import prime.gui.graphics.fills.BitmapFill;
import prime.gui.graphics.fills.ComposedFill;
import prime.gui.graphics.fills.GradientFill;
import prime.gui.graphics.fills.GradientStop;
import prime.gui.graphics.fills.GradientType;
import prime.gui.graphics.fills.SolidFill;
import prime.gui.graphics.fills.SpreadMethod;
import prime.gui.graphics.shapes.Circle;
import prime.gui.graphics.shapes.Ellipse;
import prime.gui.graphics.shapes.IGraphicShape;
import prime.gui.graphics.shapes.Line;
import prime.gui.graphics.shapes.Polygon;
import prime.gui.graphics.shapes.RegularRectangle;
import prime.gui.graphics.shapes.ShapeBase;
import prime.gui.graphics.shapes.Triangle;
import prime.gui.input.Browser;
import prime.gui.input.Keyboard;
import prime.gui.input.Mouse;
import prime.gui.text.FontStyle;
import prime.gui.text.FontWeight;
import prime.gui.text.TextAlign;
import prime.gui.text.TextDecoration;
import prime.gui.text.TextFormat;
import prime.gui.text.TextTransform;
import prime.gui.traits.IDisplayable;
import prime.gui.traits.IGraphicsOwner;
import prime.gui.traits.IInteractive;
import prime.gui.traits.IPositionable;
import prime.gui.traits.IScaleable;
import prime.gui.traits.ISizeable;
import prime.gui.traits.ITextStylable;
import prime.gui.utils.BitmapUtil;
import prime.gui.utils.DisplayUtil;
import prime.gui.utils.GraphicsUtil;

#if js
import prime.js.display.BitmapShape;
import prime.js.display.DisplayList;
import prime.js.display.DOMElem;
import prime.js.display.Image;
import prime.js.display.Link;
import prime.js.display.Sprite;
import prime.js.display.TextField;
import prime.js.display.Video;
#end

import prime.types.Asset;
import prime.utils.MatrixUtil;

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