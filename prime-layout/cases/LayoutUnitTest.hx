package cases;
 import prime.core.geom.BindableBox;
 import prime.core.geom.Box;
 import prime.core.geom.constraints.SizeConstraint;
 import prime.layout.LayoutClient;
 import prime.layout.LayoutFlags;
  using prime.utils.BitUtil;
 

/**
 * Description
 * 
 * @creation-date	Jun 22, 2010
 * @author			Ruben Weijers
 */
class LayoutUnitTest 
{
	public static function main ()
	{
		//assertions
		var assertions = new LayoutAssertions();
		assertions.run();
	}
}


class LayoutAssertions
{
	public var layout : LayoutClient;
	
	
	public function new () {
		layout = new LayoutClient();
	}
	
	
	public function run ()
	{
		trace("start unit test");
		layout.width	= 500;
		layout.height	= 300;
		layout.x		= 100;
		layout.y		= 150;
		
		//validate simple properties
		Assert.isEqual( layout.width, 500 );
		Assert.isEqual( layout.height, 300 );
		Assert.isEqual( layout.x, 100 );
		Assert.isEqual( layout.y, 150 );
		
		//the bounds object shouldn't have the right bottom, right, width and height properties yet
		Assert.isEqual( layout.bounds.left, 100 );
		Assert.isEqual( layout.bounds.right, 100 );
		Assert.isEqual( layout.bounds.top, 150 );
		Assert.isEqual( layout.bounds.bottom, 150 );
		Assert.isEqual( layout.bounds.width, 0 );
		Assert.isEqual( layout.bounds.height, 0 );
		
		//validate layout
		layout.measure();
		
		//right, bottom, width and height should be correct now
		Assert.isEqual( layout.bounds.left, 100 );
		Assert.isEqual( layout.bounds.right, 600 );
		Assert.isEqual( layout.bounds.top, 150 );
		Assert.isEqual( layout.bounds.bottom, 450 );
		Assert.isEqual( layout.bounds.width, 500 );
		Assert.isEqual( layout.bounds.height, 300 );
		
		//add padding
		layout.padding = new Box( 5, 10 );
		Assert.isEqual( layout.padding.top, 5 );
		Assert.isEqual( layout.padding.bottom, 5 );
		Assert.isEqual( layout.padding.left, 10 );
		Assert.isEqual( layout.padding.right, 10 );
		
		Assert.isEqual( layout.width, 500 );
		Assert.isEqual( layout.height, 300 );
		Assert.isEqual( layout.bounds.width, 500 );
		Assert.isEqual( layout.bounds.height, 300 );
		
		//validate measure
		layout.measure();
		Assert.isEqual( layout.width, 500 );
		Assert.isEqual( layout.height, 300 );
		Assert.isEqual( layout.bounds.width, 520 );
		Assert.isEqual( layout.bounds.height, 310 );
		Assert.isEqual( layout.bounds.left, 100 );
		Assert.isEqual( layout.bounds.right, 620 );
		Assert.isEqual( layout.bounds.top, 150 );
		Assert.isEqual( layout.bounds.bottom, 460 );
		
		//validate setting the right property
		layout.bounds.right = 900;
		Assert.isEqual( layout.bounds.right, 900 );
		Assert.isEqual( layout.bounds.left, 380 );
		Assert.isEqual( layout.x, 380 );
		
		//validate setting the left property
		layout.bounds.left = 400;
		Assert.isEqual( layout.bounds.left, 400 );
		Assert.isEqual( layout.bounds.right, 920 );
		Assert.isEqual( layout.x, 400 );
		
		//validate setting the top property
		layout.bounds.top = 400;
		Assert.isEqual( layout.bounds.top, 400 );
		Assert.isEqual( layout.bounds.bottom, 710 );
		Assert.isEqual( layout.y, 400 );
		
		//validate setting the bottom property
		layout.bounds.bottom = 900;
		Assert.isEqual( layout.bounds.bottom, 900 );
		Assert.isEqual( layout.bounds.top, 590 );
		Assert.isEqual( layout.y, 590 );
		
		
		//
		// TEST SIZE CONSTRIANTS
		//
		
		layout.x = layout.y = 100;
		
		layout.sizeConstraint = new SizeConstraint(50, 400, 10, 200);
		Assert.isEqual(layout.sizeConstraint.width.min, 50);
		Assert.isEqual(layout.sizeConstraint.width.max, 400);
		Assert.isEqual(layout.sizeConstraint.height.min, 10);
		Assert.isEqual(layout.sizeConstraint.height.max, 200);
		
		//check if the constraints are already applied
		Assert.isEqual(layout.width, layout.sizeConstraint.width.max);
		Assert.isEqual(layout.height, layout.sizeConstraint.height.max);
		
		//check if constraints won't apply when size is in between constraints
		layout.width = 300;
		layout.height = 50;
		Assert.isEqual( layout.width, 300 );
		Assert.isEqual( layout.height, 50 );
		
		//check if constraints apply when size is lower then constraints
		layout.width = 30;
		layout.height = 5;
		Assert.isEqual(layout.width, layout.sizeConstraint.width.min);
		Assert.isEqual(layout.height, layout.sizeConstraint.height.min);
		
		//check if constraints apply when size is bigger then constraints
		layout.width = 3000;
		layout.height = 500;
		Assert.isEqual(layout.width, layout.sizeConstraint.width.max);
		Assert.isEqual(layout.height, layout.sizeConstraint.height.max);
		
		//check if size updates when maxsize changes
		layout.sizeConstraint.width.max = 300;
		layout.sizeConstraint.height.max = 150;
		Assert.isEqual(layout.width, layout.sizeConstraint.width.max);
		Assert.isEqual(layout.height, layout.sizeConstraint.height.max);
		
		//check if size updates when minsize changes
		layout.width = 50;
		layout.height = 10;
		layout.sizeConstraint.width.min = 80;
		layout.sizeConstraint.height.min = 50;
		Assert.isEqual(layout.width, layout.sizeConstraint.width.min);
		Assert.isEqual(layout.height, layout.sizeConstraint.height.min);
		
		
		//
		// TEST POSITION CONSTRIANTS
		//
		
		layout.sizeConstraint = null;
		layout.padding	= null;
		layout.width	= 300;
		layout.height	= 200;
		layout.x		= -100;
		layout.y		= -100;
		layout.measure();
		Assert.isEqual( layout.bounds.left, -100 );
		Assert.isEqual( layout.bounds.top, -100 );
		Assert.isEqual( layout.bounds.width, 300 );
		Assert.isEqual( layout.bounds.height, 200 );
		
		layout.bounds.constraint = new BindableBox( -10, 900, 500, -10);
		
		//test left constraints
		Assert.isEqual( layout.bounds.left, -10 );
		layout.bounds.left = -20;
		Assert.isEqual( layout.bounds.left, -10 );
		layout.bounds.left = 20;
		Assert.isEqual( layout.bounds.left, 20 );
		
		//test top constraints
		Assert.isEqual( layout.bounds.top, -10 );
		layout.bounds.top = -30;
		Assert.isEqual( layout.bounds.top, -10 );
		layout.bounds.top = 30;
		Assert.isEqual( layout.bounds.top, 30 );
		
		//test right constraints
		Assert.isEqual( layout.bounds.right, 320 );
		layout.bounds.right = 920;
		Assert.isEqual( layout.bounds.right, 900 );
		
		//test bottom constraints
		Assert.isEqual( layout.bounds.bottom, 230 );
		layout.bounds.bottom = 600;
		Assert.isEqual( layout.bounds.bottom, 500 );
		
		
		//
		// TEST ASPECT RATIO
		//
		
		Assert.not( layout.maintainAspectRatio );
		layout.maintainAspectRatio = true;
		
		Assert.isEqual( layout.width, 300 );
		Assert.isEqual( layout.height, 200 );
		layout.width = 600;
		Assert.isEqual( layout.width, 600 );
		Assert.isEqual( layout.height, 400 );
		
		layout.height = 300;
		Assert.isEqual( layout.height, 300 );
		Assert.isEqual( layout.width, 450 );
		
		
		//
		// TEST CHANGES FLAG
		//
		
		layout.maintainAspectRatio = false;
		layout.measure();
		Assert.isEqual( layout.changes, 0 );
		
		layout.width = 300;
		Assert.that( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.not( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.not( layout.changes.has( LayoutFlags.X ) );
		Assert.not( layout.changes.has( LayoutFlags.Y ) );
		
		layout.height = 500;
		Assert.that( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.that( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.not( layout.changes.has( LayoutFlags.X ) );
		Assert.not( layout.changes.has( LayoutFlags.Y ) );
		
		layout.x = 40;
		Assert.that( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.that( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.that( layout.changes.has( LayoutFlags.X ) );
		Assert.not( layout.changes.has( LayoutFlags.Y ) );
		
		layout.y = 40;
		Assert.that( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.that( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.that( layout.changes.has( LayoutFlags.X ) );
		Assert.that( layout.changes.has( LayoutFlags.Y ) );
		
		layout.measure();
		Assert.isEqual( layout.changes, 0 );
		
		layout.bounds.left = 50;
		Assert.not( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.not( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.that( layout.changes.has( LayoutFlags.X ) );
		Assert.not( layout.changes.has( LayoutFlags.Y ) );
		
		layout.bounds.bottom = 900;
		Assert.not( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.not( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.that( layout.changes.has( LayoutFlags.X ) );
		Assert.that( layout.changes.has( LayoutFlags.Y ) );
		
		layout.measure();
		Assert.isEqual( layout.changes, 0 );
		
		layout.height = 500;
		Assert.not( layout.changes.has( LayoutFlags.WIDTH ) );
		Assert.not( layout.changes.has( LayoutFlags.HEIGHT ) );
		Assert.not( layout.changes.has( LayoutFlags.X ) );
		Assert.not( layout.changes.has( LayoutFlags.Y ) );
		
		trace("finish unit test");
	}
}