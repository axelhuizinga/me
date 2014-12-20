package me.cunity.php.applet;

import haxe.ds.StringMap;
import me.cunity.php.applet.Types;

import haxe.Log;
import haxe.PosInfos;
import haxe.remoting.Context;
import haxe.remoting.AsyncProxy;
import me.cunity.debug.Out;
import php.Session;

import php.Lib;
import php.Web;
import haxe.CallStack;

import me.cunity.php.gd.ImageText;
using StringTools;

/**
 * ...
 * @author Axel Huizinga - axel@cunity.me 
 */

 
class MediaService  extends App implements IMediaServiceApi
{

	//var params:StringMap<String>;
	
	//static var actions:StringMap<Dynamic>;
    static var instance :MediaService; 
	static var context:Context;
	
	public var currentAlbum:Album;
	

	static function main() 
	{ 
		//Log.trace = Out._trace;
		App.errLog('hello world ' + Web.getURI() + ' ' + Session.getModule());
		#if php
		trace(untyped __php__("$_SERVER"));
		if (Web.getParams().get('debug') == '1')
		{
			untyped __php__("ini_set('display_errors', 1);");
			Web.setHeader('Content-type', 'text/plain');
			untyped __php__("
				function userErrorHandler($errno, $errmsg, $filename, $linenum, $vars)
				{
					echo(\"$filename:$linenum:$errmsg <br>\");
					//print_r($GLOBALS['%s']);
				}
				$old_error_handler = set_error_handler('userErrorHandler');
			");
		}
		else if (Web.getParams().get('log2file') == '1')
			Out.init();
				//else Lib.print("<pre>");
		
		instance = new MediaService(); 

		// create an incoming connection and give access to the "instance" object 
		context = new haxe.remoting.Context(); 
		context.addObject("mediaservice", instance); 
		var hR:Bool = haxe.remoting.HttpConnection.handleRequest(context);
		App.errLog('remoting handleRequest ? ' + ( hR ? ' Y ' :' N '));
		if (hR)
		{
			App.errLog('remoting:' + Web.getParams().get("__x"));
			//App.errLog('headers:' + Web.getClientHeaders().toString());
			return;
		}
		//if (hR)
			//return; 
		else
		{			
			if (instance.user.auth)
				instance.dispatch();
		}
		#end
	} 	
	
	public function new() 
	{
		debugging = true;
		super();
	}
	
	public function add(mediaPath:String, create:Bool = false, overwrite:Bool = false, name:String = null) :Void
	{
	
	}
	
	override public function init(sP:ServiceParam = null):Void
	{		
		super.init(sP);
		//return;
		currentAlbum = openAlbum(serviceParam.baseDir + serviceParam.mediaPath);
		App.errLog('currentAlbum:' + currentAlbum.name);		
		//App.errLog('output:' + output);		
		//return output;
	}
	
	public function getAlbum(mediaPath:String):StringMap<Dynamic>
	{
		var display:StringMap<Dynamic> = new StringMap();
		App.errLog('display:' + display);
		currentAlbum = openAlbum('../' + mediaPath);
		if (currentAlbum.name == null)
			return null;
		App.errLog('currentAlbum:' + currentAlbum.name);
		display.set('name', currentAlbum.name);
		display.set('folderCount', currentAlbum.subFolder.length);
		var folderNames:StringMap<Dynamic> = new StringMap();
		var subFolders:Array<StringMap<Dynamic>> = new Array();
		for (s in currentAlbum.subFolder)
		{
			var sH:StringMap<Dynamic> = new StringMap();
			sH.set('name', s.name);
			var media:Array<Dynamic> = new Array();
			for (m in s.media)
			{
				media.push( { src:m } );
			}
			sH.set('media', media);
			subFolders.push(sH);
		}
		display.set('folders', subFolders);
		return display;
	}
		
	public function openAlbum(path:String, overwrite:Bool = false, name:String = null):Album
	{
		return new Album(this, path, overwrite, name);
	}
	
	public function upload():Void
	{
		App.errLog(Web.getParams());
		//App.errLog(Web.getMultipart(100000));
		new Upload(currentAlbum.path);
	}	
}


