

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
package prime.gui.components;
 import prime.media.VideoStream;
 import prime.fsm.states.MediaStates;
 import prime.bindable.Bindable;
 import prime.gui.core.IUIElement;
 import prime.gui.core.UIContainer;
 import prime.gui.core.UIDataContainer;
 import prime.gui.events.MouseEvents;
 import prime.layout.LayoutFlags;
 import prime.types.URI;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.DateUtil;
  using Std;


/**
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class VideoPlayer extends UIDataContainer <Bindable<URI>>
{
	public var ctrlBar		(default, null) : VideoControlBar;
	private var video		: UIContainer;
	private var bigPlayBtn	: Button;
	public var stream		(default, set_stream)	: VideoStream;
    
    private function set_stream(stream:VideoStream):VideoStream
    {
        handleVideoStateChange	.on( stream.state.change, this );
        stream.addView(video);
        return this.stream = ctrlBar.stream = stream;
    }
	
	
	override private function createChildren ()
	{
		this.attach( video		= new UIContainer("video") )
			 .attach( ctrlBar 	= new VideoControlBar("ctrlBar") )
			.attach( bigPlayBtn	= new Button("bigPlayBtn") );
		
		bigPlayBtn.layout.maintainAspectRatio = true;
		bigPlayBtn.disable();
		
		//stream = ctrlBar.stream = video.stream;
		
		togglePlayPauze			.on( userEvents.mouse.click, this );
		//handleVideoStateChange	.on( stream.state.change, this );
	}
	
	
	override public  function disposeChildren ()
	{
		userEvents.mouse.click.unbind(this);
		stream.state.change.unbind(this);
		
		ctrlBar.dispose();
		video.dispose();
		stream.dispose();
		ctrlBar = null;
		video	= null;
		stream	= null;
		super.disposeChildren();
	}
	
	
	private function togglePlayPauze (mouseObj:MouseState)
	{
		if (mouseObj.target == this)
			stream.togglePlayPauze();
	}
	
	
	private function handleVideoStateChange (newState:MediaStates, oldState:MediaStates)
	{
		togglePlayBtn( newState != MediaStates.playing );
	}
	
	
	public function togglePlayBtn (show:Bool = true)
	{
		var b		= bigPlayBtn;
		var oldV	= b.window != null;
	//	b.visible	= show;
		
		if		(!oldV && show)	b.attachTo(this);
		else if	(oldV && !show)	b.detach();
	}
}






/**
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class VideoControlBar extends UIContainer
{
	public var playBtn			(default, null)	: Button;
	public var stopBtn			(default, null)	: Button;
	public var progressBar		(default, null)	: Slider;
	public var timeDisplay		(default, null)	: Label;
	public var muteBtn			(default, null)	: Button;
	public var volumeSlider		(default, null)	: Slider;
	public var fullScreenBtn	(default, null)	: Button;
	
	public var stream			(default, set_stream)	: VideoStream;
	
	
	override public function dispose ()
	{
		stream = null;
		super.dispose();
	}
	
	
	/*override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}*/
	
	
	override private function createChildren ()
	{
		this.attach( playBtn 		= new Button("playBtn") )
			.attach( stopBtn		= new Button("stopBtn") )
			.attach( progressBar	= new Slider("progressSlider") )
			.attach( timeDisplay	= new Label("timeDisplay") )
			.attach( muteBtn		= new Button("muteBtn") )
			.attach( volumeSlider	= new Slider("volumeSlider") )
			.attach( fullScreenBtn	= new Button("fullScreenBtn") );
		
		timeDisplay.data.value = "--:-- / --:--";
		
		//FIXME RUBEN: create a nice way with macros to add children conditionally.. like 
		// children.addIf( child, function() width > 400; );
		// when( this.width > 400 ).on(updateLayout).addChild(btn); 
		addOrRemoveChildren.on( layout.changed, this );
	//	addOrRemoveChildren( LayoutFlags.WIDTH );
		
		if (stream != null)
			addStreamListeners();
	}


	override public function disposeChildren ()
	{
		playBtn.dispose();
		stopBtn.dispose();
		progressBar.dispose();
		timeDisplay.dispose();
		muteBtn.dispose();
		volumeSlider.dispose();
		fullScreenBtn.dispose();
		playBtn = stopBtn = fullScreenBtn = muteBtn = null;
		progressBar = volumeSlider = null;
		timeDisplay = null;
		super.disposeChildren();

		layout.changed.unbind( this );
	}


	private function addStreamListeners ()
	{
		updateSliderValidator	.on( stream.totalTime.change, this );
		
		stream.togglePlayPauze	.on( playBtn.userEvents.mouse.click, this );
		stream.stop				.on( stopBtn.userEvents.mouse.click, this );
		//stream.toggleFullScreen	.on( fullScreenBtn.userEvents.mouse.click, this );
		stream.toggleMute		.on( muteBtn.userEvents.mouse.click, this );
		
		progressBar	.data.bind( stream.currentTime );
		volumeSlider.data.pair( stream.volume );
		
		updateTimeLabel		.on( stream.currentTime.change, this );
		updateTimeLabel		.on( stream.totalTime.change, this );
		handleStreamChange	.on( stream.state.change, this );
		stream.freeze		.on( progressBar.sliding.begin, this );
		stream.defrost		.on( progressBar.sliding.apply, this );
		startSeeking		.on( progressBar.sliding.apply, this );
		
		handleStreamChange( stream.state.current, null );
		updateTimeLabel();
	}
	
	
	private function removeStreamListeners ()
	{
		playBtn			.userEvents.mouse.click.unbind(this);
		stopBtn			.userEvents.mouse.click.unbind(this);
		fullScreenBtn	.userEvents.mouse.click.unbind(this);
		muteBtn			.userEvents.mouse.click.unbind(this);
		
		progressBar	.data.unbind( stream.currentTime );
		volumeSlider.data.unbind( stream.volume );
		progressBar.sliding.unbind(this);
		
		stream.currentTime	.change.unbind( this );
		stream.totalTime	.change.unbind( this );
		stream.state		.change.unbind( this );
	}
	
	
	override public function validate ()
	{
		if (changes.has(prime.gui.core.UIElementFlags.STREAM) && stream != null)
			addStreamListeners();
		
		super.validate();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function set_stream (v:VideoStream)
	{
		if (stream != v)
		{
			if (stream != null && isInitialized())
				removeStreamListeners();
			
			stream = v;
			invalidate(prime.gui.core.UIElementFlags.STREAM);
		}
		return v;
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	
	private function handleStreamChange (newState:MediaStates, oldState:MediaStates)	switch (newState)
	{
		case MediaStates.playing:
			playBtn.id.value	= "pauseBtn";
		
		
		case MediaStates.paused:
			playBtn.id.value	= "playBtn";
		
		
		case MediaStates.stopped:
			playBtn.id.value	= "playBtn";
			enable();
		
		
		case MediaStates.error(str): 	disable();
		case MediaStates.empty:			disable();
		
		case loading( origState ):
        case frozen( prevState ):
	//	case MediaStates.frozen(realState):
		//	enabled.value = false;
			
	}
	
	
	private function updateSliderValidator (newTime:Float, oldTime:Float)
	{
		Assert.isNotNull( progressBar );
		progressBar.data.validator.max = newTime;
		trace(oldTime+" => "+newTime);
	}
	
	
	/**
	 * Method is called when the currentTime or totalTime changes and will
	 * update the time-label value.
	 */
	private function updateTimeLabel () : Void
	{
		var curTime = stream.currentTime.value.int().secondsToTime();
		var totTime = stream.totalTime.value.int().secondsToTime();
		timeDisplay.data.value = curTime + " / " + totTime;
	}
	
	
	/**
	 * Method is called when the user releases the video-progressbar and will
	 * seek the the new-position in the video-stream.
	 */
	private function startSeeking ()
	{
		stream.seek( progressBar.data.value );
	}
	
	
	/**
	 * Method is called when the size is changed and with add or remove some 
	 * of the displayobjects.
	 */
	private function addOrRemoveChildren (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH ))
			return;
		
		var width = layout.innerBounds.width;
		showOrHide( volumeSlider,	width > 250 );
		showOrHide( stopBtn,		width > 300 );
		showOrHide( timeDisplay,	width > 400 );
	}
	
	
	private inline function showOrHide (child:IUIElement, show:Bool)
	{
		if (child.isOnStage() && !show)		children.remove( child );
		if (!child.isOnStage() && show)		children.add( child );
		if (child.visible != show) {
			child.visible = child.layout.includeInLayout = show;
			layout.invalidate( LayoutFlags.LIST );		// force the layout-container to update all children. Otherwise the size of the sliders will be incorrect
		}
		
	//	if (!show)		layoutContainer.children.remove( child.layout );
	//	else			layoutContainer.children.add( child.layout, pos );
	}
}