package prime.gui.traits;
 import prime.bindable.Bindable;
 import prime.gui.core.IUIComponent;


/**
 * Interface for items that can be selected with the selection utility
 * 
 * @author Ruben Weijers
 * @creation-date Dec 23, 2010
 */
interface ISelectable extends IUIComponent
{
	public var selected	(default, null) : Bindable<Bool>;
	
	
	public function select ()		: Void;
	public function deselect ()		: Void;
	public function isSelected ()	: Bool;
}