package me.cunity.php.ming;

class SWFDisplayItem
{
	public var _instance:Dynamic;	
	/***METHODS***/
	public function new()
	{
	}
	
	public function move(dx:Float, dy:Float):Void
	{
		_instance.move(dx, dy);
	}	
	
	public function moveTo(x:Float, y:Float):Void
	{
		_instance.moveTo(x, y);
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
	/*

	public function setDepth(depth:Int):Void;
	public function setRatio(ratio:Float):Void;
	public function addColor(r:Int, g:Int, b:Int, ?a:Int):Void;
	public function multColor(r:Int, g:Int, b:Int, ?a:Int):Void;
	public function setName(name:String):Void;
	public function addAction(action:SWFAction):Void;
	public function remove():Void;
	public function setMaskLevel(level:Int):Void;
	public function endMask():Void;
	public function getX():Float;
	public function getY():Float;
	public function getXScale():Float;
	public function getYScale():Float;
	public function getXSkew():Float;
	public function getYSkew():Float;
	public function getRot():Float;
	public function cacheAsBitmap(cache:Bool):Void;
	public function setBlendMode(mode:Int):Void;
	public function getDepth():Int;
	public function flush():Void;
	public function addFilter(filter:SWFFilter):Void;
	public function setCXform(cx:SWFCXform):Void;
	public function getCharacter():SWFCharacter;
	*/
}
