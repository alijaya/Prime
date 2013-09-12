/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ onlinetouch.nl>
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package prime.utils;
#if macro
 import prime.utils.MacroUtils;
 import haxe.macro.Expr;
 import haxe.macro.Context;
#end
  using Type;

private typedef Is_both_A_and_B<A, B, C : (A,B)> = C;
typedef Both<A, B> = Is_both_A_and_B<A,B,Dynamic>;

#if !macro extern #end class TypeUtil
{
	/**
	 * Optimized simple instanceof check. Compiles to bytecode or Useful to quickly check if an object implements some interface.
	 *  
	 * Warning: Use Std.is() for checking enums and stuff.
	 */
	static public inline function is(o:Dynamic, t:Class<Dynamic>) : Bool
	{
		#if flash9
			return untyped __is__(o, t);
		#elseif flash
			return untyped __instanceof__(o, t);
		#elseif js {
			return Std.is(o, t);
		//	var __o = o, __t = t;
		//	return untyped __js__("__o instanceof __t");
		}
		#else
			return Std.is(o, t);
		#end
	}
	
	
	#if macro
	static public function withTypeParameters(type : haxe.macro.Type) : haxe.macro.Type return switch(type)
	{
		case TMono (t): withTypeParameters(t.get());
		case TLazy (f): TLazy(function() return withTypeParameters( f() ));
	//	case TAbstract (t:Ref<AbstractType>, params:Array<Type>):
	//	case TEnum (t:Ref<EnumType>, params): withTypeParameters(t.get(), params);
		case TInst (t, knownParams):
			var klass  = t.get();

			switch (klass.kind)
			{
				case KTypeParameter(constraints):
					if (knownParams.length > 0) throw "Huh?!";
					switch(constraints.length) {
						case 0: TDynamic(null);
						case 1: constraints[0];
						case n: throw "multiple constraints not yet implemented";
					}
				case _:
					var params = klass.params;
				//	trace(klass);
					if (params.length == 0) type; else {
						//trace("params: " + params);
						var p0 = params[0];
						if (p0 != null) switch(p0.t) {
							case TInst(tp,p): //trace('tp = ${tp.get()}, p = ${p}');

							case _:
						}

						TInst(t, params.map(function(p) return withTypeParameters(p.t)));
					}
			}

		//case TType (t:Ref<DefType>, params:Array<Type>):
		//case TFun (args:Array<{t:Type, opt:Bool, name:String}>, ret:Type):
		//case TAnonymous (a:Ref<AnonType>):
		//case TDynamic (t:Null<Type>):
		case _: type;
	}
	#end

	/**
	 * Simple cast to a type without the need (or ability) to supply type parameters.
	 *
	 *	Example:
	 *		```
	 *		interface A {}
	 *		class B<T : A>{ var inner : T; }
	 *		something.as(B).inner
	 *		```
	 *	gets typed exactly as `A`, as the type parameter is inferred from the constraint.
	 *
	 *		```
	 *		class C<T>{ var inner : T; }
	 *			something.as(C).inner
	 *		```
	 *	gets typed as Dynamic.
	 */
	static public macro function as<T>(o:ExprOf<Dynamic>, targetClass:ExprOf<Class<T>>) : ExprOf<T>
	{
		//trace(targetClass);
		var type = Context.typeof(targetClass);
		//trace("type: " + type + ", complex: " + Context.toComplexType(type));

		var elemType = switch(Context.toComplexType(type)) {
			// This gets the T out of Class<T> – seems using ComplexType is the only way to do it
			case TPath({params: [TPType(t = TPath(p))]}):
				// now t is T
				var realType = Context.getType(MacroTypeUtil.fullName(p));
				var constrainedType = withTypeParameters(realType);
				if (constrainedType != null && constrainedType != realType) {
					var comp = Context.toComplexType(constrainedType);
					//trace(type + "constrainedType: "+comp);
					comp;
				}
				else{
					//trace(type +"not constrained: "+t);
					t;
				}


			case _: throw "impossible";
		}
		var e = macro { var tmp : $elemType = untyped $o;
						tmp; };
		e.pos = Context.currentPos();
		return e;
	}
	/*
		Haxe 3.0 unfortunately loses some type information
		 that Haxe 2.11 didn't.

		```
		interface A {}
		class B<T : A>{ var inner : T; }
		```
		In Haxe 2.11:
			something.as(B).inner
		would be at least type `A`

		In haxe 3.0:
			something.as(B).inner
		gets typed as Unknown<0>.

		This results in AVM2 not finding methods, as it is
		treated by haxe as Dynamic/untyped.
	// * /
	static public inline function as<T>(o:Dynamic, t:Class<T>) : T
	{
	  #if cpp
		var tmp:T = cast o;
		return tmp;
	  #else
		return cast o;
	  #end
	}
	// */

	
	static public inline function className (o:Dynamic) : String
	{
		return o == null ? null : o.getClass().getClassName();
	}
}


#if debug
class IDUtil
{
	private static var objCounter : Int = 0;
	
	public static inline function getReadableId (obj:Dynamic) : String
	{
		return Type.getClass( obj ).getClassName().split(".").pop() + objCounter++;
	}
}	
#end


/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
extern class IntTypeUtil
{
	public static inline function int (v:Bool) : Int
	{
		return v ? 1 : 0;
	}
}



/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
extern class FloatTypeUtil
{
	public static inline function float (v:Bool) : Float
	{
		return v ? 1.0 : 0.0;
	}
}