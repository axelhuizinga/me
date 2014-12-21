package me.cunity.service;


import haxe.Log;
import haxe.PosInfos;
import haxe.remoting.HttpAsyncConnection;
import haxe.remoting.HttpConnection;
import haxe.Timer;
import me.cunity.debug.Out;
#if php
//import php.FileSystem;
import sys.io.File;
import php.Session;
import php.Web;
#end


class Service 
{

	public var dataDir:String;
	public var locale:String;
	public var online(getOnline, null):Int;
	public var user:User;
	public var templateDir:String;
	
	//MILLISECONDS
	public static inline var MAX_IDLE_TIME:Int = 1800000;//30min
	public static inline var MAX_LIFE_TIME:Int = 3600000*8;//8h
	
	public static var instance:Service;
	public static var response:Response;
	
	public function new()
	{
		instance = this;
		#if php
		dataDir = dirname(Web.getCwd()) + '/data';
		online = getOnline();
		templateDir = dirname(Web.getCwd()) + '/server/' ;
		//errLog(Web.getCookies().toString());
		#end
		var ctx = new haxe.remoting.Context();
		ctx.addObject("service", this);

		if ( HttpConnection.handleRequest(ctx) ) 
		{
			Log.trace = Out._trace;
			return;
		}
		trace("<pre>this is a remoting server@" + Web.getParams()); 
	}
	
	public function login(l:String, name:String, pass:String):Response
	{
		locale = l;
		response = new Response();
		//Auth.checkStatus(name, pass);
		User.login(name, pass);
		return response;
	}
	
	public function logout(l:String, name:String, pass:String):Response
	{
		locale = l;
		response = new Response();
		//Auth.checkStatus(name, pass);
		User.logout(name, pass);
		return response;
	}
	
	public function register(l:String, name:String, email:String, pass:String):Response
	{		
		locale = l;
		response = new Response();
		User.register(name, email, pass);
		return response;
	}
   
	public function dirname(url:String):String { 
		var sep:String = (~/\//.match(url) ? '/' :'\\'); 
		url = new EReg(sep + "$", null).replace(url, ''); 
		var arr:Array < String > = url.split(sep); 
		arr.pop(); 
		return arr.join(sep); 
	} 
	
	#if php
	
	public function errLog(m:String, ?i:PosInfos)
	{
		var msg = if( i != null ) i.fileName + ':' + i.lineNumber+":"  + i.methodName  else "";
		untyped __call__("error_log",   msg +':' + m);
	}

	function getOnline():Int
	{
		//trace('<pre>' + service.dataDir + '/sessions');
		Session.setSavePath(dataDir + '/sessions');
		//Session.setCacheLimiter(CacheLimiter.NoCache);
		//trace(Session.getCacheLimiter());
		//trace(Session.getCacheExpire());
		//Session.setCacheExpire(1);
		Session.start();
		//trace(Session.get('IP'));
		Session.set('IP',  Web.getClientIP());
		Session.close();
		//Session.regenerateId();
		
		var count:Int = 0;
		var sesDir:String = Session.getSavePath();
		var sessionFiles:Array<String> = FileSystem.readDirectory(sesDir);
		var cTime:Float = Timer.stamp();
		for (filePath in sessionFiles)
		{
			if (filePath == '.' || filePath == '..')
				continue;
			var idleTime:Float = cTime - FileSystem.stat(sesDir + '/' + filePath).atime.getTime() / 1000;
			if (idleTime  < MAX_IDLE_TIME)
				count++;
			else if (idleTime > MAX_LIFE_TIME)
				FileSystem.deleteFile(sesDir + '/' + filePath);
		}
		return count;
	}	
	#end
	

}