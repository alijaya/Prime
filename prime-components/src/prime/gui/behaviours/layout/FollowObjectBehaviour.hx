

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
package prime.gui.behaviours.layout;
 import prime.signals.Wire;
 import prime.core.geom.Point;
 import prime.gui.behaviours.BehaviourBase;
 import prime.gui.core.IUIElement;
 import prime.layout.LayoutFlags;
 import prime.gui.traits.ILayoutable;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;



/**
 * Behaviour allows the target to follow the position of another UIElement, 
 * even when it's in a different display-container.
 * 
 * This behaviour is usefull for popups like the selectionmenu of the combobox.
 * The selectionmenu is placed on top of all other UIElements but should still
 * be above the combobox button (also when it changes its position).
 * 
 * On default, the behaviour will place the target-element on the left-top 
 * corner of the followed object, but by using the relative layout-properties
 * 
 * @author Ruben Weijers
 * @creation-date Jan 18, 2011
 */
class FollowObjectBehaviour extends BehaviourBase<IUIElement>
{
	public  var followedElement 		(default, set_followedElement) : IUIElement;
	
	private var followedLayoutBinding	: Wire<Dynamic>;
	private var containerLayoutBinding	: Wire<Dynamic>;
	private var targetLayoutBinding		: Wire<Dynamic>;
	
	
	public function new (target:IUIElement, followedElement:IUIElement)
	{
		super(target);
		this.followedElement = followedElement;
	}
	
	
	override private function init ()
	{
		if (followedElement != null)
			createFollowBindings();
		containerLayoutBinding	= checkChanges			.on( target.container.as(ILayoutable).layout.changed,	this );
		targetLayoutBinding		= checkTargetChanges	.on( target.layout.changed,								this );
		target.layout.includeInLayout = false;
		
		updateTarget.on( target.displayEvents.addedToStage, this );
		disableWires.on( target.displayEvents.removedFromStage, this );
		
		if (target.window == null)			disableWires();
		else if (followedElement != null)	updatePosition();
	}
	
	
	override private function reset ()
	{
		followedLayoutBinding	.dispose();
		containerLayoutBinding	.dispose();
		targetLayoutBinding		.dispose();
		
		var e = target.displayEvents;
		e.addedToStage.unbind( this );
		e.removedFromStage.unbind( this );
		followedElement = null;
	}


	private inline function removeFollowBindings () {
		followedElement.layout.changed.unbind(this);
	}


	private inline function createFollowBindings ()
	{
		Assert.isNotNull(followedElement, "followed-element can't be null for "+target);
		followedLayoutBinding = checkChanges.on( followedElement.layout.changed, this );
	}
	
	
	private function disableWires ()
	{
		followedLayoutBinding	.disable();
		containerLayoutBinding	.disable();
		targetLayoutBinding		.disable();
	}
	
	
	private function updateTarget ()
	{
		followedLayoutBinding	.enable();
		containerLayoutBinding	.enable();
		targetLayoutBinding		.enable();
		if (target.window != null)
			updatePosition();
	}
	
	
	/**
	 * Method will check the given layoutflags for position-changes. If the
	 * position is changed, it will update the position of the target
	 */
	private function checkChanges (changes:Int)
	{
		if (changes.has( LayoutFlags.POSITION | LayoutFlags.SIZE ))
			updatePosition();
	}
	
	
	/**
	 * Method is called when the targets layout is changed and will update
	 * its position if the relative properties or size is changed.
	 */
	private function checkTargetChanges (changes:Int)
	{
		if (changes.has( LayoutFlags.SIZE | LayoutFlags.RELATIVE ))
			updatePosition.onceOn( target.displayEvents.enterFrame, this );		//FIXME: wait one frame, otherwise the width/height is possibly applied wrong
	}
	
	
	private function updatePosition ()
	{
		Assert.isNotNull(target.window, target+"");
		
		var layout		= target.layout;
		var bounds		= layout.outerBounds;
		var follow		= followedElement.layout.innerBounds;
		var relative	= layout.relative;
		var newPos		= new Point( followedElement.x, followedElement.y );
		
		if (bounds.width == 0 || bounds.height == 0)
			return;
		
		if (relative != null)
		{
			if		(relative.left.isSet())		newPos.x += relative.left;
			else if (relative.right.isSet())	newPos.x += follow.width - relative.right;
			else if (relative.hCenter.isSet())	newPos.x += ((follow.width - bounds.width) >> 1) + relative.hCenter;
			
			if		(relative.top.isSet())		newPos.y += relative.top;
			else if (relative.bottom.isSet())	newPos.y += follow.height - relative.bottom;
			else if (relative.vCenter.isSet())	newPos.y += ((follow.height - bounds.height) >> 1) + relative.vCenter;
		}
		
		followedLayoutBinding.disable();
		targetLayoutBinding.disable();
		bounds.invalidatable = false;
#if (flash9 || nme)
		newPos 				= followedElement.container.localToGlobal( newPos );
		var windowBounds	= target.window.as(ILayoutable).layout.innerBounds;
		
		bounds.left	= newPos.x.roundFloat();
		bounds.top	= newPos.y.roundFloat();
		bounds.stayWithin( windowBounds );
		
		newPos.x	= bounds.left;
		newPos.y	= bounds.top;
		newPos		= target.container.globalToLocal( newPos );
#end
		target.y = bounds.top	= newPos.y.roundFloat();
		target.x = bounds.left	= newPos.x.roundFloat();
		
		bounds.invalidatable = true;
		followedLayoutBinding.enable();
		targetLayoutBinding.enable();
	}


	private function set_followedElement (v:IUIElement)
	{
		if (v != followedElement) {
			if (initialized) {
				if (followedElement != null) {	removeFollowBindings();		disableWires(); }
				followedElement = v;
				if (followedElement != null) {	createFollowBindings();		updateTarget(); }
			} else
				followedElement = v;
		}
		return v;
	}
}