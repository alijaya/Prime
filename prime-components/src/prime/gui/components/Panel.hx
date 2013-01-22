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
package primevc.gui.components;
 import primevc.core.geom.space.Horizontal;
 import prime.signal.Signal0;
 import primevc.core.Bindable;

 import primevc.gui.components.Form;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIContainer;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.managers.ISystem;



/**
 * Panel component will display a floating window with support for a title and
 * a close-btn. 
 * 
 * Components for title and the closeBtn will be created in the skin. The skin
 * will also add the behaviour to drag the panel around.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 14, 2011
 */
class Panel extends UIContainer
{
	public var title	(default, null) 		: Bindable<String>;
	
	/**
	 * Bottom layoutcontainer which can contain controls of the panel
	 */
	public var footer 	(default, null) 		: LayoutContainer;
	/**
	 * Container in which the real content for the panel can be placed.
	 */
	public var content	(default, setContent)	: IUIElement;

	public var closed 	(default, null) 		: Signal0;

	private var sys 	: ISystem;
	
	
	public function new (id:String = null, title:String = null, content:IUIElement = null, system:ISystem = null)
	{
		super(id);
		this.title		= new Bindable<String>(title);
		this.content	= content;
		sys 			= system;
		closed 			= new Signal0();
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		if (footer != null) {
			footer.dispose();
			footer = null;
		}

		super.dispose();
		
		closed.dispose();
		title .dispose();
		title	= null;
		sys 	= null;
		closed 	= null;
	}
	
	
	override private function createChildren ()
	{
		if (content != null)
			attach(content);
	}


	public #if !noinline inline #end function open ()		{ if (!isOnStage() ||  isDetaching()) { sys.popups.add(this, false); } }
	public #if !noinline inline #end function openModal()	{ if (!isOnStage() ||  isDetaching()) { sys.popups.add(this, true); } }
	public #if !noinline inline #end function close ()		{ if ( isOnStage() && !isDetaching()) { sys.popups.remove(this); closed.send(); } }


	public function addToFooter (b:IUIElement) : Void
	{
		if (footer == null) {
			footer = Form.createHorizontalRow( Horizontal.right );
			attachLayout( footer );
		}
		b.attachLayoutTo( footer ).attachToDisplayList( this );
	}


	private function setContent (v:IUIElement)
	{
		if (v != content)
		{
			if (v != null)
				v.id.value = "content";
			
			if (isInitialized()) {
				if (content != null)
					content.detach();
				
				if (v != null)
					content.attachTo(this);
			}
			content = v;
		}
		return v;
	}
}