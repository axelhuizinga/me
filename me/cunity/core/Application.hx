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

import flash.net.URLRequest;
import flash.net.URLVariables;

import haxe.CallStack;
import haxe.ds.StringMap;


import flash.accessibility.Accessibility;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.geom.Rectangle;
import flash.Lib;
import flash.xml.XML;
import me.cunity.core.Types;
import me.cunity.data.Cookie;
import me.cunity.ui.BackGround;
import me.cunity.ui.Button;
import me.cunity.ui.Image;
import me.cunity.ui.form.Login;
import me.cunity.ui.menu.Menu;
import me.cunity.ui.DynaBlock;
import me.cunity.ui.Frame;
import me.cunity.ui.BaseCell; 
import me.cunity.ui.Copy; 
import me.cunity.ui.Drawing; 
import me.cunity.ui.Screen;
import me.cunity.ui.ScrollableText;
import me.cunity.ui.ScrollBox;
import me.cunity.ui.SWF;
import me.cunity.ui.Text;
import me.cunity.ui.Container;
import me.cunity.ui.Column;
import me.cunity.ui.Row;
import HXAddress;
import HXAddressManager;
#if flash10
//import me.cunity.ui.SVGContainer;
#end
import me.cunity.debug.Out;
import haxe.Timer;

using me.cunity.tools.ArrayTools;
using me.cunity.tools.XMLTools;

class Application extends Screen
{
	//The Application top Window 
	public static var instance:Application;
	var global:StringMap<Dynamic>;
	var cookiesEnabled:Bool;
	public var currentLocale:String;
	public var supportedLocales:Array<String>;
	
	public function new(data:String) 
	{
		instance = this;
		Lib.current.assets = new StringMap<Sprite>();
		global = new StringMap<Dynamic>();
		box = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		//me.cunity.tools.XMLTools.init();
		currentLocale = Lib.current.loaderInfo.parameters.locale;
		trace(currentLocale);
		supportedLocales = new Array();
		super( new XML(data), this);
		Lib.current.addChild(this);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize, false, 0, true);		
	}	
	
	public function setTitle(title:String)
	{
		//Out.dumpStack(CallStack.callStack());
		trace(title);
		HXAddressManager.init(title);
	}
	
	public function registerLocale(locale:String)
	{
		if (! supportedLocales.contains(locale))
			supportedLocales.push(locale);
	}
	
	public function locale(?loc:String)
	{
		var locale:String = (loc == null ? currentLocale :loc);
		trace(locale);
		
		for (c in menu.idMap.iterator())
		{
			if (c.id == locale)
			{
				c.reset(null);
				c.interactionState = InteractionState.DISABLED;
			}
			else if (c.id == currentLocale || supportedLocales.contains(c.id))
				c.interactionState = InteractionState.ENABLED;
			//trace(c.id + ' == ' +locale + ' currentLocale:' + currentLocale);
		}	
		currentLocale = locale;
		if(Cookie.isEnabled())
			Cookie.set( { locale:locale } );	
		trace(Cookie.isEnabled());
		if (loc != null && menu != null) 	
		{
			removeChild(menu);
			menu = null;
			loadMenu();
		}
	}
	
	public function mailto(source:BaseCell)
	{
		var req = new URLRequest(source.cAtts.url == null ? 'mailto:axel@cunity.me' :source.cAtts.url );
		var variables = new URLVariables();
		variables.subject = (source.cAtts.subject == null? '' :source.cAtts.subject);
		variables.body = (source.cAtts.body == null? '' :source.cAtts.body);
		//trace(Std.string(variables));
		req.data = variables;
		//Lib.getURL(req, '_self');
		var f = untyped __global__["flash.net.navigateToURL"];
		(cast f)( req, "_self"); 
		trace((source.cAtts.url == null ? 'mailto:axel@cunity.me' :source.cAtts.url ) + ' _self');
	}
	
	public function mail(href:String)
	{
		var param:Dynamic = parseHref(href);
		var req = new URLRequest(param.url == null ? 'mailto:axel@cunity.me' :param.url );
		var variables = new URLVariables();
		variables.subject = (param.subject == null? '' :param.subject);
		variables.body = (param.body == null? '' :param.body);
		trace(Std.string(variables));
		req.data = variables;		
		var f = untyped __global__["flash.net.navigateToURL"];
		(cast f)( req, "_self"); 		
	}
	
	public function parseHref(href:String):Dynamic 
	{
		var parts:Array<String>  = href.split('?');
        var p:Dynamic = { url:parts[0] };
		if (parts.length == 1)
			return p;
        var query:String = parts[1];
        var vars:Array<String> = query.split("&");
        for ( v in vars) {
            var pair:Array<String> = v.split("=");
			Reflect.setField(p, pair[0], pair[1]);
		}
        return p;
    }
	
	public function setGlobal(name:String, pub:Dynamic)
	{
		global.set(name, pub);
		trace(name +':' + pub);
	}
	
	public function getGlobal(name):Dynamic
	{		
		trace(name + ':' + global.get(name));
		return global.get(name);
	}
	
	

}