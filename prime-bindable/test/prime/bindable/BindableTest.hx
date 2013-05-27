package prime.bindable;
 import prime.bindable.Bindable;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class BindableTest
{
	public function new() {}

	@BeforeClass public function beforeClass():Void {}
	@AfterClass public function afterClass():Void {}
	@Before public function setup():Void {}
	@After public function tearDown():Void {}

	@Test public function bigTest():Void
	{
		var a = new Bindable<Int>(1000);
		var b = new Bindable<Int>(1000);
		
		b.pair(a);
		
		Assert.areEqual(a.value, b.value);
		a.value = 123;
		Assert.areEqual(a.value, b.value);
		b.value = 456;
		Assert.areEqual(a.value, b.value);
		
		a.unbind(b);
		a.value = 1337;
		Assert.areEqual(a.value, 1337);
		Assert.areEqual(b.value, 456);
		
		b.value = 1000;
		Assert.areEqual(a.value, 1337);
		Assert.areEqual(b.value, 1000);
		
		var changeCount = 0;
		a.change.observe(BindableTest, function(){ changeCount++; });
		
		a.pair(b);
		a.pair(b);
		a.pair(b);
		
		Assert.areEqual(changeCount, 1);
		
		b.value = 987;
		Assert.areEqual(a.value, 987);
		Assert.areEqual(b.value, 987);
		
		Assert.areEqual(changeCount, 2);
		
		a.dispose();
		b.value = 765;
		Assert.areEqual(a.value, #if flash9 0 #else null #end);
		Assert.areEqual(b.value, 765);
	}
}