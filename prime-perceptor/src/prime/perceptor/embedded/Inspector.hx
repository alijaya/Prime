/*
 * Copyright (c) 2013, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ prime.vc>
 */
package prime.perceptor.embedded;
// import prime.avm2.display.DisplayContainer;
 import prime.bindable.Bindable;
 import prime.bindable.collections.IReadOnlyList;
// import prime.bindable.collections.ListChange;
 import prime.bindable.collections.SimpleList;
// import prime.gui.components.Form;
 import prime.gui.components.Label;
 import prime.gui.components.ListView;
// import prime.gui.components.SelectableListView;
#if prime_css
 import prime.gui.traits.IStylable;
#end
 import prime.gui.core.IUIComponent;
 import prime.gui.core.IUIDataElement;
// import prime.gui.core.IUIElement;
// import prime.gui.core.UIComponent;
 import prime.gui.core.UIContainer;
 import prime.gui.core.UIDataContainer;
// import prime.gui.core.UITextField;
 import prime.gui.core.UIWindow;
// import prime.gui.display.IDisplayObject;
 import prime.gui.display.IDisplayContainer;
// import prime.gui.display.DisplayObject;
// import prime.gui.display.Window;
// import prime.layout.algorithms.float.HorizontalFloatAlgorithm;
// import prime.layout.LayoutContainer;
   using prime.utils.Bind;
   using prime.utils.TypeUtil;
	
/**
 * 
 * @author Danny Wilson
 * @creation-date Mar 20, 2013
 */
class Inspector extends UIContainer
{
	private var treeView : TreeComponent< IDisplayContainer, IDisplayContainer >;
	private var treeData : TypedProxyTree < IDisplayContainer, IDisplayContainer >;

	private var selectedView : ListView<String>;
	private var selectedData : SimpleList<String>;

	private var lastSelected : Bindable< TypedProxyTree< IDisplayContainer, IDisplayContainer> >;
	private var currentSelected : Bindable< TypedProxyTree< IDisplayContainer, IDisplayContainer> >;
	@borrowed var inspectingItem : IDisplayContainer;

	public function new( w:UIWindow )
	{
		super("Inspector");
		treeData = new TypedProxyTree < IDisplayContainer, IDisplayContainer > ( cast w.children.owner, getChildren, IDisplayContainer, IDisplayContainer );
	}
	
	private function getChildren( i:IDisplayContainer ) : IReadOnlyList<IDisplayContainer>
	{
		return cast i.children;
	}
	
	private override function createChildren ()	: Void
	{
		super.createChildren();
			
		treeView = new TreeComponent< IDisplayContainer, IDisplayContainer >( treeData, treeViewSelected, true );
		treeView.attachTo( this );
		
		selectedData = new SimpleList<String>();
		selectedView = new ListView<String>("InspectorData");
		selectedView.createItemRenderer = selectedViewRenderer;
		selectedView.data = selectedData;
		selectedView.attachTo( this );
	}
	
	private function treeViewSelected( treeView:TreeComponent<IDisplayContainer, IDisplayContainer> )
	{
		var treeData : TypedProxyTree < IDisplayContainer, IDisplayContainer > = treeView.data;
		var data : IDisplayContainer = treeData.source;
		
		listDisplayContainer( data );
	}
	
	private function selectedViewRenderer( item:String, depth:Int ) : IUIDataElement<String>
	{
		var container : UIDataContainer<String> = new UIDataContainer<String>( "InspectorDataContainer", item );
		
		var label = new Label("InspectorDataLabel", new Bindable<String>(item) );
		label.multiline = true;
		label.wordWrap  = true;
		label.attachTo( container );
		
		return container;
	}

	public function listDisplayContainer( d:IDisplayContainer )
	{
		if (inspectingItem == d) return;
		inspectingItem = d;

		selectedData.removeAll();
		
		/*if ( d.is(DisplayContainer) )
		{
			var dc : DisplayContainer = d.as(DisplayContainer);
			
			//todo add more properties
			selectedData.add( dc.rect+"" );
			selectedData.add( dc.scrollRect+"" );
		}
		else if ( d.is( Window ) )
		{
			var w : Window = d.as(Window);
			
			//todo add more properties
			selectedData.add( w+"" );
		}
		else*/
		
		if ( d.is( prime.gui.traits.ILayoutable ) )
		{
			var u = d.as( prime.gui.traits.ILayoutable ).layout;
			
			selectedData.add( "Layout.padding: " + u.padding.toString() );
			selectedData.add( "Layout.margin: " + u.margin.toString() );
			selectedData.add( "Layout.outerBounds: " + u.outerBounds.toString() );
			selectedData.add( "Layout.innerBounds: " + u.outerBounds.toString() );
		}
		if ( d.is( prime.gui.traits.ILayoutable ) && d.as( prime.gui.traits.ILayoutable ).layout.is( prime.layout.IAdvancedLayoutClient ) )
		{
			var u = d.as( prime.gui.traits.ILayoutable ).layout.as( prime.layout.IAdvancedLayoutClient );
			selectedData.add( "Explicit width, height: " + u.explicitWidth + ", " + u.explicitHeight );
			selectedData.add( "Measured width, height: " + u.measuredWidth + ", " + u.measuredHeight );
		}
		
		// Skip the top node CSS info, sometimes there is too much data
		// and the height of selectedView can be too large and cause
		// asserts and crashes.
		if ( this.treeView == treeView )
			return;
		
		#if prime_css
		if ( d.is( IStylable ) && d.as( IStylable ).style != null )
		{
			var u = d.as( IStylable );
			
			selectedData.add( u.toString() );
			selectedData.add( u.style.toString() + "\n  Properties: " + u.style.readProperties() + "\n  States: " + u.style.readStates() );
			selectedData.add("CSS classes");
			selectedData.add( u.styleClasses.toString() );
			selectedData.add("Applied style blocks:");
			for ( s in u.style )
			{
				var str : String =  s.toCSS( (switch(s.type) {
					case element:        '<class>';
					case styleName:      '.';
					case id:             '#';
					case specific:       '<self>';
					case elementState:   '<class>:';
					case styleNameState: '.:';
					case idState:        '#:';
				}) + s.cssName);

				selectedData.add( str );
			}
		}
		else #end
		{
			selectedData.add("DEFAULT HANDLING");
			var fields:Array<String> = Type.getInstanceFields( Type.getClass( d ) );
			for ( field in fields )
			{
				selectedData.add( field + ":" + Reflect.field( d, field ) );
			}
		}
	}
}
