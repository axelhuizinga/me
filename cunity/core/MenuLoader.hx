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

package me.cunity.core;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.xml.XML;
import flash.xml.XMLList;
import haxe.CallStack;
import erazor.Template;
import me.cunity.debug.Out;
import me.cunity.ui.BaseCell;

class MenuLoader extends URLLoader
{
	var app:Application;
	var content:XML;
	//var _id:String;
	var _path:String;
	var templateReady:Bool;
	
	public function new(path:String) 
	{
		super();
		_path = path;
		app = Application.instance;
		//trace("loadin' " + path + 'live.menu.xml');
		addEventListener(Event.COMPLETE, onComplete,false,0,true);
		addEventListener(ProgressEvent.PROGRESS, onProgress,false,0,true);
		addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
		try 
		{
			var req = new URLRequest(path + 'live.menu.xml');
            load(req);
		}
		catch (error:Dynamic) {
			trace("Unable to load requested document " + error);
		}

	}
	
	function onProgress(evt:Event) {
		
	}
	
	function onComplete(evt:Event) 
	{
		var xml:XML = new XML(evt.target.data);
		if (!templateReady)
		{
			content =  xml;
			templateReady = true;
			try {
				var req = new URLRequest(_path + 'locale/' + app.currentLocale +'/menu.xml');
				//trace(_path + 'locale/' + app.currentLocale +'/menu.xml');
				load(req);
			}
			catch (error:Dynamic) {
				trace("Unable to load requested document " + error);
			}
		}
		else
		{
			removeEventListener(Event.COMPLETE, onComplete, false);
			removeEventListener(ProgressEvent.PROGRESS, onProgress, false);
			removeEventListener(IOErrorEvent.IO_ERROR, onIOError, false);
			var localeEls:XMLList = xml.elements();
			if (xml.name() == 'locale')
			{//LOCALE FOUND :-) CREATE OBJECT FROM
				var localeObj:Dynamic = { };
				var len:Int = localeEls.length();
				for (i in 0...len)
				{
					Reflect.setField(localeObj, localeEls[i].name(), localeEls[i].toString());
				}
				var template:Template = new Template(content.toXMLString());
				try 
				{
					content = new XML(template.execute(localeObj));
				}
				catch(error:Dynamic) {
					trace("Unable to execute Template " + error);
				}				
			}
			app.addMenu(content);						
		}

	}
	
	function onIOError(evt:Event) {
		trace(evt.toString());
		app.addMenu(null);
	}
}