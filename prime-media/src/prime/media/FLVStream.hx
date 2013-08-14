package prime.media;
 import haxe.Timer;
 import prime.gui.core.IUIContainer;
 import prime.gui.core.IUIElement;
 import prime.gui.core.UIContainer;
#if (flash9 || nme)
 import prime.avm2.net.stream.NetStreamInfoCode;
 import prime.avm2.net.NetConnection;
 import prime.avm2.net.NetStream;
#end
 import prime.fsm.states.MediaStates;
 import prime.bindable.Bindable;
 import prime.types.URI;
  using prime.utils.Bind;
  using prime.utils.NumberUtil;
  using Std;
  
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


private typedef Flags = prime.gui.core.UIElementFlags;




/**
 * ...
 * @author EzeQL
 */
class FLVStream extends VideoStream
{
    #if (flash9 || nme)
	private var connection	: NetConnection;
    private var video:UIVideo;
	public var source		(default, null)			: NetStream;
	
	public var onMetaData	(default, null)			: Dynamic->Void;
	public var onCuePoint	(default, null)			: Dynamic->Void;
	public var onImageData	(default, null)			: Dynamic->Void;
	public var onPlayStatus (default, null)			: Dynamic->Void;
	public var onTextData	(default, null)			: Dynamic->Void;
	public var onXMPData	(default, null)			: Dynamic->Void;
    #end


    public function new (streamUrl:URI = null)
    {
        super(streamUrl);
        #if (flash9 || nme)
		connection	= new NetConnection();
		source		= new NetStream(connection);
		//dirty client to catch flash player exeptions..
		//@see http://www.actionscript.org/forums/archive/index.php3/t-142040.html
		source.client	= this;
		onMetaData		= handleMetaData;
		onCuePoint		= handleCuePoint;
		onImageData		= handleImageData;
		onPlayStatus	= handlePlayStatus;
		onTextData		= handleTextData;
		onXMPData		= handleXMPData;
		handleSecurityError	.on( connection.events.securityError, 	this );
		handleASyncError	.on( connection.events.asyncError, 		this );
		handleIOError		.on( connection.events.ioError, 		this );
		handleNetStatus		.on( connection.events.netStatus, 		this );

		handleASyncError	.on( source.events.asyncError, 			this );
		handleIOError		.on( source.events.ioError, 			this );
		handleNetStatus		.on( source.events.netStatus, 			this );		
#end
    }
    
    
    	// VIDEO METHODS
	//
	
	

	
	
	override public function play ( ?newUrl:URI )
	{
		if (!isStopped())		stop();
		if (newUrl != null)		url.value = newUrl;
		
		Assert.isNotNull( url.value, "There is no video-url to play" );
		source.play( url.value.toString() );
	}
	

	override public function pause ()
	{
		source.pause();
		if (!isEmpty())
			state.current = MediaStates.paused;
	}
	
	
	override public function resume ()
	{
		if (!isPaused())	return;
		source.resume();
		state.current = MediaStates.playing;
	}
	
	
	override public function stop ()
	{
		if (isEmpty())		return;
		source.close();
		state.current = MediaStates.stopped;
	}
	
	
	override public function seek (newPosition:Float)
	{
		if (isEmpty())		return;
		newPosition = validatePosition(newPosition);
		if (newPosition == source.time)
			return;
		
		source.seek( newPosition );
	}
	
	
	public function toggleFullScreen ()		//FIXME
	{
		trace("toggleFullScreen");
	}
	
    override public function freeze ()
	{
		if (isFrozen())		return;
		source.pause();
        freezeState();
	}
	
	
	/**
	 * Method will restore the state of the video to before it was frozen.
	 */
	override public function defrost ()
	{
		defrostState();
		
		if (state.current == playing)
			source.play();
	}
	
    
#if (flash9 || nme)
	private function handleNetStatus (event:prime.avm2.net.stream.NetStreamInfo)
	{
		switch (event.code)
		{
			case NetStreamInfoCode.playStreamNotFound:
				state.current = MediaStates.stopped;
				trace("invalid video-url "+url.value);
			
			
			case NetStreamInfoCode.notifySeekEnd, NetStreamInfoCode.notifySeekComplete:
				if (isPlaying())
					source.resume();
			
			
			case NetStreamInfoCode.playStop:
				state.current = MediaStates.stopped;
				if (updateTimer != null)
					updateTimer.stop();
			
			
			case NetStreamInfoCode.playStart:
				state.current = MediaStates.playing;
				if (updateTimer != null)
					updateTimer.run = updateTime;
			
			
			default:
				trace("no-handler for net-code: "+event);
		}
	}
	
	
	/**
	 * "EventHandlers" for the NetStream.client class. If not set, the 
	 * flashplayer will throw errors.
	 * 
	 * @param	?metaData
	 */
	private function handleMetaData ( info:Dynamic ) : Void
	{
		Assert.isNotNull(info);
		totalTime.value	= info.duration;
		framerate.value	= info.framerate;
		width.value		= info.width;
		height.value	= info.height;
	}
    
    override public function addView(container:IUIContainer)
    {
        video = new UIVideo("video", true);
        video.stream = this;
        container.attach(video);
        super.addView(container);
    }
	
	
	private function handleSecurityError (error:String)      trace(error);
	private function handleASyncError    (error:String)      trace(error);
	public  function handleCuePoint      (metaData:Dynamic)  trace("cuePoint: " + metaData);
	public  function handlePlayStatus    (metaData:Dynamic)  trace("onPlayStatus: " + metaData);
	public  function handleXMPData       (metaData:Dynamic)  trace("onXMPData: " + metaData);
	public  function handleImageData     (metaData:Dynamic)  trace("onImageData: " + metaData);
	public  function handleTextData      (metaData:Dynamic)  trace("onTextData: " + metaData);
#end
}

class UIVideo extends Video implements IUIElement
{
	public var prevValidatable	: IValidatable;
	public var nextValidatable	: IValidatable;
	private var changes			: Int;
	
	public var id				(default, null)					: Bindable<String>;
	public var behaviours		(default, null)					: BehaviourList;
	public var effects			(default, default)				: UIElementEffects;
	public var layout			(default, null)					: LayoutClient;
	public var system			(get_system, never)				: ISystem;
	public var state			(default, null)					: UIElementStates;
	
#if (flash9 || nme)
	public var style			(default, null)					: UIElementStyle;
	public var styleClasses		(default, null)					: SimpleList<String>;
	public var stylingEnabled	(default, set_stylingEnabled)	: Bool;
#end
	
	public var stream			(default, set_stream)					: FLVStream;
    
    private function set_stream(stream:FLVStream)
    {
        this.stream = stream;
        init();
        return stream;
    }
	
	
	
	public function new (id:String = null, stylingEnabled:Bool = true)
	{
#if debug
	if (id == null)
		id = this.getReadableId();
#end
		this.id				= new Bindable<String>(id);
		super();
#if (flash9 || nme)
		styleClasses		= new SimpleList<String>();
		this.stylingEnabled	= stylingEnabled;
#end
		visible				= false;
		changes				= 0;
		state				= new UIElementStates();
		behaviours			= new BehaviourList();
		
		//add default behaviour
		//init.onceOn( displayEvents.addedToStage, this );
		behaviours.add( new ValidateLayoutBehaviour(this) );
		
		createBehaviours();
		if (layout == null)
			layout = new AdvancedLayoutClient();
		
		state.current = state.constructed;
	}


	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		if (container != null)			detachDisplay();
		if (layout.parent != null)		detachLayout();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		
		removeValidation();
		behaviours.dispose();
		id.dispose();
		state.dispose();
		
		if (stream != null)		stream.dispose();
		if (layout != null)		layout.dispose();
		
#if (flash9 || nme)
		if (style != null && style.target == this)
			style.dispose();
		
		styleClasses.dispose();
		styleClasses	= null;
		style			= null;
#end
		
		id				= null;
		state			= null;
		behaviours		= null;
		stream			= null;
		super.dispose();
	}
	
	
	public #if !noinline inline #end function isDisposed ()	{ return state == null || state.is(state.disposed); }
	public #if !noinline inline #end function isInitialized ()	{ return state != null && state.is(state.initialized); }
	public function isResizable ()			{ return true; }
	

	//
	// METHODS
	//

	private function init ()
	{
		visible = true;
		behaviours.init();
		
#if (flash9 || nme)
		attachNetStream( stream.source );
		clear.onEntering( stream.state, MediaStates.stopped, this );
#end
		invalidate.bind(Flags.VIDEO_WIDTH) .on( stream.width.change, this );
		invalidate.bind(Flags.VIDEO_HEIGHT).on( stream.height.change, this );
		
		validate();
		removeValidation.on( displayEvents.removedFromStage, this );
		
		state.current = state.initialized;
	}
	
	
#if (flash9 || nme)
	private function set_stylingEnabled (v:Bool)
	{
		if (v != stylingEnabled)
		{
			if (stylingEnabled) {
				style.dispose();
				style = null;
			}
			
			stylingEnabled = v;
			if (stylingEnabled)
				style = new UIElementStyle(this, this);
		}
		return v;
	}
#end
	
	
	//
	// ATTACH METHODS
	//
	
	public  inline function attachLayoutTo		(t:ILayoutContainer, pos:Int = -1)	: IUIElement	{ t.children.add( layout, pos );											return this; }
	public  inline function detachLayout		()									: IUIElement	{ if (layout.parent != null) { layout.parent.children.remove( layout ); }	return this; }
	public  inline function attachTo			(t:IUIContainer, pos:Int = -1)		: IUIElement	{ attachLayoutTo(t.layoutContainer, pos);	attachToDisplayList(t, pos);	return this; }
	private inline function applyDetach			()									: IUIElement	{ detachDisplay();							detachLayout();					return this; }
	public  inline function changeLayoutDepth	(pos:Int)							: IUIElement	{ layout.parent.children.move( layout, pos );								return this; }
	public  inline function changeDepth			(pos:Int)							: IUIElement	{ changeLayoutDepth(pos);					changeDisplayDepth(pos);		return this; }
	

	public  /*inline*/ function attachToDisplayList (t:IDisplayContainer, pos:Int = -1)	: IUIElement
	{
	//	if (container != t)
	//	{
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
				
				if (!isInitialized()) 	haxe.Timer.delay( show, 100 ); //.onceOn( displayEvents.enterFrame, this );
				else 					effects.playShow();
			}
	//	}
		
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
			//	layout.includeInLayout = false;	@see UIComponent.detach
				applyDetach.onceOn( eff.ended, this );
				effects.playHide();
			}
			else
				applyDetach();
		}

		return this;
	}


	public #if !noinline inline #end function isDetaching () 	return effects != null && effects.isPlayingHide();
	public #if !noinline inline #end function isAttached () 	return window  != null;

	
	//
	// IPROPERTY-VALIDATOR METHODS
	//
	
	
	private inline function get_system () : ISystem					return window.as(ISystem);
#if (flash9 || nme)
	public #if !noinline inline #end function isOnStage () : Bool	return stage != null;			// <-- dirty way to see if the component is still on stage.. container and window will be unset after removedFromStage is fired, so if the component get's disposed on removedFromStage, we won't know that it isn't on it.
#else
	public #if !noinline inline #end function isOnStage () : Bool	return window != null;
#end
	public #if !noinline inline #end function isQueued () : Bool	return nextValidatable != null || prevValidatable != null;
	
	
	private var validateWire : Wire<Dynamic>;
	
	public function invalidate (change:Int)
	{
		if (change != 0)
		{
			changes = changes.set( change );
			if (changes == change && isInitialized())
				if      (system != null)		system.invalidation.add(this);
				else if (validateWire != null)	validateWire.enable();
				else                            validateWire = validate.on( displayEvents.addedToStage, this );
		}
	}
	
	
	public function validate ()
	{
	    if (validateWire != null)
	        validateWire.disable();
        
		if (changes > 0)
		{
			if (changes.has( Flags.VIDEO_WIDTH | Flags.VIDEO_HEIGHT ))
			{
				var l = layout.as(AdvancedLayoutClient);
				l.maintainAspectRatio = stream.width.value != 0;
				l.measuredResize( stream.width.value, stream.height.value );
				trace(stream.width.value+", "+stream.height.value);
				trace("measured: "+l.measuredWidth+", "+l.measuredHeight+"; explicit: "+l.explicitWidth+", "+l.explicitHeight+"; size: "+l.width+", "+l.height);
			}
		
			changes = 0;
		}
	}
	
	
	/**
	 * method is called when the object is removed from the stage or disposed
	 * and will remove the object from the validation queue.
	 */
	private function removeValidation () : Void
	{
		if (isQueued() &&isOnStage())
			system.invalidation.remove(this);

		if (!isDisposed() && changes > 0)
			validate.onceOn( displayEvents.addedToStage, this );
	}
	
	
	
	
	//
	// ACTIONS (actual methods performed by UIElementActions util)
	//

	public #if !noinline inline #end function show ()						{ this.doShow(); }
	public #if !noinline inline #end function hide ()						{ this.doHide(); }
	public #if !noinline inline #end function move (x:Int, y:Int)			{ this.doMove(x, y); }
	public #if !noinline inline #end function resize (w:Int, h:Int)		{ this.doResize(w, h); }
	public #if !noinline inline #end function rotate (v:Float)				{ this.doRotate(v); }
	public #if !noinline inline #end function scale (sx:Float, sy:Float)	{ this.doScale(sx, sy); }
	
	private function createBehaviours ()	: Void		{}
#if debug override public function toString () return id.value; #end
}