/**
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

import HXAddress;

import flash.events.Event;
import flash.events.TextEvent;
import flash.external.ExternalInterface;
import flash.geom.Rectangle;
import flash.Lib;
import flash.xml.XMLList;
import haxe.remoting.HttpAsyncConnection;
import haxe.crypto.Md5;
import me.cunity.core.Application;
import me.cunity.core.OverlayLoader;
import me.cunity.data.Cookie;
import me.cunity.debug.Out;
import me.cunity.service.Client;
import flash.xml.XML;
import me.cunity.service.Response;
import me.cunity.service.ServiceProxy;
import me.cunity.ui.Container;
import me.cunity.ui.Overlay;

class Login extends Form
{	
	public function new(xN:XML, p:Container) 
	{
		super(xN, p);
	}
	
	function processResult(res:Response)
	{
		trace(res.method);
		//trace(res.content.get('body'));
		if (res.hasError)
		{
			new OverlayLoader(this, 'error', res.errorContent);
			trace(res.errorContent);
			return;
		}
		switch(res.method)
		{
			case 'login', 'register':
			//case 'register':
			//case 'redirect':
			Application.instance.userStateChange = true;
			Application.instance.frame.screenLoaderData = { user:variables.get('user').tF.text };
			//trace(Application.instance.frame.history[0] + ':' + SWFAddress.getPath());
			trace(res.authStatus + ':' + Application.instance.menu.getChildByID('user/login'));
			return;
			var lastScreen = (Application.instance.frame.history.length > 1) ? Application.instance.frame.history[Application.instance.frame.history.length - 2] :Application.instance.firstScreenID;
			if (lastScreen == 'user/login' || lastScreen == 'user/new')
				lastScreen = Application.instance.firstScreenID;
			Application.instance.frame.loadScreen(lastScreen);
		}
	}
	
	override public function linkHandler(evt:Dynamic)
	{
		super.linkHandler(evt);
		var complete:Bool = true;
		//trace(evt.text + ':' + Std.string( variables.exists('user')));
		if(Std.is(evt, TextEvent))
		switch(evt.text)
		{
			case 'login':
			proxy.login(Application.instance.currentLocale, variables.get('user').tF.text, variables.get('password').tF.text, processResult);
			case 'new':
			//getVariables();
			proxy.register(Application.instance.currentLocale, variables.get('user').tF.text, variables.get('email').tF.text, variables.get('password').tF.text, processResult);
			
		}
		else
			switch(evt.currentTarget.id)
			{
				case 'login':
				if (variables.get('user').tF.text.length == 0)
				{
					variables.get('user').tF.text = variables.get('required').tF.text;
					complete = false;
				}				
				if (variables.get('password').tF.text.length == 0)
				{
					variables.get('password').tF.text = variables.get('required').tF.text;
					complete = false;
				}				
				if (complete)
				{
					if (Cookie.isEnabled())
					{
						Cookie.set( {
							password:variables.get('password').tF.text,
							user:variables.get('user').tF.text
						});
					}					
					proxy.login(Application.instance.currentLocale, variables.get('user').tF.text, Md5.encode(variables.get('password').tF.text), processResult);
				}
				case 'register':
				if (variables.get('user').tF.text.length == 0)
				{
					variables.get('user').tF.text = variables.get('required').tF.text;
					variables.get('user').selectAll(null);
					complete = false;
				}
				if (variables.get('password').tF.text.length == 0)
				{
					variables.get('password').tF.text = variables.get('required').tF.text;
					variables.get('password').selectAll(null);
					complete = false;
				}
				if (variables.get('email').tF.text.length == 0)
				{
					variables.get('email').tF.text = variables.get('required').tF.text;
					variables.get('email').selectAll(null);
					//trace(variables.exists('required') + ':' + variables.get('required').tF.text);
					complete = false;
				}
				if (complete)
				{
					if (Cookie.isEnabled())
					{
						Cookie.set( {
							email:variables.get('email').tF.text,
							password:variables.get('password').tF.text,
							user:variables.get('user').tF.text
						});
					}
					proxy.register(Application.instance.currentLocale, variables.get('user').tF.text, variables.get('email').tF.text, Md5.encode(variables.get('password').tF.text), processResult);
				}
				case 'clear':
				for (key in variables.keys()) {
					variables.get(key).tF.text = '';
				}				
				case 'logout':
				//proxy.logout();
			}
	}
	
	/*function getVariables():Map<String>
	{		
		for (key in variables.keys()) {
			//data.set(key, variables.get(key).tF.text);
			trace(key + ':' + variables.get(key).tF.text);
		}
		return data;
	}*/
	
	override public function layout()
	//override public function layout():Rectangle
	{
		if(ExternalInterface.available){
			try {
				ExternalInterface.call("focusStage");
			}
			catch(error:Dynamic) {
				trace(error);
			}
		}
		
		if (Lib.current.loaderInfo.parameters.user != null) {
			try 
			{
				variables.get('user').tF.text = Lib.current.loaderInfo.parameters.user;
				variables.get('password').tF.text = Lib.current.loaderInfo.parameters.password;				
			}
			catch(ex:Dynamic){}
		}
		else if (Cookie.isEnabled())
		{
			if (Cookie.has('user'))
				variables.get('user').tF.text = Cookie.get('user');
			if (Cookie.has('password'))
				variables.get('password').tF.text = Cookie.get('password');			
			if (variables.exists('email') && Cookie.has('email'))
				variables.get('email').tF.text = Cookie.get('email');			
		}
		
		//return 
		super.layout();
	}
}