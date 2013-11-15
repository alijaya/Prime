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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package prime.bindable.collections;
 import haxe.ds.GenericStack;
 import prime.bindable.collections.iterators.IIterator;
 import prime.core.events.ListChangeSignal;
  using prime.utils.FastArray;
  using prime.utils.IfUtil;
  using prime.utils.Bind;

/*
abstract ReadOnlyArrayListTools<T>(ReadOnlyArrayList<T>) from ReadOnlyArrayList<T> to ReadOnlyArrayList<T> {

	inline function new(a:ReadOnlyArrayList<T>)
		this = a;

    @:arrayAccess public inline function arrayAccess(key:Int) : T {
        return this.getItemAt(key);
    }
}
*/

/**
 * IReadOnlyList implementation with vector in flash10 and otherwise an array.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
//@:generic
class ReadOnlyArrayList<T> implements IReadOnlyList<T>
{
	public var beforeChange	(default, null)		: ListChangeSignal<T>;
	public var change		(default, null)		: ListChangeSignal<T>;
	public var list			(default, null)		: FastArray<T>;
	public var length		(get_length, never)	: Int;
	
	public var array		(get_array,null)	: FastArray<T>;
 		inline function get_array() : FastArray<T> return #if x_flash10 flash.Vector.convert(list) #else list #end;
	
    @:arrayAccess public inline function arrayAccess(key:Int) : T {
        return this.getItemAt(key);
    }

	public function new( wrapAroundList:FastArray<T> = null )
	{
		change 		 = new ListChangeSignal();
		beforeChange = new ListChangeSignal();
		
		if (wrapAroundList.isNull())
			list = FastArrayUtil.create();
		else
		 	list = wrapAroundList;
	}
	
	
	public function dispose ()
	{
		beforeChange.dispose();
		change.dispose();
		list	= null;
		change	= beforeChange = null;
	}
	
	
	public function clone () : IReadOnlyList<T>
	{
		return new ReadOnlyArrayList<T>( list.clone() );
	}
	
	
	public function duplicate () : IReadOnlyList<T>
	{
		return new ReadOnlyArrayList<T>( list.duplicate() );
	}
	
	
	@:keep private inline function get_length ()						return list.length;
	@:keep public  inline function iterator () : Iterator<T>			return forwardIterator();
	@:keep public  inline function forwardIterator () : IIterator<T>	return new prime.bindable.collections.iterators.FastArrayForwardIterator<T>(list);
	@:keep public  inline function reversedIterator () : IIterator<T>	return new prime.bindable.collections.iterators.FastArrayReversedIterator<T>(list);


	public #if !noinline inline #end function disableEvents ()					{ beforeChange.disable(); change.disable(); }
	public #if !noinline inline #end function enableEvents ()					{ beforeChange.enable();  change.enable(); }
	
	public #if !noinline inline #end function asIterableOf<B> ( type:Class<B> ) : Iterator<B>
	{
		#if debug for (i in 0 ... list.length) Assert.isType(list[i], type); #end
		return cast forwardIterator();
	}
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	@:keep public #if !noinline inline #end function getItemAt (pos:Int) : T
	{
		Assert.that(pos >= 0, pos+"");
	//	var i:Int = pos < 0 ? length + pos : pos;
		return list[pos];
	}
	
	
	@:keep public #if !noinline inline #end function indexOf (item:T) : Int
	{
		return list.indexOf(item);
	}
	
	
	@:keep public #if !noinline inline #end function has (item:T) : Bool
	{
		return list.indexOf(item) >= 0;
	}
	
	
	/**
	 * Method will remove the items from this list and inject the values of 
	 * the other list into this list. Changes in the otherList after injection
	 * will not be noticed by this list..
	 */
	public function inject (otherList:FastArray<T>)
	{
		this.list = otherList;
		change.send( ListChange.reset );
	}




	//
	// PAIRING / BINDING WITH OTHER LISTS
	//

	/**
	 * Keeps track of which lists are updating this list
	 */
	private var boundTo : GenericStack<ReadOnlyArrayList<T>>;
	/**
	 * Keeps track of which lists should be updated when this list changes
	 */
	private var writeTo : GenericStack<ReadOnlyArrayList<T>>;



	/**
	 * Makes sure this.value is (and remains) equal
	 * to otherList.
	 *	
	 * In other words, update this when otherList changes.
	 */
	@:keep public #if !noinline inline #end function bind (other:ReadOnlyArrayList<T>)
	{
		other.keepUpdated(this);
	}

	
	/**
	 * @see IBindableReadonly
	 */
	public function unbind (other:ReadOnlyArrayList<T>)
	{
		Assert.isNotNull(other);
		Assert.notEqual(other, this);
		
		var removed = false;
		if (writeTo.notNull()) 	{ 
			removed = this.writeTo.remove(other);
			if (removed) {
				beforeChange.unbind( other );
				change.unbind( other );
			}
		}
		if (boundTo.notNull()) 	removed = this.boundTo.remove(other) || removed;
		if (removed)			other.unbind(this);
		
		return removed;
	}
	
	
	/**
	 * Will remove every binding to lists which update this object, or which this object updates.
	 */
	public function unbindAll ()
	{
		if (writeTo.notNull()) while (!writeTo.isEmpty())	writeTo.pop().unbind(this);
		if (boundTo.notNull()) while (!boundTo.isEmpty())	boundTo.pop().unbind(this);
	}



	
	@:keep private inline function registerBoundTo(other:ReadOnlyArrayList<T>)
	{
		Assert.isNotNull(other);
		
		var b = this.boundTo;
		if (b.isNull())
			b = this.boundTo = new GenericStack<ReadOnlyArrayList<T>>();
		
		addToBoundList(b, other);
	}
	
	
	@:keep private inline function addToBoundList<T>(list:GenericStack<T>, other:T)
	{
		Assert.isNotNull(list);
		
		// Only bind if not already bound.
		var n = list.head;
		while (n.notNull())
		 	if (n.elt == other) { list = null; break; } // already bound, skip add()
			else n = n.next;
		
		if (list.notNull())
			list.add(other);
	}
	
	
	/**
	 * @see IBindableReadonly
	 */
	private function keepUpdated (other:ReadOnlyArrayList<T>)
	{
		Assert.isNotNull(other);
		Assert.notEqual(other, this);
		
		other.list = list.clone();
		other.beforeChange.send.on( beforeChange, other );
		other.applyChanges.on( change, other );
		(untyped other).registerBoundTo(this);
		
		var w = this.writeTo;
		if (w.isNull())
			w = this.writeTo = new GenericStack<ReadOnlyArrayList<T>>();
		
		addToBoundList(w, other);
	}


	private function applyChanges (c:ListChange<T>) : Void
	{
		switch (c) {
			case added(   item, newPos ):			list.insertAt(item, newPos);
			case removed( item, oldPos ):			list.removeAt(oldPos);
			case moved(   item, newPos, oldPos ):	list.move(item, newPos, oldPos);
			case reset:								list.removeAll();	
		}
		change.send(c);
	}


	
	
#if debug
	public var name : String;
	
	public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return name + "ArrayList ("+items.length+")\n" + items.join("\n");
	}
#end
}