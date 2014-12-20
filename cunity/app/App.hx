package me.cunity.app;
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.ds.StringMap;
import haxe.Json;
import haxe.PosInfos;

import me.cunity.app.data.Oracle;

using StringTools;

#if !js
import sys.FileSystem;
//import sys.db.RecordInfos;
import sys.io.File;
#end

#if php
import php.Lib;
import php.Web;
#elseif neko
import neko.Lib;
import neko.Web;
#end
#if js
import me.cunity.util.GlobalTimer;
import me.cunity.js.layout.*;
import js.JQuery;
typedef ScreenList = {
	var id:String;
	var container:Container;
};
#end


@:expose("App") class App 
{
	public var controller:App;
	public var path:String;
	public var output:String;
	public var param:Map<String, String>;
	public var root:String;// APP ROOT DIR RELATIVE 2 DOCUMENTROOT
	//public var server:Map<String, String>;
	public var server:StringMap<String>;

	public var user:User;
	public var jconf:Json;
		
	var debugging:Bool;
	var dummy:Oracle;
	var defaultPath:String;
	#if js
	public var layoutCB:Dynamic;
	public var contentBox:Container;
	public var rootBox:Container;
	public var docRoot:String;
	public var jqWin:JQuery;
	public var screens:Array<ScreenList>;
	public var minScreenWidth:Float;

	//static var proxy:OracleProxy;
	static var relayoutDelay:GTimer;
	static var initialized:Bool = true;
	public static var hasState:Bool;
	#end
	public static var ins:App;
	
	public function new() 
	{
		#if !js
		path = '';
		server = Sys.environment();
		//Lib.println( ' root:' + Web.getCwd() + ' DOCUMENT_ROOT:' + Sys.environment() + '<br>');
		//Lib.println( ' is mod_neko:' + (Web.isModNeko ? 'y':'n') + '<br>');
		App.errLog( ' root:' + server.get('DOCUMENT_ROOT'));
		root = Web.getCwd().replace(server.get('DOCUMENT_ROOT'), '');
		App.errLog( ' root:' + root);
		
		param = Web.getParams();
		trace('page:' + param.get('page'));
		#end
		ins = this;
		user = new User(this);
		init();
	}
	
	public function dispatch():Void
	{
		#if !js
		var uri:String = Web.getURI();
		App.errLog( ' root:' + root + ' uri:' + uri + ' redirect:' +  server.get('REDIRECT_URI'));
		if (root !=  uri)
		{
			uri = ~/\/$/.replace(uri, '');//REMOVE LAST /
			path =  uri.replace(root, '');
			param = new Map();
			var parameters:Array<String> = path.split('/');
			if (parameters.length > 0 && parameters[0] != '')
			{
				path = parameters.shift();
				while (parameters.length > 0)
				{
					param.set(parameters.shift(), parameters.shift());
				}
			}			
			errLog(path +':' + parameters.toString());
		}
		else
			path = 'app';
		errLog(path + (Reflect.isFunction(Reflect.field(this, path)) ? 'yeah':'nono :(') );
		
		var state:String = server.get('PHP_SELF').substr(0, server.get('PHP_SELF').lastIndexOf('/'));
		
		if (Reflect.isFunction(Reflect.field(this, path)))
			Reflect.callMethod(this, Reflect.field(this, path), [param]);
		else
		{
			var uP = { root:root, path:path, uID:user.uID, userName:user.userName, state:state};
			new Ui(this, uP);
		}
		#end
	}

	public function init(sp:Dynamic = null):Void
	{		
		if (user.auth != null)
			dispatch();		
	}
	
	public static function errLog(m:Dynamic, ?i:PosInfos)
	{
		var ms:String = Std.is(m, String) ? m :Std.string(m);
		var msg = if ( i != null ) i.fileName + ':' + i.lineNumber + ":" + i.methodName  else "";
		#if php
		untyped __call__("error_log", msg +':' + ms);
		#elseif neko
		Web.logMessage(msg +':' + ms);
		#end
	}
	
	
}