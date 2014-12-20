package me.cunity.neko.ming;

class SWFDisplayItem extends SWFCharacter
{
	private static var _moveTo;
	private static var _move;
	private static var _scaleTo;
	private static var _getPosition;
	private static var _getScaleXY;
	private static var loaded:Bool = false;
	
	function init()
	{
		_moveTo = Ming.load("SWFDisplayItemMoveTo", 3);
		_move = Ming.load( "SWFDisplayItemMove", 3);
		_scaleTo = Ming.load( "SWFDisplayItemScaleTo", 3);
		_getPosition = Ming.load( "SWFDisplayItemGetPosition", 3);
		_getScaleXY = Ming.load( "SWFDisplayItemGetXYScale", 3);
		loaded = true;
	}
	
	/***METHODS***/
	public function new()
	{
		super();
		if (!loaded)
			init();		
	}
	
	public function move(dx:Float, dy:Float):Void
	{
		//trace(untyped __dollar__getkind(_instance) + ':' + dx + ', ' + dy);
		_move(_instance, dx, dy);
	}	
	
	public function moveTo(x:Float, y:Float):Void
	{
		_moveTo(_instance, x, y);
	}
	
	public function scaleTo(xScale:Float, ?yScale:Float):Void
	{
		_scaleTo(_instance, xScale, yScale);
	}
	
	public function scale(dx:Float, ?dy:Float):Void
	{
		//;
	}
	
	function getXYScale(scale:{xScale:Float, yScale:Float}):Void
	{
		_getScaleXY(_instance, scale.xScale, scale.yScale);
	}
	
	public function getXScale():Float
	{
		var sc:{ xScale:Float, yScale:Float } = { xScale:0.0, yScale:0.0 };
		getXYScale( sc );
		return sc.xScale;
	}
	
	public function getYScale():Float
	{
		var sc:{ xScale:Float, yScale:Float } = { xScale:0.0, yScale:0.0 };
		getXYScale( sc );
		return sc.yScale;
	}
	
	function getPosition(pos:{ x:Float, y:Float })
	{
		_getPosition(_instance, pos.x, pos.y);
	}
	
	public function getX():Float
	{
		var pos = { x:0.0, y:0.0 };
		getPosition(pos);
		return pos.x;
	}
	
	public function getY():Float
	{
		var pos = { x:0.0, y:0.0 };
		getPosition(pos);
		return pos.y;
	}
	
	/*public function rotateTo(angle:Float):Void;
	public function rotate(angle:Float):Void;
	public function skewXTo(degrees:Float):Void;
	public function skewX(degrees:Float):Void;
	public function skewYTo(degrees:Float):Void;
	public function skewY(degrees:Float):Void;
	public function setMatrix(a:Float, b:Float, c:Float, d:Float, x:Float, y:Float):Void;
	public function setDepth(depth:Int):Void;
	public function setRatio(ratio:Float):Void;
	public function addColor(r:Int, g:Int, b:Int, ?a:Int):Void;
	public function multColor(r:Int, g:Int, b:Int, ?a:Int):Void;
	public function setName(name:String):Void;
	public function addAction(action:SWFAction):Void;
	public function remove():Void;
	public function setMaskLevel(level:Int):Void;
	public function endMask():Void;


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
