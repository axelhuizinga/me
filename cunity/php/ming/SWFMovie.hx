package me.cunity.php.ming;
import haxe.io.Bytes;
import me.cunity.php.classes.ReflectionClass;
import sys.io.File;
import php.Lib;
import php.Web;
import sys.io.FileOutput;

class SWFMovie extends SWFSprite
//class SWFMovie extends SWFCharacter
{
	//public var _instance:me.cunity.php.ext.ming.SWFMovie;
	
	/***METHODS***/	
	
	public function new()
	{ 
		super();
		_instance = untyped __php__("new SWFMovie()");
		//untyped __php__("$_instance = new SWFMovie();");
		if(_instance!= null)
		Ming.log(Type.typeof(this) + '._instance:' + new ReflectionClass(_instance).getName());
		
	}
	
	/*public function add(character:SWFCharacter):SWFDisplayItem
	{
		var di:SWFDisplayItem = new SWFDisplayItem();
		di._instance = untyped __php__("$_instance->add($character->_instance);");
		Ming.log(Std.string(di));
		return di;
	}
	
	public function remove(object:SWFCharacter):Void
	{
		
	}
	
	public function nextFrame():Void
	{
		untyped __php__("$_instance->nextFrame();");
	}*/
 
	public function output():Int
	{
		try
		{
			//Web.setHeader('Content-type', 'application/x-shockwave-flash');
			Ming.log(new ReflectionClass(_instance).getName());
		}
		catch (ex:Dynamic)
		{
			Ming.log(ex);
		}
		//return cast(untyped __php__("$_instance->output();"), Int);
		return _instance.output();
	}
	
	public function saveToFile(filehandle:FileHandle, compression:Int):Int
	{
		return _instance.saveToFile(filehandle, compression);
	}
	
	public function save(filenameOrHandle:Dynamic, ?compression:Int):Int
	{
		return _instance.save(filenameOrHandle);
	}
	
	public function setBackground(r:Int, g:Int, b:Int):Void
	{
		_instance.setBackground(r, g, b);
	}
	
	public function setRate(rate:Float):Void
	{
		_instance.setRate(rate);
	}
	
	public function setDimension(width:Float, height:Float):Void
	{
		_instance.setDimension(width, height);
	}
/*
	public function streamMP3(mp3:Dynamic):Void;

	*/

	//public function importChar(libswf:String , name:String):Void;
	//public function importFont(libswf:String , name:String):Void;
	public function addFont(font:SWFFont):SWFFontChar
	{
		var fontChar:SWFFontChar = new SWFFontChar();
		fontChar._instance = _instance.addFont(font._instance);
		return fontChar;
	}
	
	public function addExport(character:Dynamic, name:String):Void
	{
		_instance.addExport(character._instance, name);
	}
	
	public function writeExports():Void
	{
		_instance.writeExports();
	}
/*
	
	//public function protect():Void;
	/*public function addMetadata(xml:String):Void;
	public function setNetworkAccess(flag:Int):Void;
	public function setScriptLimits(maxRecursion:Int, timeout:Int):Void;
	public function setTabIndex(depth:Int, index:Int):Void;
	public function assignSymbol(character:Dynamic, name:String):Void;
	public function defineScene(offset:Int, name:String):Void;
	public function namedAnchor():Void;
	public function replace():Void;
	public function getRate():Float;*/

}
