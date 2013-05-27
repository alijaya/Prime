package sample;
 import prime.gui.events.MouseEvents;
 import prime.mvc.Mediator;
 import prime.signals.Signal1;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


class ButtonMediator extends Mediator <MainFacade, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        gui.addEventListener("click", clickHandler);
        super.startListening();
    }


    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        super.stopListening();
        gui.removeEventListener("click", clickHandler);
    }
    

    private function clickHandler(e)
    {
        f.events.loadImage.send(f.model.mainProxy.vo.value);
    }
}