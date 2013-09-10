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
 *  Ruben Weijers   <ruben @ onlinetouch.nl>
 */
package prime.gui.core;
 import prime.signals.Wire;
 import prime.bindable.Bindable;
 import prime.gui.behaviours.BehaviourList;
 import prime.gui.display.BitmapData;
 import prime.gui.display.IDisplayContainer;
 import prime.layout.ILayoutContainer;
 import prime.layout.AdvancedLayoutClient;
 import prime.gui.managers.ISystem;
 import prime.gui.effects.UIElementEffects;
 import prime.gui.states.UIElementStates;
#if (prime_css && (flash9 || nme))
 import prime.bindable.collections.SimpleList;
 import prime.gui.styling.UIElementStyle;
#end
 import prime.gui.traits.IValidatable;
 import prime.types.Number;
 import prime.utils.Formulas;
  using prime.gui.utils.UIElementActions;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Jul 08, 2011
 */
class UIBitmap extends prime.gui.display.BitmapShape implements IUIElement
{
    @borrowed public var prevValidatable  : IValidatable;
    @borrowed public var nextValidatable  : IValidatable;
    @borrowed public var effects          : UIElementEffects;

    private var changes         : Int;
    
    
    public var behaviours       (default, null)                 : BehaviourList;
    public var id               (default, null)                 : Bindable<String>;
    public var state            (default, null)                 : UIElementStates;
    
    public var layout           (default, null)                 : prime.layout.LayoutClient;
    public var system           (get_system, never)             : ISystem;
    
#if (prime_css && (flash9 || nme))
    public var style            (default, null)                 : UIElementStyle;
    public var styleClasses     (default, null)                 : SimpleList<String>;
    public var stylingEnabled   (default, set_stylingEnabled)    : Bool;
#end
    
    
    public function new (idValue:String = null, data:BitmapData = null)
    {
        super(data);
#if debug
        if (idValue == null)
            idValue = this.getReadableId();
#end
        id      = new Bindable<String>(idValue);
        visible = false;
        changes = 0;
        init.onceOn( displayEvents.addedToStage, this );
        
        state           = new UIElementStates();
        behaviours      = new BehaviourList();
#if (prime_css && (flash9 || nme))
        styleClasses    = new SimpleList<String>();
        stylingEnabled  = true;
#end
        
        //add default behaviours
        behaviours.add( new prime.gui.behaviours.layout.ValidateLayoutBehaviour(this) );
        
        createBehaviours();
        if (layout == null)
            layout = new AdvancedLayoutClient();
        
        state.current = state.constructed;
    }


    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        if (parent != null)     // <-- dirty way to see if the component is still on stage.. container and window will be unset after removedFromStage is fired, so if the component gets disposed on removedFromStage, we won't know that it isn't on it.
            detachDisplay();

        data = null;
        //Change the state to disposed before the behaviours are removed.
        //This way a behaviour is still able to respond to the disposed
        //state.
        state.current = state.disposed;
        Assert.that(isDisposed());
        removeValidation();

        // Behaviour reset() method and others may expect the target (this) to be somewhat intact.
        //   so dispose our fields before calling super.dispose()
        prime.utils.MacroUtils.disposeFields();
        super.dispose();
    }


    public #if !noinline inline #end function isDisposed ()    return state == null || state.is(state.disposed);
    public #if !noinline inline #end function isInitialized () return state != null && state.is(state.initialized);
    public function isResizable ()                             return true;
    
    
    //
    // METHODS
    //
    
    private function init ()
    {
        behaviours.init();
        validate();
        removeValidation.on( displayEvents.removedFromStage, this );
        updateScale     .on( layout.changed, this );
        
        state.current = state.initialized;
    }


    private function updateScale (changes:Int)
    {
        // Adjust the scale of the Bitmap since it's not allowed to change the size of the bitmapdata.
        if (changes.has(prime.layout.LayoutFlags.SIZE))
        {
            var l = advancedLayout();
            if (data == null) {
                l.maintainAspectRatio = false;
                l.measuredWidth = l.measuredHeight = Number.INT_NOT_SET;
            } else {
#if (flash9||nme) if (l.explicitWidth.isSet() || l.explicitHeight.isSet())
                    scaleX = scaleY = Formulas.scale(data.width, data.height, l.explicitWidth, l.explicitHeight);
#end            l.maintainAspectRatio = true;
                l.measuredResize((data.width * scaleX).roundFloat(), (data.height * scaleY).roundFloat());
            }
        }
    }


    public #if !noinline inline #end function advancedLayout () : AdvancedLayoutClient
    {
        return layout.as(AdvancedLayoutClient);
    }
    
    
    //
    // ATTACH METHODS
    //
    
    public  inline function attachLayoutTo      (t:ILayoutContainer, pos:Int = -1)  : IUIElement    { t.children.add( layout, pos );                                            return this; }
    public  inline function detachLayout        ()                                  : IUIElement    { if (layout.parent != null) { layout.parent.children.remove( layout ); }   return this; }
    public  inline function attachTo            (t:IUIContainer, pos:Int = -1)      : IUIElement    { attachLayoutTo(t.layoutContainer, pos);   attachToDisplayList(t, pos);    return this; }
    private inline function applyDetach         ()                                  : IUIElement    { detachDisplay();                          detachLayout();                 return this; }
    public  inline function changeLayoutDepth   (pos:Int)                           : IUIElement    { layout.parent.children.move( layout, pos );                               return this; }
    public  inline function changeDepth         (pos:Int)                           : IUIElement    { changeLayoutDepth(pos);                   changeDisplayDepth(pos);        return this; }
    

    public  /*inline*/ function attachToDisplayList (t:IDisplayContainer, pos:Int = -1) : IUIElement
    {
        //  if (container != t)
    //  {
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
                
                if (!isInitialized())   haxe.Timer.delay( show, 100 ); //.onceOn( displayEvents.enterFrame, this );
                else                    effects.playShow();
            }
    //  }
        
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
            //  layout.includeInLayout = false; @see UIComponent.detach
                applyDetach.onceOn( eff.ended, this );
                effects.playHide();
            }
            else
                applyDetach();
        }

        return this;
    }


    public #if !noinline inline #end function isDetaching ()    return effects != null && effects.isPlayingHide();
    public #if !noinline inline #end function isAttached ()     return window  != null;


    
    //
    // IPROPERTY-VALIDATOR METHODS
    //
    
    private var validateWire : Wire<Dynamic>;
    
    public function invalidate (change:Int)
    {
        if (change != 0)
        {
            changes = changes.set( change );
            
            if (changes == change && isInitialized())
                if      (system != null)        system.invalidation.add(this);
                else if (validateWire != null)  validateWire.enable();
                else                            validateWire = validate.on( displayEvents.addedToStage, this );
        }
    }
    
    
    public function validate ()
    {
        if (validateWire != null)
            validateWire.disable();
        
        changes = 0;
    }
    
    
    /**
     * method is called when the object is removed from the stage or disposed
     * and will remove the object from the validation queue.
     */
    private function removeValidation () : Void
    {
        if (isQueued() && isOnStage())
            system.invalidation.remove(this);

        if (!isDisposed() && changes > 0)
            validate.onceOn( displayEvents.addedToStage, this );
    }
    
    
    
    //
    // GETTERS / SETTESR
    //
    
    private inline function get_system () : ISystem                 return window.as(ISystem);
#if (flash9 || nme)
    public #if !noinline inline #end function isOnStage () : Bool   return stage != null;           // <-- dirty way to see if the component is still on stage.. container and window will be unset after removedFromStage is fired, so if the component gets disposed on removedFromStage, we won't know that it isn't on it.
#else
    public #if !noinline inline #end function isOnStage () : Bool   return window != null;
#end
    public #if !noinline inline #end function isQueued () : Bool    return nextValidatable != null || prevValidatable != null;
    

    override private function set_data (v:BitmapData) : BitmapData
    {
        var cur = get_data();
        if (cur != v)
        {
#if (flash9 || nme)  bitmapData  = v;
#else       data        = v; #end
            updateScale(prime.layout.LayoutFlags.SIZE);
        }
        return v;
    }

    
#if (prime_css && (flash9 || nme))
    private function set_stylingEnabled (v:Bool)
    {
        if (v != stylingEnabled)
        {
            if (stylingEnabled) {
                style.dispose();
                style = null;
            }
            
            stylingEnabled = v;
            if (v)
                style = new UIElementStyle(this, this);
        }
        return v;
    }
#end
    
    
    //
    // ACTIONS (actual methods performed by UIElementActions util)
    //

    public #if !noinline inline #end function show ()                      this.doShow();
    public #if !noinline inline #end function hide ()                      this.doHide();
    public #if !noinline inline #end function move (x:Int, y:Int)          this.doMove(x, y);
    public #if !noinline inline #end function resize (w:Int, h:Int)        this.doResize(w, h);
    public #if !noinline inline #end function rotate (v:Float)             this.doRotate(v);
    public #if !noinline inline #end function scale (sx:Float, sy:Float)   this.doScale(sx, sy);
    
    
    
    //
    // ABSTRACT METHODS
    //
    
    private function createBehaviours ()    : Void      {} //   { Assert.abstractMethod(); }
    
    
#if debug
    override public function toString() return id.value;
#end
}