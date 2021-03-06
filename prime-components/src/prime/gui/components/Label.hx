

/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package prime.gui.components;
 import prime.bindable.Bindable;
// import prime.gui.behaviours.components.LabelLayoutBehaviour;
 import prime.gui.core.UIDataComponent;
 import prime.gui.core.UITextField;
 import prime.gui.events.FocusState;
 import prime.gui.events.UserEventTarget;
 import prime.layout.AdvancedLayoutClient;
 import prime.gui.text.TextFormat;
 import prime.gui.traits.ITextStylable;
  using prime.utils.Bind;
  using prime.utils.BitUtil;
  using prime.utils.TypeUtil;


private typedef Flags		= prime.gui.core.UIElementFlags;


/**
 * Label Component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Label extends UIDataComponent <Bindable<String>> implements ITextStylable
{
	public var field				(default, null)				: UITextField;
	public var displayHTML			(default, set_displayHTML)	: Bool;
	public var multiline			(default, set_multiline)	: Bool;
	
#if (flash9 || nme)
	public var textStyle			(default, set_textStyle)	: TextFormat;

  //FIXME: Get rid of this shit via partials or something
  #if flash9
	public var wordWrap		: Bool;
  #elseif nme
	function set_wordWrap(w) return wordWrap = w
   #if html5
	public var wordWrap(default, set_wordWrap):Bool;
   #elseif cpp
	public var wordWrap(get_wordWrap, set_wordWrap):Bool;
	function get_wordWrap()  return wordWrap
   #end
  #end

	public var embedFonts #if cpp (get_embedFonts, set_embedFonts) #end : Bool;
  #if cpp
	inline function get_embedFonts()  return embedFonts
	inline function set_embedFonts(v) return embedFonts = v
  #end
#end

	
	public function new (id:String = null, data:Bindable<String> = null)
	{
		if (data == null)
			data = new Bindable<String>();
		
		layout = new AdvancedLayoutClient();
		super(id, data);
	}
	
	
	override private function createChildren ()
	{
		field = UITextField.createLabelField(id.value+"TextField", data, this, layout.as(AdvancedLayoutClient) );
	//	behaviours.add( new LabelLayoutBehaviour(field) );
		field.attachDisplayTo( this );
	}
	
	
	override public  function disposeChildren ()
	{
		super.disposeChildren();
		field.dispose();
		field = null;
	}
	
	
	override private function initData ()		{ field.data = data; }
	override private function removeData ()		{ field.data = null; }
	
	
#if (flash9 || nme)
	override public function isFocusOwner (target:UserEventTarget)
	{
		return super.isFocusOwner(target) || field.isFocusOwner(target);
	}
#end

	override public function validate ()
	{
		var changes = this.changes;
		super.validate();
		
		if (changes.has(Flags.DISPLAY_HTML))	field.displayHTML	= displayHTML;
		if (changes.has(Flags.MULTILINE))		field.multiline		= multiline;
	}
	
	
	//
	// GETERS / SETTERS
	//
	
#if (flash9 || nme)
	private inline function set_textStyle (v:TextFormat)
	{
		if (field != null) {
			field.wordWrap		= wordWrap;
			field.embedFonts	= embedFonts;
			field.textStyle 	= v;
		}
		
		return textStyle = v;
	}
#end
	
	
	private inline function set_displayHTML (v:Bool)
	{
		if (displayHTML != v)
		{
			displayHTML = v;
			invalidate( Flags.DISPLAY_HTML );
		}
		return v;
	}
	
	
	private inline function set_multiline (v:Bool)
	{
		if (multiline != v)
		{
			multiline = v;
			invalidate( Flags.MULTILINE );
		}
		return v;
	}
}