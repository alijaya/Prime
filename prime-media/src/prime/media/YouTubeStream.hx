package prime.media ;
 import flash.display.Loader;
 import flash.events.ErrorEvent;
 import flash.events.Event;
 import flash.events.IOErrorEvent;
 import flash.net.URLRequest;
 import flash.system.Security;
 import prime.gui.core.IUIContainer;
 import prime.gui.core.UIContainer;
// import prime.gui.display.Loader;
 import prime.fsm.states.MediaStates;
 import prime.types.URI;
 import prime.bindable.Bindable;
  using prime.utils.Bind;
  using prime.fsm.SimpleStateMachine;

  
    
  #if (flash9 || nme)
 import prime.bindable.collections.SimpleList;
 import prime.gui.styling.UIElementStyle;
#end
 import prime.signals.Wire;
 import prime.media.VideoStream;
 import prime.fsm.states.MediaStates;
 import prime.bindable.Bindable;
 
 import prime.gui.behaviours.layout.ValidateLayoutBehaviour;
 import prime.gui.behaviours.BehaviourList;
 
 import prime.gui.display.IDisplayContainer;
 import prime.gui.display.Video;
 import prime.gui.effects.UIElementEffects;
 
 import prime.layout.AdvancedLayoutClient;
 import prime.layout.ILayoutContainer;
 import prime.layout.LayoutClient;
 
 import prime.gui.managers.ISystem;
 import prime.fsm.states.ValidateStates;
 import prime.gui.states.UIElementStates;
 import prime.gui.traits.IValidatable;
 import prime.types.Number;
 
  using prime.gui.utils.UIElementActions;
  using prime.utils.Bind;
  using prime.fsm.SimpleStateMachine;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.TypeUtil;
  
  typedef YouTubePlayerAPI  = 
  {
      > flash.display.DisplayObject,
      function loadVideoById(id:String):Void;
      function cueVideoById(id:String):Void;
      
      function playVideo():Void;
      function pauseVideo():Void;
      function stopVideo():Void;
      
      function setSize(width:Float, height:Float):Void;
      
      function isMuted():Bool;
      function mute():Void;
      function unMute():Void;
      function setVolume(volume:Number):Void;
      
      function getDuration():Float;
      
      function seekTo(pos:Float):Void;
      
      function getVideoLoadedFraction():Float;
      
      function getPlayerState():Float;
      
      function getPlaybackQuality():Float;
      
      function destroy():Void;
    
  };
  
  
/**
 * ...
 * @author EzeQL
 */
class YouTubeStream extends VideoStream 
{
	private var loader:Loader;
	private var player:YouTubePlayerAPI;// This will hold the API player instance once it is initialized.
    private static var ereg:EReg = new EReg("v=(.+)", "");
    private var videoID:String;
    public var videoHolder:UIContainer;

    public function new (streamUrl:URI = null)
    {
        super(streamUrl);
        
        videoHolder = new UIContainer("video");
        
        if (this.url.value != null)
        {
           if ( ereg.match(streamUrl.query) )
           {
                videoID = ereg.matched(1);
           }
        }
        
        Security.allowDomain('www.youtube.com'); 
		Security.allowDomain('s.ytimg.com');
        
        state.current = MediaStates.empty;
        
        init();
    }
    
    private function checkChanges(changes:Int) 
    {
        if (changes.hasNone( prime.layout.LayoutFlags.SIZE )) return;
        
        player.setSize( videoHolder.layout.width, videoHolder.layout.height);
        
    }
    
    
    override public function play ( ?newUrl:URI )        
    {
        
        
        //player.play();
        switch ( state.current )
        {
            case loading(_) : //add action to pending;
            
            case stopped    :
                if ( newUrl == null)
                {
                    if (  videoID != null)
                    {
                        
                    }
                    else
                    {
                        //var ereg:EReg = new EReg("v=(.+)", "");
                        if ( ereg.match(url.value.query) )
                        {
                            var value = ereg.matched(1);
                            player.loadVideoById (value);
                            videoID = value;
                        }
                        else
                        {
                            //error
                        }
                        
                    }
                    //this.url.value
                }
                else
                {
                    
                    
                    if ( ereg.match(newUrl.query) )
                    {
                        videoID =  ereg.matched(1);
                        player.loadVideoById (ereg.matchedLeft());    
                    }
                    else
                    {
                        //eror
                    }
                    
                }
                
            case _:
        }
    }
    
    
    /**
     * Method will pause the stream if it was playing
     */
    override public function pause ()                    
    {
        switch(state.current)
        {
            case playing | paused: player.pauseVideo();
            case _: trace("nothing");
        }
        
    }
    override public function resume ()                   
    {
        switch(state.current)
        {
            case playing | paused: player.pauseVideo();
            case _: trace("nothing");
        }
    }
    override public function stop ()                     
    {
        switch(state.current)
        {
            case playing | paused: 
                player.pauseVideo();
                player.seekTo(0);
            case _: trace("nothing");
        }
    }
    override public function seek (newPosition:Float)    
    {
        player.seekTo ( newPosition * player.getDuration() );
    }
    

    override public function freeze() 
    {
        switch(state.current)
        {
            case frozen(_): 
                return;
            case paused | playing: 
                freezeState();
                player.pauseVideo(); 
            case _:
        }
            
        
    }
    override public function defrost() 
    {
        defrostState();

		if (state.current == playing)
			 player.playVideo();
    }
    
	public function init () :Void {
		loader = new Loader();
        loader.contentLoaderInfo.addEventListener (Event.INIT, onLoaderInit);
		loader.contentLoaderInfo.addEventListener (ErrorEvent.ERROR, loaderErrorHandler);
		loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, loaderErrorHandler);
		loader.load ( new URLRequest("http://www.youtube.com/apiplayer?version=3") );
        state.current = MediaStates.loading(state.current);
	}
    
    override public function addView(container:IUIContainer)
    {
        super.addView(container);
        container.attach(videoHolder);
    }
    
    private function onLoaderInit(event:Event):Void {

		loader.content.addEventListener("onReady", playerReadyHandler);
		loader.content.addEventListener("onError", playerErrorHandler);
		loader.content.addEventListener("onStateChange", playerStateChangeHandler);
		loader.content.addEventListener("onPlaybackQualityChange", videoPlaybackQualityChangeHandler);
        
	}
	private function loaderErrorHandler (e:Dynamic) :Void 
    {
        state.current = MediaStates.error(e.text);
	}

	private function playerReadyHandler(e:Event):Void 
    {
		player = cast loader.content;
        checkChanges( prime.layout.LayoutFlags.SIZE );
        checkChanges.on(videoHolder.layout.changed, this);
        
        videoHolder.addChild(player);

        state.current = MediaStates.stopped;
        if ( videoID != null)
            player.cueVideoById(videoID);
	}

	private function playerErrorHandler(e:Event):Void 
    {
        state.current = MediaStates.error("player error");
	}

	private function playerStateChangeHandler(e:Event):Void 
    {
        //if ( isFrozen()) return;
        var stateCode:Int = untyped e.data;
        switch(stateCode)
        {
            case -1: // (unstarted)
                
            case  0: //0 (ended)
                state.current = MediaStates.stopped;
            case  1: //1 (playing)
                state.current = MediaStates.playing;
                if (updateTimer != null)
					updateTimer.run = updateTime;
            case  2://2 (paused)
                state.current = MediaStates.paused;
            case  3: //3 (buffering)
                state.current = MediaStates.loading(state.current);
            case  5: //5 (video cued).*/
                // ?
        }
	}

	private function videoPlaybackQualityChangeHandler(e:Event):Void 
    {
        
	}

}