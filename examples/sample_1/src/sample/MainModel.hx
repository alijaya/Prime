package sample;

/**
 * Defines and groups together proxies,
 * provides access point for them and
 * handles data logic. 
 */
class MainModel extends prime.mvc.MVCNotifier implements prime.mvc.IMVCCore// extends MVCCore<MainFacade> implements IModel
{
    public var mainProxy (default, null):MainProxy;
    public function new (facade:MainFacade, enabled = true)		
    { 
      super(enabled); 
      mainProxy = new MainProxy( facade.events );
    }
}