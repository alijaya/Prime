

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
package prime.gui.behaviours.scroll;	
#if !CSSParser
 import feffects.Tween;
 import prime.core.geom.IntPoint;
 import prime.core.geom.Point;
 import prime.gui.events.MouseEvents;
 import prime.signals.Signal.Signal;
 import prime.signals.Signal0;
 import prime.signals.Wire.Wire;
  using prime.utils.NumberUtil;
  using prime.utils.Bind;


/**
 * Behaviour to scroll in the target by moving the mouse.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class MouseMoveScrollBehaviour extends MouseScrollBehaviourBase
{
	private var targetScrollPos : IntPoint;

#if release_hack
	private var xTween : feffects.Tween;
	private var yTween : feffects.Tween;
#end

	override private function calculateScroll (mouseObj:MouseState)
	{
		var horizontalScrollBufferPercent : Float = 0.250;
		var verticalScrollBufferPercent : Float = 0.25;
		
		if ( targetScrollPos == null )
			targetScrollPos	= new IntPoint();
		
		lastMouseObj = mouseObj.clone();
		
		var layout    = target.scrollableLayout;
		var scrollHor = layout.horScrollable();
		var scrollVer = layout.verScrollable();
		
		if (!scrollHor && !scrollVer)
			return;
		
		var mousePos	= ScrollHelper.getLocalMouse(target, mouseObj);
		var percentX:Float = 0, percentY:Float = 0;

		//horScroll
		if (scrollHor) 
		{
			var scrollWidth = layout.scrollableWidth;
			var layoutWidth = layout.width;
			
			//scrollWidth	= Std.int( scrollWidth * (1.0 - horizontalScrollBufferPercent * 2) );
			//layoutWidth	= Std.int( layoutWidth * (1.0-horizontalScrollBufferPercent*2) );
			
			percentX	 = ( mousePos.x / layoutWidth ).max(0).min(1);			  
#if viewer
			var shortenedWidth : Int = Std.int( layoutWidth * (1.0 - horizontalScrollBufferPercent * 2) );
			var xOffset : Int = Std.int( mousePos.x - layoutWidth * horizontalScrollBufferPercent );
			percentX = ( xOffset / shortenedWidth );			
			percentX = percentX.max(0).min(1);
#end
			targetScrollPos.x		 = ( scrollWidth * percentX ).roundFloat();
		//	untyped trace(scrollPos.x + "; scrollX: "+layout.scrollPos.x+"; sW: "+layout.scrollableWidth+"; w: "+layout.width+"; eW: "+layout.explicitWidth+"; mW: "+layout.measuredWidth+"; mX: "+mousePos.x+"; pX "+percentX+"; horP: "+layout.getHorPosition()+"; x: "+target.x);
		}
		
		//verScroll
		if (scrollVer)
		{
			var scrollHeight = layout.scrollableWidth;
			var layoutHeight = layout.height;
			
			percentY	 = ( mousePos.y / layoutHeight ).min(1).max(0);
			
#if viewer
			var shortenedHeight : Int = Std.int( layoutHeight * (1.0 - verticalScrollBufferPercent * 2) );
			var yOffset : Int = Std.int( mousePos.y - layoutHeight * verticalScrollBufferPercent );
			percentY = ( yOffset / shortenedHeight );			
			percentY = percentY.max(0).min(1);
#end
			
			targetScrollPos.y		 = ( layout.scrollableHeight * percentY ).roundFloat();
		//	untyped trace(scrollPos.y + "; scrollY: "+layout.scrollPos.y+"; sH: "+layout.scrollableHeight+"; h: "+layout.height+"; eH: "+layout.explicitHeight+"; mH: "+layout.measuredHeight+"; mY: "+mousePos.y+"; pY: "+percentY+"; verP: "+layout.getVerPosition()+"; y: "+target.y);
		}
		
		targetScrollPos = layout.validateScrollPosition( targetScrollPos );
		//trace(target+" - "+scrollHor+" / "+scrollVer+"; scrollPos "+scrollPos.x+", "+scrollPos.y+"; perc: "+percentX+", "+percentY+"; mouse: "+mousePos.x+", "+mousePos.y+"; size: "+layout.width+", "+layout.height+"; scrollable "+layout.scrollableWidth+", "+layout.scrollableHeight+"; measured "+layout.measuredWidth+", "+layout.measuredHeight);
		//trace( " scrollPos " + targetScrollPos.x + ", " + targetScrollPos.y );
		//scrollPos.x = 0;
		//scrollPos.y = -100;
		
		//var 
		

#if release_hack
		var maxTweenLength : Int = 100; // milliseconds
		var duration : Int = 350;
		var easing = feffects.easing.Quad.easeInOut;
		if ( layout.scrollPos.x != targetScrollPos.x )
		{
			// cancel existing tween
			if ( xTween != null )
			{
				xTween.onUpdate(null).onFinish(null);
				xTween.stop();
				xTween = null;
			}
			
			//
			var diff : Int = Std.int( Math.abs( targetScrollPos.x - layout.scrollPos.x ) );
			//var duration : Int = Std.int( Math.min( diff, maxTweenLength ) );
			
			xTween = new Tween( layout.scrollPos.x, targetScrollPos.x, duration, easing );
			xTween.onUpdate(
				function( newV : Float )
				{
					layout.scrollPos.x = Std.int( newV );// setTo( newV, layout.scrollPos.y );
				}
			);
			xTween.start();
			
		}
		
		if ( layout.scrollPos.y != targetScrollPos.y )
		{
			// cancel existing tween
			if ( yTween != null )
			{
				yTween.onUpdate(null).onFinish(null);
				yTween.stop();
				yTween = null;
			}
			
			//
			var diff : Int = Std.int( Math.abs( targetScrollPos.y - layout.scrollPos.y ) );
			//var duration : Int = Std.int( Math.min( diff, maxTweenLength ) );
			
			yTween = new Tween( layout.scrollPos.y, targetScrollPos.y, duration, easing );
			yTween.onUpdate(
				function( newV : Float )
				{
					layout.scrollPos.y = Std.int( newV );
				}
			);
			yTween.start();
			
		}
#else
		if (!targetScrollPos.isEqualTo( layout.scrollPos ))
			layout.scrollPos.setTo( targetScrollPos );
		
#end

	}
}


#else
class MouseMoveScrollBehaviour {}
#end