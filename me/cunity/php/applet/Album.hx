package me.cunity.php.applet;

import haxe.ds.StringMap;
import me.cunity.debug.Out;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import php.Lib;
import php.Web;
import Xml;

import me.cunity.php.gd.ImageText;

/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

class Album extends Folder
{

	var parent:Album;

	static var server:StringMap<String>;

	
	public function new(app:IMediaServiceApi, path:String,  create:Bool = false, name:String = null) 
	{
		super(app, path, create);
		
		if (error != null)
		{
			app.debug(error);
		}
		else
		{
			app.debug(media.toString());
			app.debug('subFolder.length:' + subFolder.length);
		}
		
	}
	
	public function display():String
	{
		var d:String = '';
		return d;
	}
	
}

