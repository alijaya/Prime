package cases;
 import prime.gui.managers.InvalidationManager;
 import prime.gui.core.UIWindow;
 import prime.gui.display.Window;
 import prime.gui.core.UIComponent;
 import prime.bindable.collections.SimpleList;
 import prime.bindable.collections.ListChange;
 	using prime.utils.Bind;

class InvalidationTest extends UIWindow
{
	public var results : SimpleList<String>;
	public static var t;

	public static function main () 
	{  
		t = haxe.Log.trace;
		Window.startup( function (s) return new InvalidationTest(s) ); 
	}
	
	override private function createChildren ()
	{

		haxe.Log.trace = t;

		results = new SimpleList<String>();
		printChange.on( results.change, this );
		
		var a:ValidateA = new ValidateA();
		var b:ValidateB = new ValidateB();

		a.results = results;
		a.b = b;
		b.results = results;
		b.done = done;

		attach( a );
		attach( b );

		a.invalidate( 1 );
	}

	public function done()
	{
		//Assert.that( results.length == 3 );
		trace( "results.length == 3 : " + ( results.length == 3 ) );
		trace( "results.length = " + results.length );
		
		var s:String = "";
		for ( r in results )
			s += r;

		trace( "s == a1a2b1 : " + ( s == "a1a2b1" ) );
		trace( "s = " + s );
		//Assert.that( s == "a1a2b1" );
	}

	public function printChange( change:ListChange<String> )
	{
		trace( "results." + change );
	}
}

class ValidateA extends UIComponent
{
	public var results : SimpleList<String>;
	public var b : ValidateB;
	private var count:Int;

	override public function validate () : Void
	{
		if ( count == 0 )
		{
			trace("a.validated from attach");
		}
		if ( count == 1 )
		{
			results.add( "a1" );
			invalidate( 1 );
			b.invalidate( 1 );
			
		}
		else if ( count == 2 )
		{
			results.add( "a2" );
		}
		count++;
		
	}
}

class ValidateB extends UIComponent
{
	public var results : SimpleList<String>;
	public var done : Void -> Void;
	private var count:Int;

	override public function validate () : Void
	{
		if ( count == 0 )
		{
			trace("b.validated from attach");
		}
		if ( count == 1 )
		{
			results.add( "b1" );
			done();
		}
		count++;
	}
}