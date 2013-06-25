package cases;
#if debug
 import flash.text.TextFormat;
// import prime.gui.display.TextField;
#end
 import prime.bindable.collections.ArrayList;
 import prime.bindable.collections.DataCursor;
 import prime.bindable.collections.IEditableList;
 import prime.core.geom.space.Vertical;
 import prime.core.geom.IRectangle;
 import prime.bindable.Bindable;
 import prime.gui.behaviours.drag.DragDropBehaviour;
 import prime.gui.behaviours.drag.ApplyDropBehaviour;
 import prime.gui.behaviours.drag.ShowDragGapBehaviour;
 import prime.gui.behaviours.drag.DragInfo;
 import prime.gui.components.ListView;
 import prime.gui.components.DataButton;
 import prime.gui.core.UIContainer;
 import prime.gui.core.UIDataContainer;
 import prime.gui.core.UIDataComponent;
 import prime.gui.core.UIWindow;
 import prime.gui.display.DisplayDataCursor;
 import prime.gui.display.Window;
 import prime.gui.events.DragEvents;
 import prime.gui.events.DropTargetEvents;
 import prime.layout.algorithms.float.HorizontalFloatAlgorithm;
 import prime.layout.algorithms.float.VerticalFloatAlgorithm;
 import prime.layout.algorithms.RelativeAlgorithm;
 import prime.layout.LayoutFlags;
 import prime.layout.RelativeLayout;
 import prime.layout.VirtualLayoutContainer;
 import prime.gui.traits.IDataDropTarget;
 import prime.gui.traits.IDropTarget;
 import prime.types.Number;
 import prime.utils.Color;
  using prime.utils.Bind;
  using prime.utils.Color;
  using prime.utils.TypeUtil;
  using Type;



typedef DataVOType = Bindable<String>;

/**
 * @creation-date	Sep 16, 2010
 * @author			Ruben Weijers
 */
class GlobalTest extends UIWindow
{
	public static function main () { Window.startup( function (s) return new GlobalTest(s) ); }
	override private function createBehaviours () {}
	
	
	override private function createChildren ()
	{
		var testList1 = new ArrayList<DataVOType>();
		for (i in 0...100)
			testList1.add(new DataVOType(i+""));
		
		var frame0				= new TileList( "frame0", testList1 );	//vertical list at the left
		var frame1				= new TileList( "frame1", testList1 );	//horizontal list on the top
		var frame2				= new TileList( "frame2", testList1 );	//center tile-list
		var frame3				= new TileList( "frame3", testList1 );	//right-bottom tile-list
		var frame4				= new TileList( "frame4");				//first colored block at right side
		var frame5				= new TileList( "frame5");				//second colored block at right side
		var frame6				= new TileList( "frame6");				//third colored block at right side
		var frame7				= new TileList( "frame7");				//empty block above the tree blocks
		var frame8				= new TileList( "frame8", testList1 );	//circle tile list on the right
		
		var box0				= new VirtualLayoutContainer();
		box0.algorithm			= new RelativeAlgorithm();
		box0.percentWidth		= LayoutFlags.FILL;
		box0.percentHeight		= 1;
		
		var box1				= new VirtualLayoutContainer();
		var box1Alg				= new VerticalFloatAlgorithm();
		box1Alg.direction		= Vertical.bottom;
		box1.relative			= new RelativeLayout( 90, 5, 5, Number.INT_NOT_SET );
		box1.percentWidth		= 0.4;
		box1.algorithm			= box1Alg;
		
		var box2				= new VirtualLayoutContainer();
		box2.algorithm			= new HorizontalFloatAlgorithm();
		box2.percentWidth		= 1;
		box2.percentHeight	 	= 0.15;

#if debug
		box0.name	= "box0";
		box1.name	= "box1";
		box2.name	= "box2";
#end
		
		layoutContainer.children.add( frame0.layout );
		layoutContainer.children.add( box0 );
		
		box0.children.add( frame1.layout );
		box0.children.add( frame2.layout );
		box0.children.add( box1 );
		
		box1.children.add( frame3.layout );
		box1.children.add( box2 );
		box1.children.add( frame7.layout );
		box1.children.add( frame8.layout );
		
		box2.children.add( frame4.layout );
		box2.children.add( frame5.layout );
		box2.children.add( frame6.layout );
		
		children.add(frame0);
		children.add(frame2);
		children.add(frame1);
		children.add(frame3);
		children.add(frame4);
		children.add(frame5);
		children.add(frame6);
		children.add(frame7);
		children.add(frame8);
		
		haxe.Log.clear.on( frame4.userEvents.mouse.down, this );
	}
}


class Tile extends DataButton < DataVOType >
{
	public static var counter				: Int = 0;
	private var num							: Int;

#if (debug && flash90)
	private var textField					: TextField;
#end
	
	
#if debug
	public function new (value:DataVOType = null)
	{
		num = counter++;
		super("Tile" + num, value);
	}
#end
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new DragDropBehaviour(this) );
		changeStyleClass.on( userEvents.mouse.click, this );
	}
	
	
#if (debug && flash90)
	override private function createChildren ()
	{
		textField = new TextField(data);
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		children.add( textField );
	}
#end
	
	
	override public function createDragInfo () : DragInfo
	{
		return new DragInfo( this, null, this ); //getDisplayCursor()/*, new Tile(value), null*/ );
	}
	
	
	private function changeStyleClass ()
	{
		if (styleClasses.length == 1)
			styleClasses.remove("odd");
		else
			styleClasses.add("odd");
	}
}


class TileList extends ListView < DataVOType > implements IDataDropTarget < DataVOType >
{
	public var dragEvents	(default, null)		: DropTargetEvents;
	public var list			(get_list, never)	: IEditableList < DataVOType >;
	
	
	public function new (id:String = null, list:ArrayList<DataVOType> = null)
	{
		doubleClickEnabled	= true;
		dragEvents			= new DropTargetEvents();
		super(id, list);
		createItemRenderer	= createRenderer;
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new ApplyDropBehaviour (this) );
		behaviours.add( new ShowDragGapBehaviour(this) );
	}
	
	
	private function createRenderer (dataItem:DataVOType, pos:Int)
	{
		return cast new Tile(dataItem);
	}
	
	
	public function isDisplayDropAllowed (displayCursor:DisplayDataCursor ) : Bool
	{
		var allowed = false;
		if (displayCursor.target.is(Tile))
		{
			var tile = displayCursor.target.as(Tile);
			if ( data != null && !data.has( tile.data ) )
				allowed = true;
		}
		return allowed;
	}
	
	
	public function isDataDropAllowed (dataCursor:DataCursor < DataVOType > ) : Bool
	{
		return dataCursor.list == data;
	}
	
	
	private inline function get_list ()
	{
		return cast data;
	}
}