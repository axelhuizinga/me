package me.cunity.php.applet;
import haxe.io.Bytes;
import haxe.Json;
//import hxjson2.JSONEncoder;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import php.Lib;
import php.NativeArray;
import php.Web;

/**
 * ...
 * @author axel@cunity.me
 */

class Upload 
{
	
	var currentFilePath:String;
	var currentFileName:String;
	
	var output:FileOutput ;
	var filename:String;
	
	public function new(path:String = 'upload') 
	{
		currentFilePath = path;
		Web.parseMultipart(onPart, onData);
	}
	
	function onPart(name:String, ?fileName:String = ''):Void
	{
		App.errLog('name:' + name + ' fileName:' + fileName);
		if (null != output) output.close(); 
		currentFileName = fileName;
		output = File.write (currentFilePath + "/" + currentFileName, true);
	}
	
	function onData(b:Bytes, pos:Int, len:Int):Void
	{
		App.errLog('pos:' + pos + ' len:' + len);
		//currentFileName = (currentFileName != filename)?filename:currentFileName;
		output.write (b);
	}
	
	function onComplete(info:Dynamic):Void
	{
		/*     => name, => type => tmp_name => error  => size*/
		//var iH:Map<Dynamic> = Lib.hashOfAssociativeArray(Lib.associativeArrayOfObject(info));

		App.errLog('info:' + info.toString());
		//var encoder:JSONEncoder = new JSONEncoder(iH);
		Lib.print(Json.stringify(info));
	}
	
}