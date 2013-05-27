

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
 *  Ruben Weijers   <ruben @ onlinetouch.nl>
 */
package prime.gui.components;
 import prime.signals.Signal0;
 import prime.gui.core.IUIElement;
 import prime.gui.managers.ISystem;
  using prime.utils.Bind;


/**
 * Panel with an ok button
 * 
 * @author Ruben Weijers
 * @creation-date Oct 6, 2011
 */
class AlertPanel extends Panel
{
    public var acceptLabel  (default, set_acceptLabel)   : String;
    public var acceptBtn    (default, null)             : Button;
    public var accepted     (default, null)             : Signal0;


    public function new (id:String = null, title:String = null, content:IUIElement = null, system:ISystem = null, acceptLabel:String = "Ok")     //TRANSLATE
    {
        super(id, title, content, system);
        accepted         = new Signal0();
        this.acceptLabel = acceptLabel;
    }

    
    override private function createChildren ()
    {
        super.createChildren();

        acceptBtn = new Button("acceptBtn", acceptLabel);
        acceptBtn.styleClasses.add("confirmBtn");

        addToFooter( acceptBtn );
        accept.on( acceptBtn.userEvents.mouse.click, this );
    }


    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        super.dispose();
        accepted.dispose();
        accepted = null;
    }

    
    override public function disposeChildren ()
    {
        acceptBtn.dispose();
        acceptBtn = null;
        super.disposeChildren();
    }


    private function accept ()
    {
        accepted.send();
        close();
    }


    private inline function set_acceptLabel (v:String)
    {
        if (v != acceptLabel) {
            acceptLabel = v;
            if (acceptBtn != null)
                acceptBtn.data.value = v;
        }
        return v;
    }
}