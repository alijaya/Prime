package sample;
 import prime.mvc.MVCActor;
  using prime.utils.Bind;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCActor<MainFacade>
{	
    public function new (facade:MainFacade)		{ super(facade); }
}