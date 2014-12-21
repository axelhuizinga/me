package me.cunity.php.ming;

class SWFCharacter
{
	var _cName:String;
	public var _instance:Dynamic;

	/***METHODS***/
	public function new()
	{
		_cName = Type.getClassName(Type.getClass(this)).split('.').pop();
	}

	public function getWidth():Int
	{
		return untyped _instance.getWidth();
	}
	public function getHeight():Int
	{
		return untyped _instance.getHeight();
	}
}
