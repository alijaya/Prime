/****
* 
****/

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


/**
 * Collection of manager classes.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 17, 2011
 */
interface ISystem
{
#if !CSSParser
	
	/**
	 * Popup manager. IUIElements that are added to the popupmanager will
	 * stay on top of the normal content.
	 */
	public var popups		(getPopupManager, null)	: IPopupManager;
	
	/**
	 * Tooltip manager
	 */
	public var toolTip		(default, null)			: ToolTipManager;
	
	
	
	/**
	 * Render manager. Invalidated rendering objects will be validated when
	 * the FlashPlayer fires a RenderEvent.
	 */
	public var rendering	(default, null)			: RenderManager;
	
	/**
	 * Invalidation manager. Invalidated objects will be validated on the next
	 * 'enterFrame' event.
	 */
	public var invalidation	(default, null)			: InvalidationManager;
#end
}