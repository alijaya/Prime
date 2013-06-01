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
 import prime.core.traits.IDisposable;
 import prime.utils.DuplicateUtil;
  using prime.utils.FastArray;
  using prime.utils.TypeUtil;
  using Std;

typedef FastArray<T> =
	#if flash10		flash.Vector<T>
	#else			Array<T>;
	#end


/**
 * Class provides some additional methods for a FastArray
 * 
 * @author			Ruben Weijers
 * @author			Danny Wilson
 */
#if flash10 extern #end class FastArrayUtil
{
	#if (flash10 && no_inline) "[!] ERROR Flash 10 Vectors require inlining!" #end
	static public inline function create<T>(?size:UInt = 0, ?fixed:Bool = false) : FastArray<T>
	{
#if flash10
		return new flash.Vector<T>(size, fixed);
#elseif flash
		return untyped __new__(Array, size);
#elseif neko
		return untyped Array.new1(neko.NativeArray.alloc(size), size);
#elseif cpp
		return new Array<T>();
#elseif js
		// if size is the constant value 0, only [] will be inlined at the call site.
		return if (size == 0) [] else (untyped Array)(size);
#end
	}
	
	static public inline function toVector<T> ( array:Array<T> ) : FastArray<T> return ofArray(array); 		//alias for ofArray
	static public inline function ofArray<T>  ( array:Array<T> ) : FastArray<T>
	{
	#if flash10
		return flash.Vector.ofArray(array);
	#else
		return array;
	#end
	}
	
#if !flash10
	static public inline function indexOf<T> ( list:FastArray<T>, item:T, ?startPos:Int = 0 ) : Int
	{
		var pos:Int = -1;
		var l		= list.length;
		for (i in startPos...l) {
			if (list[i] == item) {
				pos = i;
				break;
			}
		}
		return pos;
	}
#end
	
	
	static public #if flash10 inline #end function insertAt<T>( list:FastArray<T>, item:T, pos:Int ) : Int
	{
		var newPos:Int	= 0;
		var len			= list.length.int();
		if (pos < 0 || pos == len)
		{
			newPos = list.push( item ) - 1;
		}
		else
		{
			if (pos > len)
				pos = len;
			
			//move all items in the list one place down
			var i = len;
			while ( i > pos ) {
				list[i] = list[i - 1];
				i--;
			}
			
			list[pos] = item;
			newPos = pos;
		}
		return newPos;
	}


	static public #if flash10 inline #end function validateNewIndex<T>( list:FastArray<T>, pos:Int ) : Int
		return pos < 0 || pos > list.length.int() ? list.length : pos;


	static public inline function add<T>( list:FastArray<T>, item:T ) : T
	{
		list.push(item);
		return item;
	}
	
	
	static public #if flash10 inline #end function move<T>( list:FastArray<T>, item:T, newPos:Int, curPos:Int = -1 ) : Bool
	{
		if (curPos == -1)
			curPos = list.indexOf(item);
		
		var len = list.length.int();
#if debug
		if (newPos > len)	throw "Moving from " + curPos + " to position "+newPos+", but it is bigger then the list length ("+len+")..";
		if (curPos < 0)		throw "Item is not part of list so cannot be moved";
#end
		if (newPos > len)
			newPos = len;
		
		if (curPos != newPos)
		{
			if (curPos > newPos) {
				var i = curPos;
				while ( i > newPos )
					list[i] = list[--i];
				
				list[newPos] = item;
			} else {
				for (i in curPos...newPos)
					list[i] = list[i + 1];
				
				list[newPos] = item;
			}
		}
		return curPos != newPos;
	}
	
	
	static public inline function swap<T> (list:FastArray<T>, item1:T, item2:T ) : Void
	{
		if (!list.has(item1))		throw "item1 "+item1+" is not in list";
		if (!list.has(item2))		throw "item2 "+item2+" is not in list";
		
		var item1Pos:Int = list.indexOf( item1 );
		var item2Pos:Int = list.indexOf( item2 );
		list[ item1Pos ] = item2;
		list[ item2Pos ] = item1;
	}
	
	
	static public inline function removeItem<T> (list:FastArray<T>, item:T) : Bool {
		return removeAt(list, list.indexOf(item));
	}
	
	
	static public inline function removeAt<T> (list:FastArray<T>, pos:Int) : Bool {
		
		if		(pos == 0)						list.shift();
		else if	(pos == (list.length.int() - 1))list.pop();
		else if (pos > 0)						list.splice(pos, 1);
		return pos >= 0;
	}
	
	
	public static inline function removeAll<T> (list:FastArray<T>) : FastArray<T>
	{
#if (php || cpp)
		list.splice(0, list.length);
#else
	#if flash10	Assert.not(list.fixed); #end
		(untyped list).length = 0;
#end
		/*var l = list.length;
		while (l-- > 0)
			list.pop();
		*/
		return list;
	}
	
	
	public static inline function dispose<T> (list:FastArray<T>) : Void {
		var l = list.length;
		while (l-- > 0) {
			var i = list.pop();
			if (i.is(IDisposable))
				i.as(IDisposable).dispose();
		}
	}
	
	
	static public inline function has<T>( list:FastArray<T>, item:T ) : Bool	{ return list.indexOf( item ) >= 0; }


	static public inline function last<T> ( list:FastArray<T> ) : T 			{ return list.length == 0 ? null : list[list.length - 1]; }
	static public inline function first<T> ( list:FastArray<T> ) : T 			{ return list.length == 0 ? null : list[0]; }


#if flash10
	/** Alias for arr.clone() */
	static public inline function copy<T> ( arr:FastArray<T> ) : FastArray<T>
	{
		return arr.concat();
	}
#end	
	
	/**
	 * Clone will generate a new FastArray with the same children as the given
	 * fast-array
	 */
	static public inline function clone<T> ( arr:FastArray<T> ) : FastArray<T>
	{
		return #if flash10 arr.concat(); #else arr.copy(); #end
	}
	
	
	/**
	 * Duplicate will create a new FastArray. The content of the given
	 * FastArray are also duplicated if possible
	 * 
	 * Note: Inline is needed to create a Vector with the same datatype as 
	 * 		the original. Without 'inline', a Vector<String> will be duplicated
	 * 		to Vector<Object>
	 */
	static public inline function duplicate<T> ( arr:FastArray<T> ) : FastArray<T>
	{
		var l = arr.length;
		var n:FastArray<T> = FastArrayUtil.create(l);
		for (i in 0...l)
			n[i] = DuplicateUtil.duplicateItem( arr[i] );
		
		return n;
	}
	
	
	static public inline function asArrayOf<A,B> ( arr:FastArray<A>, type:Class<B> ) : FastArray<B>
	{
		return #if flash10 flash.Vector.convert(arr) #else untyped arr #end;
	}
	
	
#if debug
	static public inline function asString<T>( list:FastArray<T> ) : String
	{
		var items:FastArray<String> = FastArrayUtil.create();
		var i = 0;
		for (item in list) {
			items.push( "[ " + i + " ] = " + item );
			i++;
		}
		return "FastArray ("+items.length+")\n" + items.join("\n");
	}
#end
	
/*	
	public static inline function insert<T> ( list:FastArray<T>, arg0:T, ?arg1:T, ?arg2:T, ?arg3:T, ?arg4:T, ?arg5:T, ?arg6:T, ?arg7:T, ?arg8:T, ?arg9:T, ?arg10:T, ?arg11:T )
	{
		list.push( arg0 );
		
		if (arg1 != null) {
			list.push(arg1);
			if (arg2 != null)
			{
				list.push(arg2);
				if (arg3 != null)
				{
					list.push(arg3);
					if (arg4 != null)
					{
						list.push(arg4);
						if (arg5 != null)
						{
							list.push(arg5);
							if (arg6 != null)
							{
								list.push(arg6);
								if (arg7 != null)
								{
									list.push(arg7);
									if (arg8 != null)
									{
										list.push(arg8);
										if (arg9 != null)
										{
											list.push(arg9);
											if (arg10 != null)
											{
												list.push(arg10);
												if (arg11 != null)
													list.push(arg11);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	*/
}