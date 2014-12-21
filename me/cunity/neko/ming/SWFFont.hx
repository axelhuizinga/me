package me.cunity.neko.ming;
import neko.Lib;

class SWFFont
{
	private static var _new;
	private static var _getAscent;
	private static var loaded:Bool = false;
	
	public var _instance:Dynamic;
	
	function init()
	{
		_new = Ming.load("newFont",1);
		_getAscent = Ming.load( "getAscent", 1);
		loaded = true;		
	}
	
	/***METHODS***/

	public function new(filename:String)
	{
		if (!loaded)
			init();
		_instance = _new(Lib.haxeToNeko(filename));
	}
	
	public function getWidth():Void;
	public function getUTF8Width():Void;
	
	public function getAscent():Float {
		return _getAscent(_instance);
	}
	
	public function getDescent():Void;
	public function getLeading():Void;
	public function getGlyphCount():Void;
	public function getName():Void;
	public function getShape():Void;
}
