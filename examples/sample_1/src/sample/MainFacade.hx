package sample;


import prime.mvc.Facade;
import prime.core.traits.IDisposable;

/**
 * Initializes the main application parts
 * and provides an access point for them.
 * This is the core class of the application.
 */
class MainFacade extends Facade<MainEvents, MainModel, IDisposable, MainController, MainView>
{
    public static function main ()	
    {
      new MainFacade().start();
    }
    private function new ()			{ super(); }


    override private function setupModel ()			{ model			= new MainModel(this); } 
    override private function setupEvents ()		{ events		= new MainEvents(); } 
    override private function setupView ()			{ view			= new MainView(this); }
    override private function setupController ()	{ controller	= new MainController(this); }
}