package me.cunity.neko.ming;
import neko.Lib;

class SWFShape extends SWFCharacter
{
	private static var _new;
	private static var _drawCircle;
	private static var _drawLine;
	private static var _drawLineto;
	private static var _setLine;	
	private static var loaded:Bool = false;
	
	function init()
	{
		_new = Ming.load("newShape",0);
		_drawCircle = Ming.load("drawCircle",2);
		_drawLine = Ming.load("drawLine",3);
		_drawLineto = Ming.load("drawLineTo",3);
		_setLine = Ming.load( "setLine", 2);
		loaded = true;
	}	
	
	/***METHODS***/

	public function new()
	{
		super();
		if (!loaded)
			init();
		_instance = _new();

	}
	
	public function setLine(width:Float, r:Int, g:Int, b:Int, a:Int = 255):Void
	{
		_setLine(_instance, Lib.haxeToNeko([width, r, g, b, a]));
	}
	
	public function drawLineTo(x:Int, y:Int):Void
	{
		_drawLineto(_instance, x, y);
	}
	
	public function drawLine(dx:Int, dy:Int):Void
	{
		_drawLine(_instance, dx, dy);	
	}
	
	/*public function addFill(fillOrRed:Dynamic, ?flagOrGreen:Int, ?blue:Int, alpha:Int = 255):SWFFill;
	public function setLeftFill(fill:SWFFill):Void;
	public function setRightFill(fill:SWFFill):Void;
	public function movePenTo(x:Int, y:Int):Void;
	public function movePen(dx:Int, dx:Int):Void;

	public function drawCurveTo():Void;
	public function drawCurve():Void;
	public function drawGlyph(char:String):Void;*/
	
	public function drawCircle(radius:Int):Void
	{
		_drawCircle(_instance, radius);
	}
	/*public function drawArc():Void;
	public function drawCubic():Void;
	public function drawCubicTo():Void;
	public function end():Void;
	public function useVersion(version:Int):Void;
	public function setRenderHintingFlags():Void;
	public function getPenX():Int;
	public function getPenY():Int;
	public function hideLine():Void;
	public function drawCharacterBounds():Void;
	//public function setLine2():Void;
	//public function setLine2Filled():Void;
	public function dumpOutline():Void;*/
}
