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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */

package prime.avm2.events;
private typedef MouseSignal = prime.avm2.events.MouseSignal; // override import
 import prime.core.geom.Point;
 import prime.gui.events.MouseEvents;
 import prime.gui.events.KeyModState;
 import flash.events.IEventDispatcher;
 import flash.events.MouseEvent;


/**
 * Group of proxying Signals to flash.events.Mouse events.
 * 
 * @author Danny Wilson
 * @creation-date jun 11, 2010
 */
class MouseEvents extends MouseSignals
{
	private var eventDispatcher : IEventDispatcher;
	
	public function new (eventDispatcher:IEventDispatcher)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		super.dispose();
	}
	
	
	override private function createDown ()			{ down			= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_DOWN	, 1); }
	override private function createUp ()			{ up			= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_UP		, 1); }
	override private function createMove ()			{ move			= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_MOVE	, 0); }
	override private function createClick () 		{ click			= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.CLICK		, 1); }
	override private function createDoubleClick ()	{ doubleClick	= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.DOUBLE_CLICK	, 2); }
	override private function createOverChild ()	{ overChild		= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_OVER	, 0); }
	override private function createOutOfChild ()	{ outOfChild	= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_OUT	, 0); }
	override private function createRollOver ()		{ rollOver		= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.ROLL_OVER	, 0); }
	override private function createRollOut ()		{ rollOut		= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.ROLL_OUT		, 0); }
	override private function createScroll ()		{ scroll		= new primevc.avm2.events.MouseSignal( eventDispatcher, MouseEvent.MOUSE_WHEEL	, 0); }
}