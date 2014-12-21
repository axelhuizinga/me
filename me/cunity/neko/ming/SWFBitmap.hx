package me.cunity.neko.ming;
import neko.FileSystem;
import neko.io.File;
import neko.Lib;

class SWFBitmap extends SWFCharacter
{
	private static var _new;
	private static var _getWidth;
	private static var _getHeight;
	
	private static var loaded:Bool = false;
	
	function init()
	{
		_new = neko.Lib.load("libMing", "newBitmap", -1);
		_getWidth = neko.Lib.load("libMing", "getBitmapWidth", 1);
		_getHeight = neko.Lib.load("libMing", "getBitmapHeight", 1);
	}
	
	/***METHODS***/

	public function new(file:Dynamic)
	{
		super();
		if (!loaded)
			init();
		//Ming.log(Std.is(file, String) ? 'is String' :'is resource');
		_instance = _new(file);//alpha mask not yet implemented
	}
	
	public function getWidth():Int
	{
		return _getWidth(_instance);
	}
	
	public function getHeight():Int
	{
		return _getHeight(_instance);
	}
}
