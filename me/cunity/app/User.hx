package me.cunity.app;

/**
 * ...
 * @author axel@cunity.me
 */

#if (php||neko)
import sys.FileSystem;
import sys.io.File;
#if php
import php.Web;
import php.Lib;
#elseif neko
import neko.Web;
import neko.Lib;
#end
#end

import haxe.xml.Fast;
import haxe.crypto.Md5;

import me.cunity.app.Cookie;
import me.cunity.app.Types;

class User 
{
	public var auth(get_auth, null):UserLevel;
	public var cookies:Map<String, String>;
	public var uID(default, null):String;
	public var userName(default, null):String;
	
	private var _authenticated:UserLevel;

	public function new(app:App) 
	{
		#if !js
		_authenticated = null;
		app.user = this;
		var cookie  = new Cookie();
		App.errLog('cookie:' + cookie.get('uID'));
		//App.errLog('session_id:' + Session.getId());
		if (cookie.get('uID') != null && cookie.get('uID') == app.param.get('uID'))
		{
			_authenticated = app.param.exists('admin') &&  app.param.get('admin') == '1' ? 
				admin :authUser ;
			uID = cookie.get('uID');
		}
		else if (app.param.exists('userName') && app.param.get('userName') != '' && 
			app.param.exists('passwd') && app.param.get('passwd') != '')
		{
			//uID = Md5.encode( Date.now().toString() + Web.getClientIP());
			cookie.set('uID', uID);
			userName = Md5.encode(app.param.get('userName'));
			cookie.set('userName', userName);
			_authenticated = app.param.exists('admin') &&  app.param.get('admin') == '1' ? 
				admin :authUser ;		
		}
		else 
		{
			uID = Md5.encode( Date.now().toString() + Web.getClientIP());
			cookie.set('uID', uID);
			userName = Md5.encode('guest');
			cookie.set('userName', userName);	
			trace("uID:" + uID);
			trace(cookie);
			_authenticated = guest;
		}
		#end
	}
	
	public function get_auth():UserLevel
	{
		return _authenticated;		
	}
	
}