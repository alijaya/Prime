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
package prime.media;
#if (flash9 || nme)
 import flash.events.Event;
 import flash.media.SoundTransform;
#end
 import prime.bindable.Bindable;
  using prime.utils.Bind;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;


#if flash
private typedef Sound = flash.media.SoundMixer;
#end


/**
 * Singleton which collects all playing sound-objects and adds an API to apply 
 * actions on them.
 *
 * @since   Oct 3, 2011
 * @author  Ruben Weijers
 */
class SoundMixer
{
    public function new () {}
    
    private static var instance (get_instance, null) : SoundMixerInstance;
    
    private static inline function get_instance ()
    {
        if (instance.isNull())
            instance = new SoundMixerInstance();
        
        return instance;
    }


    public static #if !noinline inline #end function stopAll ()                        { instance.stopAll(); }
    public static #if !noinline inline #end function stopAllExcept (s:BaseMediaStream) { instance.stopAllExcept(s); }
    public static #if !noinline inline #end function freezeAll ()                      { instance.freezeAll(); }
    public static #if !noinline inline #end function defrostAll ()                     { instance.defrostAll(); }


    public static #if !noinline inline #end function add (s:BaseMediaStream)           { instance.add(s); }
    public static #if !noinline inline #end function remove (s:BaseMediaStream)        { instance.remove(s); }


    public static #if !noinline inline #end function mute ()                           { instance.mute(); }
    public static #if !noinline inline #end function unmute ()                         { instance.unmute(); }
    public static #if !noinline inline #end function toggleMute ()                     { instance.toggleMute(); }




    public static var volume    (get_volume, never)                  : Bindable<Float>;
        private static inline function get_volume ()                 { return instance.volume; }
    
    public static var isMuted   (get_isMuted, never)                 : Bindable<Bool>;
        private inline static function get_isMuted()                 { return instance.isMuted; }
    
    public static var isFrozen  (get_isFrozen, never)                : Bool;
        private inline static function get_isFrozen()                { return instance.isFrozen; }
}







/**
 * Singleton implemention
 */
private class SoundMixerInstance
{
    private var next        : BaseMediaStream;

    /**
     * Overall volume setting
     */
    public var volume       (default, null)         : Bindable<Float>;
    /**
     * Flag indicating if the sound is muted
     */
    public var isMuted      (default, null)         : Bindable<Bool>;
    /**
     * Flag indicating if all channels are frozem
     */
    public var isFrozen (get_isFrozen, never)        : Bool;
        private inline function get_isFrozen ()      { return numberOfFreezes > 0; }
    
    /**
     * The number of times "pauseAll" is called
     */
    private var numberOfFreezes                     : Int;
    
    
    public function new ()
    {
        volume              = new Bindable<Float>(1.0);
        isMuted             = new Bindable<Bool>(false);
        numberOfFreezes     = 0;
        applyVolume.on(isMuted.change, this);
    }


    public function stopAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function stopAllExcept (exception:BaseMediaStream = null)
    {
        var c = next;
        while (c.notNull()) {
            if (c != exception)
                c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function freezeAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.freeze();
            c = c.next;
        }
        numberOfFreezes++;
    }


    public function defrostAll ()
    {
        var c = next;
        numberOfFreezes--;
        while (c.notNull()) {
            c.defrost();
            c = c.next;
        }
    }


    public #if !noinline inline #end function add (stream:BaseMediaStream)
    {
        Assert.isNotNull(stream);
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                stream.freeze();
        
        (untyped stream).next = next;
        next = stream;
    //    ListUtil.addNode(this, s);
    }


    public function remove (stream:BaseMediaStream)
    {
        Assert.isNotNull(stream);

        //defrost the channel
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                stream.defrost();
        
        //remove it
        var prev:BaseMediaStream = null;
        var cur  = next;
        while (cur.notNull()) {
            if (cur == stream) {
                if (prev == null)   next = cur.next;
                else                (untyped prev).next = cur.next;
                break;
            }
            prev = cur;
            cur  = cur.next;
        }
    }


    public #if !noinline inline #end function mute ()     isMuted.value = true;
    public #if !noinline inline #end function unmute ()   isMuted.value = false;

    
    /**
     * Mutes or unmutes all soundClients. If a client is muted, the sound will
     * be paused instead of turning the volume to zero.
     */
    public #if !noinline inline #end function toggleMute ()
    {
        if (isMuted.value)  unmute();
        else                mute();
    }


    private function applyVolume ()
    {
#if (flash9 || nme)
        var s    = Sound.soundTransform;
        s.volume = (!isMuted.value).boolCalc() * volume.value;
        Sound.soundTransform = s;
#end
    }
}
