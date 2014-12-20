/**
 * 
 * @author axel@cunity.me
 *
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.ui.form;
import flash.xml.XML;
import haxe.ds.StringMap.StringMap;
import me.cunity.service.Client;
//import me.cunity.service.Response;
import me.cunity.service.ServiceProxy;
import me.cunity.ui.Column;
//import me.cunity.ui.Container;

import me.cunity.ui.Text;

//class Form extends Container
class Form extends Column
{
	public var variables:StringMap<Text>;
	var data:StringMap<String>;
	var proxy:ServiceProxy;	
	
	public function new(xN:XML, p:Container) 
	{
		data = new StringMap();
		variables = new StringMap();
		super(xN, p);
		var client:Client = new Client();
		proxy = client.init();
	}	
	
	public function linkHandler(evt:Dynamic) 
	{
		//throw('not implemented by ' + Type.getClass(this));
		removeOverlay();			
	}
}