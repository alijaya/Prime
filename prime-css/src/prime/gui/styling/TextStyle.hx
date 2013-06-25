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
package prime.gui.styling;
 import prime.core.traits.IInvalidatable;
 import prime.gui.text.FontStyle;
 import prime.gui.text.FontWeight;
 import prime.gui.text.TextAlign;
 import prime.gui.text.TextDecoration;
 import prime.gui.text.TextTransform;
 import prime.types.Number;
 import prime.types.RGBA;
 import prime.utils.NumberUtil;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;
  using prime.utils.Color;


private typedef Flags = TextStyleFlags;


/**
 * Class holding all style properties for fonts.
 * Font properties are also inheritable of the container object.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class TextStyle extends StyleSubBlock
{
	private var extendedStyle	: TextStyle;
	private var nestingStyle	: TextStyle;
	private var superStyle		: TextStyle;
	private var parentStyle		: TextStyle;
	
	private var _size			: Int;
	private var _family			: String;
	private var _embeddedFont	: Bool;
	private var _color			: Null < RGBA >;
	private var _weight			: FontWeight;
	private var _style			: FontStyle;
	private var _letterSpacing	: Float;
	private var _align			: #if (nme && cpp) String #else TextAlign #end;
	private var _decoration		: TextDecoration;
	private var _indent			: Float;
	private var _transform		: TextTransform;
	private var _textWrap		: Null < Bool >;
	private var _columnCount	: Int;
	private var _columnGap		: Int;
	private var _columnWidth	: Int;
	
	
	public var size				(get_size,			set_size)			: Int;
	public var family			(get_family,		set_family)			: String;
	public var embeddedFont		(get_embeddedFont,	set_embeddedFont)	: Bool;
	public var color			(get_color,			set_color)			: Null<RGBA>;
	public var weight			(get_weight,		set_weight)			: FontWeight;
	public var style			(get_style,			set_style)			: FontStyle;
	/**
	 * @default	0
	 */
	public var letterSpacing	(get_letterSpacing,	set_letterSpacing)	: Float;
	public var align			(get_align,			set_align)			: #if (nme && cpp) String #else TextAlign #end;
	public var decoration		(get_decoration,	set_decoration)		: TextDecoration;
	public var indent			(get_indent,		set_indent)			: Float;
	public var transform		(get_transform,		set_transform)		: TextTransform;
	
	public var textWrap			(get_textWrap,		set_textWrap)		: Null < Bool >;
	public var columnCount		(get_columnCount,	set_columnCount)	: Int;
	public var columnGap		(get_columnGap,		set_columnGap)		: Int;
	public var columnWidth		(get_columnWidth,	set_columnWidth)	: Int;
	
	
	public function new (
		filledProps	: Int			= 0,
		size:Int					= Number.INT_NOT_SET,
		family:String				= null,
		embeddedFont:Bool			= false,
		color:Null<RGBA>			= null,
		weight:FontWeight			= null,
		style:FontStyle				= null,
		letterSpacing:Float			= Number.INT_NOT_SET,
		align:#if (nme && cpp) String #else TextAlign #end = null,
		decoration:TextDecoration	= null,
		indent:Float				= Number.INT_NOT_SET,
		transform:TextTransform		= null,
		textWrap:Null < Bool >		= null,
		columnCount:Int				= Number.INT_NOT_SET,
		columnGap:Int				= Number.INT_NOT_SET,
		columnWidth:Int				= Number.INT_NOT_SET
	)
	{
		super(filledProps);
		#if (flash9 || nme) this._size          #else this.size          #end = size;
		#if (flash9 || nme) this._family        #else this.family        #end = family;
		#if (flash9 || nme) this._embeddedFont  #else this.embeddedFont  #end = embeddedFont;
		#if (flash9 || nme) this._color         #else this.color         #end = color;
		#if (flash9 || nme) this._weight        #else this.weight        #end = weight;
		#if (flash9 || nme) this._style         #else this.style         #end = style;
		#if (flash9 || nme) this._letterSpacing #else this.letterSpacing #end = letterSpacing == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : letterSpacing;
		#if (flash9 || nme) this._align         #else this.align         #end = align;
		#if (flash9 || nme) this._decoration    #else this.decoration    #end = decoration;
		#if (flash9 || nme) this._indent        #else this.indent        #end = indent == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : indent;
		#if (flash9 || nme) this._transform     #else this.transform     #end = transform;
		#if (flash9 || nme) this._textWrap      #else this.textWrap      #end = textWrap;
		#if (flash9 || nme) this._columnCount   #else this.columnCount   #end = columnCount;
		#if (flash9 || nme) this._columnGap     #else this.columnGap     #end = columnGap;
		#if (flash9 || nme) this._columnWidth   #else this.columnWidth   #end = columnWidth;
	}
	
	
	override public function dispose ()
	{
		_family		= null;
		_align		= null;
		_weight		= null;
		_style		= null;
		_decoration	= null;
		_transform	= null;
		_textWrap	= null;
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.invalidated.unbind( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.font;
				
				if (extendedStyle != null)
					extendedStyle.invalidated.bind( this, invalidateCall );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.NESTING_STYLE ))
		{
			if (nestingStyle != null)
				nestingStyle.invalidated.unbind( this );
			
			nestingStyle = null;
			if (owner != null && owner.nestingInherited != null)
			{
				nestingStyle = owner.nestingInherited.font;
				
				if (nestingStyle != null)
					nestingStyle.invalidated.bind( this, invalidateCall );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.invalidated.unbind( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.font;
				
				if (superStyle != null)
					superStyle.invalidated.bind( this, invalidateCall );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.PARENT_STYLE ))
		{
			if (parentStyle != null)
				parentStyle.invalidated.unbind( this );
			
			parentStyle = null;
			if (owner != null && owner.parentStyle != null)
			{
				parentStyle = owner.parentStyle.font;
				
				if (parentStyle != null)
					parentStyle.invalidated.bind( this, invalidateCall );
			}
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		inheritedProperties = 0;
		if (extendedStyle != null)	inheritedProperties  = extendedStyle.allFilledProperties;
		if (nestingStyle != null)	inheritedProperties |= nestingStyle.allFilledProperties;
		if (superStyle != null)		inheritedProperties |= superStyle.allFilledProperties;
		if (parentStyle != null)	inheritedProperties |= parentStyle.allFilledProperties;
		
		allFilledProperties = filledProperties | inheritedProperties;
		inheritedProperties	= inheritedProperties.unset( filledProperties );
	}
	
	
	override public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool)
	{
		var props = filledProperties;
		if (!noExtendedStyle && extendedStyle != null)	props |= extendedStyle.allFilledProperties;
		if (!noSuperStyle && superStyle != null)		props |= superStyle.allFilledProperties;
		return props;
	}
	
	
	override private function isPropAnStyleReference ( property)
	{
		return super.isPropAnStyleReference(property) || property == StyleFlags.NESTING_STYLE || property == StyleFlags.PARENT_STYLE;
	}
	
	
	/**
	 * Method is called when a property in the parent-, super-, extended- or 
	 * nested-style is changed. If the property is not set in this style-object,
	 * it means that the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
		var propIsInNesting		= nestingStyle != null	&& nestingStyle	.allFilledProperties.has( changeFromOther );
		var propIsInParent		= parentStyle != null	&& parentStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the nesting style and the extendedStyle doesn't have the property that is changed, broadcast the change as well
		else if (sender == nestingStyle && !propIsInExtended)
		{
			if (propIsInNesting)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the nesting- and extendedStyle doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended && !propIsInNesting)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the parent style and the other styles doesn't have the property that is changed, broadcast the change as well
		else if (sender == parentStyle && !propIsInExtended && !propIsInNesting && !propIsInSuper)
		{
			if (propIsInParent)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	private function get_size ()
	{
		var v = _size;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.size;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.size;
		if (v.notSet() && superStyle != null)		v = superStyle.size;
		if (v.notSet() && parentStyle != null)		v = parentStyle.size;
		
		return v;
	}
	
	
	private function get_family ()
	{
		var v = _family;
		if (v == null && extendedStyle != null)		v = extendedStyle.family;
		if (v == null && nestingStyle != null)		v = nestingStyle.family;
		if (v == null && superStyle != null)		v = superStyle.family;
		if (v == null && parentStyle != null)		v = parentStyle.family;

		return v;
	}

	
	private function get_embeddedFont ()
	{
		var fam = _family;
		var val = _embeddedFont;
		if (fam == null && extendedStyle != null)	{ fam = extendedStyle.family; 	val = extendedStyle.embeddedFont; }
		if (fam == null && nestingStyle != null)	{ fam = nestingStyle.family;	val = nestingStyle.embeddedFont; }
		if (fam == null && superStyle != null)		{ fam = superStyle.family;		val = superStyle.embeddedFont; }
		if (fam == null && parentStyle != null)		{ fam = parentStyle.family;		val = parentStyle.embeddedFont; }

		return val;
	}
	
	
	private function get_color ()
	{
		var v = _color;
		if (v == null && extendedStyle != null)		v = extendedStyle.color;
		if (v == null && nestingStyle != null)		v = nestingStyle.color;
		if (v == null && superStyle != null)		v = superStyle.color;
		if (v == null && parentStyle != null)		v = parentStyle.color;

		return v;
	}
	
	
	private function get_align ()
	{
		var v = _align;
		if (v == null && extendedStyle != null)		v = extendedStyle.align;
		if (v == null && nestingStyle != null)		v = nestingStyle.align;
		if (v == null && superStyle != null)		v = superStyle.align;
		if (v == null && parentStyle != null)		v = parentStyle.align;

		return v;
	}
	
	
	private function get_weight ()
	{
		var v = _weight;
		if (v == null && extendedStyle != null)		v = extendedStyle.weight;
		if (v == null && nestingStyle != null)		v = nestingStyle.weight;
		if (v == null && superStyle != null)		v = superStyle.weight;
		if (v == null && parentStyle != null)		v = parentStyle.weight;

		return v;
	}
	
	
	private function get_style ()
	{
		var v = _style;
		if (v == null && extendedStyle != null)		v = extendedStyle.style;
		if (v == null && nestingStyle != null)		v = nestingStyle.style;
		if (v == null && superStyle != null)		v = superStyle.style;
		if (v == null && parentStyle != null)		v = parentStyle.style;

		return v;
	}

	
	private function get_letterSpacing ()
	{
		var v = _letterSpacing;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.letterSpacing;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.letterSpacing;
		if (v.notSet() && superStyle != null)		v = superStyle.letterSpacing;
		if (v.notSet() && parentStyle != null)		v = parentStyle.letterSpacing;

		return v;
	}
	
	
	private function get_decoration ()
	{
		var v = _decoration;
		if (v == null && extendedStyle != null)		v = extendedStyle.decoration;
		if (v == null && nestingStyle != null)		v = nestingStyle.decoration;
		if (v == null && superStyle != null)		v = superStyle.decoration;
		if (v == null && parentStyle != null)		v = parentStyle.decoration;

		return v;
	}
	
	
	private function get_indent ()
	{
		var v = _indent;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.indent;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.indent;
		if (v.notSet() && superStyle != null)		v = superStyle.indent;
		if (v.notSet() && parentStyle != null)		v = parentStyle.indent;

		return v;
	}
	
	
	private function get_transform ()
	{
		var v = _transform;
		if (v == null && extendedStyle != null)		v = extendedStyle.transform;
		if (v == null && nestingStyle != null)		v = nestingStyle.transform;
		if (v == null && superStyle != null)		v = superStyle.transform;
		if (v == null && parentStyle != null)		v = parentStyle.transform;

		return v;
	}
	
	
	private function get_textWrap ()
	{
		var v = _textWrap;
		if (v == null && extendedStyle != null)		v = extendedStyle.textWrap;
		if (v == null && nestingStyle != null)		v = nestingStyle.textWrap;
		if (v == null && superStyle != null)		v = superStyle.textWrap;
		if (v == null && parentStyle != null)		v = parentStyle.textWrap;

		return v;
	}
	
	
	private function get_columnCount ()
	{
		var v = _columnCount;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnCount;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnCount;
		if (v.notSet() && superStyle != null)		v = superStyle.columnCount;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnCount;

		return v;
	}
	
	
	private function get_columnGap ()
	{
		var v = _columnGap;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnGap;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnGap;
		if (v.notSet() && superStyle != null)		v = superStyle.columnGap;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnGap;

		return v;
	}
	
	
	private function get_columnWidth ()
	{
		var v = _columnWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnWidth;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.columnWidth;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnWidth;

		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function set_size (v)
	{
		if (v != _size) {
			_size = v;
			markProperty( Flags.SIZE, v.isSet() );
		}
		return v;
	}
	
	
	private function set_family (v)
	{
		if (v != _family) {
			_family = v;
			markProperty( Flags.FAMILY, v != null );
		}
		return v;
	}

	
	private function set_embeddedFont (v)
	{
		if (v != _embeddedFont) {
			_embeddedFont = v;
			markProperty( Flags.EMBEDDED, _family != null );
		}
		return v;
	}
	
	
	private function set_color (v:Null<RGBA>)
	{
		if (v != null)
			v = v.validate();
		
		if (v != _color) {
			_color = v;
			markProperty( Flags.COLOR, v != null );
		}
		return v;
	}
	
	
	private function set_weight (v)
	{
		if (v != _weight) {
			_weight = v;
			markProperty( Flags.WEIGHT, v != null );
		}
		return v;
	}
	
	
	private function set_style (v)
	{
		if (v != _style) {
			_style = v;
			markProperty( Flags.STYLE, v != null );
		}
		return v;
	}
	
	
	private function set_letterSpacing (v)
	{
		if (v != _letterSpacing) {
			_letterSpacing = v;
			markProperty( Flags.LETTER_SPACING, v.isSet() );
		}
		return v;
	}
	
	
	private function set_align (v)
	{
		if (v != _align) {
			_align = v;
			markProperty( Flags.ALIGN, v != null );
		}
		return v;
	}
	
	
	private function set_decoration (v)
	{
		if (v != _decoration) {
			_decoration = v;
			markProperty( Flags.DECORATION, v != null );
		}
		return v;
	}
	
	
	private function set_indent (v)
	{
		if (v != _indent) {
			_indent = v;
			markProperty( Flags.INDENT, v.isSet() );
		}
		return v;
	}
	
	
	private function set_transform (v)
	{
		if (v != _transform) {
			_transform = v;
			markProperty( Flags.TRANSFORM, v != null );
		}
		return v;
	}
	
	
	private function set_textWrap (v)
	{
		if (v != _textWrap) {
			_textWrap = v;
			markProperty( Flags.TEXTWRAP, v != null );
		}
		return v;
	}
	
	
	private function set_columnCount (v)
	{
		if (v != _columnCount) {
			_columnCount = v;
			markProperty( Flags.COLUMN_COUNT, v.isSet() );
		}
		return v;
	}
	
	
	private function set_columnGap (v)
	{
		if (v != _columnGap) {
			_columnGap = v;
			markProperty( Flags.COLUMN_GAP, v.isSet() );
		}
		return v;
	}
	
	
	private function set_columnWidth (v)
	{
		if (v != _columnWidth) {
			_columnWidth = v;
			markProperty( Flags.COLUMN_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	

#if CSSParser
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		if (_size.isSet())				css.push("font-size: " 		+ _size + "px");
		if (_family != null)			css.push("font-family: "	+ _family);
		if (_color != null)				css.push("color: "			+ _color.string());
		if (_weight != null)			css.push("font-weight: "	+ _weight);
		if (_style != null)				css.push("font-style: "		+ _style);
		if (_letterSpacing.isSet())		css.push("letter-spacing: "	+ _letterSpacing);
		if (_align != null)				css.push("text-align: "		+ _align);
		if (_decoration != null)		css.push("text-decoration: "+ _decoration);
		if (_indent.isSet())			css.push("text-indent: "	+ _indent);
		if (_transform != null)			css.push("text-transform: "	+ _transform);
		if (_textWrap != null)			css.push("text-wrap: "		+ _textWrap);
		if (_columnCount.isSet())		css.push("column-count: "	+ _columnCount);
		if (_columnGap.isSet())			css.push("column-gap: "		+ _columnGap);
		if (_columnWidth.isSet())		css.push("column-width: "	+ _columnWidth);
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function toCode (code:prime.tools.generator.ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ filledProperties, _size, _family, _embeddedFont, _color, _weight, _style, _letterSpacing, _align, _decoration, _indent, _transform, _textWrap, _columnCount, _columnGap, _columnWidth ] );
	}
	
	override public function cleanUp () {}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return Flags.readProperties( flags );
	}
#end
}