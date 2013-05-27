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
package prime.gui.styling;
 import prime.bindable.collections.iterators.IIterator;
 import prime.bindable.collections.PriorityList;
 import prime.bindable.collections.FastDoubleCell;
 import prime.core.traits.IInvalidatable;
 import prime.core.traits.IInvalidateListener;
 import prime.core.traits.IDisposable;
  using prime.utils.BitUtil;
  using prime.utils.TypeUtil;
#if debug
  using Type;
#end



/**
 * Base class for style-proxys
 * 
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
//#if (flash9 || cpp) @:generic #end
class StyleCollectionBase <StyleGroupType:StyleSubBlock> implements IInvalidateListener
{
	/**
	 * Flag with all the style-declaration-properties that are defined for 
	 * the stylesheet.target.
	 */
	public var filledProperties		(default, null)	: Int;
	
	/**
	 * Bit-flag from StyleFlags indicating which property is searched in this 
	 * proxy.
	 */
	public var propertyTypeFlag		(default, null)	: Int;
//	public var change				(default, null)	: Signal1 < Int >;
	
	private var elementStyle		: UIElementStyle;
	
	/**
	 * Cached iterator that is only used to update the filled properties flag.
	 * Since this operation happens quite frequent, the iterator is cached.
	 */
	private var groupIterator		: StyleCollectionForwardIterator < StyleGroupType >;
	private var groupRevIterator	: StyleCollectionReversedIterator < StyleGroupType >;
	public  var changes				: Int;
	
	
	public function new (elementStyle:UIElementStyle, propertyTypeFlag:Int)
	{
		changes					= 0;
		this.elementStyle		= elementStyle;
		this.propertyTypeFlag	= propertyTypeFlag;
		filledProperties		= 0;
		groupIterator			= forwardIterator();
		groupRevIterator		= reversedIterator();
	}
	
	
	public function dispose ()
	{
		groupIterator.dispose();
		groupRevIterator.dispose();
		
		groupRevIterator	= null;
		groupIterator		= null;
		elementStyle		= null;
	}
	
	
	public #if !noinline inline #end function has (properties:Int) : Bool
	{
		return filledProperties.has(properties);
	}
	
	
	public function updateFilledPropertiesFlag (?excludedStyle:StyleGroupType) : Void
	{	
		Assert.isNotNull( groupIterator );
		filledProperties = 0;
		groupIterator.rewind();
		
		//loop through every stylegroup that has the defined StyleGroupType
		if (elementStyle.styles.length > 0)
			for (styleGroup in groupIterator)
				if (styleGroup != excludedStyle)
					filledProperties = filledProperties.set( styleGroup.allFilledProperties );
	}
	
	
	public function invalidateCall ( changeFromSender:Int, sender:IInvalidatable ) : Void
	{
		changes = changes.set( getRealChangesOf( cast sender, changeFromSender ) );
	//	trace("\tchanged properties " + readProperties(changes));
		apply();
	}
	

	public function add ( style:StyleGroupType ) : Int
	{
		Assert.isNotNull(style);
		if (isListeningTo(style))
			return 0;
		
		style.invalidated.bind( this, invalidateCall );

		var updatedProps = getRealChangesOf( style, style.allFilledProperties );
		if (updatedProps > 0) {
			changes				= changes.set( updatedProps );
			filledProperties	= filledProperties.set( updatedProps );
		}
		return updatedProps;
	}
	
	
	public function remove ( style:StyleGroupType, isStyleStillInList:Bool = true ) : Int
	{
		Assert.isNotNull(style);

		if (!style.invalidated.hasListener(this))
			return 0;
		else style.invalidated.unbind(this); //TODO: Optimize by getting unbind count from Signal
		
		updateFilledPropertiesFlag( style );	//exclude the to be removed style
		
		var updatedProps = isStyleStillInList ? getRealChangesOf( style, style.allFilledProperties ) : style.allFilledProperties;
		changes = changes.set(updatedProps);
		return updatedProps;
	}
	
	
	public function apply ()
	{
		Assert.abstractMethod();
	}


	private inline function isListeningTo (style:StyleGroupType) : Bool
	{
		return style.invalidated.hasListener(this);
	}
	
	
	/**
	 * Method returns the flags that are changed when the given style-group 
	 * was changed.
	 * 
	 * @example
	 * 		#aId.layout.width = 50;
	 * 		aComponent.layout.width = 40;
	 * 		aComponent.layout.height = 40;
	 * 
	 * Then the width of aComponent.layout changes:
	 * 		aComponent.layout.width = 60;
	 * 
	 * The width of #aId.layout has a higher priority so the real-changes for
	 * the IUIElement are none.
	 * 
	 * When the height of aComponent.layout would change, there is no style
	 * defined with a higher priority height, so the real-changes for the 
	 * IUIelement are 'height'.
	 */
	private function getRealChangesOf ( styleGroup:StyleGroupType, styleChanges:Int ) : Int
	{
		if (elementStyle.styles.length > 0)
		{
			var styleCell:FastDoubleCell<StyleBlock> = null;
			var iterator = groupRevIterator;
			
			iterator.rewind();
			while( iterator.hasNext() )
			{
				var cell = iterator.currentCell;
				if (iterator.next() == styleGroup) {
					styleCell = cell;
					break;
				}
			}
			
			Assert.that( styleCell != null );
			iterator.setCurrent( styleCell.prev );
			
			for (styleGroup in iterator)
			{
				styleChanges = styleChanges.unset( styleGroup.allFilledProperties );
				if (styleChanges == 0)
					break;
			}
		}
		
		return styleChanges;
	}
	
	
	
	public function iterator ()						: Iterator < StyleGroupType >							{ return forwardIterator(); }
	public function reversed ()						: Iterator < StyleGroupType >							{ return reversedIterator(); }
	public function forwardIterator ()				: StyleCollectionForwardIterator < StyleGroupType >		{ Assert.abstractMethod(); return null; }
	public function reversedIterator ()				: StyleCollectionReversedIterator < StyleGroupType >	{ Assert.abstractMethod(); return null; }
	
#if debug
	public function readProperties (props:Int = -1)	: String	{ Assert.abstractMethod(); return null; }
	public function readChanges (props:Int = -1)	: String	{ return readProperties(changes); }
	public function toString () : String						{ return this.getClass().getClassName(); }
#end
}



/**
 * Base class for style-group iterators. A style-group-iterator iterates over
 * the style-objects of a style sheet and returns the next style-group if it
 * is found in the style-object. Style-objects who don't have the searched
 * style-group, are skipped.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionIteratorBase implements IDisposable
{
	private var elementStyle	: UIElementStyle;
	public var currentCell		: FastDoubleCell<StyleBlock>;
	/**
	 * Flag to search for in target styles to see if the style contains the group
	 */
	private var flag		: Int;
	
	
	public function new (elementStyle:UIElementStyle, groupFlag:Int)
	{
		this.elementStyle	= elementStyle;
		flag				= groupFlag;
		rewind();
	}
	
	
	public function dispose ()
	{
		elementStyle	= null;
		flag			= 0;
		currentCell		= null;
	}
	
	
	public function rewind () : Void		{ Assert.abstractMethod(); }
	
	/**
	 * Method will set the current property to the next cell and will return 
	 * the previous current value.
	 */
	private function setNext() : FastDoubleCell<StyleBlock>	{ Assert.abstractMethod(); return null; }
	public  function hasNext () : Bool		{ return currentCell != null; }
	
	
	/*public function setCurrent(cur:FastDoubleCell<StyleBlock>)
	{
		currentCell = cur;
		if (cur != null && !cur.data.has(flag) && hasNext()) {
#if debug	Assert.notEqual(cur.next, cur); #end
			setNext();
		}
	}*/
	public function setCurrent(cur:Dynamic)
	{
		var cur = currentCell = cast cur;
		if (cur != null && !cur.data.has(flag) && hasNext()) {
#if debug	Assert.notEqual(cur.next, cur); #end
			setNext();
		}
	}
}



/**
 * Iterates forward over a styles prioritylist
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
//#if (flash9 || cpp) @:generic #end
class StyleCollectionForwardIterator <StyleGroupType> extends StyleCollectionIteratorBase implements IIterator < StyleGroupType >
{
	public function new (elementStyle:UIElementStyle, groupFlag:Int) super(elementStyle, groupFlag)	//FIXME: NEEDED FOR HAXE 2.09 (http://code.google.com/p/haxe/issues/detail?id=671)
	override public function rewind () : Void	{ setCurrent( elementStyle.styles.first ); }
	public function next () : StyleGroupType	{ Assert.abstractMethod(); return null; }
	public function value () : StyleGroupType	{ Assert.abstractMethod(); return null; }
	
	
	override private function setNext ()
	{
		var c = currentCell;
		setCurrent( currentCell.next );
		return c;
	}
	
	
#if (unitTesting && debug)
	public function new (elementStyle:UIElementStyle, groupFlag:Int)
	{
		super( elementStyle, groupFlag );
		test();
	}
	
	
	public function test ()
	{
		var cur = elementStyle.styles.first, prev:FastDoubleCell<StyleBlock> = null;
		while (cur != null)
		{
			if (prev == null)	Assert.isNull( cur.prev, "first incorrect" );
			else				Assert.isEqual( cur.prev, prev, "previous incorrect" );
			
			prev	= cur;
			cur		= cur.next;
		}
	}
#end
}


/**
 * Iterates backwards over styles prioritylist
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionReversedIterator < StyleGroupType > extends StyleCollectionIteratorBase
			,	implements IIterator < StyleGroupType >
//#if flash9	,	implements haxe.rtti.Generic #end
{
	public function new (elementStyle:UIElementStyle, groupFlag:Int) { super(elementStyle, groupFlag); }	//FIXME: NEEDED FOR HAXE 2.09 (http://code.google.com/p/haxe/issues/detail?id=671)
	override public function rewind () : Void	{ setCurrent( elementStyle.styles.last ); }
	public function next () : StyleGroupType	{ Assert.abstractMethod(); return null; }
	public function value () : StyleGroupType	{ Assert.abstractMethod(); return null; }
	
	
	override private function setNext ()
	{
		var c = currentCell;
		setCurrent( currentCell.prev );
		return c;
	}


#if (unitTesting && debug)
	public function new (elementStyle:UIElementStyle, groupFlag:Int)
	{
		super( elementStyle, groupFlag );
		test();
	}
	
	
	public function test ()
	{
		var cur = elementStyle.styles.last, prev:FastDoubleCell<StyleBlock> = null;
		while (cur != null)
		{
			if (prev == null)	Assert.isNull( cur.next, "last incorrect" );
			else				Assert.isEqual( cur.next, prev, "next incorrect" );

			prev	= cur;
			cur		= cur.prev;
		}
	}
#end
}