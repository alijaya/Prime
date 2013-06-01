

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
package prime.gui.core;
#if (flash9 || nme)
 import flash.text.TextFieldAutoSize;
 import prime.bindable.collections.SimpleList;
 import prime.gui.styling.UIElementStyle;
#end
 import prime.signals.Wire;
 import prime.bindable.Bindable;
 
 import prime.gui.behaviours.layout.ValidateLayoutBehaviour;
 import prime.gui.behaviours.BehaviourList;
 import prime.gui.display.IDisplayContainer;
 import prime.gui.display.IInteractiveObject;
 import prime.gui.display.TextField;
 import prime.gui.effects.UIElementEffects;
 import prime.layout.ILayoutContainer;
 import prime.layout.AdvancedLayoutClient;
 import prime.layout.LayoutClient;
 import prime.layout.LayoutFlags;
 import prime.gui.managers.ISystem;
 import prime.fsm.states.ValidateStates;
 import prime.gui.states.UIElementStates;
 import prime.gui.traits.ITextStylable;
 import prime.gui.traits.IValidatable;
 import prime.types.Number;
  using prime.gui.utils.UIElementActions;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;


/**
 * TextField with IUIElement implementation.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class UITextField extends TextField implements IUIElement
{
	public static #if !noinline inline #end function createLabelField (id:String = null, data:Bindable<String> = null, owner:ITextStylable = null, injectedLayout:AdvancedLayoutClient = null) : UITextField
	{
		var f = new UITextField( #if debug id #else null #end, injectedLayout == null, data, injectedLayout );	//FIXME: stylingEnabled doesn't always have to be true..
#if (flash9 || nme)
		f.selectable	 = false;
		f.mouseEnabled	 = false;
		#if !cpp f.tabEnabled = false; #end

		if (owner != null)
		{
			f.wordWrap	 = owner.wordWrap;
			f.embedFonts = owner.embedFonts;

			if (owner.textStyle != null)
				f.textStyle = owner.textStyle;
			
			if (owner.is(IInteractiveObject))
				f.respondToFocusOf( owner.as(IInteractiveObject) );
		}
#end	return f;
	}


	public var prevValidatable	: IValidatable;
	public var nextValidatable	: IValidatable;
	private var changes			: Int;
	
	public var id				(default, null)					: Bindable < String >;
	public var behaviours		(default, null)					: BehaviourList;
	public var effects			(default, default)				: UIElementEffects;
	public var layout			(default, null)					: LayoutClient;
	public var system			(get_system, never)				: ISystem;
	public var state			(default, null)					: UIElementStates;

	private var validateWire		: Wire<Dynamic>;
//	private var updateSizeWire		: Wire<Dynamic>;
	private var hasInjectedLayout	: Bool;

#if (flash9 || nme)
	public var style			(default, null)					: UIElementStyle;
	public var styleClasses		(default, null)					: SimpleList<String>;
	public var stylingEnabled	(default, set_stylingEnabled)	: Bool;
#end
	
	/**
	 * @param injectedLayout
	 * 			LayoutClient of a wrapper object to optimize textfield-wrappers that will only contain 1 layout-client.
	 */
	public function new (id:String = null, stylingEnabled:Bool = true, data:Bindable<String> = null, injectedLayout:AdvancedLayoutClient = null)
	{
#if debug
	if (id == null)
		id = this.getReadableId();
#end
		this.id				= new Bindable<String>(id);
		super(data);
#if (flash9 || nme)
		styleClasses		= new SimpleList<String>();
		this.stylingEnabled	= stylingEnabled;
#end
		visible				= false;
		changes				= 0;
		state				= new UIElementStates();
		behaviours			= new BehaviourList();
		
		//add default behaviour
		init.onceOn( displayEvents.addedToStage, this );

		hasInjectedLayout = injectedLayout != null;
		if (hasInjectedLayout) {
			layout = injectedLayout;
			applyInjectedLayout.on(injectedLayout.changed, this);
		}
		else
		{
			behaviours.add( new ValidateLayoutBehaviour(this) );
			if (layout == null)
				layout = new AdvancedLayoutClient();
		}
		
		
		createBehaviours();
		state.current = state.constructed;
	}


	override public function dispose ()
	{
		if (isDisposed())
			return;
		
	//	if (updateSizeWire != null) 						{ updateSizeWire.dispose(); updateSizeWire = null; }
		if (validateWire != null)							{ validateWire.dispose(); 	validateWire = null; }
		if (container != null)								{ detachDisplay(); }
		if (!hasInjectedLayout && layout.parent != null)	{ detachLayout(); }
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		removeValidation();
		behaviours.dispose();
		id.dispose();
		state.dispose();
		
		if (!hasInjectedLayout && layout != null) {
			layout.dispose();
			layout = null;
		}

#if (flash9 || nme)
		if (style != null && style.target == this)
			style.dispose();
		
		styleClasses.dispose();
		styleClasses	= null;
		style			= null;
#end
		
		id				= null;
		state			= null;
		behaviours		= null;
		super.dispose();
	}
	
	
	public #if !noinline inline #end function isDisposed ()	{ return state == null || state.is(state.disposed); }
	public #if !noinline inline #end function isInitialized ()	{ return state != null && state.is(state.initialized); }
	public function isResizable ()			{ return true; }
	
	
	//
	// ATTACH METHODS
	//
	
	public  inline function attachLayoutTo		(t:ILayoutContainer, pos:Int = -1)	: IUIElement	{ if (!hasInjectedLayout) 	 { t.children.add( layout, pos ); }				return this; }
	public  inline function detachLayout		()									: IUIElement	{ if (layout.parent != null) { layout.parent.children.remove( layout ); }	return this; }
	public  inline function attachTo			(t:IUIContainer, pos:Int = -1)		: IUIElement	{ attachLayoutTo(t.layoutContainer, pos);	attachToDisplayList(t, pos);	return this; }
	private inline function applyDetach			()									: IUIElement	{ detachDisplay();							detachLayout();					return this; }
	public  inline function changeLayoutDepth	(pos:Int)							: IUIElement	{ layout.parent.children.move( layout, pos );								return this; }
	public  inline function changeDepth			(pos:Int)							: IUIElement	{ changeLayoutDepth(pos);					changeDisplayDepth(pos);		return this; }
	

	public  /*inline*/ function attachToDisplayList (t:IDisplayContainer, pos:Int = -1)	: IUIElement
	{
		//	if (container != t)
	//	{
			var wasDetaching = isDetaching();
			if (wasDetaching) {
				effects.hide.ended.unbind(this);
				effects.hide.stop();
			}
			
			attachDisplayTo(t, pos);
			var hasEffect = effects != null && effects.show != null;
			var isPlaying = hasEffect && effects.show.isPlaying();
			
			if (!hasEffect && !visible)
				visible = true;
			
			else if (hasEffect && !isPlaying)
			{
				if (!wasDetaching)
					visible = false;
				
				if (!isInitialized()) 	haxe.Timer.delay( show, 100 ); //.onceOn( displayEvents.enterFrame, this );
				else 					effects.playShow();
			}
	//	}
		
		return this;
	}


	public  function detach () : IUIElement
	{
		if (effects != null && effects.isPlayingShow())
			effects.show.stop();
		
		var hasEffect = effects != null && effects.hide != null;
		var isPlaying = hasEffect && effects.hide.isPlaying();

		if (!isPlaying)
		{
			if (hasEffect) {
				var eff = effects.hide;
			//	layout.includeInLayout = false;	@see UIComponent.detach
				applyDetach.onceOn( eff.ended, this );
				effects.playHide();
			}
			else
				applyDetach();
		}

		return this;
	}


	public #if !noinline inline #end function isDetaching () 				{ return effects != null && effects.isPlayingHide(); }
	public #if !noinline inline #end function isAttached () 				{ return window  != null; }



	//
	// METHODS
	//

	private function init ()
	{
		visible = true;
		behaviours.init();

	//	updateSizeWire	= displayEvents.enterFrame  .observeDisabled( this, updateSize );
		validateWire 	= displayEvents.addedToStage.observeDisabled( this, validate );

		validate();
		removeValidation.on( displayEvents.removedFromStage, this );
	//	applyTextFormat	.on( displayEvents.addedToStage, this );
		
		state.current = state.initialized;
	}
	
	
	public #if !noinline inline #end function setHtmlText (v:String) : Void
	{
		if (v == null)
			v = "";
		
		htmlText = v;
		invalidate( UIElementFlags.TEXT );
	//	layout.invalidate( LayoutFlags.WIDTH | LayoutFlags.HEIGHT );
	//	updateSize.onceOn( layout.state.change, this );
	}
	
	
#if (flash9 || nme)
	override private function set_textStyle (v)
	{
	//	Assert.isNotNull(v);
		
		invalidate( UIElementFlags.TEXTSTYLE );
		textStyle = v;
		
		if (v != null)
			defaultTextFormat = v;
		
		if (window == null)
			return v;
		
		//Invalidate layout and apply the textformat when the layout starts validating
		//This will prevend screen flickering.
	//	layout.invalidate( LayoutFlags.WIDTH | LayoutFlags.HEIGHT );
		
		return v; 
	}
	
	
	override private function applyTextFormat ()
	{
		super.applyTextFormat();
		updateSize(); //Wire.enable();
	}
	
	
	private function set_stylingEnabled (v:Bool)
	{
		if (v != stylingEnabled)
		{
			if (stylingEnabled) {
				style.dispose();
				style = null;
			}
			
			stylingEnabled = v;
			if (stylingEnabled)
				style = new UIElementStyle(this, this);
		}
		return v;
	}
#end
	
	
	
	
	private inline function get_system () : ISystem		{ return window.as(ISystem); }
#if (flash9 || nme)
	public #if !noinline inline #end function isOnStage () : Bool			{ return stage != null; }			// <-- dirty way to see if the component is still on stage.. container and window will be unset after removedFromStage is fired, so if the component gets disposed on removedFromStage, we won't know that it isn't on it.
#else
	public #if !noinline inline #end function isOnStage () : Bool			{ return window != null; }
#end
	public #if !noinline inline #end function isQueued () : Bool			{ return nextValidatable != null || prevValidatable != null; }
	
	//
	// IPROPERTY-VALIDATOR METHODS
	//
	
	public function invalidate (change:Int)
	{
		if (change != 0)
		{
			changes = changes.set( change );
			
			if (changes == change && isInitialized())
				if (system != null)		system.invalidation.add(this);
				else					validateWire.enable();
		}
	}
	
	
	public function validate ()
	{
	    if (validateWire != null)
	        validateWire.disable();
        
		if (changes.has( UIElementFlags.TEXTSTYLE ))
			applyTextFormat();
		
		else if (changes.has( UIElementFlags.TEXT ))	// only update size when the TextStyle hasn't changed, since changing the TextStyle will also cause the textfield to update its size
			updateSize();
		
		changes = 0;
	}
	
	
	/**
	 * method is called when the object is removed from the stage or disposed
	 * and will remove the object from the validation queue.
	 */
	private function removeValidation () : Void
	{
		if (isQueued() &&isOnStage())
			system.invalidation.remove(this);
			
		if (!isDisposed() && changes > 0)
			validate.onceOn( displayEvents.addedToStage, this );
	}
	
	
	
	
	//
	// ACTIONS (actual methods performed by UIElementActions util)
	//

	public #if !noinline inline #end function show ()						{ this.doShow(); }
	public #if !noinline inline #end function hide ()						{ this.doHide(); }
	public #if !noinline inline #end function move (x:Int, y:Int)			{ this.doMove(x, y); }
	public #if !noinline inline #end function resize (w:Int, h:Int)		{ this.doResize(w, h); }
	public #if !noinline inline #end function rotate (v:Float)				{ this.doRotate(v); }
	public #if !noinline inline #end function scale (sx:Float, sy:Float)	{ this.doScale(sx, sy); }
	
	
	private function createBehaviours ()	: Void		{}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateSize ()
	{
		if ((multiline || wordWrap) && layout.isInvalidated()) {
			updateSize.onceOn( displayEvents.enterFrame, this );
			return;
		}
		var l = layout.as(AdvancedLayoutClient);
	#if !html5 //FIXME
		if (l.measuredWidth  == l.width) 	scrollH = 0;
		if (l.measuredHeight == l.height) 	scrollV = 1;
	#end
	//	updateSizeWire.disable();
		l.invalidatable  = false;
		l.measuredWidth	 = realTextWidth .roundFloat();
		l.measuredHeight = realTextHeight.roundFloat();
		l.invalidatable  = true;

#if (flash9 || nme)
		if (multiline && l.isChanged())
			updateWordWrap.onceOn( l.changed, this );
#end
		
	//	trace(this+" - "+e+": ps: "+l.percentWidth+", "+l.percentHeight+"; ms: "+l.measuredWidth+", "+l.measuredHeight+"; s: "+l.width+", "+l.height+"; es: "+l.explicitWidth+"; "+l.explicitHeight+"; size: "+autoSize);

		if (this.isOnStage() && l.parent == null && l.changes != 0)
			l.validate();
	}


	private function applyInjectedLayout (changes:Int)
	{
		Assert.that(hasInjectedLayout);
		var layout = layout.as(AdvancedLayoutClient);
		if (changes.has(LayoutFlags.SIZE))
		{
			width  = layout.width;
			height = layout.height;
		}

		if (changes.has(LayoutFlags.PADDING))
		{
			x = layout.padding.left;
			y = layout.padding.top;
		}
	}


#if (flash9 || nme)
	private function updateWordWrap ()
	{
		Assert.that(multiline);
		wordWrap = layout.as(AdvancedLayoutClient).explicitWidth.isSet();
	//	autoSize = l.measuredWidth == l.width ? flash.text.TextFieldAutoSize.LEFT : flash.text.TextFieldAutoSize.NONE;	// <-- textfield will also adjust its height == not desirable
			
	}
#end
	
	
#if debug
	override public function toString()		{ return id.value; }
	public function readChanges()			{ return UIElementFlags.readProperties(changes); }
#end
}