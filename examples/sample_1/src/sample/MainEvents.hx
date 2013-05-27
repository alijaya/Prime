package sample;
 import prime.signals.Signal1;
 import prime.signals.Signals;

/**
 * Defines and groups together application events
 * and provides an access point for them.
 */
class MainEvents extends Signals
{
    public var loadImage:Signal1 < String >;

    public function new ()
    {
        super();
        
        loadImage = new Signal1();
    }
}