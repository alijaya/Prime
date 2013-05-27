

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
 import prime.core.geom.Rectangle;
 import prime.bindable.Bindable;

 import prime.gui.behaviours.BehaviourList;
 import prime.gui.graphics.GraphicProperties;
 import prime.layout.IScrollableLayout;
 import prime.layout.LayoutContainer;
 import prime.layout.LayoutClient;
 import prime.layout.VirtualLayoutContainer;

 import prime.gui.managers.InvalidationManager;
 import prime.gui.managers.RenderManager;
 import prime.gui.managers.ToolTipManager;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.TypeUtil;

#if flash9
 import prime.bindable.collections.SimpleList;
 import prime.gui.display.VectorShape;
#end
#if debug
 import prime.gui.events.KeyboardEvents;
#end


/**
 * UIWindow acts as a container for display objects and 
 * determines their layout. 
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIWindow extends prime.gui.display.Window		
	,	implements prime.core.traits.IIdentifiable
	,	implements prime.gui.managers.ISystem
	,	implements prime.gui.traits.IBehaving
	,	implements prime.gui.traits.IDrawable
	,	implements prime.gui.traits.ILayoutable
	,	implements prime.gui.traits.IStylable
	, 	implements prime.gui.traits.IScrollable
{
	public var layout				(default, null)					: LayoutClient;
	
	/**
	 * variable 'layout' casted as LayoutContainer. The 'layout' is meant for
	 * the children of window except for popups.
	 */
	public var layoutContainer		(get_layoutContainer, never)	: LayoutContainer;
	public var scrollableLayout		(get_scrollableLayout, never)	: IScrollableLayout;
	public var isScrollable											: Bool;
	
	/**
	 * Top layout-container, only containing 'layout' and 'popupLayout'.
	 */
	public var topLayout			(default, null)					: LayoutContainer;
	/**
	 * Layoutcontainer for popups.
	 */
	public var popupLayout			(default, null)					: LayoutContainer;
	
#if embed_perceptor
	public var appLayout			(default, null) 				: LayoutContainer;
	public var perceptorLayout 		(default, null)					: LayoutContainer;
#end
	
	public var behaviours			(default, null)					: BehaviourList;
	public var id					(default, null)					: Bindable<String>;
	public var graphicData			(default, null)					: GraphicProperties;
	
#if flash9
	public var scaleX				: Float;
	public var scaleY				: Float;
	
	
	/**
	 * Shape to draw the background graphics in. Stage doesn't have a Graphics
	 * property.
	 */
	public var bgShape				: VectorShape;
	/**
	 * Reference to bgShape.graphics.. Needed for compatibility with IDrawable
	 */
	public var graphics				(default, null)					: flash.display.Graphics;
	
	public var style				(default, null)					: prime.gui.styling.UIElementStyle;
	public var styleClasses			(default, null)					: SimpleList<String>;
	public var stylingEnabled		(default, set_stylingEnabled)	: Bool;
#end
	
	public var invalidation			(default, null)					: InvalidationManager;
	public var rendering			(default, null)					: RenderManager;
	public var popups				(get_popups, null)				: prime.gui.managers.IPopupManager;
	public var toolTip				(default, null)					: ToolTipManager;
	
	
	public function new (target:prime.gui.display.Stage, id:String = null)
	{
		scaleX = scaleY = 1;
		super(target);
		
#if debug if (id == null) id = this.getReadableId(); #end
		this.id			= new Bindable<String>( id );
		rendering		= new RenderManager(this);
		invalidation	= new InvalidationManager(this);
		toolTip			= new ToolTipManager(this);
		behaviours		= new BehaviourList();
#if flash9		
		graphicData		= new GraphicProperties(rect);
		styleClasses	= new SimpleList<String>();
#end
		behaviours.add( new prime.gui.behaviours.layout.WindowLayoutBehaviour(this) );
		behaviours.add( new prime.gui.behaviours.RenderGraphicsBehaviour(this) );
		
		createBehaviours();
		createLayout();
#if flash9
		bgShape			= new VectorShape();
		graphics		= bgShape.graphics;
		children.add(bgShape);
		stylingEnabled	= true;
#end
		init();
	}
	
	
	private function init ()
	{
		layout.invalidatable = false;
		behaviours.init();
		createChildren();
#if debug 
		var debugBar = new prime.gui.components.DebugBar();
		function(ks:KeyboardState) { 
			if (ks.keyCode() == prime.gui.input.KeyCodes.KeyCodes.ESCAPE) { debugBar.isAttached() ? debugBar.detach() : attach(debugBar); }
		}.on(this.userEvents.key.up, this);
#end
#if (flash9 && stats)
		children.add( new net.hires.debug.Stats() );
#end

		layout.invalidatable = true;
	}


	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		behaviours		.dispose();
		layout			.dispose();
		invalidation	.dispose();
		rendering		.dispose();
		toolTip			.dispose();
		rect			.dispose();
		
#if flash9
		bgShape			.dispose();
		style			.dispose();
		styleClasses	.dispose();
		styleClasses	= null;
		style			= null;
		bgShape			= null;
#end
		
		if (layout != null)					layout		.dispose();
		if (graphicData != null)			graphicData	.dispose();
		if ((untyped this).popups != null)	popups		.dispose();
		
		behaviours		= null;
		graphicData		= null;
		layout			= null;
		invalidation	= null;
		rendering		= null;
		rect			= null;
		
		super.dispose();
	}
	
	
	private inline function createLayout ()
	{
		topLayout	=	#if flash9	new prime.avm2.layout.StageLayout( target );
						#else		new LayoutContainer();	#end
		
		layout		= new VirtualLayoutContainer( #if debug "stagecontentLayout" #end );
		popupLayout	= new VirtualLayoutContainer( #if debug "popupLayout" #end );
		layout.invalidatable 	= popupLayout.invalidatable = false;
		
#if embed_perceptor
		// use a seperate top level layout instead of adding to contentLayout
		// as no assumptions can be made about what layout algorithm contentLayout
		// will get and how it will behave
		perceptorLayout = new VirtualLayoutContainer("SplitAppPerceptorLayout");
		perceptorLayout.algorithm = new prime.layout.algorithms.float.HorizontalFloatAlgorithm( prime.core.geom.space.Horizontal.center, prime.core.geom.space.Vertical.center );

		appLayout = new VirtualLayoutContainer("SplitAppContentLayout");
		appLayout.algorithm	= new prime.layout.algorithms.RelativeAlgorithm();
		appLayout.percentWidth	= 0.7;
		appLayout.percentHeight = 1.0;
		perceptorLayout.percentWidth = 0.3;
		perceptorLayout.percentHeight = 1.0;
		topLayout.algorithm = new prime.layout.algorithms.float.HorizontalFloatAlgorithm( prime.core.geom.space.Horizontal.center, prime.core.geom.space.Vertical.center );
		//layout.as(LayoutContainer).algorithm = new prime.layout.algorithms.float.HorizontalFloatAlgorithm( prime.core.geom.space.Horizontal.center, prime.core.geom.space.Vertical.center );
#end
		
		popupLayout.algorithm	= new prime.layout.algorithms.RelativeAlgorithm();
		layout.percentWidth		= layout.percentHeight = popupLayout.percentWidth = popupLayout.percentHeight = 1.0;
		layout.invalidatable 	= popupLayout.invalidatable = true;

#if embed_perceptor
		appLayout.children.add( layout );
		appLayout.children.add( popupLayout );
		
		topLayout.children.add( appLayout );
		topLayout.children.add( perceptorLayout );
#else
		topLayout.children.add( layout );
		topLayout.children.add( popupLayout );
#end
	//	layoutContainer.algorithm = new RelativeAlgorithm();
	}
	
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createBehaviours ()	: Void
	{
	//	behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
#if flash9 target.stageFocusRect = false; #end
	}
	
	
	private function createChildren ()		: Void 
	{
#if embed_perceptor
		var i = new prime.perceptor.embedded.Inspector(this);
		i.attachLayoutTo( perceptorLayout );
		i.attachToDisplayList( this );
#end
	}
	
	public #if !noinline inline #end function attach        (child:IUIElement)          : UIWindow { child.attachLayoutTo(layoutContainer).attachToDisplayList(this); return this; }
	public #if !noinline inline #end function attachDisplay (child:IUIElement)          : UIWindow { child.attachToDisplayList(this);                                 return this; }
	public #if !noinline inline #end function attachLayout  (layout:LayoutClient)       : UIWindow { layoutContainer.attach(layout);                                  return this; }
	public #if !noinline inline #end function changeDepthOf (child:IUIElement, pos:Int)	: UIWindow { child.changeDepth(pos);                                          return this; }


	//
	// ISCROLLABLE
	//

	public #if !noinline inline #end function scrollToX     	(x:Float) : Void	{ var r = target.scrollRect; r.x = x; target.scrollRect = r; }
	public #if !noinline inline #end function scrollToY     	(y:Float) : Void	{ var r = target.scrollRect; r.y = y; target.scrollRect = r; }
    public #if !noinline inline #end function scrollTo         (x:Float, y:Float)  { var r = target.scrollRect; r.x = x; r.y = y; target.scrollRect = r; }

	public #if !noinline inline #end function applyScrollX   	() : Void			{ scrollToX( layoutContainer.scrollPos.x ); }
	public #if !noinline inline #end function applyScrollY   	() : Void			{ scrollToY( layoutContainer.scrollPos.y ); }

    public #if !noinline inline #end function setClippingSize	(w:Float, h:Float) 	{ var r = target.scrollRect; r.width = w; r.height = h; target.scrollRect = r; }
    public #if !noinline inline #end function createScrollRect (w:Float, h:Float)	{ isScrollable = true;  target.scrollRect	= new Rectangle(0,0, w, h); }
    public #if !noinline inline #end function removeScrollRect () 					{ isScrollable = false; target.scrollRect	= null; }

    public #if !noinline inline #end function getScrollRect    ()                  { return target.scrollRect; }
    public #if !noinline inline #end function setScrollRect    (v:Rectangle)       { return target.scrollRect = v; }


    public function enableClipping ()
    {
        createScrollRect( rect.width, rect.height);
        
        var s = layoutContainer.scrollPos;
        updateScrollRect.on( layoutContainer.changed, this );
        applyScrollX.on( s.xProp.change, this );
        applyScrollY.on( s.yProp.change, this );
    }


    public function disableClipping ()
    {
        var l = layoutContainer;
        l.changed.unbind(this);
        l.scrollPos.xProp.change.unbind( this );
        l.scrollPos.yProp.change.unbind( this );
        removeScrollRect();
    }


    private function updateScrollRect (changes:Int)
    {
        if (changes.hasNone( prime.layout.LayoutFlags.SIZE ))
            return;
        
        var r = getScrollRect();
        r.width  = rect.width;
        r.height = rect.height;
        
        if (graphicData.border != null)
        {
            var border = graphicData.border.weight;
            var layout = layoutContainer;
            r.x        = layout.scrollPos.x - border;
            r.y        = layout.scrollPos.y - border;
            r.width   += border * 2;
            r.height  += border * 2;
        }
        setScrollRect(r);
    }

	
	
	//
	// GETTERS / SETTERS
	//
	
	public #if !noinline inline #end function isDisposed ()	{ return displayEvents == null; }
	private inline function getLayoutContainer ()			{ return layout.as(LayoutContainer); }
	private inline function getScrollableLayout () 			{ return layout.as(IScrollableLayout); }
	private inline function getPopupManager ()				{ if (popups == null) { popups = new prime.gui.managers.PopupManager(this); } return popups; }
	
	
#if flash9
	private function set_stylingEnabled (v:Bool)
	{
		if (v != stylingEnabled)
		{
			if (stylingEnabled) {
				style.dispose();
				style = null;
			}
			
			stylingEnabled = v;
			if (v) {
				style = new prime.gui.styling.ApplicationStyle(this, this);
				style.updateStyles();
			}
		}
		return v;
	}
#end


#if debug
	public function toString ()
	{
		return id.value;
	}
#end
}