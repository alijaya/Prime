package sample;
 import prime.gui.events.MouseEvents;
 import prime.mvc.Mediator;
 import prime.signal.Signal1;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;

/**
 * Defines what ui events should be listened to
 * and what functions react to them.
 */
class ImageLoaderMediator extends Mediator <MainFacade, ImageLoader>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        // Bind a ui event to a function.
        f.events.loadImage.bind(this, gui.loadImage);
        super.startListening();
    }


    override public function stopListening ()
    {
        if (!isListening())
            return;
		
		super.stopListening();
        // Unbind action from a ui event.
        f.events.loadImage.unbind(this);
    }
}