package cases;
 import flash.Vector;
 import prime.utils.MacroUtils;


/**
 * @author Ruben Weijers
 * @creation-date May 17, 2011
 */
class MacroTests
{
	public static function main ()
	{
		trace(" BEGIN  ");
		var b = new Test3();
		trace("=== traceValues");
		b.traceFields();
		trace("=== Value of testStrA");
		trace( "testStrA:	"+ b.testStrA );
		trace("=== autoTraceMe");
	//	b.traceMe("blaaaaaaaa");
		trace("=== dispose");
		b.dispose();
		trace("=== traceValues");
		b.traceFields();
		trace("=== Value of testStrA");
		trace( "testStrA:	"+ b.testStrA );
		trace("=== finish"); //*/
	}
}


interface IDisposable
{
	public function dispose() : Void;
}

interface IClient<T> implements IDisposable {
	public var list : Vector<T>;
}
interface IClient2 {}
@:generic class Client<T> implements IClient<T> implements IClient2
{
	public var val (default, null) : Int;
	public var list : Vector<T>;
	
	public function new ()				{ this.val = Test1.counter++; list = new Vector<T>(); }
	public function dispose ()			{ trace("Disposed called on "+this); this.val = -1;  }
	public function toString ()			{ return ""+val; }
	public function traceMe(v:String)	{ trace(val+" - "+v); }
}

class A {}

/*@:build(prime.utils.MacroUtils.autoDispose())
@:build(prime.utils.MacroUtils.autoTraceFields())
@:build(prime.utils.MacroUtils.autoTraceMe())*/
/*@:build(prime.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
@:autoBuild(prime.utils.MacroUtils.autoDispose())
@:autoBuild(prime.utils.MacroUtils.autoTraceMe())
@:autoBuild(prime.utils.MacroUtils.autoTraceFields())
@:autoBuild(prime.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
class Test0
{
	public function new() {}
}*/
@:build(prime.utils.MacroUtils.autoDispose())
@:build(prime.utils.MacroUtils.autoTraceFields())
//@:build(prime.utils.MacroUtils.autoTraceMe())
@:build(prime.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
@:autoBuild(prime.utils.MacroUtils.autoDispose())
//@:autoBuild(prime.utils.MacroUtils.autoTraceMe())
@:autoBuild(prime.utils.MacroUtils.autoTraceFields())
@:autoBuild(prime.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
class Test1 //extends Test0
{
	public static var counter = 1;
	
	@manual public var clientA	: Client<Int>;
	public  var clientB	: IClient<String>;
	public  var clientC	: IClient<A>;
	private var clientD : Client<Bool>;
	@borrowed public  var clientE	: IClient<A>;
	@manual public  var testStrA	: String;
	public  var testStrB	: String;
	public function new () { testStrA = testStrB = "TEST"; }
	public function dispose() { trace("Custom dispose function here"); }
//	public function new () { clientA = new Client(); testStr = "blaat1"; }
//	public function traceFields() {}
	
}

class Test2 extends Test1
{
	public var clientF : IClient<A>;
	public function new ()	{ super(); }
}

class Test3 extends Test2 {}


