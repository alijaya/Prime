package cases;
 import prime.bindable.BindableFlags;
 import prime.bindable.RevertableBindable;
 import prime.bindable.BindableFlags;
  using prime.utils.BitUtil;

/**
 * Tests for complicated RevertableBindable functionality...
 *  
 * @author Danny Wilson
 * @creation-date jul 02, 2010
 */
class RevertableBindableTests extends haxe.unit.TestCase
{
	public static function main()
	{	
		var r = new haxe.unit.TestRunner();
		r.add(new RevertableBindableTests());
		r.run();
	}
	
	function test_Pairing()
	{
		var a = new RevertableBindable<String>("one"),
			b = new RevertableBindable<String>("two");
		
		a.beginEdit(); b.beginEdit();
		a.pair(b);
		assertEquals("two", a.value);
		assertEquals("two", b.value);
	#if debug
		assertTrue(a.isBoundTo(b));
		assertTrue(b.isBoundTo(a));
	#end
		b.value = "three";
		assertEquals("three", b.value);
		assertEquals("two", a.value);
		b.commitEdit();
		
		assertEquals("three", b.value);
		assertEquals("three", a.value);
		
		b.unbind(a);
		
		b.beginEdit();
		b.value = "four";
		assertEquals("three", a.value);
		assertEquals("four",  b.value);
		
		a.value = "five";
		assertEquals("five", a.value);
		assertEquals("four", b.value);
		
		// ---
		a.bind(b);
		b.bind(a);
		a.value = "six";
		a.commitEdit();
		assertEquals("six", a.value);
		assertEquals("six", b.value);
		
		a.unbind(b);
		b.value = "seven";
		assertEquals("six", a.value);
		assertEquals("seven", b.value);
		
		a.beginEdit();
		a.value = "eight";
		a.commitEdit();
		assertEquals("eight", a.value);
		assertEquals("seven", b.value);
	}
	
	function test_BasicEditing()
	{
		var s = new RevertableBindable<String>("initial");
		s.cancelEdit();
		
		assertTrue(s.flags.hasNone(IN_EDITMODE));
		assertFalse(s.isEditable());
		assertEquals("initial", s.value);
		
		s.beginEdit();
		assertTrue(s.flags.has(IN_EDITMODE));
		assertTrue(s.isEditable());
		s.cancelEdit();
		assertTrue(s.flags.hasNone(IN_EDITMODE));
		assertFalse(s.isEditable());
		assertEquals("initial", s.value);
		
		
		s.beginEdit();
		s.value = "nonsense";
		assertTrue(s.isEditable());
		assertEquals("initial",  s.shadowValue);
		assertEquals("nonsense", s.value);
		assertTrue(s.isChanged());
		
		s.cancelEdit();
		assertEquals("initial", s.value);
		
//		s.value = "new";
		s.beginEdit();
		s.value = "edited";
		s.commitEdit();
		assertEquals("edited", s.value);
	}
	
	function test_Begin_keeps_pre_edit_value_intact()
	{
		var s = new RevertableBindable<String>("initial");
		assertFalse(s.isEditable());
		
		s.beginEdit();
		assertTrue(s.isEditable());
		assertFalse(s.isChanged());

		assertEquals("initial", s.value);
		assertEquals(null, 		s.shadowValue);
		s.value = "second";
		
		s.beginEdit();
		assertTrue(s.isChanged());
		assertEquals("second",  s.value);
		assertEquals("initial", s.shadowValue);
		
		s.cancelEdit();
		assertEquals("initial", s.value);
	}
	
	function test_SignalDispatchingFlags()
	{
		var check = checkFunction(shouldSignal);
		
		
		check(IS_VALID /* && not IN_EDITMODE */, true);
		check(IS_VALID | IN_EDITMODE | DISPATCH_CHANGES_BEFORE_COMMIT, true);
		check(/*not IS_VALID && not IN_EDITMODE */ INVALID_CHANGES_DISPATCH_SIGNAL, true);
		check(/*not IS_VALID*/ IN_EDITMODE | INVALID_CHANGES_DISPATCH_SIGNAL | DISPATCH_CHANGES_BEFORE_COMMIT, true);
		
		check(IN_EDITMODE, false);
		check(IN_EDITMODE | IS_VALID, false);
		check(IN_EDITMODE | /*not IS_VALID*/ DISPATCH_CHANGES_BEFORE_COMMIT, false);
		
		// No flags
		check(0, false);
		// All flags set
		check(IN_EDITMODE | IS_VALID | INVALID_CHANGES_DISPATCH_SIGNAL | DISPATCH_CHANGES_BEFORE_COMMIT, true);
		
		#if debug
		this.assertTrue(true);
		#else
		print("\n-- You should recompile in debug mode...\n");
		#end
	}
	
	function test_BindingDispatchingFlags()
	{
		var check = checkFunction(shouldUpdateBindings);
		
		
		check(IS_VALID /* && not IN_EDITMODE */, true);
		check(IS_VALID | IN_EDITMODE | UPDATE_BINDINGS_BEFORE_COMMIT, true);
		check(/*not IS_VALID && not IN_EDITMODE */ INVALID_CHANGES_UPDATE_BINDINGS, true);
		check(/*not IS_VALID*/ IN_EDITMODE | INVALID_CHANGES_UPDATE_BINDINGS | UPDATE_BINDINGS_BEFORE_COMMIT, true);
		
		check(IN_EDITMODE, false);
		check(IN_EDITMODE | IS_VALID, false);
		check(IN_EDITMODE | /*not IS_VALID*/ UPDATE_BINDINGS_BEFORE_COMMIT, false);
		
		// No flags
		check(0, false);
		// All flags set
		check(IN_EDITMODE | IS_VALID | INVALID_CHANGES_UPDATE_BINDINGS | UPDATE_BINDINGS_BEFORE_COMMIT, true);
		
		#if debug
		this.assertTrue(true);
		#else
		print("\n-- You should recompile in debug mode...\n");
		#end
	}

	function shouldSignal 			(flags:Int)		return RevertableBindableFlags.shouldSignal(flags)				// couldn't be called directly since it's inline
	function shouldUpdateBindings 	(flags:Int)		return RevertableBindableFlags.shouldUpdateBindings(flags)		// couldn't be called directly since it's inline
	
	static function checkFunction(fn)
	 	return function(flags:Int, expected:Bool)
	{
		var res = fn(flags);
		
		Assert.that(res == expected, "result: "+res+", expected: "+expected+" for flags: "+
			(flags & DISPATCH_CHANGES_BEFORE_COMMIT != 0? "DISPATCH_CHANGES_BEFORE_COMMIT, " : "") + 
			(flags & INVALID_CHANGES_DISPATCH_SIGNAL != 0? "INVALID_CHANGES_DISPATCH_SIGNAL, " : "") + 
			(flags & UPDATE_BINDINGS_BEFORE_COMMIT != 0? "UPDATE_BINDINGS_BEFORE_COMMIT, " : "") + 
			(flags & INVALID_CHANGES_UPDATE_BINDINGS != 0? "INVALID_CHANGES_UPDATE_BINDINGS, " : "") + 
			(flags & IN_EDITMODE != 0? "IN_EDITMODE, " : "") + 
			(flags & IS_VALID != 0? "IS_VALID, " : "")
		);
	}
	
	
	static inline public var DISPATCH_CHANGES_BEFORE_COMMIT		= RevertableBindableFlags.DISPATCH_CHANGES_BEFORE_COMMIT;
	static inline public var INVALID_CHANGES_DISPATCH_SIGNAL	= RevertableBindableFlags.INVALID_CHANGES_DISPATCH_SIGNAL;
	static inline public var UPDATE_BINDINGS_BEFORE_COMMIT		= RevertableBindableFlags.UPDATE_BINDINGS_BEFORE_COMMIT;
	static inline public var INVALID_CHANGES_UPDATE_BINDINGS	= RevertableBindableFlags.INVALID_CHANGES_UPDATE_BINDINGS;
	static inline public var IN_EDITMODE						= RevertableBindableFlags.IN_EDITMODE;
	static inline public var IS_VALID							= RevertableBindableFlags.IS_VALID;
}