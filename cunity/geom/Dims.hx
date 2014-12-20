/**
 *
 * @author ...
 */

package me.cunity.geom;
import flash.display.DisplayObject;

class Dims
{

	var width:Float;
	var height:Float;
	public function new(?w:Float=0, ?h:Float = 0) 
	{
		width = w;
		height = h;		
	}
	
	public static function setRect(obj:DisplayObject, x:Float, y:Float, w:Float, h:Float) {
		obj.x = x;
		obj.y = y;
		obj.width = w;
		obj.height = h;
	}
	
}