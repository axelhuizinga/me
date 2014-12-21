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
import haxe.Template;
import php.FileSystem;
import sys.io.File;
import php.Lib;


class Ui 
{
	
	public static function create(flow:Flow, layout:Xml) :String
	{
		//trace(Std.string(flow.attributes));
		trace(Std.string(layout));
		//trace(flow.attributes.get('templates') );
		//trace(layout.get('url'));
		//return null;
		var tmplUrl:String = flow.attributes.get('templates') + '/' + layout.get('url') + '.mtt';
		//trace(tmplUrl);
		if(!FileSystem.exists(tmplUrl)) tmplUrl = flow.attributes.get('templates') + '/' + flow.attributes.get('default') + '.mtt';
		trace(tmplUrl);
		if (!FileSystem.exists(tmplUrl)) throw("Template " + tmplUrl + " not found!");
		//trace(File.getContent(tmplUrl));
		var templ:Template = new Template(File.getContent(tmplUrl));
		trace(Type.getClass(templ));
		var ctx:Context = new Context(layout);
		if (tmplUrl ==  flow.attributes.get('root') && flow.attributes.exists('frame')){
			ctx.atts.home = flow.attributes.exists('home') ?  flow.attributes.get('home') :'home';
		}
		//ctx.atts.debug = Out.finish();
		trace(Std.string(ctx.atts));
		return templ.execute(ctx.atts);
		
	}
	
}