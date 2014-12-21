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
 * THIS SOFTWARE IS PROVIDED BY THE TOUCH MY PIXEL & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE TOUCH MY PIXEL & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.effects.phx;
import phx.Body;
import phx.Properties;
	
class Dumper 
{

	public static function properties(obj:Dynamic, ?internal:Bool):String {//ACCEPT A BODY OR PROPERTIES
		var p:Properties = null;
		var b:Body = null;
		var res:String = '';
		
		if (Type.getClass(obj) == Properties) {
			p = obj;
			res = p.id+'.:{\n';
		}
		else {
			p = obj.properties;
			b = obj;
			res = b.id+'.properties:{\n';
		}
		res += '\tlinearFriction:' + p.linearFriction + ',\n';
		res += '\tangularFriction:' + p.angularFriction + ',\n';
		res += '\tbiasCoef:' + p.biasCoef + ',\n';
		res += '\tmaxMotion:' + p.maxMotion + ',\n';
		res += '\tmaxDist:' + p.maxDist + ',\n';
		if (!internal) {
			res += '}\n';
			return res;
		}
		res += '\tcount:' + p.count + ',\n';
		res += '\tlfdt:' + p.lfdt + ',\n';
		res += '\tafdt:' + p.afdt + ',\n}\n';
		return res;
	}
	
	public function new() 
	{
		
	}
	
}