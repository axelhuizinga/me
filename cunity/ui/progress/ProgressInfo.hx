/**
 *
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.ui.progress;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.xml.XML;
import flash.xml.XMLList;

import me.cunity.debug.Out;
import me.cunity.ui.Container;
import me.cunity.ui.BaseCell;
import haxe.Timer;
using me.cunity.tools.XMLTools;

class ProgressInfo extends BaseCell
{
	public var textField:TextField;
	static var me:ProgressInfo;
	
	public function new(xN:XML, p:Progress) 
	{
		super(xN, cast p);
		//visible = true;
		textField = new TextField();
		p.infoTextField = textField;
		addChild(textField);
		var format:TextFormat = textField.defaultTextFormat;
		//var font:XMLList = xNode.attribute('font');
		//this.bgColor = bgColor.length() == 1 ? Std.parseInt(bgColor.toString()):12;
		xNode.getAttribute( 'color', format, 0x600000);
		xNode.getAttribute( 'font', format, 'Arial');
		xNode.getAttribute( 'size', format, 14);
		xNode.getAttribute( 'bold', format, false);
		//trace(format.size);
		format.align = TextFormatAlign.CENTER;
		//format.align = TextFormatAlign.RIGHT;
		textField.blendMode = BlendMode.LAYER;
		textField.defaultTextFormat = format;
		//counter.embedFonts = true;
		textField.selectable = false;
		textField.autoSize = TextFieldAutoSize.CENTER;
		//textField.autoSize = TextFieldAutoSize.RIGHT;
		textField.text = Std.string(xNode.attribute('text'));
		//textField.border = true;
		textField.borderColor = 0xffffff;
		//me = this;

	}
	
	
}