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
#if CSSParser
 import prime.tools.generator.ICodeGenerator;
  using prime.types.Reference;
#end
 import prime.core.geom.Corners;
 import prime.core.traits.IInvalidatable;
 import prime.gui.graphics.borders.IBorder;
 import prime.gui.graphics.shapes.IGraphicShape;
 import prime.gui.graphics.IGraphicProperty;
 import prime.types.Asset;
 import prime.types.Factory;
 import prime.types.Number;
  using prime.utils.BitUtil;
  using prime.utils.NumberUtil;


private typedef Flags		= GraphicFlags;
private typedef Shape		= #if CSSParser prime.types.Reference; #else IGraphicShape; #end
private typedef Skin		= #if CSSParser Factory<Dynamic> #else Factory<prime.gui.core.ISkin> #end;
private typedef Icon		= Factory<Dynamic>;
private typedef Overflow	= #if CSSParser Factory1<Dynamic, Dynamic> #else Factory1<prime.gui.traits.IScrollable, prime.gui.behaviours.scroll.IScrollBehaviour> #end;


/**
 * Style-sub-block containing all the graphic/visual properties for an element.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 25, 2010
 */
class GraphicsStyle extends StyleSubBlock
{
	private var extendedStyle	: GraphicsStyle;
	private var superStyle		: GraphicsStyle;
	
	private var _shape			: Shape;
	private var _skin			: Skin;
	private var _overflow		: Overflow;
	private var _opacity		: Float;
	private var _visible		: Null < Bool >;
	private var _icon			: Icon;
	private var _iconFill		: IGraphicProperty;
	private var _background		: IGraphicProperty;
	private var _border			: IBorder;
	private var _borderRadius	: Corners;
	
	
	/**
	 * Cached asset instance of the Icon factory. Created and available through 
	 * the use of getIconInstance
	 */
	private var iconAsset		: Asset;
	
	
	public var shape		(get_shape,			set_shape)			: Shape;
	public var skin			(get_skin,			set_skin)			: Skin;
	public var overflow		(get_overflow,		set_overflow)		: Overflow;
	public var opacity		(get_opacity,		set_opacity)		: Float;
	public var visible		(get_visible,		set_visible)		: Null< Bool >;
	public var icon			(get_icon,			set_icon)			: Icon;
	public var iconFill		(get_iconFill,		set_iconFill)		: IGraphicProperty;
	public var background	(get_background, 	set_background)		: IGraphicProperty;
	public var border		(get_border,		set_border)			: IBorder;
	public var borderRadius	(get_borderRadius,	set_borderRadius)	: Corners;
	
	
	
	public function new (
		filledProps	: Int = 0,
		background	: IGraphicProperty = null,
		border		: IBorder = null,
		shape		: Shape = null,
		skin		: Skin = null,
		overflow	: Overflow = null,
		visible		: Null < Bool > = null,
		opacity		: Float = Number.INT_NOT_SET,
		icon		: Icon = null,
		iconFill	: IGraphicProperty = null,
		borderRadius: Corners = null)
	{
		super(filledProps);
		
		#if (flash9 || nme) this._shape         #else this.shape         #end = shape;
		#if (flash9 || nme) this._background    #else this.background    #end = background;
		#if (flash9 || nme) this._border        #else this.border        #end = border;
		#if (flash9 || nme) this._skin          #else this.skin          #end = skin;
		#if (flash9 || nme) this._visible       #else this.visible       #end = visible;
		#if (flash9 || nme) this._opacity       #else this.opacity       #end = opacity != Number.INT_NOT_SET ? opacity : Number.FLOAT_NOT_SET;
		#if (flash9 || nme) this._icon          #else this.icon          #end = icon;
		#if (flash9 || nme) this._iconFill      #else this.iconFill      #end = iconFill;
		#if (flash9 || nme) this._overflow      #else this.overflow      #end = overflow;
		#if (flash9 || nme) this._borderRadius  #else this.borderRadius  #end = borderRadius;
		
#if debug
		if (shape != null) {
			Assert.isNotNull( this.shape );
			Assert.that( owns(Flags.SHAPE) );
		}
#end
	}
	
	
	override public function dispose ()
	{
		extendedStyle = superStyle = null;
		
	//	if (_skin != null)			_skin.dispose();
		if (_background != null)	_background.dispose();
		if (_border != null)		_border.dispose();
		if (_iconFill != null)		_iconFill.dispose();
		if (iconAsset != null)		iconAsset.dispose();
#if !CSSParser
		if (_shape != null)			_shape.dispose();
		if (iconAsset != null)		{ iconAsset.dispose(); iconAsset = null; }
#end
		
		_skin			= null;
		_shape			= null;
		_background		= null;
		_border			= null;
		_icon			= null;
		_iconFill		= null;
		_overflow		= null;
		_visible		= null;
		_borderRadius	= null;
		_opacity		= Number.FLOAT_NOT_SET;
		
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
				extendedStyle = owner.extendedStyle.graphics;
				
				if (extendedStyle != null)
					extendedStyle.invalidated.bind( this, invalidateCall );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.invalidated.unbind( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.graphics;
				
				if (superStyle != null)
					superStyle.invalidated.bind( this, invalidateCall );
			}
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		inheritedProperties = 0;
		if (extendedStyle != null)	inheritedProperties  = extendedStyle.allFilledProperties;
		if (superStyle != null)		inheritedProperties |= superStyle.allFilledProperties;
		
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
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
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
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	
	private function get_skin ()
	{
		//if the skin flag is set, the property is allowed to be null (skin: 'none')
		var v:Skin = null;
		if (owns( Flags.SKIN ))							v = _skin;
		else {
			if 		(extendedStyle != null)				v = extendedStyle.skin;
			else if (v == null && superStyle != null)	v = superStyle.skin;
		}
		return v;
	}
	
	
	private function get_shape ()
	{
		var v = _shape;
		if (v == null && extendedStyle != null)		v = extendedStyle.shape;
		if (v == null && superStyle != null)		v = superStyle.shape;
		return v;
	}
	

	private function get_background ()
	{
		var v = _background;
		if (v == null && extendedStyle != null)		v = extendedStyle.background;
		if (v == null && superStyle != null)		v = superStyle.background;
		return v;
	}


	private function get_border ()
	{
		var v = _border;
		if (v == null && extendedStyle != null)		v = extendedStyle.border;
		if (v == null && superStyle != null)		v = superStyle.border;
		return v;
	}
	
	
	private function get_visible ()
	{
		var v = _visible;
		if (v == null && extendedStyle != null)		v = extendedStyle.visible;
		if (v == null && superStyle != null)		v = superStyle.visible;
		return v;
	}


	private function get_opacity ()
	{
		var v = _opacity;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.opacity;
		if (v.notSet() && superStyle != null)		v = superStyle.opacity;
		return v;
	}
	

	private function get_icon ()
	{
		var v = _icon;
		if (v == null && extendedStyle != null)		v = extendedStyle.icon;
		if (v == null && superStyle != null)		v = superStyle.icon;
		return v;
	}
	

	private function get_iconFill ()
	{
		var v = _iconFill;
		if (v == null && extendedStyle != null)		v = extendedStyle.iconFill;
		if (v == null && superStyle != null)		v = superStyle.iconFill;
		return v;
	}
	

	private function get_overflow ()
	{
		//if the overflow flag is set, the property is allowed to be null (overflow: 'visible')
		var v:Overflow = null;
		if (owns( Flags.OVERFLOW ))						v = _overflow;
		else {
			if 		(extendedStyle != null)				v = extendedStyle.overflow;
			else if (v == null && superStyle != null)	v = superStyle.overflow;
		}
		return v;
	}
	

	private function get_borderRadius ()
	{
		var v = _borderRadius;
		if (v == null && extendedStyle != null)		v = extendedStyle.borderRadius;
		if (v == null && superStyle != null)		v = superStyle.borderRadius;
		return v;
	}
	
	
#if (flash9 || nme)
	public function getIconInstance () : Asset
	{
		if (iconAsset != null)	return iconAsset;
		if (_icon != null)		return iconAsset = Asset.fromFactory( _icon );
		
		if (extendedStyle != null && extendedStyle.has(Flags.ICON))
			return extendedStyle.getIconInstance();
		
		if (superStyle != null && superStyle.has(Flags.ICON))
			return superStyle.getIconInstance();
		
		return null;
	}
#end
	
	
	
	//
	// SETTERS
	//
	
	private function set_skin (v)
	{
		if (v != _skin) {
			_skin = v;
			markProperty( Flags.SKIN, v != null );
		}
		return v;
	}


	private function set_shape (v)
	{
		if (v != _shape) {
			_shape = v;
			markProperty( Flags.SHAPE, v != null );
		}
		return v;
	}
	
	
	private function set_background (v)
	{
		if (v != _background) {
			_background = v;
			markProperty( Flags.BACKGROUND, v != null );
		}
		return v;
	}


	private function set_border (v)
	{
		if (v != _border) {
			_border = v;
			markProperty( Flags.BORDER, v != null );
		}
		return v;
	}
	
	
	private function set_visible (v)
	{
		if (v != _visible) {
			_visible = v;
			markProperty( Flags.VISIBLE, v != null );
		}
		return v;
	}
	
	
	private function set_opacity (v)
	{
		if (v != _opacity) {
			_opacity = v;
			markProperty( Flags.OPACITY, v.isSet() );
		}
		return v;
	}
	
	
	private function set_icon (v)
	{
		if (v != _icon) {
			_icon = v;
			markProperty( Flags.ICON, v != null );
		}
		return v;
	}
	
	
	private function set_iconFill (v)
	{
		if (v != _iconFill) {
			_iconFill = v;
			markProperty( Flags.ICON_FILL, v != null );
		}
		return v;
	}
	
	
	private function set_overflow (v)
	{
		if (v != _overflow) {
			_overflow = v;
			markProperty( Flags.OVERFLOW, v != null );
		}
		return v;
	}
	
	
	private function set_borderRadius (v)
	{
		if (v != _borderRadius) {
			_borderRadius = v;
			markProperty( Flags.BORDER_RADIUS, v != null );
		}
		return v;
	}
	
	
	
	
#if CSSParser
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		if (_skin != null)			css.push("skin: " + _skin.toCSS() );
		if (_shape != null)			css.push("shape: " + _shape.toCSS() );
		if (_background != null)	css.push("background: " + _background.toCSS() );
		if (_border != null)		css.push("border: "+ _border.toCSS() );
		if (_visible != null)		css.push("visability: "+ _visible );
		if (_opacity.isSet())		css.push("opacity: "+ _opacity );
		if (_icon != null)			css.push("icon: "+ _icon );
		if (_iconFill != null)		css.push("icon-fill: "+ _iconFill );
		if (_overflow != null)		css.push("overflow: "+ _overflow.toCSS() );
		if (_borderRadius != null)	css.push("border-radius: "+ _borderRadius );
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ filledProperties, _background, _border, _shape, _skin, _overflow, _visible, _opacity, _icon, _iconFill, _borderRadius ] );
	}
	
	
	override public function cleanUp ()
	{
		if (_background != null)
		{
			_background.cleanUp();
			if (_background.isEmpty()) {
				_background.dispose();
				background = null;
			}
		}
		
		if (_iconFill != null)
		{
			_iconFill.cleanUp();
			if (_iconFill.isEmpty()) {
				_iconFill.dispose();
				iconFill = null;
			}
		}
		
		if (_border != null)
		{
			_border.cleanUp();
			if (_border.isEmpty()) {
				_border.dispose();
				border = null;
			}
		}
	#if !CSSParser
		if (_shape != null)
		{
			_shape.cleanUp();
			if (_shape.isEmpty()) {
				_shape.dispose();
				shape = null;
			}
		}
		
		if (_icon != null)
		{
			_icon.cleanUp();
			if (_icon.isEmpty()) {
				_icon.dispose();
				icon = null;
			}
		}
	#end
	}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;

		return Flags.readProperties(flags);
	}
#end
}