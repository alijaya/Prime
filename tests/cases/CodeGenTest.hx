package cases;
 import prime.core.traits.IUIdentifiable;
 import prime.tools.generator.CodeGenerator;
 import prime.tools.generator.ICodeFormattable;
 import prime.tools.generator.ICodeGenerator;
 import prime.utils.StringUtil;


/**
 * @author Ruben Weijers
 * @creation-date Sep 14, 2010
 */
class CodeGenTest
{
	public static function main ()
	{
		var generator	= new CodeGenerator();
		var holder		= new Holder( new A("aap"), new B(5), new C(false), new B(9050) );
		holder.b.secret	= "The quick brown fox jumps over the lazy dog";
		var holder2		= new Holder( holder.a, null, holder.c, null );
		var holder3		= new Holder( null, holder.b, null, holder.d );
		var holders		= new HolderList();
		holders.children.add(holder);
		holders.children.add(holder2);
		holders.children.add(holder);
		holders.children.add(holder3);
		generator.generate(holders);
		generator.flush();
	}
}


class Base implements IUIdentifiable
{
	public var _oid (default, null)		: Int;
	public function new () { _oid = Std.random(prime.types.Number.Number.INT_MAX); }
}


class HolderList extends Base implements ICodeFormattable
{
	public var children : haxe.ds.GenericStack < Holder >;
	
	public function new ()
	{
		super();
		children = new haxe.ds.GenericStack<Holder>();
	}
	
	
	public function toCode (code:ICodeGenerator)
	{
		code.construct(this);
		for (child in children)
			code.setAction(this, "children.add", [child]);
	}

	/*
	 * Returns true when some values within the object are set, otherwise false
	 */
	public function isEmpty () : Bool
	{
		return false;
	}
	
	/**
	 * Method to remove empty properties from the object. This way, unused
	 * code will be removed.
	 */
	public function cleanUp () : Void
	{

	}
}


class Holder extends Base implements ICodeFormattable
{
	public var a (default, null)	: A;
	public var b (default, null)	: B;
	public var c (default, null)	: C;
	public var d (default, null)	: B;
	
	
	public function new (?a:A, ?b:B, ?c:C, ?d:B)
	{
		super();
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
	}
	

	public function toCode (code:ICodeGenerator) : Void
	{
		code.construct( this, [ a, b, c, d ] );
	}

	/*
	 * Returns true when some values within the object are set, otherwise false
	 */
	public function isEmpty () : Bool
	{
		return false;
	}
	
	/**
	 * Method to remove empty properties from the object. This way, unused
	 * code will be removed.
	 */
	public function cleanUp () : Void
	{

	}
}




class A extends Base implements ICodeFormattable
{
	public var value (default, null) : String;
	
	
	public function new (val:String)
	{
		super();
		value = val;
	}
	
	
	public function toCode (c:ICodeGenerator) : Void
	{
		c.construct( this, [ value ] );
	}

	/*
	 * Returns true when some values within the object are set, otherwise false
	 */
	public function isEmpty () : Bool
	{
		return false;
	}
	
	/**
	 * Method to remove empty properties from the object. This way, unused
	 * code will be removed.
	 */
	public function cleanUp () : Void
	{

	}
}




class B extends Base implements ICodeFormattable
{
	public var value (default, null) : Int;
	public var secret : String;
	
	
	public function new (val:Int)
	{
		super();
		value = val;
	}


	public function toCode (c:ICodeGenerator) : Void
	{
		c.construct( this, [ value ] );
		c.setProp(this, "secret", secret);
	}

	/*
	 * Returns true when some values within the object are set, otherwise false
	 */
	public function isEmpty () : Bool
	{
		return false;
	}
	
	/**
	 * Method to remove empty properties from the object. This way, unused
	 * code will be removed.
	 */
	public function cleanUp () : Void
	{

	}
}




class C extends Base implements ICodeFormattable
{
	public var value (default, null)	: Bool;
	public var direction				: Direction;
	
	
	public function new (val:Bool, dir:Direction = null)
	{
		super();
		value		= val;
		direction	= dir == null ? horizontal(center) : dir;
	}
	

	public function toCode (c:ICodeGenerator) : Void
	{
		c.construct( this, [ value, direction ] );
	}

	/*
	 * Returns true when some values within the object are set, otherwise false
	 */
	public function isEmpty () : Bool
	{
		return false;
	}
	
	/**
	 * Method to remove empty properties from the object. This way, unused
	 * code will be removed.
	 */
	public function cleanUp () : Void
	{

	}
}


enum Direction	{ vertical (dir:Vertical); horizontal (dir:Horizontal); }
enum Horizontal	{ left; center; right; }
enum Vertical	{ top; center; bottom; }