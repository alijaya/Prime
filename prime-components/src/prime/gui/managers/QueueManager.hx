

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
package prime.gui.managers;
 import prime.gui.traits.IValidatable;
 import prime.gui.display.Window;
  using prime.utils.Bind;


/**
 * Base class for managers who work with a queue like InvalidationManager and
 * RenderManager.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class QueueManager implements prime.core.traits.IDisposable implements IValidatable
{	
	/**
	 * Reference to the object that owns the object
	 */
	private var owner				: Window;
	private var first				: IValidatable;
	private var last				: IValidatable;
	private var isValidating		: Bool;

	private var finalInvalidatable 	: FinalInvalidatable;
	
	
	public function new (owner:Window)
	{
		validateQueue.on( owner.displayEvents.render, this );
		this.owner		= owner;
		isValidating	= false;

		finalInvalidatable = new FinalInvalidatable(this);
	}
	
	
	public function dispose ()
	{
		while (last != null)
		{
			var obj = last;
			last = last.prevValidatable;
			obj.nextValidatable = obj.prevValidatable = null;
		}
		
		first	= null;
		owner	= null;
	}
	
	
	//
	// VALIDATION METHODS
	//
	private function validateQueue ()			{ Assert.abstractMethod(); }
	
	
	
	/**
	 * Adds an obj to the end of the queue with objects
	 */
	public function add ( obj:IValidatable )
	{
		//if the invalidated object is the first in the list, it's probably 
		//invalidated during its own validation. To make sure the object is valid
		//it will be removed from the queue and then added at the end of the 
		//queue.
		if (isValidating && obj == first && obj != last)
			remove(obj);
		
		//only add the object if it's not in the list yet
	//	else if (obj.prevValidatable == null && first != null && obj == first)
	//		return;
			
	//	else if (obj.nextValidatable == null && last != null && obj == last)
	//		return;
		
	//	else if (obj.prevValidatable != null && obj.prevValidatable == last)
	//		return;
		
		else if (obj.isQueued())
			return;
			
//#if debug	if (obj.prevValidatable == null)	Assert.isEqual( obj, first, obj + "" );
//			if (obj.nextValidatable == null)	Assert.isEqual( obj, last, obj + "" ); #end
//			return;
		
		if (first == null)
		{
			first = obj;
			obj.prevValidatable = this;
			obj.nextValidatable = last;
			owner.invalidate();
		}
		else
		{
			last.nextValidatable	= obj;
			obj.prevValidatable		= last;
		}
		
		last = obj;

		if ( !finalInvalidatable.isQueued() && obj != finalInvalidatable )
		{
			add( finalInvalidatable );
		}

		//checkList();
	}
	
	private function checkList()
	{
		var curCell = first;
		while (curCell != null)
		{
			if ( curCell == first && curCell != last )
			{
				Assert.that( curCell.prevValidatable == this || curCell.prevValidatable == null );
				Assert.that( curCell.nextValidatable != null );
			}
			if ( curCell != first && curCell == last )
			{
				Assert.that( last.prevValidatable != this );
				Assert.that( last.prevValidatable != null );
				Assert.that( last.nextValidatable == null );
			}

			if ( curCell != first && curCell != last )
			{
				Assert.that( curCell.prevValidatable != null );
				Assert.that( curCell.nextValidatable != null );
			}
			curCell	= curCell.nextValidatable;
		}
	}
	
	/**
	 * Removed an object from the queue with objects
	 */
	public function remove ( obj:IValidatable )
	{
		var next = obj.nextValidatable;
		var prev = obj.prevValidatable;
		if (prev == this) prev = null;

		obj.nextValidatable = obj.prevValidatable = null;

		if (obj  == first) first = next;
		if (obj  == last ) last  = prev;
		if (prev != null ) prev.nextValidatable = next;
		if (next != null ) next.prevValidatable = prev;
	}
	
	
	//
	// IVALIDATABLE IMPLEMENTATION
	//
	
	//properties are only here to make the manager also an IValidatable
	public var prevValidatable		: IValidatable;
	public var nextValidatable		: IValidatable;
	public #if !noinline inline #end function isOnStage ()		{ return true; }
	public #if !noinline inline #end function isQueued ()		{ return true; }
	
	
#if debug
	/**
	 * flag indicating if the traceQueue method should trace anything.
	 * @default false
	 */
	public var traceQueues : Bool;
	
	
	public function traceQueue ()
	{
		if (!traceQueues) return;
		
		var curCell = first;
		var i = 0;
		var s = "\n\t\t\tlistQueue; isValidating? "+isValidating;
		while (curCell != null)
		{
			s += "\n\t\t\t\t\t\t\t[ "+i+" ] = "+curCell;
			s += "\n\t\t\t\t\t\t\t\t\t\t[ "+i+" ].prevValidatable = "+curCell.prevValidatable;
			curCell	= curCell.nextValidatable;
			i++;
		}
		s += "\n\t\t\tqueue length: "+i;
		trace(s);
	}
	
	
	public function toString () { return "QueueManager"; }
#end
}


/**
 * This class fixes a bug when an IValidatable object is last in the queue and invalidates again (IValidatable will point to themselves) 
 * and they cause something else to invalidate (now the current IValidatable will point to the new final), overwritting their spot in the queue.
 * 
 * See the tests\cases\InvalidationTest
 *
 * NOTE: This bug is only fixed for prime.gui.managersRenderManager and prime.gui.managers.InvalidationManager, currently the only
 * classes to extend QueueManager
 *
 * @author Andrew Pahuru
 * @creation-date Sep 29, 2013
 */
private class FinalInvalidatable implements prime.gui.traits.IGraphicsValidator implements prime.gui.traits.IPropertyValidator
{
	public var prevValidatable		: IValidatable;
	public var nextValidatable		: IValidatable;
	
	private var  manager 			: QueueManager;

	public function new( manager : QueueManager ) { this.manager = manager; }

	public function isOnStage () : Bool { return false; };
	public function isQueued () : Bool 
	{ 
		return nextValidatable != null || prevValidatable != null; 
	};
	
	public function invalidateGraphics () : Void {}

	/**
	 * If nothing else is queued do nothing. Else keep invalidating until this object is the only thing queued.
	 */
	public function validateGraphics ()	: Void
	{
		if ( nextValidatable != null )
		{
			manager.add( this );
		}
	}

	/**
	 * If nothing else is queued do nothing. Else keep invalidating until this object is the only thing queued.
	 */
	public function validate ()	: Void
	{	
		//trace("FINAL");
		if ( nextValidatable != null )
		{
			//trace("READDING");
			manager.add( this );
		}
	}
}