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
package primevc.gui.behaviours.scroll;	
#if !CSSParser
 import primevc.core.geom.IntPoint;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.NumberUtil;


/**
 * Behaviour to scroll in the target by moving the mouse.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class MouseMoveScrollBehaviour extends MouseScrollBehaviourBase
{
	override private function calculateScroll (mouseObj:MouseState)
	{
		var layout    = target.scrollableLayout;
		var scrollHor = layout.horScrollable();
		var scrollVer = layout.verScrollable();
		if (!scrollHor && !scrollVer)
			return;
		
		var mousePos	= ScrollHelper.getLocalMouse(target, mouseObj);
	//	var percentX:Float = 0, percentY:Float = 0;
		var scrollPos	= new IntPoint();
		
		//horScroll
		if (scrollHor) {
			var percentX	 = ( mousePos.x / layout.width ).max(0).min(1);
			scrollPos.x		 = ( layout.scrollableWidth * percentX ).roundFloat();
		//	untyped trace(scrollPos.x + "; scrollX: "+layout.scrollPos.x+"; sW: "+layout.scrollableWidth+"; w: "+layout.width+"; eW: "+layout.explicitWidth+"; mW: "+layout.measuredWidth+"; mX: "+mousePos.x+"; pX "+percentX+"; horP: "+layout.getHorPosition()+"; x: "+target.x);
		}
		
		//verScroll
		if (scrollVer) {
			var percentY	 = ( mousePos.y / layout.height ).min(1).max(0);
			scrollPos.y		 = ( layout.scrollableHeight * percentY ).roundFloat();
		//	untyped trace(scrollPos.y + "; scrollY: "+layout.scrollPos.y+"; sH: "+layout.scrollableHeight+"; h: "+layout.height+"; eH: "+layout.explicitHeight+"; mH: "+layout.measuredHeight+"; mY: "+mousePos.y+"; pY: "+percentY+"; verP: "+layout.getVerPosition()+"; y: "+target.y);
		}
		
		scrollPos = layout.validateScrollPosition( scrollPos );
	//	trace(target+" - "+scrollHor+" / "+scrollVer+"; scrollPos "+scrollPos.x+", "+scrollPos.y+"; perc: "+percentX+", "+percentY+"; mouse: "+mousePos.x+", "+mousePos.y+"; size: "+layout.width+", "+layout.height+"; scrollable "+layout.scrollableWidth+", "+layout.scrollableHeight+"; measured "+layout.measuredWidth+", "+layout.measuredHeight);
		
		if (!scrollPos.isEqualTo( layout.scrollPos ))
			layout.scrollPos.setTo( scrollPos );
	}
}


#else
class MouseMoveScrollBehaviour {}
#end