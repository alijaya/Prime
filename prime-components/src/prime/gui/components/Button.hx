

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
 import prime.gui.core.UIDataContainer;
 import prime.gui.graphics.IGraphicProperty;
#if prime_css
 import prime.gui.styling.IIconOwner;
#end
 import prime.gui.text.TextFormat;
 import prime.gui.traits.ISelectable;
 import prime.gui.traits.ITextStylable;
 import prime.types.Asset;


private typedef Flags = prime.gui.core.UIElementFlags;


/**
 * Button component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Button extends UIDataContainer <Bindable<String>> #if prime_css implements IIconOwner #end implements ITextStylable implements ISelectable
{
	public var selected		(default, null)			: Bindable<Bool>;
	public var icon			(default, set_icon)		: Asset;
	public var iconFill		(default, set_iconFill)	: IGraphicProperty;
#if (flash9 || nme)
	public var textStyle	(default, set_textStyle)	: TextFormat;

  //FIXME: Get rid of this shit via partials or something
  #if flash9
	public var wordWrap		: Bool;
  #elseif nme
	function set_wordWrap(w) return wordWrap = w
   #if html5
	public var wordWrap(default, set_wordWrap):Bool;
   #elseif cpp
	public var wordWrap(get_wordWrap, set_wordWrap):Bool;
	function get_wordWrap() return wordWrap
   #end
  #end

	public var embedFonts #if cpp (get_embedFonts, set_embedFonts) #end : Bool;
  #if cpp
	inline function get_embedFonts()  return embedFonts
	inline function set_embedFonts(v) return embedFonts = v
  #end
#end
	
	
	public function new (id:String = null, value:String = null, icon:Asset = null)
	{
		if (data == null)	super(id, new Bindable<String>(value));
		else				super(id, this.data);
		
		this.icon	= icon;
		selected	= new Bindable<Bool>(false);
		#if prime_css styleClasses.add("formElement"); #end
	}


	private inline function set_icon (v:Asset)
	{
		if (v != icon) {
			icon = v;
			invalidate( Flags.ICON );
		}
		return v;
	}
	
	
	private inline function set_iconFill (v:IGraphicProperty)
	{
		if (v != iconFill) {
			iconFill = v;
			invalidate( Flags.ICON_FILL );
		}
		return v;
	}
	
	
#if (flash9 || nme)
	private inline function set_textStyle (v:TextFormat)
	{
		textStyle = v;
		invalidate( Flags.TEXTSTYLE );
		return v;
	}
#end
	
	
	public #if !noinline inline #end function select ()			{ selected.value = true; }
	public #if !noinline inline #end function deselect ()		{ selected.value = false; }
	public #if !noinline inline #end function toggleSelect ()	{ selected.value = !selected.value; }
	public #if !noinline inline #end function isSelected ()		{ return selected.value; }
}