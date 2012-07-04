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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers   <ruben @ onlinetouch.nl>
 */
package primevc.gui.components;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.Bindable;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.UIComponent;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.traits.ISelectable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 5, 2011
 */
class Form
{
    public static inline function addHorLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, direction:Horizontal = null, percentWidth:Float = 1.0)
    {
        return createLabelRow( form, labelStr, input, createHorizontalRow(direction, percentWidth), "horLabel" );
    }


    public static inline function addVerLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, direction:Vertical = null, percentWidth:Float = 1.0)
    {
        return createLabelRow( form, labelStr, input, createVerticalRow(direction, percentWidth), "verLabel" );
    }


    private static function createLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, row:LayoutContainer, labelStyleClass:String = null)
    {
        var label = createLabel(input, labelStr);
        label.styleClasses.add(labelStyleClass);
        row.dispose.on( input.state.disposed.entering, row );
        
        var added   = input.displayEvents.addedToStage.observe( form, null );
        var removed = input.displayEvents.removedFromStage.observe( form, null );

        // attach row
        var attach = function () {
            if (input.layout.parent == row)
                return;

            removed.disable();
            added  .disable();

            var disDepth = input.container.children.indexOf(input);
            var layDepth = input.layout.parent.children.indexOf(input.layout);
            
            input.detach();
            row .attach(label.layout).attach(input.layout);
            row .attachTo(form.layoutContainer, layDepth);
            input.attachToDisplayList( form, disDepth );
            label.attachToDisplayList( form, disDepth );

            removed.enable();
            added  .enable();
        };
        var detach = function () {
            if (input.container != null) return;
            row.detach();
            label.detach();
        };

        added  .handler = attach;
        removed.handler = detach;
        input.attachTo(form);

    //  if (labelWidth >= 0)
    //      label.layout.percentWidth = labelWidth;
        return row;
    }


    public static inline function rowIndexOf (input:UIComponent) : Int
    {
        var form = input.container.as(IUIContainer);
        return form.layoutContainer.children.indexOf( cast input.layout.parent ) + 1;
    }


    public static function createLabel(input:UIComponent, labelStr:String) : Label
    {
        var label = new Label(input.id.value+"Label", new Bindable<String>(labelStr));
        
        // bind hover events together
        var inputEvents = input.userEvents.mouse;
        var labelEvents = label.userEvents.mouse;
        labelEvents.rollOver.on( inputEvents.rollOver,  input );
        labelEvents.rollOut .on( inputEvents.rollOut,   input );
        
        label.enabled.pair( input.enabled );
        label.dispose.on( input.state.disposed.entering, label );
        
        if (input.is(ISelectable)) {
            input.setFocus    .on( labelEvents.click,    input );
            inputEvents.click .on( labelEvents.click,    input );
        }
        return label;
    }


    public static /*inline*/ function createHorizontalRow (direction:Horizontal = null, percentWidth:Float = 1.0) : LayoutContainer
    {
        var row          = new VirtualLayoutContainer();
        row.algorithm    = new HorizontalFloatAlgorithm( direction == null ? Horizontal.left : direction, Vertical.center );
        if (percentWidth > 0)   row.percentWidth = percentWidth;
        return row;
    }


    public static /*inline*/ function createVerticalRow (direction:Vertical = null, percentWidth:Float = 1.0) : LayoutContainer
    {
        var row          = new VirtualLayoutContainer();
        row.algorithm    = new VerticalFloatAlgorithm( direction == null ? Vertical.center : direction, Horizontal.left );
        if (percentWidth > 0)   row.percentWidth = percentWidth;
        return row;
    }
}