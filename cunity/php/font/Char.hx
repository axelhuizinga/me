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


import php.Lib;

class Char 
{
	public var drawingData:Array<String>;
	public var kerningData:Map<Float>;
	public var advance:Float;
	public var char:String;
	public var x:Float;
	
	
	var typeTool:TypeTool;
	var kerning:Float;
	var _drawLength:Int;
	var _pos:Int;
	
	public function new(c:String, tA:TypeTool) 
	{
		
		char = c;
		typeTool = tA;
		drawingData = new Array().concat(typeTool.charData.get(char));
		if (typeTool.fontInfo.kerning == 1) {
			var l:Int = typeTool.fontInfo.glyphs;
			if(drawingData.length == 1)
			trace(char.charCodeAt(0) +':' + drawingData[0]);
			//trace(drawingData.length +'-'+ l);
			parseKerning(drawingData.splice(drawingData.length - l, l));
		}
		var lineWidth = 1;
		advance =  Std.parseFloat(drawingData.shift()) + lineWidth;
		//kerning =  (kerningData != null) kerningData();
		//x = typeTool.currentAdvance;
		//typeTool.currentAdvance += advance;
		trace('charcode:' + char.charCodeAt(0) +':' + advance +' x:' + x + ' typeTool.currentAdvance:' + typeTool.currentAdvance + ' drawingData.length:' +
			drawingData.length);
		_drawLength = Math.ceil(drawingData.length / 10);
		//graphics.lineStyle(1, 0xffffff);		
		/*graphics.lineStyle(lineWidth, 0xffffff);		
		graphics.beginFill(0x222222);
		var matrix:Matrix = transform.matrix;
		matrix.d=-1;
		transform.matrix = matrix;
		typeTool.addChild(this);
		addEventListener(Event.ENTER_FRAME, onEnterFrame,false,0,true);*/
		
	}
	
	public function getAdvance(pos:Int):Float {
		return (kerningData == null || pos == 0) ? advance :advance + kerningData.get(typeTool.charShapes[pos-1].char);
	}
	
	function parseKerning(kData:Array<String>){
		kerningData = new Map();
		trace(kData.length +':' + typeTool.fontInfo.glyphs);
		for (k in 0...kData.length) {
			var p = kData[k].split(':|');
			//trace(p);
			kerningData.set(p[0], Std.parseFloat(p[1]));
		}
	}
		
	/*function onEnterFrame(evt:Event) {
		if(drawingData.length > 0 ) 
			drawNextPart();	
		else
			removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
	}*/
	
	public function drawNextPart() {
		//trace(char);
		var drawData:Array<String> = drawingData.splice(0, _drawLength);
		for(data in drawData){
			var d:Array < String > = data.split(' ');
			var method:String = d[0].charAt(0);
			d[0] = d[0].substr(1);
			//trace(method);
			switch (method) {
				case 'M':
				//graphics.moveTo(Std.parseFloat(d.shift()), Std.parseFloat(d.shift()));
				case 'L':
				//graphics.lineTo(Std.parseFloat(d.shift()), Std.parseFloat(d.shift()));
				case 'Q':
				/*graphics.curveTo(
					Std.parseFloat(d.shift()), Std.parseFloat(d.shift()), 
					Std.parseFloat(d.shift()), Std.parseFloat(d.shift())
				);	*/			
			}
		}
	}
}