package me.cunity.php.ming;

class SWFFill
{
	public var _instance:Dynamic;
	
	/***METHODS***/

	public function new()
	{
		
	}
	public function moveTo(x:Float, y:Float):Void
	{
		_instance.moveTo(x, y);
	}
	
	public function move(dx:Float, ?dy:Float):Void
	{
		_instance.move(dx, dy);
	}
	
	public function scaleTo(x:Float, ?y:Float):Void
	{
		_instance.scaleTo(x, y==null ? x :y);
	}
	
	public function scale(dx:Float, ?dy:Float):Void
	{
		_instance.scale(dx, dy==null ? dx :dy);
	}
	
	public function rotateTo(angle:Float):Void
	{
		_instance.rotateTo(angle);
	}
	
	public function rotate(dAngle:Float):Void
	{
		_instance.rotate(dAngle);
	}
	
	public function skewXTo(angle:Float):Void
	{
		_instance.skewXTo(angle);
	}
	
	public function skewX(dAngle:Float):Void
	{
		_instance.skewX(dAngle);
	}
	
	public function skewYTo(angle:Float):Void
	{
		_instance.skewYTo(angle);
	}
	
	public function skewY(dAngle:Float):Void
	{
		_instance.skewY(dAngle);
	}
	
	public function setMatrix(a:Float, b:Float, c:Float, d:Float, x:Float, y:Float ):Void
	{
		_instance.setMatrix(a, b, c, d, x, y);
	}
}
