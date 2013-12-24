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
 import prime.gui.behaviours.scroll.DragScrollBehaviour;
 import prime.gui.behaviours.scroll.ShowScrollbarsBehaviour;
 import prime.gui.components.skins.BasicPanelSkin;
 import prime.gui.components.skins.ButtonIconLabelSkin;
 import prime.gui.components.skins.ButtonIconSkin;
 import prime.gui.components.skins.ButtonLabelSkin;
 import prime.gui.components.skins.InputFieldSkin;
 import prime.gui.components.skins.SlidingToggleButtonSkin;
 import prime.gui.effects.FadeEffect;
 import prime.gui.effects.MoveEffect;
 import prime.gui.filters.DropShadowFilter;
 import prime.gui.graphics.borders.CapsStyle;
 import prime.gui.graphics.borders.ComposedBorder;
 import prime.gui.graphics.borders.JointStyle;
 import prime.gui.graphics.borders.SolidBorder;
 import prime.gui.graphics.fills.ComposedFill;
 import prime.gui.graphics.fills.GradientFill;
 import prime.gui.graphics.fills.GradientStop;
 import prime.gui.graphics.fills.GradientType;
 import prime.gui.graphics.fills.SolidFill;
 import prime.gui.graphics.fills.SpreadMethod;
 import prime.gui.graphics.shapes.RegularRectangle;
 import prime.gui.styling.EffectsStyle;
 import prime.gui.styling.FilterCollectionType;
 import prime.gui.styling.FiltersStyle;
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
 import prime.layout.RelativeLayout;



/**
 * This class is a template for generating UIElementStyle classes
 */
class StyleSheet extends StyleBlock
{
	public static var version = 1385800219.04;

	public function new ()
	{
		super("", 0, StyleBlockType.specific);
		elementChildren		= new ChildrenList();
		styleNameChildren	= new ChildrenList();
		idChildren			= new ChildrenList();
		
		
		var styleBlock0 = new StyleBlock('IDisplayObject', 64, StyleBlockType.element, new GraphicsStyle(56, null, null, new RegularRectangle(), null, null, true, 1));
		this.elementChildren.set('prime.gui.display.IDisplayObject', styleBlock0);
		var styleBlock1 = new StyleBlock('UIWindow', 82, StyleBlockType.element, new GraphicsStyle(130, new SolidFill(-15790336), null, null, null, function (a) { return new ClippedLayoutBehaviour(a); }), new LayoutStyle(8, null, null, null, function () { return new VerticalFloatAlgorithm(Vertical.center, Horizontal.center); }));
		styleBlock1.set_inheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.core.UIWindow', styleBlock1);
		var styleBlock2 = new StyleBlock('UIGraphic', 66, StyleBlockType.element, new GraphicsStyle(8, null, null, new RegularRectangle()));
		styleBlock2.set_inheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.core.UIGraphic', styleBlock2);
		var styleBlock3 = new StyleBlock('Button', 0x000872, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(-16776961), null, null, function () { return new ButtonLabelSkin(); }), new LayoutStyle(0x00100B, null, null, new Box(20, 20, 20, 20), function () { return new HorizontalFloatAlgorithm(Horizontal.center, Vertical.center); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 50, 50), new TextStyle(7, 10, 'Arial', false, 0x444444FF));
		styleBlock3.set_inheritedStyles(null, styleBlock0);
		var styleBlock4 = new StyleBlock('UITextField', 18, StyleBlockType.element, null, new LayoutStyle(0x000100, null, null, null, null, LayoutStyleFlags.FILL));
		styleBlock4.set_inheritedStyles(null, styleBlock0, null, styleBlock3);
		styleBlock3.set_children(null, null, ['prime.gui.core.UITextField' => styleBlock4]);
		var styleBlock5 = new StyleBlock('InputField', 66, StyleBlockType.element, new GraphicsStyle(5, null, new SolidBorder(new SolidFill(255), 1, false, CapsStyle.NONE, JointStyle.ROUND, false), null, function () { return new InputFieldSkin(); }));
		styleBlock5.set_inheritedStyles(null, styleBlock3);
		this.elementChildren.set('prime.gui.components.InputField', styleBlock5);
		var styleBlock6 = new StyleBlock('Label', 34, StyleBlockType.element, null, null, new TextStyle(3, 12, 'Verdana', false));
		styleBlock6.set_inheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.components.Label', styleBlock6);
		var styleBlock7 = new StyleBlock('Image', 66, StyleBlockType.element, new GraphicsStyle(8, null, null, new RegularRectangle()));
		styleBlock7.set_inheritedStyles(null, styleBlock2);
		this.elementChildren.set('prime.gui.components.Image', styleBlock7);
		this.elementChildren.set('prime.gui.components.Button', styleBlock3);
		var styleBlock8 = new StyleBlock('TextArea', 82, StyleBlockType.element, new GraphicsStyle(129, null, null, null, null, function (a) { return new ShowScrollbarsBehaviour(a); }), new LayoutStyle(8));
		styleBlock8.set_inheritedStyles(null, styleBlock5);
		this.elementChildren.set('prime.gui.components.TextArea', styleBlock8);
		var styleBlock9 = new StyleBlock('SliderBase', 82, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(-1)), new LayoutStyle(8, null, null, null, function () { return new RelativeAlgorithm(); }));
		styleBlock9.set_inheritedStyles(null, styleBlock0);
		this.elementChildren.set('prime.gui.components.SliderBase', styleBlock9);
		var styleBlock10 = new StyleBlock('ScrollBar', 66, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0x212121FF)));
		styleBlock10.set_inheritedStyles(null, styleBlock9);
		this.elementChildren.set('prime.gui.components.ScrollBar', styleBlock10);
		var styleBlock11 = new StyleBlock('ComboBox', 82, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconLabelSkin(); }), new LayoutStyle(32, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 40));
		styleBlock11.set_inheritedStyles(null, styleBlock3);
		this.elementChildren.set('prime.gui.components.ComboBox', styleBlock11);
		var styleBlock12 = new StyleBlock('Panel', 0x002042, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new BasicPanelSkin(); }));
		styleBlock12.set_inheritedStyles(null, styleBlock0);
		var styleBlock13 = new StyleBlock('closeBtn', 64, StyleBlockType.id, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconSkin(); }));
		styleBlock13;
		styleBlock12.set_children(['closeBtn' => styleBlock13]);
		this.elementChildren.set('prime.gui.components.Panel', styleBlock12);
		var styleBlock14 = new StyleBlock('DebugBar', 0x000C52, StyleBlockType.element, new GraphicsStyle(34, new SolidFill(0x111111AA), null, null, null, null, null, 0.5), new LayoutStyle(0x00010C, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, function () { return new HorizontalFloatAlgorithm(Horizontal.center, Vertical.center); }, 1));
		styleBlock14.set_inheritedStyles(null, styleBlock0);
		var styleBlock15 = new StyleBlock('Button', 0x000476, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(-858993409), null, null, function () { return new ButtonLabelSkin(); }), new LayoutStyle(0x003008, null, new Box(4, 6, 4, 6), new Box(5, 5, 5, 5)), new TextStyle(5, 10, null, false, 0x333333FF));
		styleBlock15.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock14);
		var styleBlock16 = new StyleBlock('hover', 64, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(-1)));
		styleBlock16;
		var styleBlock17 = new StyleBlock('selected', 64, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(-1)));
		styleBlock17;
		styleBlock15.states = new StatesStyle(0x000802, [2 => styleBlock16, 0x000800 => styleBlock17]);
		styleBlock14.set_children(null, null, ['prime.gui.components.Button' => styleBlock15]);
		var styleBlock18 = new StyleBlock('hover', 64, StyleBlockType.elementState, new GraphicsStyle(32, null, null, null, null, null, null, 1));
		styleBlock18;
		styleBlock14.states = new StatesStyle(2, [2 => styleBlock18]);
		this.elementChildren.set('prime.gui.components.DebugBar', styleBlock14);
		var styleBlock19 = new StyleBlock('UIComponent', 66, StyleBlockType.element, new GraphicsStyle(36, null, new SolidBorder(new SolidFill(-16711681), 3, false, CapsStyle.NONE, JointStyle.ROUND, false), null, null, null, null, 0.7));
		var styleBlock20 = new StyleBlock('debug', 0x000800, StyleBlockType.styleName);
		styleBlock19.set_inheritedStyles(null, styleBlock0, null, styleBlock20);
		styleBlock20.set_children(null, null, ['prime.gui.core.UIComponent' => styleBlock19]);
		this.styleNameChildren.set('debug', styleBlock20);
		var styleBlock21 = new StyleBlock('ListView', 18, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 1, 1));
		var styleBlock22 = new StyleBlock('listHolder', 0x000810, StyleBlockType.styleName, null, new LayoutStyle(8, null, null, null, function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); }));
		styleBlock21.set_inheritedStyles(null, styleBlock0, null, styleBlock22);
		var styleBlock23 = new StyleBlock('SelectableListView', 18, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 1, 1));
		styleBlock23.set_inheritedStyles(null, styleBlock21, null, styleBlock22);
		styleBlock22.set_children(null, null, ['prime.gui.components.ListView' => styleBlock21, 'prime.gui.components.SelectableListView' => styleBlock23]);
		this.styleNameChildren.set('listHolder', styleBlock22);
		var styleBlock24 = new StyleBlock('UIGraphic', 22, StyleBlockType.element, null, new LayoutStyle(0x000300, null, null, null, null, 0, 1));
		var styleBlock25 = new StyleBlock('horizontalSlider', 0x000810, StyleBlockType.styleName, null, new LayoutStyle(34, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, 4, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 30));
		styleBlock24.set_inheritedStyles(null, styleBlock0, styleBlock2, styleBlock25);
		var styleBlock26 = new StyleBlock('Button', 86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x666666FF)), new LayoutStyle(7, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 15));
		styleBlock26.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock25);
		styleBlock25.set_children(null, null, ['prime.gui.core.UIGraphic' => styleBlock24, 'prime.gui.components.Button' => styleBlock26]);
		this.styleNameChildren.set('horizontalSlider', styleBlock25);
		var styleBlock27 = new StyleBlock('UIGraphic', 22, StyleBlockType.element, null, new LayoutStyle(0x000304, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, 1, 0));
		var styleBlock28 = new StyleBlock('verticalSlider', 0x000810, StyleBlockType.styleName, null, new LayoutStyle(129, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 4, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 30));
		styleBlock27.set_inheritedStyles(null, styleBlock0, styleBlock2, styleBlock28);
		var styleBlock29 = new StyleBlock('Button', 86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x666666FF)), new LayoutStyle(135, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 15, 6, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 15));
		styleBlock29.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock28);
		styleBlock28.set_children(null, null, ['prime.gui.core.UIGraphic' => styleBlock27, 'prime.gui.components.Button' => styleBlock29]);
		this.styleNameChildren.set('verticalSlider', styleBlock28);
		var styleBlock30 = new StyleBlock('Button', 86, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0x212121FF)), new LayoutStyle(39, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 9, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 15));
		var styleBlock31 = new StyleBlock('horizontalScrollBar', 0x000810, StyleBlockType.styleName, null, new LayoutStyle(2, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, 2));
		styleBlock30.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock31);
		styleBlock31.set_children(null, null, ['prime.gui.components.Button' => styleBlock30]);
		this.styleNameChildren.set('horizontalScrollBar', styleBlock31);
		var styleBlock32 = new StyleBlock('Button', 86, StyleBlockType.element, new GraphicsStyle(3, new SolidFill(0x212121FF)), new LayoutStyle(135, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 9, 6, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 15));
		var styleBlock33 = new StyleBlock('verticalScrollBar', 0x000810, StyleBlockType.styleName, null, new LayoutStyle(1, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 2));
		styleBlock32.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock33);
		styleBlock33.set_children(null, null, ['prime.gui.components.Button' => styleBlock32]);
		this.styleNameChildren.set('verticalScrollBar', styleBlock33);
		var styleBlock34 = new StyleBlock('SelectableListView', 0x000852, StyleBlockType.element, new GraphicsStyle(128, null, null, null, null, function (a) { return new ShowScrollbarsBehaviour(a); }), new LayoutStyle(0x00A3CB, null, new Box(0, 0, 0, 0), null, function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); }, Number.EMPTY, Number.EMPTY, Number.EMPTY, Number.EMPTY, Number.INT_NOT_SET, 20, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 60, 0x0001F4));
		var styleBlock35 = new StyleBlock('comboList', 0x000840, StyleBlockType.styleName, new GraphicsStyle(0x000106, new SolidFill(-101058049), new SolidBorder(new SolidFill(0x707070FF), 1, false, CapsStyle.NONE, JointStyle.ROUND, false), null, null, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(10, 10, 10, 10)));
		styleBlock34.set_inheritedStyles(null, styleBlock0, null, styleBlock35);
		var styleBlock36 = new StyleBlock('Button', 86, StyleBlockType.element, new GraphicsStyle(1, null, null, null, function () { return new ButtonIconLabelSkin(); }), new LayoutStyle(0x011100, null, null, new Box(0, 0, 0, 0), null, 1, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 1));
		styleBlock36.set_inheritedStyles(null, styleBlock0, styleBlock3, styleBlock34);
		styleBlock34.set_children(null, null, ['prime.gui.components.Button' => styleBlock36]);
		styleBlock35.set_children(null, null, ['prime.gui.components.SelectableListView' => styleBlock34]);
		this.styleNameChildren.set('comboList', styleBlock35);
		var styleBlock37 = new StyleBlock('onBg', 80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-16776961)), new LayoutStyle(4, new RelativeLayout(1, Number.INT_NOT_SET, 1)));
		styleBlock37;
		var styleBlock38 = new StyleBlock('onLabel', 32, StyleBlockType.id, null, null, new TextStyle(4, Number.INT_NOT_SET, null, false, -1));
		styleBlock38;
		var styleBlock39 = new StyleBlock('slide', 208, StyleBlockType.id, new GraphicsStyle(0x00010A, new SolidFill(-1), null, new RegularRectangle(), null, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(5, 5, 5, 5)), new LayoutStyle(0x000300, null, null, null, null, 0.51, 1.1), null, new EffectsStyle(32, new MoveEffect(180, Number.INT_NOT_SET, null, false)));
		styleBlock39;
		var styleBlock40 = new StyleBlock('UITextField', 50, StyleBlockType.element, null, new LayoutStyle(0x000104, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0), null, null, null, 1), new TextStyle(0x000247, 8, 'Lucida Grande', false, -1, null, null, Number.FLOAT_NOT_SET, TextAlign.CENTER, null, Number.FLOAT_NOT_SET, TextTransform.uppercase));
		var styleBlock41 = new StyleBlock('slideToggleButton', 0x002850, StyleBlockType.styleName, new GraphicsStyle(0x000103, new SolidFill(0x666666FF), null, null, function () { return new SlidingToggleButtonSkin(); }, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(5, 5, 5, 5)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 50, 30));
		styleBlock40.set_inheritedStyles(null, styleBlock0, null, styleBlock41);
		styleBlock41.set_children(['onBg' => styleBlock37, 'onLabel' => styleBlock38, 'slide' => styleBlock39], null, ['prime.gui.core.UITextField' => styleBlock40]);
		this.styleNameChildren.set('slideToggleButton', styleBlock41);
		this.styleNameChildren.set('styleOne', new StyleBlock('styleOne', 16, StyleBlockType.styleName, null, new LayoutStyle(0x002008, null, new Box(10, 10, 10, 10), null, function () { return new HorizontalFloatAlgorithm(Horizontal.right, Vertical.bottom); })));
		var gradientFill42 = new GradientFill(GradientType.linear, SpreadMethod.normal, 0, -90);
		gradientFill42.add(new GradientStop(0x111111BB, 0));
		gradientFill42.add(new GradientStop(0x3D3D3DFF, 85));
		gradientFill42.add(new GradientStop(0x484848FF, 170));
		gradientFill42.add(new GradientStop(0x565656FF, 255));
		this.styleNameChildren.set('styleTwo', new StyleBlock('styleTwo', 64, StyleBlockType.styleName, new GraphicsStyle(2, gradientFill42)));
		var composedBorder43 = new ComposedBorder();
		composedBorder43.add(new SolidBorder(new SolidFill(0x7C7C7CFF), 1, true, CapsStyle.NONE, JointStyle.ROUND, false));
		composedBorder43.add(new SolidBorder(new SolidFill(0x111111FF), 1, false, CapsStyle.NONE, JointStyle.ROUND, false));
		this.styleNameChildren.set('styleThree', new StyleBlock('styleThree', 0x000140, StyleBlockType.styleName, new GraphicsStyle(4, null, composedBorder43), null, null, null, new FiltersStyle(1, FilterCollectionType.box, new DropShadowFilter(2, 90, 255, 1, 18, 18, 1, 1, false, false, false))));
		this.styleNameChildren.set('InspectorTreeComponentRoot', new StyleBlock('InspectorTreeComponentRoot', 80, StyleBlockType.styleName, new GraphicsStyle(130, new SolidFill(0xFF00FF), null, null, null, function (a) { return new DragScrollBehaviour(a); }), new LayoutStyle(0x001108, null, null, new Box(0, 0, 0, 5), function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); }, 0.5)));
		this.styleNameChildren.set('InspectorTreeComponent', new StyleBlock('InspectorTreeComponent', 80, StyleBlockType.styleName, new GraphicsStyle(2, new SolidFill(0x00FFFF)), new LayoutStyle(0x001008, null, null, new Box(0, 0, 0, 5), function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); })));
		this.styleNameChildren.set('InspectorTreeLabel', new StyleBlock('InspectorTreeLabel', 80, StyleBlockType.styleName, new GraphicsStyle(2, new SolidFill(0xFFFFFF)), new LayoutStyle(0x003048, null, new Box(0, 0, 0, 0), new Box(0, 0, 0, 0), function () { return new VerticalFloatAlgorithm(Vertical.center, Horizontal.left); }, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 40)));
		this.styleNameChildren.set('InspectorTreeContainer', new StyleBlock('InspectorTreeContainer', 80, StyleBlockType.styleName, new GraphicsStyle(2, new SolidFill(0x00FFFF)), new LayoutStyle(8, null, null, null, function () { return new VerticalFloatAlgorithm(Vertical.top, Horizontal.left); })));
		this.idChildren.set('modal', new StyleBlock('modal', 80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-2004318089)), new LayoutStyle(0x000300, null, null, null, null, 1, 1)));
		this.idChildren.set('toolTip', new StyleBlock('toolTip', 96, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(0x555555FF)), null, new TextStyle(7, 9, 'Verdana', false, -1)));
		var composedFill44 = new ComposedFill();
		composedFill44.add(new SolidFill(-15790081));
		var gradientFill45 = new GradientFill(GradientType.linear, SpreadMethod.normal, 0, -90);
		gradientFill45.add(new GradientStop(0x111111BB, 0));
		gradientFill45.add(new GradientStop(0x3D3D3DFF, 85));
		gradientFill45.add(new GradientStop(0x484848FF, 170));
		gradientFill45.add(new GradientStop(0x565656FF, 255));
		composedFill44.add(gradientFill45);
		var composedBorder46 = new ComposedBorder();
		composedBorder46.add(new SolidBorder(new SolidFill(0x7C7C7CFF), 1, true, CapsStyle.NONE, JointStyle.ROUND, false));
		composedBorder46.add(new SolidBorder(new SolidFill(0x111111FF), 1, false, CapsStyle.NONE, JointStyle.ROUND, false));
		this.idChildren.set('buttonHolder', new StyleBlock('buttonHolder', 0x000150, StyleBlockType.id, new GraphicsStyle(6, composedFill44, composedBorder46), new LayoutStyle(0x003008, null, new Box(10, 10, 10, 10), new Box(10, 10, 10, 10), function () { return new HorizontalFloatAlgorithm(Horizontal.center, Vertical.center); }), null, null, new FiltersStyle(1, FilterCollectionType.box, new DropShadowFilter(2, 90, 0x2E2E2E, 1, 18, 18, 1, 1, false, false, false))));
		var fadeEffect47 = new FadeEffect(150, Number.INT_NOT_SET, null, false, 0, 1);
		this.idChildren.set('customContainer', new StyleBlock('customContainer', 208, StyleBlockType.id, new GraphicsStyle(0x000100, null, null, null, null, null, null, Number.FLOAT_NOT_SET, null, null, new Corners(15, 15, 15, 15)), new LayoutStyle(0x002004, new RelativeLayout(Number.INT_NOT_SET, Number.INT_NOT_SET, -60, Number.INT_NOT_SET, 0), new Box(2, 8, 2, 8)), null, new EffectsStyle(0x000600, null, null, null, null, fadeEffect47, fadeEffect47)));
		this.idChildren.set('Inspector', new StyleBlock('Inspector', 80, StyleBlockType.id, new GraphicsStyle(130, new SolidFill(-16776961), null, null, null, function (a) { return new DragScrollBehaviour(a); }), new LayoutStyle(0x000308, null, null, null, function () { return new HorizontalFloatAlgorithm(Horizontal.left, Vertical.top); }, 1, 1)));
		this.idChildren.set('InspectorData', new StyleBlock('InspectorData', 80, StyleBlockType.id, new GraphicsStyle(130, new SolidFill(-65281), null, null, null, function (a) { return new ShowScrollbarsBehaviour(a); }), new LayoutStyle(0x000348, null, null, null, function () { return new VerticalFloatAlgorithm(Vertical.center, Horizontal.center); }, 0.5, 0.95, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0x002328)));
		this.idChildren.set('InspectorDataContainer', new StyleBlock('InspectorDataContainer', 80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-16711681)), new LayoutStyle(0x0001C8, null, null, null, function () { return new HorizontalFloatAlgorithm(Horizontal.left, Vertical.center); }, 1, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 40, 0x002328)));
		this.idChildren.set('InspectorDataLabel', new StyleBlock('InspectorDataLabel', 80, StyleBlockType.id, new GraphicsStyle(2, new SolidFill(-252645121)), new LayoutStyle(0x000180, null, null, null, null, 1, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 30)));
	}
}