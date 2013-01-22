package sample;

import prime.mvc.MVCNotifier;
import prime.mvc.core.MVCCore;


/**
 * Defines and groups together proxies,
 * provides access point for them and
 * handles data logic. 
 */
class MainModel extends MVCCore<MainFacade>, implements IModel
{
    public var mainProxy (default, null):MainProxy;
    public function new (facade:MainFacade)		{ super(facade); }

    public function init ()
    {
        mainProxy = new MainProxy( facade.events );
    }
}