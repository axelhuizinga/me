package me.cunity.neko.ming;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesData;
//import haxe.io.Unsigned_char__;
import neko.io.File;
import neko.Lib;
import neko.io.FileOutput;

class SWFMovie extends SWFSprite
{
	/***METHODS***/
	
	private static var _new;
	private static var _add;
	private static var _addMore;
	private static var _addExport;
	private static var _addFont;
	private static var _writeExports;
	private static var _movieSave;
	private static var _movieBytes;
	private static var _nextFrame;
	private static var _output;
	private static var _setDimension;
	private static var _movieString;
	private static var loaded:Bool = false;
	
	override function init()
	{
		_new = Ming.load("newMovie", 0);
		_add = Ming.load("movieAdd",2);
		_addMore = Ming.load("movieAddMore",3);
		_addExport = Ming.load("movieAddExport",3);
		_addFont = Ming.load("addFont",2);
		_writeExports = Ming.load("movieWriteExports",1);
		_movieSave = Ming.load("movieSave", 2);
		#if neko
		_movieBytes = Ming.load("movieBytes", 1);
		#else
		_movieBytes = Ming.load("movieBytes", 2);
		#end
		_movieString= Ming.load("movieString",1);
		_nextFrame = Ming.load("movieNextFrame",1);
		_output = Ming.load( "output", 1);
		_setDimension = Ming.load( "movieSetDimension", 3);		
		loaded = true;
	}
	
	public function new()
	{ 
		super();
		if (!loaded)
			init();
		_instance = _new();
		
	}
	override public function nextFrame():Void
	{
		_nextFrame(_instance);
	}
	//public function labelFrame(label:String):Void;
	override public function add(character:SWFCharacter):SWFDisplayItem
	{
		var di:SWFDisplayItem = new SWFDisplayItem();
		//di._instance = Lib.nekoToHaxe(_add(_instance, character._instance));
		di._instance =  _add(_instance, character._instance);
		////Ming.log(Std.string(di));
		return di;
	}
	
	public function addMore(character:SWFCharacter, times:Int):Array<SWFDisplayItem>
	{
		var dis:Array<SWFDisplayItem> = new Array();
		var added:Dynamic =  _addMore(_instance, character._instance, times);
		////Ming.log(Std.string(added));
		//Ming.log('len:' + untyped added.length);
		return added;
		var items:Array<Dynamic> =  Lib.nekoToHaxe(added);
		for (item in items)
		{
			var d:SWFDisplayItem = new SWFDisplayItem();
			d._instance = item;	
			dis.push(d);
		}
		return dis;
	}
	
	//public function remove(displayObject:Dynamic):Void;
	public function output():Int
	{
		try
		{
			//File.stdout().writeString('Content-type', 'application/x-shockwave-flash');
		}
		catch (ex:Dynamic)
		{
			File.stderr().writeString(ex);
		}
		//var mS:Array<Int> = Lib.nekoToHaxe(_movieBytes(_instance));
		//Lib.print(mS.toString());
		return _output(_instance);
		//return 0;
	}
	
	public function save(file:Dynamic):Int
	{
		return _movieSave(_instance, file);
	}
	
	public function setDimension(width:Float, height:Float):Void
	{
		_setDimension(_instance, width, height);
	}
	
	/*
	public function setBackground(r:Int, g:Int, b:Int):Void;
	public function setRate(rate:Float):Void;

	public function streamMP3(mp3:Dynamic):Void;

	*/

	//public function importChar(libswf:String , name:String):Void;
	//public function importFont(libswf:String , name:String):Void;
	
	public function addFont(font:SWFFont):SWFFontChar
	{
		var fc:SWFFontChar = new SWFFontChar();
		fc._instance = _addFont(_instance, font._instance);
		return fc;
	}
	
	public function addExport(character:SWFCharacter, name:String):Void
	{
		_addExport(_instance, character._instance, Lib.haxeToNeko(name));
	}
	
	public function writeExports():Void
	{
		_writeExports(_instance);
	}

	public function getBytes():Bytes
	{
		#if neko
		var mS:Array<Int> = Lib.nekoToHaxe(_movieBytes(_instance));
		var bytes:Bytes =  haxe.io.Bytes.alloc(mS.length);
		var i=0;
		for(byte in mS)
			bytes.set(i++, byte);		
		return bytes;
		#else
		return _movieBytes(_instance, Bytes);
		#end
		return null;
	}
	
	public function toString():String
	{
		return Lib.nekoToHaxe(_movieString(_instance));
	}
	
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
