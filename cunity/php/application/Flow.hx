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
import me.cunity.util.XmlUtils;
import sys.io.File;
import php.Lib;
import php.Sys;
import php.Web;

class Flow 
{
	var _ui:String;
	var _ctx:Context;
	var _async:Bool;
	public var attributes:Map<String>;
	
	public function new(configPath:String ) 
	{
		attributes = new Map();
		var uri :String = Web.getURI();
		trace(Web.getCwd() );
		var self :String = untyped __var__('_SERVER', 'REQUEST_URI');
		trace(self);
		try {		
			var layout:Xml = Xml.parse(File.getContent(configPath));	
			var root = layout.firstElement().get('root');
			var pageUrl = new EReg(".*" + root, '').replace(uri, '');
			for (att in layout.firstElement().attributes())//parse site global atts
				attributes.set(att, layout.firstElement().get(att));
			trace('>'+pageUrl + '<');
			//if (pageUrl == attributes.get('root')) {
			if (pageUrl == '' || pageUrl == 'index') {
				pageUrl = 'index';
				createUi(layout.firstElement());
			}
			else
			createUi(XmlUtils.getChildByAtt(layout.firstElement().elements(), 'url',  pageUrl));
		}
		catch (ex:Dynamic) {
			Lib.println(ex);
		}
	}
	
	function createUi(ui:Xml) {
		_ui =Ui.create(this, ui);
	}
	
}