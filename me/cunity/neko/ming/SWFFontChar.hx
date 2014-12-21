package me.cunity.neko.ming;
import neko.Lib;

class SWFFontChar extends SWFCharacter
{
	//private static var _addUTF8Chars = neko.Lib.load("cffi/libMing", "addUTF8Chars", 2);
	
	//public var _instance:Dynamic;
	
	/***METHODS***/
	public function new()	
	{	
		super();
	}
	
	public function addChars():Void;
	
	public function addUTF8Chars(chars:String):Void
	{
		//_addUTF8Chars(_instance, Lib.haxeToNeko(chars));
	}
	
	public function addAllChars():Void;
}
