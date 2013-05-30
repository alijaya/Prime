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
 *  Danny Wilson    <danny @ onlinetouch.nl>
 */
package prime.gui.events;
 import prime.signals.Signals;
 import prime.core.geom.Point;
 import prime.core.traits.IClonable;
 import prime.gui.events.KeyModState;


typedef TouchEvents =
    #if     flash9  prime.avm2.events.TouchEvents;
    #elseif flash   prime.avm1.events.TouchEvents;
    #elseif nodejs  #error;
    #elseif js      prime.js  .events.TouchEvents;
//  #elseif neko    prime.neko.events.TouchEvents;
    #else           #error; #end

typedef TouchHandler    = TouchState -> Void;
typedef TouchSignal     = prime.signals.Signal1<TouchState>;


/**
 * Cross-platform touch events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 10, 2011
 */
class TouchSignals extends Signals
{
    /** Fires to indicate when the user places a touch point on the touch surface. */
    public var start        (get_start,  null) : TouchSignal;
    /** Fires when the user removes a touch point from the touch surface, also including cases where the touch point physically leaves the touch surface, such as being dragged off of the screen */
    public var end          (get_end,    null) : TouchSignal;
    /** Fires to indicate when the user moves a touch point along the touch surface. */
    public var move         (get_move,   null) : TouchSignal;
    /** Fires when the user removes a touch point from the touch surface, also including cases where the touch point physically leaves the touch surface, such as being dragged off of the screen */
    public var cancel       (get_cancel, null) : TouchSignal;
    
    
    private inline function get_start ()     { if (start == null)        { createStart(); }  return start; }
    private inline function get_end ()       { if (end == null)          { createEnd(); }    return end; }
    private inline function get_move ()      { if (move == null)         { createMove(); }   return move; }
    private inline function get_cancel ()    { if (cancel == null)       { createCancel(); } return cancel; }
    
    
    private function createStart ()         { Assert.abstractMethod(); }
    private function createEnd ()           { Assert.abstractMethod(); }
    private function createMove ()          { Assert.abstractMethod(); }
    private function createCancel ()        { Assert.abstractMethod(); }
}

/**
 * State information sent by TouchSignal.
 * 
 * @author Danny Wilson
 * @author Ruben Weijers
 * @creation-date Nov 10, 2011
 */
@:publicFields class TouchState implements IClonable<TouchState>
{
    public static inline var fake = new TouchState( null, null, null );
    
    /**
     * Target of the event
     */  
    var target  (default,null)      : UserEventTarget;
    var local   (default,null)      : Point;
    var stage   (default,null)      : Point;
    
    
    public function new(t:UserEventTarget, l:Point, s:Point)
    {
        this.target = t;
        this.local  = l;
        this.stage  = s;
    }
    
#if flash9
    public #if !noinline inline #end function isDispatchedBy (obj:UserEventTarget) : Bool
    {
        return obj != null && obj == related;
    }
#end
    
    
    public #if !noinline inline #end function clone () : TouchState
    {
        return new TouchState(target, local, stage);
    }
    
    
#if debug
    public var owner : TouchSignal;
    
    public function toString () {
        return "TouchState of "+owner+"; pos: "+local;
    }
#end
}
