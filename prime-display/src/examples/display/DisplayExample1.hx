package examples.display;
 import prime.gui.display.Sprite;
 import prime.gui.events.MouseEvents;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;

class DisplayExample1 extends Sprite
{
	static function main() flash.Lib.current.addChild(new DisplayExample1())

	public function new (){
		super();
		funkify(0xDEADBEEF);
		changeColor .on( this.userEvents.mouse.rollOver,  this );
		addUglyChild.on( this.userEvents.mouse.click,     this );
	}

	function changeColor(state : MouseState) funkify(Std.int( 0xF1F100 * state.local.x ))

	function addUglyChild() {
		var it = new DisplayExample1();
		it.x = if (parent.is(Sprite)) parent.as(Sprite).children.indexOf(this) * 10  else  10;
		it.y = this.parent.y + 50;
		it.attachDisplayTo(this);
	}

	function funkify(color) {
		graphics.clear();  graphics.beginFill(color);  graphics.drawRect(0,0, 100,100);
	}
}
