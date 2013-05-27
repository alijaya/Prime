

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
 import prime.signals.Signal1;
 import prime.net.FileReferenceList;
 import prime.net.FileReference;
 import prime.net.FileFilter;
 import prime.net.IFileReference;
 import prime.gui.core.IUIElement;
 import prime.gui.managers.ISystem;
  using prime.utils.Bind;
  using prime.utils.TypeUtil;


/**
 * Panel with an upload/cancel button
 * 
 * @author Ruben Weijers
 * @creation-date Oct 6, 2011
 */
class UploadPanel extends ConfirmPanel
{
    private var fileBrowser : IFileReference;
    public  var fileTypes   : Array<FileFilter>;
    /**
     * Maximum number of files. Default: -1 (unlimited)
     */
    private var maxFiles    : Int;

    public  var upload      (default, null) : Signal1<Array<FileReference>>;


    public function new (id:String = null, title:String = null, content:IUIElement = null, system:ISystem = null, applyLabel:String = "Uploaden", cancelLabel:String = "Annuleren", fileTypes:Array<FileFilter>, maxFiles:Int = -1)     //TRANSLATE
    {
        super(id, title, content, system, applyLabel, cancelLabel);
        upload          = new Signal1();
        this.fileTypes  = fileTypes;
        this.maxFiles   = maxFiles;
    }


    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        super.dispose();
        if (fileBrowser != null)
            unsetBrowser();
        
        if (fileTypes != null)
            fileTypes = null;
        
    //  upload.dispose();
        upload = null;
    }

    
    override private function createChildren ()
    {
        super.createChildren();
        acceptBtn.id.value = "uploadBtn";
        acceptBtn.userEvents.mouse.click.unbind(this);
        openFileList.on( acceptBtn.userEvents.mouse.click, this );
    }


    private function openFileList ()
    {
        Assert.isNull(fileBrowser);
        fileBrowser = maxFiles == 1 ? new FileReference() : new FileReferenceList().as(IFileReference);
        sendUpload  .onceOn( fileBrowser.select, this );
        unsetBrowser.onceOn( fileBrowser.cancel, this );
        
        fileBrowser.browse(fileTypes);
    }
    
    
    private inline function unsetBrowser ()
    {
        fileBrowser.is(FileReference) ? fileBrowser.as(FileReference).dispose2() : fileBrowser.dispose();
        fileBrowser = null;
    }


    private function sendUpload ()
    {
        if (maxFiles == 1) {
            upload.send([fileBrowser.as(FileReference)]);
            fileBrowser = null;
        } else {
            upload.send(fileBrowser.as(FileReferenceList).list);
            unsetBrowser(); //only dispose a FileReferenceList, it's too early to dispose a FileReference
        }
    }


    private function cancelUpload ()
    {
        canceled.send();
        unsetBrowser();
    }
}