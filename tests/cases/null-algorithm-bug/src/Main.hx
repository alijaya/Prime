package ;

/**
 * ...
 * @author AndrewP
 */

import prime.gui.core.UIWindow;
import prime.gui.core.UIContainer;
import prime.gui.components.Button;
import prime.gui.components.Label;
import prime.gui.events.MouseEvents;
	using prime.utils.Bind;
	using prime.utils.TypeUtil;

class Main extends UIWindow 
{
	private var state 	: Bool;
	private var test 	: CustomContainer;
	
	public static function main () 
	{
		prime.gui.display.Window.startup( function (s) return new Main(s) );
	}

	public function new(target:prime.gui.display.Stage, id:String = null)
	{
		super(target, id);
	}

	override public function createChildren()
	{
		// needed for Perceptor
		super.createChildren();
		
		var a = new Button( null, "Style One");
		var b = new Button( null, "Style Two");
		var c = new Button( null, "Style Three");
		var d = new Button( null, "Style All");
		var e = new Button( null, "Toggle Visible");
		
		toggleTestStyle.bind( "styleOne" ).on( a.userEvents.mouse.click, this );
		toggleTestStyle.bind( "styleTwo" ).on( b.userEvents.mouse.click, this );
		toggleTestStyle.bind( "styleThree" ).on( c.userEvents.mouse.click, this );
		toggleTestStyle.bind( "styleAll" ).on( d.userEvents.mouse.click, this );
		onClick.on( e.userEvents.mouse.click, this );
		
		var	buttonHolder = new UIContainer("buttonHolder");
		
		buttonHolder.attach( a );
		buttonHolder.attach( b );
		buttonHolder.attach( c );
		buttonHolder.attach( d );
		buttonHolder.attach( e );
		
		attach( buttonHolder );
		attach( test = new CustomContainer("customContainer") );
		
		
 	}
	
	public function toggleTestStyle( newStyle:String )
	{
		if ( test.test.styleClasses.has( newStyle ) )
			test.test.styleClasses.remove( newStyle );
		else
			test.test.styleClasses.add( newStyle );
	}

	public function onClick( state:MouseState )
	{
		if ( !state.related.is(Button) )
			return;

		if ( test.isEnabled() )
		{
			test.disable();
			test.detach();
		}
		else 
		{
			test.enable();
			attach( test );
			
		}
	}
}

class CustomContainer extends UIContainer
{
	public var test : UIContainer;
	
	override private function createChildren ()
	{
		super.createChildren();
		
		//layout.width = 300;
		//layout.height = 150;
		
		//styleClasses.add( "dark" );
		
		test = new UIContainer();
		
		styleClasses.add( "styleOne" );
		//styleClasses.add( "styleTwo" );
		test.styleClasses.add( "styleOne" );
		test.styleClasses.add( "styleTwo" );
		
		test.attach(new Button( null, "test"));
		test.attach(new Button( null, "more test"));
		
		attach(test);
	}
}