

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
 *  Ezequiel Moreno
 */
package prime.gui.managers;
 
 import prime.gui.core.UIWindow;
#if flash
 import flash.ui.Mouse;
 typedef Cursor = { name:String, cursorData:flash.ui.MouseCursorData }
 #else
 #error "tbd"
#end

class CursorManager implements prime.core.traits.IDisposable
{
  private var window:UIWindow;
  
  public var cursorMap (default, null) : Map < String, Cursor >;
  
  public function new (window:UIWindow)
	{
		this.window	= window;
    cursorMap = new Map<String,Cursor>();
  }
  
  public function addCursor( cursor:Cursor )
  {
    if ( cursorMap.exists( cursor.name ))
    {
      //error or replace?
    }
    else
    {
      cursorMap.set(cursor.name, cursor);
#if flash
      Mouse.registerCursor(cursor.name, cursor.cursorData);
#end
    }
  }
  
  public function showCursor( name:String )
  {
    if ( cursorMap.exists( name ))
    {
#if flash
      Mouse.cursor = name;
#end
    }
    else
    {
    }

  }
  
  public function showDefault()
  {
#if flash
      Mouse.cursor = flash.ui.MouseCursor.AUTO;
#end
  }
	
}

