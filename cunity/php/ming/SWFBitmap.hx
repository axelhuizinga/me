package me.cunity.php.ming;

class SWFBitmap extends SWFCharacter
{	
	/***METHODS***/

	public function new(path:String)
	{
		super();
		_instance = untyped __php__("new SWFBitmap(fopen($path, 'rb'))");
	}
	/*public function getWidth():Int;
	public function getHeight():Int;*/
}
