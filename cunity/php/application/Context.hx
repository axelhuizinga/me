/**
 * @author Axel Huizinga
 * axel@cunity.me
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

package me.cunity.php.application;
import me.cunity.debug.Out;
import me.cunity.util.XmlUtils;


class Context
{
	public var atts:Dynamic;
	
	public function new(param:Xml) 
	{
		
		atts = { stylesheets:[], scripts:[]};
		//atts = { };
		trace(param + ':' +Std.string(param.attributes().hasNext()));
		//for (att in param.attributes()) {
		var it:Iterator<String> = param.attributes();
		while (it.hasNext()) {
			var att = it.next();
			trace(att);
			switch(att) {
				case 'stylesheets':
				trace(param.get(att));
				trace(~/\s?,\s?/.split(param.get(att)));
				var hrefs:Array < String > = ~/\s?,\s?/.split(param.get(att));
				for (url in hrefs)
					atts.stylesheets.push( { href:url } );
				default:
				Reflect.setField(this.atts, att, param.get(att));
			}
		}
		trace(Std.string(atts));
		if (param.elementsNamed('content').hasNext())
			atts.content = XmlUtils.innerHTML(param.elementsNamed('content').next());
		trace(atts.content);

	}
	

	public function toString():String {
		var _s:String = '';
		var fields:Array<String> = Type.getInstanceFields(Type.getClass(this));
		var _s:String = Std.string(fields);
		//var _s:String = Std.string(Reflect.fields(this.atts));
		for (f in Reflect.fields(this.atts))
			_s += f + ':' + Reflect.field(this.atts, f) + '<br/>\n';
		return _s;
	}
	
}