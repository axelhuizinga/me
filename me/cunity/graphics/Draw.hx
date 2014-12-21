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

package me.cunity.graphics;
import flash.display.Shape;

typedef DrawParam = {
	method:{ name:String, args:Array<Dynamic>},
	style:Array<Dynamic>
};


class Draw extends Shape
{

	public function new(p:DrawParam) 
	{
		super();
		/*if (p.param != null) {
			if (p.param.fill != null) {
				Reflect.callMethod(graphics, Reflect.field(graphics, p.param.fill), p.param.fill.args);			
			}
			if (p.param.line != null) {
				Reflect.callMethod(graphics, Reflect.field(graphics, p.param.line), p.param.line.args);			
			}
		}*/
		var styles:Array<Dynamic> = p.style;
		for (s in styles) {
			trace(s.name +':' + Std.string(s.args));
			Reflect.callMethod(graphics, Reflect.field(graphics, s.name), s.args);
		}
		trace(p.method.name +':' + Std.string(p.method.args));
		Reflect.callMethod(graphics, Reflect.field(graphics, p.method.name), p.method.args);
		if (p.method.name.indexOf('FillType')>-1)
			graphics.endFill();
	}
	
}