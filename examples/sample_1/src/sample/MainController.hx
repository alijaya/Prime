package sample;
 import prime.mvc.MVCActor;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCActor<MainFacade> , implements prime.mvc.IMVCCoreActor
{	
    public function new (facade:MainFacade)		{ super(facade); }
}