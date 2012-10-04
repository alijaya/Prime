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
package primevc.gui.core;
#if (flash9 && stats)
 import net.hires.debug.Stats;
#end
 import primevc.core.geom.Rectangle;
 import primevc.core.Bindable;

 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.VirtualLayoutContainer;

 import primevc.gui.managers.InvalidationManager;
 import primevc.gui.managers.RenderManager;
 import primevc.gui.managers.ToolTipManager;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;

#if flash9
 import primevc.core.collections.SimpleList;
 import primevc.gui.display.VectorShape;
#end


/**
 * UIWindow acts as a container for display objects and 
 * determines their layout. 
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIWindow extends primevc.gui.display.Window		
	,	implements primevc.core.traits.IIdentifiable
	,	implements primevc.gui.managers.ISystem
	,	implements primevc.gui.traits.IBehaving
	,	implements primevc.gui.traits.IDrawable
	,	implements primevc.gui.traits.ILayoutable
	,	implements primevc.gui.traits.IStylable
	, 	implements primevc.gui.traits.IScrollable
{
	public var layout				(default, null)					: LayoutClient;
	
	/**
	 * variable 'layout' casted as LayoutContainer. The 'layout' is meant for
	 * the children of window except for popups.
	 */
	public var layoutContainer		(getLayoutContainer, never)		: LayoutContainer;
	public var scrollableLayout		(getScrollableLayout, never)	: IScrollableLayout;
	public var isScrollable											: Bool;
	
	/**
	 * Top layout-container, only containing 'layout' and 'popupLayout'.
	 */
	public var topLayout			(default, null)					: LayoutContainer;
	/**
	 * Layoutcontainer for popups.
	 */
	public var popupLayout			(default, null)					: LayoutContainer;
	
	
	
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
	
	public var style				(default, null)					: primevc.gui.styling.UIElementStyle;
	public var styleClasses			(default, null)					: SimpleList<String>;
	public var stylingEnabled		(default, setStylingEnabled)	: Bool;
#end
	
	public var invalidation			(default, null)					: InvalidationManager;
	public var rendering			(default, null)					: RenderManager;
	public var popups				(getPopupManager, null)			: primevc.gui.managers.IPopupManager;
	public var toolTip				(default, null)					: ToolTipManager;
	
	
	public function new (target:primevc.gui.display.Stage, id:String = null)
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
		
		behaviours.add( new primevc.gui.behaviours.layout.WindowLayoutBehaviour(this) );
		behaviours.add( new primevc.gui.behaviours.RenderGraphicsBehaviour(this) );
		
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

#if (flash9 && stats)
		children.add( new Stats() );
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
		topLayout	=	#if flash9	new primevc.avm2.layout.StageLayout( target );
						#else		new LayoutContainer();	#end
		
		layout		= new VirtualLayoutContainer( #if debug "contentLayout" #end );
		popupLayout	= new VirtualLayoutContainer( #if debug "popupLayout" #end );
		layout.invalidatable 	= popupLayout.invalidatable = false;
		
		popupLayout.algorithm	= new primevc.gui.layout.algorithms.RelativeAlgorithm();
		layout.percentWidth		= layout.percentHeight = popupLayout.percentWidth = popupLayout.percentHeight = 1.0;
		layout.invalidatable 	= popupLayout.invalidatable = true;

		topLayout.children.add( layout );
		topLayout.children.add( popupLayout );
	//	layoutContainer.algorithm = new RelativeAlgorithm();
	}
	
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createBehaviours ()	: Void
	{
	//	behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
#if flash9
		target.stageFocusRect = false;
#end
	}
	
	
	private function createChildren ()		: Void {}
	
	public inline function attach 			(child:IUIElement)          : UIWindow { child.attachLayoutTo(layoutContainer).attachToDisplayList(this); return this; }
	public inline function attachDisplay 	(child:IUIElement)          : UIWindow { child.attachToDisplayList(this);                                 return this; }
	public inline function attachLayout 	(layout:LayoutClient)       : UIWindow { layoutContainer.attach(layout);                                  return this; }
	public inline function changeDepthOf	(child:IUIElement, pos:Int)	: UIWindow { child.changeDepth(pos);                                          return this; }


	//
	// ISCROLLABLE
	//

	public inline function scrollToX     	(x:Float) : Void	{ var r = target.scrollRect; r.x = x; target.scrollRect = r; }
	public inline function scrollToY     	(y:Float) : Void	{ var r = target.scrollRect; r.y = y; target.scrollRect = r; }
    public inline function scrollTo         (x:Float, y:Float)  { var r = target.scrollRect; r.x = x; r.y = y; target.scrollRect = r; }

	public inline function applyScrollX   	() : Void			{ scrollToX( layoutContainer.scrollPos.x ); }
	public inline function applyScrollY   	() : Void			{ scrollToY( layoutContainer.scrollPos.y ); }

    public inline function setClippingSize	(w:Float, h:Float) 	{ var r = target.scrollRect; r.width = w; r.height = h; target.scrollRect = r; }
    public inline function createScrollRect (w:Float, h:Float)	{ isScrollable = true;  target.scrollRect	= new Rectangle(0,0, w, h); }
    public inline function removeScrollRect () 					{ isScrollable = false; target.scrollRect	= null; }

    public inline function getScrollRect    ()                  { return target.scrollRect; }
    public inline function setScrollRect    (v:Rectangle)       { return target.scrollRect = v; }


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
        if (changes.hasNone( primevc.gui.layout.LayoutFlags.SIZE ))
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
	
	public inline function isDisposed ()			{ return displayEvents == null; }
	private inline function getLayoutContainer ()	{ return layout.as(LayoutContainer); }
	private inline function getScrollableLayout () 	{ return layout.as(IScrollableLayout); }
	private inline function getPopupManager ()		{ if (popups == null) { popups = new primevc.gui.managers.PopupManager(this); } return popups; }
	
	
#if flash9
	private function setStylingEnabled (v:Bool)
	{
		if (v != stylingEnabled)
		{
			if (stylingEnabled) {
				style.dispose();
				style = null;
			}
			
			stylingEnabled = v;
			if (v) {
				style = new primevc.gui.styling.ApplicationStyle(this, this);
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