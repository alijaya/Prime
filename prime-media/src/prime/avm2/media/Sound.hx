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
 *  Ruben Weijers   <ruben @ prime.vc>
 */
package prime.avm2.media;
 import flash.media.SoundLoaderContext;
 import prime.avm2.events.SoundEvents;
 import prime.core.traits.IDisposable;
 import prime.types.URI;


/**
 * AVM2 Sound-object with PrimeVC events
 * 
 * @author Ruben Weijers
 * @creation-date Sep 28, 2011
 */
class Sound extends flash.media.Sound implements IDisposable
{
    public var events (default, null)   : SoundEvents;
    
    
    public function new (stream:URI = null, context:SoundLoaderContext = null)
    {
        super( stream == null ? null : stream.toRequest(), context );
        events = new SoundEvents(this);
    }
    
    
    public function dispose ()
    {
        try { close(); } 
        catch(e:Dynamic) { trace(this+": loader close error: "+e); }
        events.dispose();
        events = null;
    }
}