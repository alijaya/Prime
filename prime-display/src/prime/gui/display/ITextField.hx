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
package prime.gui.display;
#if (flash9||nme)
 import flash.text.TextFormat;
 import flash.text.TextFieldType;
 import flash.text.TextFieldAutoSize;
 import flash.text.AntiAliasType;
#end
#if !cpp
 import #if flash9 flash #else native #end .text.GridFitType;
 import #if flash9 flash #else native #end .text.TextLineMetrics;
#end


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
interface ITextField extends IInteractiveObject extends prime.gui.traits.ITextStylable
{
	
	public var textEvents			(default, null)			: prime.gui.events.TextEvents;
	
	/**
	 * The real text-value of the inputfield. The UITextField can apply a
	 * text-transform on the 'text' property but it will leave the 'value' 
	 * unchanged.
	 * 
	 * TODO: not implemented for the htmlText property
	 */
	public var data					(default, set_data)		: prime.bindable.Bindable<String>;
	public var value				(get_value, set_value)	: String;
	
	
	/**
	 * Method will return true if the textfield can be editted by the user
	 * and false when the text is not editable;
	 */
	public function isEditable ()	: Bool;
	
	
#if (flash9 || nme)

  // Flash only:
  #if flash9
	public var alwaysShowSelection					: Bool;
	public var text									: String;
	public var textColor							: UInt;
	public var htmlText								: String;
	public var textHeight			(default, null)	: Float;
	public var textWidth			(default, null)	: Float;
	public var type									: TextFieldType;
//	public var defaultTextFormat					: TextFormat;
	public var styleSheet							: flash.text.StyleSheet;
	public var selectedText			(default, null)	: String;
	
	public var autoSize								: TextFieldAutoSize;
	public var background							: Bool;
	public var backgroundColor						: UInt;
	public var border								: Bool;
	public var borderColor							: UInt;
	public var bottomScrollV		(default, null)	: Int;   //FIXME: Add to: HTML5
	public var condenseWhite						: Bool;  //FIXME: Add to: HTML5, CPP
	public var thickness							: Float; //FIXME: Add to: HTML5, CPP
	public var useRichTextClipboard					: Bool;  //FIXME: Add to: HTML5, CPP
	public var maxScrollH			(default, null)	: Int;
	public var maxScrollV			(default, null)	: Int;
	public var mouseWheelEnabled					: Bool;
	public var numLines				(default, null)	: Int;
	public var scrollH								: Int;
	public var scrollV								: Int;
	public var selectable							: Bool;
  #end

  // Flash, or NME JS:
  #if !cpp
	// TODO: Implement selection and scrolling interface for NME's targets.
	public var selectionBeginIndex	(default, null)	: Int;
	public var selectionEndIndex	(default, null)	: Int;
	public var caretIndex			(default, null)	: Int;
	public var displayAsPassword					: Bool;
	public var length				(default, null)	: Int;
	public var maxChars								: Int;
	public var multiline							: Bool;
	public var restrict								: String;
	public var sharpness							: Float;
  #end

  // NME, not Flash:
  #if !flash9
	public var text(get_text, set_text):String;
	public var textColor(get_textColor, set_textColor):Int;
	public var htmlText(get_htmlText, set_htmlText) : String;
	public var textHeight(get_textHeight, null):Float;
	public var textWidth(get_textWidth, null):Float;

   #if html5
	public var autoSize(default, set_autoSize):String;
	public var background(default,set_background):Bool;
	public var backgroundColor(default, set_backgroundColor):Int;
	public var border(default, set_border):Bool;
	public var borderColor(default, set_borderColor):Int;
	public var type(get_type, set_type):String;

   #elseif cpp
	public var autoSize(get_autoSize, set_autoSize):TextFieldAutoSize;
	public var background(get_background, set_background):Bool;
	public var backgroundColor(get_backgroundColor, set_backgroundColor):Int;
	public var border(get_border, set_border):Bool;
	public var borderColor(get_borderColor, set_borderColor):Int;
	public var bottomScrollV(get_bottomScrollV, null):Int;
	public var displayAsPassword(get_displayAsPassword, set_displayAsPassword):Bool;
	public var maxChars(get_maxChars, set_maxChars):Int;
	public var maxScrollH(get_maxScrollH, null):Int;
	public var maxScrollV(get_maxScrollV, null):Int;
	public var multiline(get_multiline, set_multiline):Bool;
	public var numLines(get_numLines, null):Int;
	public var scrollH(get_scrollH, set_scrollH):Int;
	public var scrollV(get_scrollV, set_scrollV):Int;
	public var selectable(get_selectable, set_selectable):Bool;
	public var type(get_type, set_type):TextFieldType;
   #end
  #end
	
	
	//
	// FONT SETTINGS
	//
	
	public var antiAliasType						: #if html5 String #else AntiAliasType #end; //FIXME
	#if !cpp public var gridFitType					: #if html5 String #else GridFitType   #end; #end //FIXME
	
	
  #if (flash9 || html5)
	public function getCharIndexAtPoint (x : Float, y : Float)			: Int;
	public function getLineIndexAtPoint (x : Float, y : Float)			: Int;

  #elseif (flash9 || nme)
	public function getLineOffset (lineIndex : Int)						: Int;
	public function getLineText (lineIndex : Int)						: String;

  #elseif flash9
	public function getCharBoundaries (charIndex : Int)					: flash.geom.Rectangle;
	public function getFirstCharInParagraph (charIndex : Int)			: Int;
	public function getImageReference (id : String)						: flash.display.DisplayObject;
	
	public function getLineIndexOfChar (charIndex : Int)				: Int;
	public function getLineLength (lineIndex : Int)						: Int;
	public function getLineMetrics (lineIndex : Int)					: TextLineMetrics;
	
	public function getParagraphLength (charIndex : Int)				: Int;
	
	public function getRawText ()																			: String;
	public function getXMLText    (beginIndex:Int = 0, endIndex:Int = 2147483647)							: String;
	public function insertXMLText (beginIndex:Int, endIndex:Int, richText:String, pasting:Bool = false)		: Void;
	public function replaceSelectedText (value : String)													: Void;
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String)								: Void;
	
	public function getTextFormat (beginIndex : Int = -1, endIndex : Int = -1)								: TextFormat;
	public function getTextRuns   (beginIndex : Int =  0, endIndex : Int = 2147483647)						: Array<Dynamic>;
  #end

	public function appendText (newText:String)																: Void;
	public function setSelection  (beginIndex : Int, endIndex : Int)										: Void;
	public function setTextFormat (format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1)				: #if html5 flash.text.TextFormat #else Void #end; //FIXME
#end
}