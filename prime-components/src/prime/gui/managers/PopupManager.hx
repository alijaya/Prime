

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
 import prime.gui.core.IUIComponent;
 import prime.gui.core.UIComponent;
 import prime.gui.core.UIWindow;
 import prime.utils.FastArray;
  using prime.utils.Bind;
  using prime.utils.FastArray;



/**
 * @author Ruben Weijers
 * @creation-date Jan 17, 2011
 */
class PopupManager implements IPopupManager 
{
	private var window	: UIWindow;
	public  var modal	(default, null) : UIComponent;	//can't be a UIGraphic since it needs to block mouse clicks
	
	/**
	 * List of all popups who also want a modal. If a new popup is opened above
	 * the current popup, the modal will move one level up.
	 */
	private var modalPopups	: FastArray<IUIComponent>;
	
	
	
	public function new (window:UIWindow)
	{
		modalPopups	= FastArrayUtil.create();
		this.window = window;
	}
	
	
	public function dispose ()
	{
		modalPopups.removeAll();
		modalPopups = null;
		window = null;
	}
	
	
	
	/**
	 * Method will open the given popup on the forground of the window
	 * @return 	index of the popup in the displaylist
	 */
	public #if !noinline inline #end function add (popup:IUIComponent, modal:Bool = false) : Int
	{
		var isFirst = window.popupLayout.children.length == 0;
		Assert.isNull( popup.window );
		Assert.isNull( popup.layout.parent );
		window.popupLayout.children.add( popup.layout );
	//	popup.visible = false;

		popup.setFocus.onceOn( popup.displayEvents.addedToStage, this );	// this way (instead of calling popup.setFocus directly) the popup can override the focus behaviour
		popup.attachToDisplayList( window );
		
		if (modal)
			createModalFor(popup);
	
	//	popup.show();
	//	popup.setFocus();
		
		if (isFirst)
			window.userEvents.key.disable();
		
		return window.children.length - 1;
	}
	
	
	public #if !noinline inline #end function remove (popup:IUIComponent)
	{
		Assert.isNotNull( popup.window );
		Assert.isNotNull( popup.layout.parent );
		popup.detach();
	//	popup.removeFocus();
		removeModalFor( popup );
		
		if (window.popupLayout.children.length == 0)
			window.userEvents.key.enable();
	}
	
	
	
	
	private function createModalFor (popup:IUIComponent)
	{
		if (modal == null) {
			modal = new UIComponent("modal");
			#if (!cpp || !nme) modal.tabEnabled = false; #end
		}
		
		if (modal.window == null)
		{
			window.popupLayout.children.add( modal.layout );
			modal.attachToDisplayList( window );
		}

		moveModalBgBehind( popup );
		modalPopups.push( popup );
	}
	
	
	private function removeModalFor (popup:IUIComponent)
	{
		var index = modalPopups.indexOf(popup);
		if (index > -1)
		{
			modalPopups.removeItem(popup);
			
			//keep the modalbackground if there are more modal-popups open
			if (modalPopups.length > 0)		moveModalBgBehind( modalPopups.last() );
			else							modal.detach();
		}
	}
	
	
	private inline function moveModalBgBehind (popup:IUIComponent)
	{
		window.children.move( modal, window.children.indexOf(popup) );
	}
}