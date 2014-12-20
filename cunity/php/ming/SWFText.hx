package me.cunity.php.ming;

class SWFText
{
	public var _instance:Dynamic;
	/***METHODS***/

	public function new()
	{
		_instance = untyped __php__("new SWFText()");
	}
	
	public function setFont(font:SWFFont):Void
	{
		_instance.setFont(font._instance);
	}
	
	public function setHeight(height:Float):Void
	{
		_instance.setHeight(height);
	}
	
	public function setSpacing(spacing:Float):Void
	{
		_instance.setSpacing(spacing);
	}
	
	public function setColor(r:Int, g:Int, b:Int, a:Int = 255):Void
	{
		_instance.setColor(r, g, b, a);
	}
	
	public function moveTo(x:Float, y:Float):Void
	{
		_instance.moveTo(x, y);
	}
	
	public function addString(string:String):Void
	{
		_instance.addString(string);
	}
	
	public function addUTF8String(string:String):Void
	{
		_instance.addUTF8String(string);
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
}
