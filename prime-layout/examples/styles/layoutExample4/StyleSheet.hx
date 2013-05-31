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
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package ;
 import prime.gui.styling.LayoutStyleFlags;
 import prime.gui.styling.StyleChildren;
 import prime.gui.styling.StyleBlockType;
 import prime.gui.styling.StyleBlock;
 import prime.types.Number;
 import prime.core.geom.Box;
 import prime.core.geom.Corners;
 import prime.core.geom.space.Horizontal;
 import prime.core.geom.space.Vertical;
 import prime.gui.behaviours.layout.ClippedLayoutBehaviour;
 import prime.gui.behaviours.scroll.ShowScrollbarsBehaviour;
 import prime.gui.components.skins.BasicPanelSkin;
 import prime.gui.components.skins.ButtonIconLabelSkin;
 import prime.gui.components.skins.ButtonIconSkin;
 import prime.gui.components.skins.ButtonLabelSkin;
 import prime.gui.components.skins.InputFieldSkin;
 import prime.gui.components.skins.SlidingToggleButtonSkin;
 import prime.gui.effects.MoveEffect;
 import prime.gui.graphics.borders.CapsStyle;
 import prime.gui.graphics.borders.JointStyle;
 import prime.gui.graphics.borders.SolidBorder;
 import prime.gui.graphics.fills.SolidFill;
 import prime.gui.graphics.shapes.RegularRectangle;
 import prime.gui.styling.EffectsStyle;
 import prime.gui.styling.GraphicsStyle;
 import prime.gui.styling.LayoutStyle;
 import prime.gui.styling.StatesStyle;
 import prime.gui.styling.StyleBlock;
 import prime.gui.styling.StyleBlockType;
 import prime.gui.styling.TextStyle;
 import prime.gui.text.TextAlign;
 import prime.gui.text.TextTransform;
 import prime.layout.algorithms.floating.HorizontalFloatAlgorithm;
 import prime.layout.algorithms.floating.VerticalFloatAlgorithm;
 import prime.layout.algorithms.RelativeAlgorithm;
 import prime.layout.algorithms.tile.SimpleTileAlgorithm;
 import prime.layout.RelativeLayout;



/**
 * This class is a template for generating UIElementStyle classes
 */
class StyleSheet extends StyleBlock
{
	public function new ()
	{
		super(0, StyleBlockType.specific);
		elementChildren		= new ChildrenList();
		styleNameChildren	= new ChildrenList();
		idChildren			= new ChildrenList();
		
		
		var styleBlock0 = new StyleBlock(64, StyleBlockType.element, new GraphicsStyle(56, null, null, new RegularRectangle(), null, null, true, 1));
		this.elementChildren.set('prime.gui.display.IDisplayObject', styleBlock0);
		var styleBlock1 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(128, null, null, null, null, function (a) { return new ClippedLayoutBehaviour(a); }));
		styleBlock1.setInheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.core.UIWindow', styleBlock1);
		var styleBlock2 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(8, null, null, new RegularRectangle()));
		styleBlock2.setInheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.core.UIGraphic', styleBlock2);
		var styleBlock3 = new StyleBlock(0x000872, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(-256)), new LayoutStyle(8, null, null, null, function () { return new HorizontalFloatAlgorithm(Horizontal.center, Vertical.center); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648), new TextStyle(7, 10, 'Arial', false, 0x444444FF, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648));
		styleBlock3.setInheritedStyles(null, styleBlock0);
		var styleBlock4 = new StyleBlock(18, StyleBlockType.element, null, new LayoutStyle(0x000100, null, null, null, null, LayoutStyleFlags.FILL, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock4.setInheritedStyles(null, styleBlock0, null, styleBlock3);
		var hash5 = new Hash();
		hash5.set('prime.gui.core.UITextField', styleBlock4);
		styleBlock3.setChildren(null, null, hash5);
		var styleBlock6 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(5, null, new SolidBorder(new SolidFill(255), 1, false, CapsStyle.NONE, JointStyle.ROUND, false), null, function () { return new InputFieldSkin(); }));
		styleBlock6.setInheritedStyles(null, styleBlock3);
		this.elementChildren.set('prime.gui.components.InputField', styleBlock6);
		var styleBlock7 = new StyleBlock(34, StyleBlockType.element, null, null, new TextStyle(3, 12, 'Verdana', false, null, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648));
		styleBlock7.setInheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.components.Label', styleBlock7);
		var styleBlock8 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(8, null, null, new RegularRectangle()));
		styleBlock8.setInheritedStyles(null, styleBlock2);
		this.elementChildren.set('prime.gui.components.Image', styleBlock8);
		this.elementChildren.set('prime.gui.components.Button', styleBlock3);
		var styleBlock9 = new StyleBlock(82, StyleBlockType.element, new GraphicsStyle(129, null, null, null, null, function (a) { return new ShowScrollbarsBehaviour(a); }), new LayoutStyle(8, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock9.setInheritedStyles(null, styleBlock6);
		this.elementChildren.set('prime.gui.components.TextArea', styleBlock9);
		var styleBlock10 = new StyleBlock(82, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(-1)), new LayoutStyle(8, null, null, null, function () { return new RelativeAlgorithm(); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock10.setInheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.components.SliderBase', styleBlock10);
		var styleBlock11 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0x212121FF)));
		styleBlock11.setInheritedStyles(null, styleBlock10);
		this.elementChildren.set('prime.gui.components.ScrollBar', styleBlock11);
		var styleBlock12 = new StyleBlock(82, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconLabelSkin(); }), new LayoutStyle(32, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, 40, -2147483648, -2147483648, -2147483648));
		styleBlock12.setInheritedStyles(null, styleBlock3);
		this.elementChildren.set('prime.gui.components.ComboBox', styleBlock12);
		var styleBlock13 = new StyleBlock(0x002042, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new BasicPanelSkin(); }));
		styleBlock13.setInheritedStyles(null, styleBlock0);
		var hash14 = new Hash();
		hash14.set('closeBtn', new StyleBlock(64, StyleBlockType.id, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconSkin(); })));
		styleBlock13.setChildren(hash14);
		this.elementChildren.set('prime.gui.components.Panel', styleBlock13);
		var styleBlock15 = new StyleBlock(0x000852, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0x111111AA)), new LayoutStyle(0x00010C, new RelativeLayout(-2147483648, -2147483648, 0, -2147483648, -2147483648, -2147483648), null, null, function () { return new HorizontalFloatAlgorithm(Horizontal.center, Vertical.center); }, 1, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock15.setInheritedStyles(null, styleBlock0);
		var styleBlock16 = new StyleBlock(0x000476, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(-858993409), null, null, function () { return new ButtonLabelSkin(); }), new LayoutStyle(0x003000, null, new Box(4, 6, 4, 6), new Box(5, 5, 5, 5), null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648), new TextStyle(5, 10, null, false, 0x333333FF, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648));
		styleBlock16.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock15);
		var intHash17 = new IntHash();
		intHash17.set(2, new StyleBlock(64, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(-1))));
		intHash17.set(0x000800, new StyleBlock(64, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(-1))));
		styleBlock16.states = new StatesStyle(0x000802, intHash17);
		var hash18 = new Hash();
		hash18.set('prime.gui.components.Button', styleBlock16);
		styleBlock15.setChildren(null, null, hash18);
		this.elementChildren.set('prime.gui.components.DebugBar', styleBlock15);
		var styleBlock19 = new StyleBlock(0x000812, StyleBlockType.element, null, new LayoutStyle(8, null, null, null, function () { return new SimpleTileAlgorithm(); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock19.setInheritedStyles(null, styleBlock1);
		var styleBlock20 = new StyleBlock(84, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(-5592321)), new LayoutStyle(0x001003, null, null, new Box(20, 5, 20, 5), null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 30, 50, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock20.setInheritedStyles(null, null, styleBlock0, styleBlock19);
		var hash21 = new Hash();
		hash21.set('prime.gui.display.IDisplayObject', styleBlock20);
		var styleBlock22 = new StyleBlock(0x000402, StyleBlockType.element);
		styleBlock22.setInheritedStyles(null, styleBlock20, null, styleBlock19);
		var intHash23 = new IntHash();
		intHash23.set(2, new StyleBlock(80, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(-290791937)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 80, 80, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648)));
		styleBlock22.states = new StatesStyle(2, intHash23);
		hash21.set('prime.gui.core.UIComponent', styleBlock22);
		var styleBlock24 = new StyleBlock(70, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(-571561217)));
		styleBlock24.setInheritedStyles(null, styleBlock20, styleBlock2, styleBlock19);
		hash21.set('prime.gui.core.UIGraphic', styleBlock24);
		styleBlock19.setChildren(null, null, hash21);
		this.elementChildren.set('examples.layout.LayoutExample4', styleBlock19);
		var styleBlock25 = new StyleBlock(66, StyleBlockType.element, new GraphicsStyle(36, null, new SolidBorder(new SolidFill(-16711681), 3, false, CapsStyle.NONE, JointStyle.ROUND, false), null, null, null, null, 0.7));
		var styleBlock26 = new StyleBlock(0x000800, StyleBlockType.styleName);
		styleBlock25.setInheritedStyles(null, styleBlock0, null, styleBlock26);
		var hash27 = new Hash();
		hash27.set('prime.gui.core.UIComponent', styleBlock25);
		styleBlock26.setChildren(null, null, hash27);
		this.styleNameChildren.set('debug', styleBlock26);
		var styleBlock28 = new StyleBlock(18, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 1, 1, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		var styleBlock29 = new StyleBlock(0x000810, StyleBlockType.styleName, null, new LayoutStyle(8, null, null, null, function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock28.setInheritedStyles(null, styleBlock0, null, styleBlock29);
		var hash30 = new Hash();
		hash30.set('prime.gui.components.ListView', styleBlock28);
		var styleBlock31 = new StyleBlock(18, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 1, 1, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock31.setInheritedStyles(null, styleBlock28, null, styleBlock29);
		hash30.set('prime.gui.components.SelectableListView', styleBlock31);
		styleBlock29.setChildren(null, null, hash30);
		this.styleNameChildren.set('listHolder', styleBlock29);
		var styleBlock32 = new StyleBlock(22, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 0, 1, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		var styleBlock33 = new StyleBlock(0x000810, StyleBlockType.styleName, null, new LayoutStyle(34, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, 4, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, 30, -2147483648, -2147483648, -2147483648));
		styleBlock32.setInheritedStyles(null, styleBlock0, styleBlock2, styleBlock33);
		var hash34 = new Hash();
		hash34.set('prime.gui.core.UIGraphic', styleBlock32);
		var styleBlock35 = new StyleBlock(86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x666666FF)), new LayoutStyle(7, new RelativeLayout(-2147483648, -2147483648, -2147483648, -2147483648, -2147483648, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 15, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock35.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock33);
		hash34.set('prime.gui.components.Button', styleBlock35);
		styleBlock33.setChildren(null, null, hash34);
		this.styleNameChildren.set('horizontalSlider', styleBlock33);
		var styleBlock36 = new StyleBlock(22, StyleBlockType.element, null, new LayoutStyle(0x000304, new RelativeLayout(-2147483648, -2147483648, 0, -2147483648, -2147483648, -2147483648), null, null, null, 1, 0, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		var styleBlock37 = new StyleBlock(0x000810, StyleBlockType.styleName, null, new LayoutStyle(129, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 4, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, 30, -2147483648));
		styleBlock36.setInheritedStyles(null, styleBlock0, styleBlock2, styleBlock37);
		var hash38 = new Hash();
		hash38.set('prime.gui.core.UIGraphic', styleBlock36);
		var styleBlock39 = new StyleBlock(86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x666666FF)), new LayoutStyle(135, new RelativeLayout(-2147483648, -2147483648, -2147483648, -2147483648, 0, -2147483648), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 15, 6, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, 15, -2147483648));
		styleBlock39.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock37);
		hash38.set('prime.gui.components.Button', styleBlock39);
		styleBlock37.setChildren(null, null, hash38);
		this.styleNameChildren.set('verticalSlider', styleBlock37);
		var styleBlock40 = new StyleBlock(86, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0x212121FF)), new LayoutStyle(39, new RelativeLayout(-2147483648, -2147483648, -2147483648, -2147483648, -2147483648, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 9, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, 15, -2147483648, -2147483648, -2147483648));
		var styleBlock41 = new StyleBlock(0x000810, StyleBlockType.styleName, null, new LayoutStyle(2, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, 2, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock40.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock41);
		var hash42 = new Hash();
		hash42.set('prime.gui.components.Button', styleBlock40);
		styleBlock41.setChildren(null, null, hash42);
		this.styleNameChildren.set('horizontalScrollBar', styleBlock41);
		var styleBlock43 = new StyleBlock(86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x212121FF)), new LayoutStyle(135, new RelativeLayout(-2147483648, -2147483648, -2147483648, -2147483648, 0, -2147483648), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 9, 6, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, 15, -2147483648));
		var styleBlock44 = new StyleBlock(0x000810, StyleBlockType.styleName, null, new LayoutStyle(1, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 2, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock43.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock44);
		var hash45 = new Hash();
		hash45.set('prime.gui.components.Button', styleBlock43);
		styleBlock44.setChildren(null, null, hash45);
		this.styleNameChildren.set('verticalScrollBar', styleBlock44);
		var styleBlock46 = new StyleBlock(0x000852, StyleBlockType.element, new GraphicsStyle(128, null, null, null, null, function (a) { return new ShowScrollbarsBehaviour(a); }), new LayoutStyle(0x00A3CB, null, new Box(0, 0, 0, 0), null, function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); }, Number.EMPTY, Number.EMPTY, Number.EMPTY, Number.EMPTY, -2147483648, 20, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, 60, 0x0001F4));
		var styleBlock47 = new StyleBlock(0x000840, StyleBlockType.styleName, new GraphicsStyle(0x000106, new SolidFill(-101058049), new SolidBorder(new SolidFill(0x707070FF), 1, false, CapsStyle.NONE, JointStyle.ROUND, false), null, null, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(10, 10, 10, 10)));
		styleBlock46.setInheritedStyles(null, styleBlock0, null, styleBlock47);
		var styleBlock48 = new StyleBlock(86, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconLabelSkin(); }), new LayoutStyle(0x011100, null, null, new Box(0, 0, 0, 0), null, 1, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648, 1));
		styleBlock48.setInheritedStyles(null, styleBlock0, styleBlock3, styleBlock46);
		var hash49 = new Hash();
		hash49.set('prime.gui.components.Button', styleBlock48);
		styleBlock46.setChildren(null, null, hash49);
		var hash50 = new Hash();
		hash50.set('prime.gui.components.SelectableListView', styleBlock46);
		styleBlock47.setChildren(null, null, hash50);
		this.styleNameChildren.set('comboList', styleBlock47);
		var hash51 = new Hash();
		hash51.set('onBg', new StyleBlock(80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-16776961)), new LayoutStyle(4, new RelativeLayout(1, -2147483648, 1, -2147483648, -2147483648, -2147483648), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648)));
		hash51.set('onLabel', new StyleBlock(32, StyleBlockType.id, null, null, new TextStyle(4, -2147483648, null, false, -1, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648)));
		hash51.set('slide', new StyleBlock(208, StyleBlockType.id, new GraphicsStyle(0x00010A, new SolidFill(-1), null, new RegularRectangle(), null, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(5, 5, 5, 5)), new LayoutStyle(0x000300, null, null, null, null, 0.51, 1.1, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648), null, new EffectsStyle(32, new MoveEffect(180, -2147483648, null, false))));
		var styleBlock52 = new StyleBlock(50, StyleBlockType.element, null, new LayoutStyle(0x000104, new RelativeLayout(-2147483648, -2147483648, -2147483648, -2147483648, -2147483648, 0), null, null, null, 1, Number.FLOAT_NOT_SET, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648), new TextStyle(0x000247, 8, 'Lucida Grande', false, -1, null, null, Number.FLOAT_NOT_SET, TextAlign.CENTER, null, Number.FLOAT_NOT_SET, TextTransform.uppercase, null, -2147483648, -2147483648, -2147483648));
		var styleBlock53 = new StyleBlock(0x002850, StyleBlockType.styleName, new GraphicsStyle(0x000103, new SolidFill(0x666666FF), null, null, function () { return new SlidingToggleButtonSkin(); }, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(5, 5, 5, 5)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 50, 30, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock52.setInheritedStyles(null, styleBlock0, null, styleBlock53);
		var hash54 = new Hash();
		hash54.set('prime.gui.core.UITextField', styleBlock52);
		styleBlock53.setChildren(hash51, null, hash54);
		this.styleNameChildren.set('slideToggleButton', styleBlock53);
		this.idChildren.set('modal', new StyleBlock(80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-2004318089)), new LayoutStyle(0x000300, null, null, null, null, 1, 1, -2147483648, -2147483648, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648)));
		this.idChildren.set('toolTip', new StyleBlock(96, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(0x555555FF)), null, new TextStyle(7, 9, 'Verdana', false, -1, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648)));
		var intHash55 = new IntHash();
		intHash55.set(2, new StyleBlock(80, StyleBlockType.idState, new GraphicsStyle(2, new SolidFill(-572662273)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 100, 25, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648)));
		var styleBlock56 = new StyleBlock(0x000450, StyleBlockType.id, new GraphicsStyle(0x000116, new SolidFill(-858993409), new SolidBorder(new SolidFill(0x4D4D4DFF), 1, false, CapsStyle.NONE, JointStyle.ROUND, false), null, null, null, true, Number.FLOAT_NOT_SET, null, null, new Corners(10, 10, 10, 10)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 100, 25, -2147483648, -2147483648, Number.FLOAT_NOT_SET, null, null, -2147483648, -2147483648, -2147483648, -2147483648));
		styleBlock56.states = new StatesStyle(2, intHash55);
		this.idChildren.set('search', styleBlock56);
	}
}