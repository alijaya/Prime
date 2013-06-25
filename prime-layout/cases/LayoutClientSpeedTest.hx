package cases;
 import Benchmark;
 import prime.core.geom.BindableBox;
 import prime.core.geom.constraints.SizeConstraint;
 import prime.core.geom.RangedFloat;
 import prime.types.Number;
 import prime.gui.events.LayoutEvents;
 import prime.layout.LayoutClient;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
 

/**
 * Description
 * 
 * @creation-date	Jun 20, 2010
 * @author			Ruben Weijers
 */
class LayoutClientSpeedTest 
{
	public static function main ()
	{
		var bench = new Benchmark();
		var test1 = new DynamicLayoutClientTest();
		var test2 = new ManualLayoutClientTest();
		var test3 = new SimpleManualLayoutClientTest();
		var test4 = new ManualIntLayoutClientTest();
		
		var group = new Comparison( "create", 100000 );
		bench.add( group );
		group.add( new Test( test1.testCreate,			"auto") );
		group.add( new Test( test2.testCreate,			"manual") );
		group.add( new Test( test3.testCreate,			"manual simple") );
		group.add( new Test( test4.testCreate,			"manual int") );
		
		var group = new Comparison( "Set Width", 1000000 );
		bench.add( group );
		group.add( new Test( test1.testSetWidth,		"auto") );
		group.add( new Test( test2.testSetWidth,		"manual") );
		group.add( new Test( test3.testSetWidth,		"manual simple") );
		group.add( new Test( test4.testSetWidth,		"manual int") );
		
		group = new Comparison( "Get Width", 1000000 );
		bench.add( group );
		group.add( new Test( test1.testGetWidth,		"auto") );
		group.add( new Test( test2.testGetWidth,		"manual") );
		group.add( new Test( test3.testGetWidth,		"manual simple") );
		group.add( new Test( test4.testGetWidth,		"manual int") );
		
		var group = new Comparison( "constrained width", 100000 );
		bench.add( group );
		group.add( new Test( test1.initConstraints,		"auto init constraints") );
		group.add( new Test( test1.setConstraints,		"auto set constraints") );
		group.add( new Test( test1.setMaxWidth,			"auto set max width") );
		
		group.add( new Test( test1.testSetWidth,		"auto set width") );
		group.add( new Test( test1.testSetX,			"auto set x") );
		group.add( new Test( test1.testSetLeft,			"auto set left") );
		group.add( new Test( test1.testSetRight,		"auto set right") );
		
		group.add( new Test( test1.testSetPosConstrains,"auto set pos constraints") );
		group.add( new Test( test1.testSetX,			"auto set x") );
		group.add( new Test( test1.testSetLeft,			"auto set left") );
		group.add( new Test( test1.testSetRight,		"auto set right") );
		group.add( new Test( test1.testGetWidth,		"auto get width") );
		group.add( new Test( test1.initAspectRatio,		"init aspect ratio") );
		group.add( new Test( test1.testAspectRatio,		"auto set aspect width") );
		
		bench.start();
	}
}



class DynamicLayoutClientTest
{
	public var nextNum	: Int;
	public var client	: LayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new LayoutClient(); }
	
	public function initConstraints () {
		nextNum = 1;
		client.sizeConstraint = new SizeConstraint();
	}
	public function  setConstraints () {
		var c = client.sizeConstraint;
		c.width.min = 10;
		c.width.max = 1000000;
	}
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testSetX () {
		client.x = nextNum++;
	}
	
	public function testSetLeft () {
		client.bounds.left = nextNum++;
	}
	
	public function testSetRight () {
		client.bounds.right = nextNum++;
	}
	
	public function testSetPosConstrains () {
		client.bounds.constraint = new BindableBox();
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
	
	public function  setMaxWidth () {
		client.sizeConstraint.width.max++;
	}
	
	public function initAspectRatio () {
		client.width	= 500;
		client.height	= 300;
		client.maintainAspectRatio = true;
	}
	
	public function testAspectRatio () {
		client.width++;
	}
}


class ManualLayoutClientTest
{
	public var nextNum	: Float;
	public var client : ManualLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new ManualLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class ManualLayoutClient
{
	
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, set_width)	: Float;
	public var height	(default, set_height)	: Float;
	public var x		(default, set_x)		: Float;
	public var y		(default, set_y)		: Float;
	
	public var maxWidth		(default, set_maxWidth)			: Float;
	public var maxHeight	(default, set_maxHeight)		: Float;
	public var minWidth		(default, set_minWidth)			: Float;
	public var minHeight	(default, set_minHeight)		: Float;
	
	private var rangedWidth		(default, null)				: RangedFloat; // RangedNumber < Float >;
	private var rangedHeight	(default, null)				: RangedFloat; // RangedNumber < Float >;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, set_changes)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		rangedWidth		= new RangedFloat(0, 0);
		rangedHeight	= new RangedFloat(0, 0);
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	
//	private inline function set_width (v)	{ return width = v; }
//	private inline function set_height (v)	{ return width = v; }
//	private inline function set_x (v)		{ return width = v; }
//	private inline function set_y (v)		{ return width = v; }
	
	
	private inline function set_x (v:Float)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function set_y (v:Float)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function set_width (v:Float)
	{
		if (v != width) {
			width	= rangedWidth.value = v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function set_height (v:Float)
	{
		if (v != height) {
			height	= rangedHeight.value = v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private function set_maxWidth (v:Float)
	{
		if (v != maxWidth) {
			maxWidth	= rangedWidth.max = v;
			width		= rangedWidth.value;
		}
		return maxWidth;
	}
	
	
	private function set_maxHeight (v:Float)
	{
		if (v != maxHeight) {
			maxHeight	= rangedHeight.max = v;
			height		= rangedHeight.value;
		}
		return maxHeight;
	}
	
	
	private function set_minWidth (v:Float)
	{
		if (v != minWidth) {
			minWidth	= rangedWidth.min = v;
			width		= rangedWidth.value;
		}
		return minWidth;
	}
	
	
	private function set_minHeight (v:Float)
	{
		if (v != minHeight) {
			minHeight	= rangedHeight.min = v;
			height		= rangedHeight.value;
		}
		return minHeight;
	}
	
	
	private inline function set_changes (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}






class SimpleManualLayoutClientTest
{
	public var nextNum	: Float;
	public var client	: SimpleManualLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new SimpleManualLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class SimpleManualLayoutClient
{
	
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, set_width)	: Float;
	public var height	(default, set_height)	: Float;
	public var x		(default, set_x)		: Float;
	public var y		(default, set_y)		: Float;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, set_changes)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	private inline function set_x (v:Float)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function set_y (v:Float)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function set_width (v:Float)
	{
		if (v != width) {
			width	= v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function set_height (v:Float)
	{
		if (v != height) {
			height	= v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private inline function set_changes (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}








class ManualIntLayoutClientTest
{
	public var nextNum	: Int;
	public var client : ManualIntLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new ManualIntLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class ManualIntLayoutClient
{
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, set_width)	: Int;
	public var height	(default, set_height)	: Int;
	public var x		(default, set_x)		: Int;
	public var y		(default, set_y)		: Int;
	
	public var maxWidth		(default, set_maxWidth)			: Int;
	public var maxHeight	(default, set_maxHeight)		: Int;
	public var minWidth		(default, set_minWidth)			: Int;
	public var minHeight	(default, set_minHeight)		: Int;
	
	private var rangedWidth		(default, null)				: RangedInt; // RangedNumber < Float >;
	private var rangedHeight	(default, null)				: RangedInt; // RangedNumber < Float >;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, set_changes)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		rangedWidth		= new RangedInt(0, 0);
		rangedHeight	= new RangedInt(0, 0);
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	
//	private inline function set_width (v)	{ return width = v; }
//	private inline function set_height (v)	{ return width = v; }
//	private inline function set_x (v)		{ return width = v; }
//	private inline function set_y (v)		{ return width = v; }
	
	
	private inline function set_x (v:Int)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function set_y (v:Int)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function set_width (v:Int)
	{
		if (v != width) {
			width	= rangedWidth.value = v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function set_height (v:Int)
	{
		if (v != height) {
			height	= rangedHeight.value = v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private function set_maxWidth (v:Int)
	{
		if (v != maxWidth) {
			maxWidth	= rangedWidth.max = v;
			width		= rangedWidth.value;
		}
		return maxWidth;
	}
	
	
	private function set_maxHeight (v:Int)
	{
		if (v != maxHeight) {
			maxHeight	= rangedHeight.max = v;
			height		= rangedHeight.value;
		}
		return maxHeight;
	}
	
	
	private function set_minWidth (v:Int)
	{
		if (v != minWidth) {
			minWidth	= rangedWidth.min = v;
			width		= rangedWidth.value;
		}
		return minWidth;
	}
	
	
	private function set_minHeight (v:Int)
	{
		if (v != minHeight) {
			minHeight	= rangedHeight.min = v;
			height		= rangedHeight.value;
		}
		return minHeight;
	}
	
	
	private inline function set_changes (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}



class RangedInt
{
	public var value	(default, set_value)	: Int;
	public var min		(default, set_min)		: Int;
	public var max		(default, set_max)		: Int;
	
	
	public function new( value, min = Number.INT_MIN, max = Number.INT_MAX ) 
	{
		this.max	= max;
		this.min	= min;
		this.value	= value;
	}
	
	
	private inline function set_value (v:Int) {
		return value = v.within( min, max );
	}
	
	
	private inline function set_min (v:Int) {
		Assert.that( v < max, "v: "+v+"; max: "+max);
		if (v != min)
		{
			min = v;
			if (value < min)
				value = min;
		}
		return v;
	}
	
	
	private inline function set_max (v:Int) {
		Assert.that( v > min, "v: "+v+"; min: "+min);
		if (v != max)
		{
			max = v;
			if (value > max)
				value = max;
		}		
		return v;
	}
}