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
package prime.media;
 import haxe.Timer;
 import prime.gui.core.IUIContainer;
#if (flash9 || nme)
 import prime.avm2.net.stream.NetStreamInfoCode;
 import prime.avm2.net.NetConnection;
 import prime.avm2.net.NetStream;
#end
 import prime.fsm.states.MediaStates;
 import prime.bindable.Bindable;
 import prime.types.URI;
 import prime.gui.core.UIContainer;
  using prime.utils.Bind;
  using prime.utils.NumberUtil;
  using Std;


/**
 * @author Ruben Weijers
 * @creation-date Jan 10, 2011
 */
class VideoStream extends BaseMediaStream
{

	
	/**
	 * Bindable value with the frame-rate of the videostream.
	 */
	public var framerate	(default, null)			: Bindable<Int>;
	
	/**
	 * Bindable value with the original width of the videostream
	 */
	public var width		(default, null)			: Bindable<Int>;
	
	/**
	 * Bindable value with the original height of the videostream
	 */
	public var height		(default, null)			: Bindable<Int>;
			
	

	public function new (streamUrl:URI = null)
	{
		framerate = new Bindable<Int>(0);
		width	  = new Bindable<Int>(0);
		height	  = new Bindable<Int>(0);
		super(streamUrl);

        SoundMixer.add(this);
        applyVolume.on(volume.change, this);
	}
	
	
	override public function dispose ()
	{
		//if (source == null)
			//return;					// <-- is already disposed
		
		stop();
        SoundMixer.remove(this);
		
//#if (flash9 || nme)
	///*	source.client = null;		//gives error "Invalid parameter flash.net::NetStream/set client()"*/
		//(untyped state).current = MediaStates.empty;
		//source.dispose2();
		//connection.dispose();
		//connection	= null;
		//source		= null;
//#end
		
		super.dispose();
		framerate.dispose();
		width	 .dispose();
		height	 .dispose();
		width = height = framerate = null;
	}


	//
	// GETTERS / SETTERS
	//
	
	override private function get_currentTime ()
	{
		if (!isPlaying())	return currentTime;
		
		if (updateTimer == null) {
			updateTimer			= new haxe.Timer(250);
			updateTimer.run		= updateTime;
			updateTime();
		}
		return currentTime;
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	
	private function updateTime () {
		//currentTime.value = source.time;
	}
	
	public function addView(container:IUIContainer)
    {

    }
	/**
	 * Method is called when the value of the volume bindable changes. It will
	 * make sure the value is 0 => value >= 1.
	 * The method will also apply the new volume-level on the video-stream.
	 */
	private function applyVolume ()
	{
		//Assert.that(volume.value.isWithin(0,1));
		//Assert.isNotNull(source);
		//Assert.isNotNull(source.soundTransform);
		//var sound				= source.soundTransform;
		//sound.volume			= volume.value; // * flash.media.SoundMixer.soundTransform.volume;
		//source.soundTransform	= sound;
	}
    
    static public function fromURI(uri:URI):VideoStream
    {
        switch( uri.host)
        {
            case "www.youtube.com" :    return new YouTubeStream(uri);
            default            :        return new FLVStream(uri);
        }
    }
	
    
	
}