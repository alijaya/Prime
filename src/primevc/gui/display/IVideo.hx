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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.display;


/**
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
interface IVideo implements IDisplayObject
{
#if (flash9 || jeash)
	/**
	* Indicates the type of filter applied to decoded video as part of post-processing.
	 */
	public var deblocking	: Int;
	/**
	 * Specifies whether the video should be smoothed (interpolated) when it is scaled.
	 */
	public var smoothing	: Bool;
	public var videoHeight	(default, never)	: Int;
	public var videoWidth	(default, never)	: Int;
	
	/**
	 * Specifies a video stream from a camera to be displayed within the 
	 * boundaries of the Video object in the application.
	 * @param camera Camera
	 */
	public function attachCamera (camera:flash.media.Camera) : Void;
	/**
	 * Specifies a video stream to be displayed within the boundaries of the 
	 * Video object in the application.
	 * @param netStream NetStream
	 */
	public function attachNetStream (netStream:flash.net.NetStream) : Void;
	/**
	 * Clears the image currently displayed in the Video object (not the video 
	 * stream).
	 */
	public function clear () : Void;
#end
}