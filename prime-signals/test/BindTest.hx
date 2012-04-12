package cases;
 import Benchmark;
 import prime.signal.Wire;
 import prime.signal.Signal0;
  using prime.utils.Bind;

/**
 * Tests for the Pipe sub-system
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class BindTest
{
	static function main()
	{
		var b = new Benchmark();
		
		b.add(new Test(test, "Woei", 1000000));
		b.start();
		
//		Test.main();
	}
	
	static var d = new Signal0();
	
	static function test() : Void
	{
		var b:Wire<Void->Void> = Wire.make(d,null,null);
		b.dispose();
	}
}
