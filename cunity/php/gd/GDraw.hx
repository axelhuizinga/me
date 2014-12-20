package me.cunity.php.gd;
import me.cunity.debug.Out;
import php.Lib;
import php.Web;

import me.cunity.php.gd.ImageText;

/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

class GDraw 
{

	var params:Map<String>;
	
	static var actions:Map<Dynamic>;
    static var instance :GDraw; 
	
	static function main() 
	{ 
		if (Web.getParams().get('debug') == '1')
		{
			untyped __php__("ini_set('display_errors', 1);");
			Web.setHeader('Content-type', 'text/plain');
			untyped __php__("
				function userErrorHandler($errno, $errmsg, $filename, $linenum, $vars)
				{
					echo(\"$filename:$linenum:$errmsg <br>\");
					#print_r($GLOBALS['%s']);
				}
				$old_error_handler = set_error_handler('userErrorHandler');
			");
		}
		else
			Out.init();
		instance = new GDraw(); 

		// create an incoming connection and give access to the "instance" object 
		var context = new haxe.remoting.Context(); 
		context.addObject("api",instance); 
		haxe.remoting.HttpConnection.handleRequest(context); 

	} 	
	
	public function new() 
	{
		if (Web.getParams().exists('do'))
		{
			try {
				draw();		
			}
			catch (ex:Dynamic) {
				//trace(ex);
				Lib.print("<pre>" + Std.string(ex));
				//untyped __call__("print_r", GLOBALS['%s']);
				untyped __php__("print_r($GLOBALS['%s'])");
				Lib.print("</pre>");
				trace( 'ooops');
			}			
			
		}
	}
	
	public function draw(p:Map<String>=null)
	{
		#if php
		params = p==null ? Web.getParams():p;
		switch(params.get('do'))
		{
			case 'ImageText':
				Out.dumpVar(params);
				new  ImageText();
				var fontColor:String = params.get('fontColor');
				var fontName:String = params.get('fontName');
				var fontSize:Int = params.exists('fontSize') ? Std.parseInt(params.get('fontSize')) :null;
				var tImage:ImageText = new ImageText();
				tImage.imageSettings(
					params.get('text'),
					params.exists('fontSize') ? Std.parseInt(params.get('fontSize')) :null,
					fontName, fontColor);
				tImage.makeImage(OutputMethod.show);
				
			/*$authKey	= isset($_GET['a'])		? $_GET['a']:'';
			$timg->authSign($authKey);
			*/				
		}		
		#end
	}
	
}

