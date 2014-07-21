/******************************************************************************
 * Shamelessly copied from the Caffeine-hx project and expanded a bit.        *
 * (thanks guys!)                                                             *
 ******************************************************************************
 * 
 * Copyright (c) 2011, The Caffeine-hx project contributors
 * Original author: Russell Weir
 * Contributors: Danny Wilson
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
 * THIS SOFTWARE IS PROVIDED BY THE CAFFEINE-HX PROJECT CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE CAFFEINE-HX PROJECT CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

import haxe.macro.Expr;
import haxe.macro.Context;
 using Type;

/**
 * A class of basic assertions macros that only generate code when the -debug
 * flag is used on the haxe compiler command line.
 *
 * If you get strange compiler errors like `Bool should be haxe.macro.Expr`,
 *  it means our "anti macro-in-macro" code got triggered, preventing you from accidentally destroying the compiler cache.
 **/
@:publicFields #if !macro extern #end class Assert
{
	/**
	* Asserts that first is equal to second
	* @param first Any expression that can test against second
	* @param second Any expression that can test against first
	**/
	#if !macro macro #end static function isEqual<T>( first:ExprOf<T>, second:ExprOf<T>, ?message:Expr ) : Expr
		return #if !display throwIf(first, OpNotEq, second, message) #else macro null #end;

	/**
	* Asserts that first is _not_ equal to second
	* @param first Any expression that can test against second
	* @param second Any expression that can test against first
	**/
	#if !macro macro #end static function notEqual<T>( first:ExprOf<T>, second:ExprOf<T>, ?message:Expr ) : Expr
		return #if !display throwIf(first, OpEq, second, message) #else macro null #end;

	/**
	* Asserts that expr evaluates not false
	* @param expr An expression that evaluates to a Bool
	**/
	#if !macro macro #end static function that  ( expr:Expr, ?message:Expr ) : Expr
		return #if !display throwIf(expr, null, macro !$expr, message) #else macro null #end;

	/**
	* Asserts that expr evaluates to true
	* @param expr An expression that evaluates to a Bool
	**/
	#if !macro macro #end static function isTrue( expr:ExprOf<Bool>, ?message:Expr ) : Expr
		return #if !display throwIf(expr, OpNotEq, macro true, message) #else macro null #end;

	/**
	* Asserts that expr evaluates not true
	* @param expr An expression that evaluates to a Bool
	**/
	#if !macro macro #end static function not    ( expr:ExprOf<Bool>, ?message:Expr ) : Expr
		return #if !display throwIf(macro !$expr, null, macro $expr, message) #else macro null #end;

	/**
	* Asserts that expr evaluates to false
	* @param expr An expression that evaluates to a Bool
	**/
	#if !macro macro #end static function isFalse( expr:ExprOf<Bool>, ?message:Expr ) : Expr
		return #if !display throwIf(expr, OpNotEq, macro false, message) #else macro null #end;

	/**
	* Checks that the passed expression is null.
	* @param expr A string, class or anything that can be tested for null
	**/
	#if !macro macro #end static function isNull   ( expr:Expr, ?message:Expr ) : Expr
		return #if !display throwIf(expr, OpNotEq, macro null, message) #else macro null #end;

	/**
	* Checks that the passed expression is not null.
	* @param expr A string, class or anything that can be tested for null
	**/
	#if !macro macro #end static function isNotNull( expr:Expr, ?message:Expr ) : Expr
		return #if !display throwIf(expr, OpEq, macro null, message) #else macro null #end;

	//
	// Prime additions
	//

	static inline public function isType(var1:Dynamic, type:Class<Dynamic>, ?pos:haxe.PosInfos) : Void
	{
	#if (debug && !display)
	  #if !macro
		Assert.isNotNull( var1, "To check the type of a variable it can't be null." );
		Assert.isNotNull( type, "The type of a variable can't be null." );
	  #end

		if (!Std.is(var1, type))
			throw "var of type '" + Type.getClass(var1).getClassName() + "' should be of type '" + type.getClassName() + "'";
	#end
	}

	static inline public function abstractMethod(msg:String = "", ?pos:haxe.PosInfos) : Void {
		#if debug sendError("Abstract method", msg, pos); #end
	}

	static inline private function sendError(error:String, msg:Dynamic, pos:haxe.PosInfos) : Void
	{
#if debug
		var className = pos.className.split(".").pop();
		var s = className + "." + pos.methodName + "()::" + pos.lineNumber + ": "+error + "; msg: " + Std.string(msg);
		trace(s);
	//#if flash9
	//	throw new Error(s);
	//#else
		throw s;
	//#end
#end
	}

#if (macro && !display)
	//
	// Macro implementations
	//

	static private var emptyExpr = macro null;

	private static function throwIf( first:Expr, assertCompareOp:Binop, second:Expr, message:ExprOf<String> ) : Expr
	{
		//var out = Assert.notMacro();
		var pos = Context.currentPos();

		if (Context.defined("macro")) throw "Don't use Assert from macro code, it will kill the compiler cache!";
		if (Context.defined("display") || !Context.defined("debug")) return emptyExpr;

		var secondIsConstant = assertCompareOp == null;
		var firstComp = macro
			$v{ new haxe.macro.Printer().printExpr(first) } + " (which is: `" + Std.string($i{"firstValue"}) + "`)" +
			$v{ secondIsConstant
					? ""
					: ((switch(assertCompareOp) {
						case OpEq:	" to not be `";
						case OpGt:	" < `";
						case OpGte:	" <= `";
						case OpLt:	" > `";
						case OpLte:	" >= `";
						default:    " to equal `";
					}) + new haxe.macro.Printer().printExpr(second) + "`")
			};

		var expectedValue = macro Std.string($firstComp);// + " to be: `" + Std.string($i{"secondValue"}) + "`";

		var throwExpr = macro throw new chx.lang.FatalException( ((untyped $message) != null? Std.string($message) : "") + " \n Expected:  " + $expectedValue + "\n at " + $v{Std.string(pos)});
		throwExpr.pos = pos;

		var ifExpr = macro {
		/*[0]*/var firstValue  = $first;
		/*[1]*/var secondValue = $second;
		/*[2]*/if (${secondIsConstant? second
		                             : { expr: EBinop(assertCompareOp, {expr:EConst(CIdent("firstValue")),  pos:pos}, 
		                                                               {expr:EConst(CIdent("secondValue")), pos:pos}),
		                                 pos: pos }})
				${{expr:throwExpr.expr, pos:pos}}
		}
		switch (ifExpr.expr) {
			case EBlock(exprs):
				exprs[0].pos = pos;
				if (secondIsConstant) ifExpr.expr = EBlock([ exprs[0], exprs[2] ]); // remove `var second` declaration.
			default: throw "impossible";
		}
		ifExpr.pos = pos;
		return ifExpr;
	}
#end
}
