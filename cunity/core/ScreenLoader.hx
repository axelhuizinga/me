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
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.xml.XML;
import flash.xml.XMLList;
//import erazor.macro.SimpleTemplate;
import erazor.Template;
import me.cunity.debug.Out;
import me.cunity.ui.BaseCell;
import me.cunity.ui.Frame;
//import org.sugar.xml.MacroFast;
using StringTools;

class ScreenLoader extends URLLoader
{
	var frame:Frame;
	var content:XML;
	var _id:String;
	var templateReady:Bool;
	
	public function new(f:Frame, id:String = null) 
	{
		super();
		frame = f;
		addEventListener(Event.COMPLETE, onComplete,false,0,true);
		//addEventListener(ProgressEvent.PROGRESS, onProgress);
		addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
		//addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		trace(id);
		if (id != null)
			loadScreen(id);
	}
	
	public function loadScreen(id:String)
	{
		_id = id;
		trace(id);
		var template = new URLRequest('site/' + id + '.xml?t=' +  Std.random(100000));
		
		try {
            load(template);
		}
		catch (error:Dynamic) {
			trace("Unable to load requested document " + error);
		}
	}
	
	function onComplete(evt:Event) 
	{
		//Out.dumpObject(evt.target);
		var xml:XML = new XML(evt.target.data);
		trace(xml.elements().length() + ' templateReady:' + templateReady);
		if (templateReady)
		{
			//PROCESS TEMPLATE WITH LOCALE
			var localeEls:XMLList = xml.elements();
			trace(xml.name() + ' localeEls.length:' + localeEls.length());
			if (xml.name() == 'locale')
			{//LOCALE FOUND :-) CREATE OBJECT FROM
				var localeObj:Dynamic = frame.screenLoaderData;// { };
				frame.screenLoaderData = {};
				var len:Int = localeEls.length();
				for (i in 0...len)
				{
					Reflect.setField(localeObj, localeEls[i].name(), localeEls[i].toString());
				}
				//trace(Std.string(localeObj));
				//trace(content.toXMLString());
				var template:Template = new Template(content.toXMLString());
				//var template:SimpleTemplate<Dynamic> = new SimpleTemplate();
				try{
					content = new XML(template.execute(localeObj));
				}
				catch (ex:Dynamic) { trace(ex); }
				content.replace('<br/>', '<br>');
			}
			//trace(content);
			frame.createScreen(content, _id);
			destroy();
		}
		else
		{
			templateReady = true;
			content = xml;
			try {
				var locale = new URLRequest('site/locale/' + Application.instance.currentLocale + '/' + _id + '.xml');
				trace('site/locale/' + Application.instance.currentLocale + '/' + _id + '.xml');
				load(locale);
			}
			catch (error:Dynamic) {
				trace("Unable to load requested document " + error);
			}
		}
	}
	
	function onIOError(evt:Event) {
		trace("Unable to load requested document " + evt.toString());
		frame.getScreen('home');//TODO CONFIG PARAM 4 DEFAULT SITE TO LOAD
		destroy();
	}
	
	function destroy()
	{
		removeEventListener(Event.COMPLETE, onComplete, false);
		removeEventListener(IOErrorEvent.IO_ERROR, onIOError, false);
	}
}