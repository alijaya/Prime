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
 import primevc.core.geom.Rectangle;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * Container class without data.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class UIContainer extends UIComponent, implements IUIContainer
{
    public function new (id:String = null)
    {
        layout = new LayoutContainer();
        super(id);
    }


    public var layoutContainer  (get_layoutContainer, never)    : LayoutContainer;
    public var scrollableLayout (get_scrollableLayout, never)   : IScrollableLayout;
    public var isScrollable                                     : Bool;
	
	private inline function get_layoutContainer ()     									{ return layout.as(LayoutContainer); }
	private inline function get_scrollableLayout () 									{ return layout.as(IScrollableLayout); }
	public  inline function attach			(child:IUIElement)			: IUIContainer	{ child.attachTo(this);             return this; }
	public  inline function changeDepthOf	(child:IUIElement, pos:Int)	: IUIContainer	{ child.changeDepth(pos);           return this; }
    public  inline function attachDisplay   (child:IUIElement)          : IUIContainer  { child.attachDisplayTo(this);      return this; }
	public  inline function attachLayout	(layout:LayoutClient)		: IUIContainer	{ layoutContainer.attach(layout);   return this; }
    


    //
    // ISCROLLABLE
    //

    public #if !noinline inline #end function scrollToX        (x:Float) : Void    { var r = scrollRect; r.x = x; scrollRect = r; }
    public #if !noinline inline #end function scrollToY        (y:Float) : Void    { var r = scrollRect; r.y = y; scrollRect = r; }
    public #if !noinline inline #end function scrollTo         (x:Float, y:Float)  { var r = scrollRect; r.x = x; r.y = y; scrollRect = r; }

    public #if !noinline inline #end function applyScrollX     ()        : Void    { scrollToX( layoutContainer.scrollPos.x ); }
    public #if !noinline inline #end function applyScrollY     ()        : Void    { scrollToY( layoutContainer.scrollPos.y ); }
    
    public #if !noinline inline #end function setClippingSize  (w:Float, h:Float)  { var r = scrollRect; r.width = w; r.height = h; scrollRect = r; }
    public #if !noinline inline #end function createScrollRect (w:Float, h:Float)  { isScrollable = true;  scrollRect = new Rectangle(0,0, w, h); }
    public #if !noinline inline #end function removeScrollRect ()                  { isScrollable = false; scrollRect = null; }
    public #if !noinline inline #end function getScrollRect    ()                  { return scrollRect; }
    public #if !noinline inline #end function setScrollRect    (v:Rectangle)       { return scrollRect = v; }


    public function enableClipping ()
    {
        Assert.isNull(scrollRect, id.value);
        createScrollRect( layout.outerBounds.width, layout.outerBounds.height);
        
        var s = layoutContainer.scrollPos;
        updateScrollRect.on( layoutContainer.changed, this );
        applyScrollX.on( s.xProp.change, this );
        applyScrollY.on( s.yProp.change, this );
    }


    public function disableClipping ()
    {
        Assert.notNull(scrollRect, id.value);
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
        r.width  = layout.outerBounds.width;
        r.height = layout.outerBounds.height;
        
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
}