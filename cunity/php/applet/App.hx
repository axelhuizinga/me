package me.cunity.php.applet;

import haxe.ds.StringMap;
import me.cunity.php.applet.Types;

import haxe.xml.Fast;
import haxe.PosInfos;

#if php
import sys.FileSystem;
import sys.io.File;
import php.Lib;
import haxe.io.Path;
import php.Session;
import php.Web;
#end 
using StringTools;

import me.cunity.debug.Out;
/**
 * ...
 * @author axel@cunity.me
 */

class App implements IServiceApi
{

	public var controller:App;
	public var action:String;
	public var output:String;
	public var param:StringMap<String>;
	public var root:String;
	public var server:StringMap<String>;
	public var serviceParam(default, null):ServiceParam;
	public var user:User;
	public var xconf:Fast;
		
	var debugging:Bool;
	
	public function new() 
	{
		#if php
		server = Lib.hashOfAssociativeArray(untyped __php__("$_SERVER"));
		root = Web.getCwd().replace(server.get('DOCUMENT_ROOT'), '');
		param = Web.getParams();
		user = new User(this);
		init();
		me.cunity.debug.Out.dumpObject(server);
		#end
	}
	
	public function debug(m:Dynamic, ?i:PosInfos)
	{
		if (!debugging)
			return;
		var ms:String = Std.is(m, String) ? m :Std.string(m);
		if ( i != null ) 
			ms = i.fileName + ':' + i.lineNumber + ":" + i.methodName  + ms;
		output += ms + "\n";
	}
	
	private function dispatch():Bool
	{
		#if php
		var uri:String = Web.getURI();
		App.errLog( ' root:' + root + ' uri:' + uri );
		action =   '';
		if (root !=  uri)
		{
			uri = ~/\/$/.replace(uri, '');
			action =  uri.replace(root, '');
			param = new StringMap();
			var parameters:Array<String> = action.split('/');
			if (parameters.length > 0 && parameters[0] != '')
			{
				action = parameters.shift();
				while (parameters.length > 0)
				{
					param.set(parameters.shift(), parameters.shift());
				}
			}			
			errLog(action +':' + param.toString());
		}
		errLog(action + (Reflect.isFunction(Reflect.field(this, action)) ? 'yeah':'nono :(') );
		//if (Reflect.isFunction(action))
		if (Reflect.isFunction(Reflect.field(this, action)))
			Reflect.callMethod(this, Reflect.field(this, action), [param]);
		else
		{
			var uP = { root:root, uID:user.uID, userName:user.userName};
			for (fName in Reflect.fields(serviceParam))
				Reflect.setField(uP, fName, Reflect.field(serviceParam, fName));
			new Ui(xconf != null && xconf.has.home ? xconf.att.home :'app', uP);		
		}
		#end
		return action != '';
	}
	
	public function init(sp:ServiceParam = null):Void
	{		
		serviceParam = new ServiceParam({ baseDir:'' });
		if (xconf != null)
		{
			for (name in Reflect.fields(serviceParam))
			{
			
				//App.errLog(name + ':' + (xconf.x.exists(name) ? 'y':'n'));
				if (xconf.x.exists(name))
					Reflect.setField(serviceParam, name, xconf.x.get(name));					
			}

		}
		App.errLog('path:' + serviceParam.mediaPath);
		App.errLog('output:' + output);		
		//return output;
	}
	
	public static function errLog(m:Dynamic, ?i:PosInfos)
	{
		var ms:String = Std.is(m, String) ? m :Std.string(m);
		var msg = if ( i != null ) i.fileName + ':' + i.lineNumber + ":" + i.methodName  else "";
		//trace("<textarea cols='80' rows='15'>" + msg +':' + untyped __call__('htmlspecialchars', ms) + "</textarea>");
		if (false && ms.length > 100)
		untyped __call__("error_log",  
			"<textarea cols='80' rows='15'>"+ msg +':' + untyped __call__('htmlspecialchars', ms) + "</textarea>");
		else
		untyped __call__("error_log",   msg +':' + untyped __call__('htmlspecialchars', ms));
		//untyped __call__("error_log",   msg +':' + untyped __call__('htmlspecialchars', ms.substr(0,110)));
	}
	
	
}