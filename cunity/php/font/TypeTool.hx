/**
 *
 * @author Axel Huizinga
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

package me.cunity.php.font;
import haxe.Http;
import php.Lib;


import me.cunity.tools.ArrayTools;

typedef FontInfo = {
	file:String,
	height:Float,
	ascend:Float,
	descend:Float,
	kerning:Int,
	glyphs:Int
};

class TypeTool
{

	var fontData:Array<String>;
	public var charShapes:Array<Char>;
	//var charShapes:Array<CharTrace>;
	public var charData:Map<Array<String>>;
	public var fontInfo:FontInfo;
	public var currentAdvance:Float;
	
	public var y:Float;
	var callBack:Void->Void;
	
	public function new(cB:Void->Void) 
	{
		callBack = cB;

	//var req:String = Http.requestUrl('http://go2ghana.net/cgi-bin/ttfData.cgi');
	var req:String = Http.requestUrl('http://go2ghana.net/cgi-bin/ttfData.cgi?method=getChars&font=Dustismo%20Bold.ttf&kerning=1&size=32');
		//trace(req);
		/*var variables:URLVariables = new URLVariables();
		variables.method = 'getChars';
		variables.font = 'kaufman.ttf';
		variables.font = 'arial.ttf';
		variables.kerning = 0;
		variables.size = 32;
		req.data = variables;
		req.method = URLRequestMethod.POST;
		fontLoader.load(req);*/
		if (req.length > 0)
			onFontComplete(req);
	}
	
	function initFont(fI:String) {
		var pairs:Array < String >  = fI.split(',');
		trace(Std.string(pairs));
		fontInfo = {file:'', height:0.0, ascend:0.0, descend:0.0, kerning:0, glyphs:0 };
		for (p in pairs) {
			var kv = p.split(':');
			Reflect.setField(fontInfo, kv[0], kv[1]);
		}	
		y = fontInfo.height;
	}
	
	function clearChars() {
		if(charShapes != null){
			for (c in charShapes)
				c = null;
				//removeChild(c);
		}
		charShapes = new Array();
	}
	
	function onFontComplete(info:String) {//	PARSE FONTINFO AND GLYPH OUTLINES
		//trace(evt.target.data);
		var t:Float = Date.now().getTime();
		charData = new Map();
		clearChars();
		fontData = info.split('\n');
		fontData.pop();
		trace(fontData.length);
		initFont(fontData.shift());
		var loop:Int = 2;
		var keys:Array<String> = new Array();
		while (fontData.length > 0) {
			var l:Null<Int> = Std.parseInt(fontData.pop());//	GET LENGTH OF DATA FOR NEXT GLYPH
			if (l == null) continue;// SHOULD NOT HAPPEN
			var charInfo = fontData.pop().split(':|');
			//keys[charInfo[0].charCodeAt(0)] = charInfo[0];				
			//trace(charInfo[0].charCodeAt(0)+':' + charInfo[1] +':' + l);
			//if (loop-- < 0) break;
			charData.set(charInfo[0], [charInfo[1]].concat(fontData.splice(fontData.length - l, l)));
			//charData.set(fontData.pop(), fontData.splice(fontData.length - l, l));
		}
		
		trace('FontParsing Time:' + Std.string((Date.now().getTime() - t) / 1000));
		trace("StartUp Time:" + Std.string((Date.now().getTime() - t)/1000));

		var lineWidth = 0;
		var m = '\n';
		keys = [];
		//for (c in 32...62){
		for (k in charData.keys()) {
			keys.push(k);
		}
		keys = ArrayTools.stringIt2Array(charData.keys(), true);
		for (k in keys){
			//m += c + ':' + keys[c] + ' - ';
			m += k + ' - ';
			if (lineWidth++ > 20) {
				lineWidth = 0;
				m += '\n';
			}
		}
		trace(m);		
		callBack();
	}

	
	/*function onFontIOError(evt:IOErrorEvent) {
		trace(evt.toString());
	}
	
	public function updateChars(chars:String) {
		var charQueue = (chars != '') ? chars.split('') :[];		
		for (c in 0...charQueue.length){
			//trace(charQueue[c] +':' + charQueue.length);
			if (charShapes[c] != null) {
				if(charShapes[c].char == charQueue[c])
					continue;
				else {
					var oldChar = charShapes.splice(c, 1);
					removeChild(oldChar[0]);
					if(charShapes.length < c+1 || charShapes.length == 0 || charShapes[c].char != charQueue[c])
					charShapes.insert(c, new Char(charQueue[c], this));					
				}					
			}
			charShapes.push(new Char(charQueue[c], this));
		}
		while (charShapes.length > charQueue.length) {
			var tail = charShapes.pop();
			removeChild(tail);
		}
		currentAdvance = 0;
		for (c in 0...charShapes.length) {
			charShapes[c].x  = currentAdvance;
			currentAdvance += charShapes[c].getAdvance(c) ;
		}
	}*/
}