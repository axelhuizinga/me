/**
 *
 * @author ...
 */

package me.cunity.geom;
import me.cunity.debug.Out;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Point;

class Rotate 
{
	public static function rotateWithNewOrigin(ob:DisplayObject, angleDegrees:Float, newOrigin:Point){
		//Out.dumpLayout(ob, false);
		//trace(ob +  ':' + Std.string(newOrigin));
		var m:Matrix = ob.transform.matrix;	
		m.rotate (angleDegrees * (Math.PI / 180));
		newOrigin = m.transformPoint(newOrigin);	
		//trace(Std.string(newOrigin));
		m.tx -= newOrigin.x ;
		m.ty -= newOrigin.y ;		
		ob.transform.matrix = m;
		//Out.dumpLayout(ob);
	}

	public static function rotateAroundPoint(ob:DisplayObject, angleDegrees:Float, ptRotationPoint:Point){
		//Out.dumpLayout(ob, false);
		//trace(ob + ':' + Std.string(ptRotationPoint) );
		var m:Matrix = ob.transform.matrix;
		m.tx -= ptRotationPoint.x;
		m.ty -= ptRotationPoint.y;
		m.rotate (angleDegrees * (Math.PI / 180));
		m.tx += ptRotationPoint.x;
		m.ty += ptRotationPoint.y;	
		ob.transform.matrix = m;
	}
	
	public static function rotateDOb(ob:DisplayObject, dir:String) {
		var m:Matrix = ob.transform.matrix;
		//trace(Std.string(m));
		trace(ob + ':' + ob.width + ' x ' + ob.height);
		//Out.dumpLayout(ob);
		switch(dir) {
			case 'up':
			//
			//m.rotate ( -90 * (Math.PI / 180));			
			m.rotate ( -45 * (Math.PI / 180));			
			//m.rotate ( -90 * (Math.PI / 180));			
			m.translate(0, ob.width);			
		}
		ob.transform.matrix = m;
		//ob.visible = false;
		//Out.dumpLayout(ob);
		//trace(ob.y);
		//trace(Std.string(m));
	}
	

	
	
}