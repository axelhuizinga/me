package me.cunity.app;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.io.Path;

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
class RData extends App
{
	static var rinst :RData; 
	
	static function main() 
	{ 
		rinst = new RData(); 
		var context = new haxe.remoting.Context(); 
		context.addObject("rdata", rinst); 
		#if !js
		haxe.remoting.HttpConnection.handleRequest(context); 
		var hR:Bool = haxe.remoting.HttpConnection.handleRequest(context);
		App.errLog('remoting handleRequest ? ' + ( hR ? ' Y ' :' N '));
		if (hR)
		{// REMOTING (AJAX) REQUEST
			
			App.errLog('remoting:' + Web.getParams().get("__x"));
			//App.errLog('headers:' + Web.getClientHeaders().toString());
			
			return; 
		}
		#end
		if (rinst.user.auth)
			rinst.dispatch();
	} 
	
	public function new() 
	{
		super();	
	}
	
	public function getData():List<Dynamic>
	{
		var data:List<Dynamic> = new List();
		#if php
		#end
		return data;
	}
}