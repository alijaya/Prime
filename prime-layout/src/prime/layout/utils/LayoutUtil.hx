package prime.layout.utils;
 import prime.bindable.collections.IEditableList;
 import prime.bindable.collections.iterators.IIterator;
 import prime.gui.core.IUIElement;
 import prime.gui.display.DisplayList;
 import prime.gui.display.IDisplayObject;
 import prime.layout.ILayoutClient;
 import prime.layout.LayoutClient;
  using prime.utils.TypeUtil;

/**
 * ...
 * @author EzeQL
 */

class LayoutUtil
{

}

class LayoutIteratorUtil
{
	//returns the first child over an Iterator having client as layout.
	static public function firstHavingLayout( iter:IIterator<IDisplayObject>, client:ILayoutClient,?optVisible:Bool = false):IUIElement
	{
		for ( child in iter)
		{
			var c = child.as(IUIElement);
			if (c.layout == client && (!optVisible || c.visible)) 	return c;
		}
		return null;
	}
	
	//returns the first child from an iterator<Layoutclient> where includeInLayout = paremeter includedInlayout
	static public function firstClientIncludedInLayout( iter:IIterator<LayoutClient>,?includedInLayout:Bool = false):LayoutClient
	{
		for ( c in iter) if (c.includeInLayout == includedInLayout ) return c;
		return null;
	}
	
	
}

class LayoutDisplayListUtil
{
	//returns the first child over a displaylist having client as layout.
	static public function firstHavingLayout(displayList:DisplayList, client:ILayoutClient,?optVisible:Bool = false):IUIElement
	{
		for (child in displayList)
		{
			var c = child.as(IUIElement);
			if (c.layout == client && (!optVisible || c.visible)) 	return c;
		}
		return null;
	}
		//returns the first child over a list of Layoutclients where includeInLayout = paremeter includedInlayout
	static public function firstClientIncludedInLayout(children:IEditableList<LayoutClient>,?includedInLayout:Bool = false):LayoutClient
	{
		for (c in children)	if (c.includeInLayout == includedInLayout ) return c;
		return null;
	}
	
}