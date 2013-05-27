package sample;
 import prime.gui.display.Window;
 import prime.mvc.MVCActor;


/**
 * Defines and groups together and couples 
 * mediators and application windows.
 */
class MainView extends prime.mvc.MVCActor<MainFacade>, implements prime.mvc.IMVCCoreActor
{
    private var window:MainWindow;
    public var buttonMediator(default, null):ButtonMediator;
    public var imageLoaderMediator(default, null):ImageLoaderMediator;

    public function new (facade:MainFacade)
    {
        super(facade);
        window		    		  = Window.startup( function (s) return new MainWindow(s) );
        buttonMediator	  	= new ButtonMediator(facade, true, window.loadButton);
        imageLoaderMediator = new ImageLoaderMediator(facade, true, window.imageLoader);
    }
	
	
    override public function dispose ()
    {
        if (!isListening())
            return;

        buttonMediator.dispose();
        imageLoaderMediator.dispose();
        window.dispose();
        
        buttonMediator = null;
        imageLoaderMediator = null;
        window = null;
        
        super.dispose();
    }
	
	
    override public function startListening ()
    {
        if (!isListening())
            return;

        buttonMediator.startListening();
        imageLoaderMediator.startListening();
        super.startListening();
    }
	
	
    override public function stopListening ()
    {
        if (!isListening())
            return;

        super.stopListening();
        buttonMediator.stopListening();
        imageLoaderMediator.stopListening();
    }
}