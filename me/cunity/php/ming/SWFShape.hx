package me.cunity.php.ming;


class SWFShape extends SWFCharacter
{
	
	/***METHODS***/

	public function new()
	{
		super();
		_instance = untyped __php__("new SWFShape()");
	}
	
	public function setLine(width:Float, r:Int, g:Int, b:Int, a:Int = 255):Void
	{
		_instance.setLine(width, r, g, b, a);
	}
	
	public function addFill(fillOrRed:Dynamic, ?flagsOrGreen:Int, ?blue:Int, alpha:Int = 255):SWFFill
	{
		var fill:SWFFill = new SWFFill();
		
		fill._instance = (Std.is(fillOrRed, Int) ?
			_instance.addFill(fillOrRed, flagsOrGreen, blue, alpha):
			_instance.addFill(fillOrRed._instance, flagsOrGreen));
		
		return fill;
	}
	
	public function setLeftFill(fill:SWFFill):Void
	{
		_instance.setLeftFill(fill._instance);
	}
	
	public function setRightFill(fill:SWFFill):Void
	{
		_instance.setRightFill(fill._instance);
	}
	
	public function movePenTo(x:Int, y:Int):Void
	{
		_instance.movePenTo(x,y);
	}
	
	public function movePen(dx:Int, dy:Int):Void
	{
		_instance.movePen(dx, dy);
	}
	
	public function drawLineTo(x:Int, y:Int):Void
	{
		_instance.drawLineTo(x, y);
	}
	
	public function drawLine(dx:Int, dy:Int):Void
	{
		_instance.drawLine(dx, dy);
	}
	
	public function drawCurveTo(
		controlx:Float, controly:Float, anchorx:Float, anchory:Float, ?targetx:Float, ?targety:Float):Void
	{
		if(targetx == null)
			_instance.drawCurveTo(controlx, controly, anchorx, anchory);
		else
			_instance.drawCurveTo(controlx, controly, anchorx, anchory, targetx, targety);		
	}
	
	public function drawCurve(
		controldx:Float, controldy:Float, anchordx:Float, anchordy:Float, ?targetdx:Float, ?targetdy:Float):Void
	{
		if(targetdx == null)
			_instance.drawCurveTo(controldx, controldy, anchordx, anchordy);
		else
			_instance.drawCurveTo(controldx, controldy, anchordx, anchordy, targetdx, targetdy);
	}
	
	public function drawGlyph(char:String):Void
	{
		_instance.drawGlyph(char);
	}
	
	public function drawCircle(radius:Int):Void
	{
		_instance.drawCircle(radius);
	}
	
	public function drawArc(r:Float, startAngle:Float, endAngle:Float):Void
	{
		_instance.drawArc(r, startAngle, endAngle);
	}
	
	public function drawCubic(bx:Float, by:Float, cx:Float, cy:Float, dx:Float, dy:Float ):Void
	{//relative to current pen position
		_instance.drawCubic(bx, by, cx, cy, dx, dy);
	}
	
	public function drawCubicTo(bx:Float, by:Float, cx:Float, cy:Float, dx:Float, dy:Float):Void
	{
		_instance.drawCubicTo(bx, by, cx, cy, dx, dy);
	}
	
	public function end():Void
	{
		_instance.end();
	}
	
	public function getVersion():Int
	{
		return _instance.getVersion();
	}
	
	public function useVersion(version:Int):Void
	{
		_instance.useVersion(version);
	}
	
	public function setRenderHintingFlags(flags:Int):Void
	{//Possible values:SWF_SHAPE_USESCALINGSTROKES SWF_SHAPE_USENONSCALINGSTROKES
		_instance.setRenderHintingFlags(flags);
	}
	public function getPenX():Int
	{
		return _instance.getPenX();
	}
	
	public function getPenY():Int
	{
		return _instance.getPenY();
	}
	
	public function hideLine():Void
	{
		_instance.hideLine();
	}
	
	public function drawCharacterBounds(character:SWFCharacter):Void
	{
		_instance.drawCharacterBounds(character);
	}
	
	/*
 * set Linestyle2 introduce with SWF 8.
 *
 * set line width in TWIPS
 * WARNING:this is an internal interface
 * external use is deprecated! use setLine2 instead !
 * set color {r, g, b, a}
 *
 * Linestyle2 extends Linestyle1 with some extra flags:
 *
 * Line cap style:select one of the following flags (default is round cap style)
 * SWF_LINESTYLE_CAP_ROUND 
 * SWF_LINESTYLE_CAP_NONE
 * SWF_LINESTYLE_CAP_SQUARE 
 *
 * Line join style:select one of the following flags (default is round join style)
 * SWF_LINESTYLE_JOIN_ROUND
 * SWF_LINESTYLE_JOIN_BEVEL 
 * SWF_LINESTYLE_JOIN_MITER  
 *
 * Scaling flags:disable horizontal / vertical scaling
 * SWF_LINESTYLE_FLAG_NOHSCALE
 * SWF_LINESTYLE_FLAG_NOVSCALE 
 *
 * Enable pixel hinting to correct blurry vertical / horizontal lines
 * -> all anchors will be aligned to full pixels
 * SWF_LINESTYLE_FLAG_HINTING  
 *
 * Disable stroke closure:if no-close flag is set caps will be applied 
 * instead of joins
 * SWF_LINESTYLE_FLAG_NOCLOSE
 *
 * End-cap style:default round
 * SWF_LINESTYLE_FLAG_ENDCAP_ROUND
 * SWF_LINESTYLE_FLAG_ENDCAP_NONE
 * SWF_LINESTYLE_FLAG_ENDCAP_SQUARE
 *
 * If join style is SWF_LINESTYLE_JOIN_MITER a miter limit factor 
 * must be set. Miter max length is then calculated as:
 * max miter len = miter limit * width.
 * If join style is not miter, this value will be ignored.
 */

	public function setLine2(width:Float, flags:Int, miterLimit:Float, r:Int, g:Int, b:Int, a=255 ):Void
	{
		_instance.setLine2(width, flags, miterLimit, r, g, b, a);
	}
	
	public function setLine2Filled(width:Float, fill:SWFFill, flags:Int, miterLimit:Float):Void
	{
		_instance.setLine2Filled(width, fill._instance, flags, miterLimit);
	}
	
	public function dumpOutline():String
	{
		return _instance.dumpOutline();
	}
}
