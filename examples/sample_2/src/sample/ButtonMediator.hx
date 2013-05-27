package sample;
 import prime.gui.events.MouseEvents;
 import prime.mvc.Mediator;
 import prime.signals.Signal1;
 import prime.gui.components.Button;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


/**
 * ButtonMediator corresponds to a mediator in the MVC model.
 * A mediator separates event handling for a specific UI element
 * from the element itself. It defines what Button events should 
 * be listened to and what functions react to them. 
 */
class ButtonMediator extends Mediator <MainFacade, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
		
        clickHandler.on(gui.userEvents.mouse.click, this);
        super.startListening();
    }


    override public function stopListening ()
    {
        if (!isListening())
            return;
        
		super.stopListening();
        gui.userEvents.unbind(this);
    }
    
	
    private function clickHandler(e)
    {
        f.events.loadImage.send(f.model.mainProxy.vo.value);
    }
}