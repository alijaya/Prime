package nme.test;

import flash.display.Bitmap;
import flash.display.Sprite;
import nme.Assets;
import flash.Lib;

import prime.bindable.Bindable;
import prime.layout.LayoutClient;

import prime.gui.display.Window;
import prime.gui.core.UIWindow;

#if flash
//import prime.gui.components.AudioPlayer;
//import prime.gui.components.UploadPanel;
//import prime.gui.components.VideoPlayer;
//import prime.gui.components.skins.ButtonAudioPlayerSkin;

import prime.gui.components.DebugBar;

// --- JS needs maxScrollH and friends ---
import prime.gui.components.TextArea;

#end

import prime.gui.components.Button;
import prime.gui.components.AlertPanel;
import prime.gui.components.ColorPicker;
import prime.gui.components.DataButton;
import prime.gui.components.IItemRenderer;
import prime.gui.components.Image;
import prime.gui.components.ListHolder;
import prime.gui.components.ProgressBar;
import prime.gui.components.Slider;
import prime.gui.components.ToggleGroup;
import prime.gui.components.ComboBox;
import prime.gui.components.IListHolder;
import prime.gui.components.InputField;
import prime.gui.components.ListView;
import prime.gui.components.ScrollBar;
import prime.gui.components.SliderBase;
import prime.gui.components.ConfirmPanel;
import prime.gui.components.Form;
import prime.gui.components.ITextArea;
import prime.gui.components.Label;
import prime.gui.components.Panel;
import prime.gui.components.SelectableListView;

import prime.gui.components.skins.BasicPanelSkin;
import prime.gui.components.skins.ButtonIconLabelSkin;
import prime.gui.components.skins.ButtonIconSkin;
import prime.gui.components.skins.ButtonLabelSkin;
import prime.gui.components.skins.CircleProgressSkin;
import prime.gui.components.skins.ClosablePanelSkin;
import prime.gui.components.skins.EmptyPanelSkin;
import prime.gui.components.skins.InputFieldSkin;
import prime.gui.components.skins.LinearProgressLabelSkin;
import prime.gui.components.skins.LinearProgressSkin;
import prime.gui.components.skins.MovablePanelSkin;
import prime.gui.components.skins.SlidingToggleButtonSkin;

class Main extends Sprite
{
	private var testBindabe:Bindable<Float>;
	
	public function new () {
		super ();
		addChild( new examples.display.DisplayExample1() );
return;

		var window = Window.startup( function(stage) return new MainWindow(stage) );
		var txt = new flash.text.TextField(); // prime.gui.display.TextField();
		txt.x = txt.y = 100;
		txt.text = "WAAAT";
		//txt.userEvents.focus.bind(this, function(e) trace("focus" + e));
		//txt.userEvents.blur.bind(this, function(e) trace("blur" + e));
		//trace(txt);
		txt.type = flash.text.TextFieldType.INPUT;
		txt.addEventListener(flash.events.FocusEvent.FOCUS_IN,  function(e) trace("focus" + e));
		txt.addEventListener(flash.events.FocusEvent.FOCUS_OUT, function(e) trace("blur " + e));
		addChild(txt);
//		examples.layout.LayoutExample4.main();
/*
		var bitmap = new Bitmap (Assets.getBitmapData ("assets/nme.png"));
		addChild (bitmap);
		
		bitmap.x = (Lib.current.stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (Lib.current.stage.stageHeight - bitmap.height) / 2;

		testBindabe = new Bindable<Float>(0);
		testBindabe.value = 123;

		var layout:LayoutClient = new LayoutClient(100,100);
*/
	}

	public static function Go()
	{
	#if flash
	   new Main();
	#else
	   Lib.create(function(){new Main();},320,480,60,0xccccff,(1*Lib.HARDWARE) | Lib.RESIZABLE);
	#end
	}
}

class MainWindow extends UIWindow
{
	public function new(stage) {
		Assert.isNotNull(stage);
		super(stage, "MainWindow");
	
		var button = new Button( "buttonAdd", "+" );
		button.visible = true;
		button.graphicData.fill = new prime.gui.graphics.fills.SolidFill(0xffaaaaff);
		button.graphicData.shape = new prime.gui.graphics.shapes.RegularRectangle();
		button.layout.margin = new prime.core.geom.Box(20,5);
		button.layout.resize( 30, 50 );
		children.add( button );
		//untyped console.log(button);
	}
}