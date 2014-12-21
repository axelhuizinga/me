package me.cunity.php.applet;
import me.cunity.debug.Out;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import php.Lib;
import php.Web;
import Xml;

/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

class Folder 
{
	public var subFolder:Array<Folder>;
	public var error:String;
	public var info:Xml;
	public var name:String;
	public var media:Array<String>;	
	public var path:String;
	var application:IMediaServiceApi;
	//public static var '/' :String =  '/';
	
	public function new(app:IMediaServiceApi, path:String, create:Bool = false, name:String = null) 
	{
		application = app;
		this.name = name == null ?  new Path(path).file :name;		
		media = new Array();		
		subFolder = new Array();	
		this.path = path;
		if (create && !FileSystem.isDirectory(path))
		{
			if (!ensureDir(path))
			{
				error = "Couldn't create" + path;
				return;
			}
		}
		var dir:Array<String> = FileSystem.readDirectory(path);
		application.debug('folder content count:' + dir.length);
		for (el in dir)
		{
			if (el == 'info.xml')
			{				
				info = Xml.parse(File.getContent(path + '/' + el));
				//trace(path + '/' + el + ' xml:<br/><textarea rows="20" cols="100">' + info.toString() + '</textarea>');
				continue;
			}
			if (FileSystem.isDirectory(path + '/' + el))
			{
				subFolder.push(new Folder(application, path + '/' + el));
				continue;
			}
			media.push(el);	
		}
	}
	
	function create(path:String):Bool
	{		
		if (FileSystem.exists(path))		
			return true;			
		else
		{
			FileSystem.createDirectory(path);
			return true;			
		}
	}
	
	public function delete(overwrite:Bool = false):Bool
	{		
		if (FileSystem.exists(path) )
		{
			FileSystem.deleteDirectory(path);
			return true;
		}		
		return false;
	}	
	
	public function addFolder(name:String):Bool
	{
		if (FileSystem.exists(path + '/' + name) )
		{
			return true;
		}
		else
		{
			FileSystem.createDirectory(path);
			return true;			
		}			
		return false;		
	}
	
	public function move(to:String, overwrite:Bool = false):Bool
	{
		if (FileSystem.exists(to) )
		{
			if (!overwrite)
			{				
				//be careful - this will overwrite any media with the same name
				//inside of the existing folder
				return false;
			}
		}
		else
		{

			if (!ensureDir(path))					
				return false;			
		}	
		if (copy(to, overwrite))
		{//success - delete old folder
			deleteDirRekursive(path);
			path = to;
		}
		return true;
	}

	public function copy(to:String, overwrite:Bool):Bool
	{
		//trace('copy to:' + to);
		for (el in media)
		{
			File.copy(path + '/' + el, to + '/' + el);
			if (FileSystem.stat(path + '/' + el).size != FileSystem.stat(to + '/' + el).size)
				return false;
		}
		if (info != null)
		{			
			File.copy(path + '/info.xml', to + '/info.xml');
			if (FileSystem.stat(path + '/info.xml').size != FileSystem.stat(to + '/info.xml').size)			
				return false;			
		}		
		for (el in subFolder)
		{
			var eR:EReg = new EReg('^' + path, null);
			var sTo:String = to + eR.replace(el.path, '');			
			if (!el.copy(sTo, overwrite))
			{				
				return false;
				el.path = sTo;
			}
		}
		return true;
	}
	
	public function ensureDir(APath:String):Bool 
	{        
		//trace(APath);
		if (APath == null)
			return false;
        try 
		{            
            if (! FileSystem.exists(APath)) 
			{
               return untyped __call__("mkdir", APath, 0, true);
            }
			else
				return true;
        } 
		catch (e:Dynamic) 
		{
			application.debug(e);
			//MediaService.errLog(e);
            return false;
        }
    }
	
	public static function deleteDirRekursive(path:String):Bool
	{
		var content = FileSystem.readDirectory(path);
		for (el in content)
		{
			if (FileSystem.isDirectory(path + '/' + el))
			{				
				if (!deleteDirRekursive(path + '/' + el))
					return false;
				continue;
			}
			FileSystem.deleteFile(path + '/' + el);	
		}
		FileSystem.deleteDirectory(path);
		return true;
	}
}