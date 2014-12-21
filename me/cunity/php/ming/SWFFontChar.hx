package me.cunity.php.ming;

class SWFFontChar
{
	public var _instance:Dynamic;
	/***METHODS***/

	public function new()
	{
		
	}
	
	public function addChars(chars:String):Void
	{
		_instance.addChars(chars);
	}
	
	public function addUTF8Chars(chars:String):Void
	{
		_instance.addUTF8Chars(chars);
	}
	
	public function addAllChars():Void
	{
		_instance.addAllChars();
	}
}
