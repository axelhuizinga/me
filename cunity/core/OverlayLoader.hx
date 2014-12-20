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
//import erazor.Template;
import erazor.Template;
import me.cunity.debug.Out;
import me.cunity.ui.BaseCell;
import me.cunity.ui.Frame;
//import org.sugar.xml.MacroFast;

class OverlayLoader extends URLLoader
{
	var _parent:BaseCell;
	var content:String;
	var document:XML;
	var _id:String;
	var templateReady:Bool;
	
	public function new(p:BaseCell, id:String, cnt:String = null) 
	{
		super();
		_parent = p;
		addEventListener(Event.COMPLETE, onComplete,false,0,true);
		//addEventListener(ProgressEvent.PROGRESS, onProgress);
		addEventListener(IOErrorEvent.IO_ERROR, onIOError,false,0,true);
		//addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		
		try {
            load(new URLRequest('site/' + id + '.xml'));
		}
		catch (error:Dynamic) {
			trace("Unable to load requested document " + error);
		}
	}
	
	function onComplete(evt:Event) 
	{
		//Out.dumpObject(evt.target);
		var xml:XML = new XML(evt.target.data);
		//trace(xml.elements().length() + ' templateReady:' + templateReady);
		if (document != null)
		{
			//PROCESS TEMPLATE WITH LOCALE
			var localeEls:XMLList = xml.elements();
			//trace(xml.name() + ' localeEls.length:' + localeEls.length());
			if (xml.name() == 'locale')
			{//LOCALE FOUND :-) CREATE OBJECT FROM
				var localeObj:Dynamic = { };
				var len:Int = localeEls.length();
				for (i in 0...len)
				{
					Reflect.setField(localeObj, localeEls[i].name(), localeEls[i].toString());
				}
				localeObj.content = content;
				try{
					var template:Template = new Template(document.toXMLString());
					document = new XML( template.execute(localeObj) );
				}
				catch (ex:Dynamic) { trace(ex);}
			}
			//trace(content + ':' + document);
			_parent.createOverlay(document, _id);
			destroy();
		}
		else
		{
			templateReady = true;
			document = xml;
			try {
				var locale = new URLRequest('site/locale/' + Application.instance.currentLocale + '/' + _id + '.xml');
				//trace('site/locale/' + Application.instance.currentLocale + '/' + _id + '.xml');
				load(locale);
			}
			catch (error:Dynamic) {
				trace("Unable to load requested document " + error);
			}
		}
		//
		//
	}
	
	function onIOError(evt:Event) {
		trace("Unable to load requested document " + evt.toString());
		destroy();
	}
	
	function destroy()
	{
		removeEventListener(Event.COMPLETE, onComplete, false);
		removeEventListener(IOErrorEvent.IO_ERROR, onIOError, false);
	}
}