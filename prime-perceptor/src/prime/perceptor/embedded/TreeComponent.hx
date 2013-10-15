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
 import prime.bindable.collections.ListChange;
 import prime.bindable.Bindable;
 import prime.gui.components.Label;
 import prime.gui.core.UIContainer;
 import prime.gui.core.UIDataContainer;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;
  using prime.fsm.SimpleStateMachine;
	
/**
 * GUI data component designed to work with and visualise a TypedProxyTree,
 * which is stored in data property.
 * ...
 * @author ...
 */

// private typedef DataType = TypedProxyTree<T, F>;
 
class TreeComponent<T, F> extends UIDataContainer< TypedProxyTree<T, F> >
{
	// Subtrees grouped in a container to simplify attaching/detaching
	// all at once
	private var subtrees : UIContainer;
	private var selectHandler : TreeComponent < T, F >->Void;
	public var debugHandler : Dynamic -> Dynamic -> Void;
	private var label : Label;
	private var labelStr : String;
	
	public function new ( data:TypedProxyTree<T, F>, selectHandler:TreeComponent<T, F>->Void, isRoot:Bool = false )
	{
		super( data + " - TreeNode", data);
		styleClasses.add( isRoot ? "InspectorTreeComponentRoot" : "InspectorTreeComponent" );
		this.selectHandler = selectHandler;
	}
	
	private function dataOrphaned()
	{
		name = labelStr = label.data.value = label.data.value + "(orphaned)";
		label.userEvents.mouse.click.unbind( this );
	}
	
	private function listChange( change : ListChange< TypedProxyTree<T, F> > )
	{
		switch( change )
		{
			case added( item, newPos ):
				var subtree : TreeComponent<T, F> = new TreeComponent<T, F>( item, selectHandler );
				subtree.debugHandler = debugHandler;
				subtree.attachTo( subtrees );
			case removed( item, oldPos ): 
				var subtree : TreeComponent<T, F> = null;
				for ( s in subtrees.children )
				{
					if ( s.is(TreeComponent) && s.as(TreeComponent).data == item )
					{
						subtree = cast s;
						break;
					}
				}
				if ( subtree != null ) {
					subtree.detach();
					//subtree.dataOrphaned();
				}

			case moved( item, newPos, oldPos ):
			case reset:
		}
		
		name = data + " - TreeNode";
		layout.name = name + " - Layout";
		
		label.name = label.data.value = data + " - Label";
		label.layout.name = label.name + " - Layout";
		
		subtrees.name = label.data.value = data + " - Sub";
		subtrees.layout.name = subtrees.name + " - Layout";
		
		label.data.value = name;
		//name = label.data.value = data + " - TreeNode";
		//layout.name = name + " - Layout";
	}
 
	public override function createChildren()
	{
		super.createChildren();	
		
		label = new Label( "testlabel", new Bindable<String>( labelStr = data+"" ) );
		label.styleClasses.add( "InspectorTreeLabel" );
		label.attachTo( this );
		
		subtrees = new UIContainer( "testTree" );
		subtrees.styleClasses.add( "InspectorTreeContainer" );
		for ( subtreeData in data )
		{
			var subtree : TreeComponent<T, F> = new TreeComponent<T, F>( subtreeData, selectHandler );
			subtree.debugHandler = debugHandler;
			subtree.attachTo( subtrees );
		}
		subtrees.attachTo( this );
		
		toggleSubtrees.on( label.userEvents.mouse.click, this );
		if( data.change!=null )
			listChange.on( data.change, this );
	}
	
	public function toggleSubtrees()
	{
		if ( subtrees.isOnStage() )
			subtrees.detach();
		else
			subtrees.attachTo( this );
		selectHandler(this);
	}
	
	public function debug(indent:Int=0)
	{
		//if ( label.data.value == "[6]:spreads : SpreadOverview" && debugHandler != null )
		//	debugHandler(label, false);
		var indentation:String = "["+indent+"]";
		for ( i in 0...indent )
			indentation += "  ";
		trace( indentation + label.data.value + " " + subtrees.y + " " + subtrees.layout.outerBounds.top );
		if ( subtrees.isOnStage() )
			for ( subtree in subtrees.children )
				untyped subtree.debug( indent + 1 );
	}
	
}