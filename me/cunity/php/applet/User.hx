package me.cunity.php.applet;

/**
 * ...
 * @author axel@cunity.me
 */
#if php
import sys.FileSystem;
import sys.io.File;
import php.Lib;
import php.Session;
import php.Web;
import haxe.xml.Fast;
import haxe.crypto.Md5;
#end

class User 
{
	public var auth(get, null):Bool;
	public var uID(default, null):String;
	public var userName(default, null):String;
	
	private var _authenticated:Bool;

	public function new(app:App) 
	{
		#if php
		_authenticated = false;
		app.user = this;
		if (!FileSystem.exists('site.xml'))
		{			
			_authenticated = true;
			return;
		}
		Session.start();
		App.errLog('session_id:' + Session.getId());
		app.xconf = new Fast(Xml.parse(File.getContent('site.xml')).firstElement());	
		if (app.param.exists('user') &&  app.param.exists('pass') && app.xconf.hasNode.user)
		{//### USER SESSION LOGIN
			for (user in app.xconf.nodes.user)
			{
				//App.errLog (app.param.get('user') + ' == ' +  user.att.name  + ' && ' + 
					//app.param.get('pass') + ' == ' +  user.att.pass);
				if (app.param.get('user') == user.att.name  &&  app.param.get('pass') == user.att.pass)
				{
					uID = Md5.encode(user.att.pass + Web.getClientIP());
					Session.set('uID', uID);
					userName = Md5.encode(user.att.name);
					Session.set('userName', userName);
					_authenticated = true;
				}
			}
		}
		if (Session.exists('uID') && Session.get('uID') ==  app.param.get('uID'))	
		{
			userName = Session.get('userName');
			_authenticated = true;
			return;
		}
		var pathParts:Array<String> = Web.getURI().split('/');
		var rL:Int = app.root.split('/').length;
		App.errLog(rL + ' <= ' + pathParts.length);
		if(rL <= pathParts.length)
		{
			var userNameR = pathParts.pop();
			App.errLog(userNameR + ':' + Session.get('userName') + ' uID:' + Session.get('uID') );
			_authenticated = true;
			return;
		}		
		new me.cunity.php.applet.Ui('login', { root:app.root } );
		#end
	}
	
	public function get_auth():Bool
	{
		return _authenticated;		
	}
	
}