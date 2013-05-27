package sample;


import prime.mvc.Proxy;
import prime.bindable.Bindable;

/**
 * Provides access to data and handles data logic.
 */
class MainProxy extends Proxy<Bindable<String>, {}>
{
    public function new(events)
    {
        super(events);
        vo = new Bindable<String>("http://i286.photobucket.com/albums/ll87/amandakendle/StBasilsCathedralMoscow.jpg");
    }
}