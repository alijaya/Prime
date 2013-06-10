package sample;
 import prime.gui.events.MouseEvents;
 import prime.mvc.Mediator;
 import prime.signals.Signal1;
 import prime.types.Asset;
 import prime.gui.components.Image;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


/**
 * ImageLoaderMediator corresponds to a mediator in the MVC model.
 * A mediator separates event handling for a specific UI element
 * from the element itself. It defines what ImageLoader events 
 * should be listened to and what functions react to them. 
 */
class ImageLoaderMediator extends Mediator <MainFacade, Image>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        // Bind a ui event to a function.
        //events.loadImage.bind(this, gui.loadImage);
		loadImage.on(f.events.loadImage, this);
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
	
	
	private function loadImage(url:String) 
	{
		//gui.layout.maintainAspectRatio = false;
		gui.data = Asset.fromString(url);
	}
}
