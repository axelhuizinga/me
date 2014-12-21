package me.cunity.php.ming;

class SWFFont 
{
	public var _instance:Dynamic;
	/***METHODS***/

	public function new(file:String)
	{
		_instance = untyped __php__("new SWFFont($file)");
	}
	
	public function getWidth(string:String):Float
	{
		return _instance.getWidth(string);
	}
	
	public function getUTF8Width(string:String):Float
	{
		return _instance.getUTF8Width(string);
	}
	
	public function getAscent():Float
	{
		return _instance.getAscent();
	}
	
	public function getDescent():Float
	{
		return _instance.getDescent();
	}
	
	public function getLeading():Float
	{
		return _instance.getLeading();
	}
	
	public function getGlyphCount():Int
	{
		return _instance.getGlyphCount();
	}
	
	public function getName():String
	{
		return _instance.getName();
	}
	
	public function getShape(char:Int):String
	{
		return _instance.getShape(char);
	}
}
