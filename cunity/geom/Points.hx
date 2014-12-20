/**
 *
 * @author ...
 */

package me.cunity.geom;
import flash.geom.Point;

class Points
{	
	
	public static function getPoint(ob:Dynamic, loc:String):Point {
		//trace(loc + ':' + ob + ':' + ob.height);
		return switch(loc) {
			case 'bottomLeft':
			new Point(ob.x, ob.y + ob.height);
			case 'bottomRight':
			new Point(ob.x + ob.width, ob.y + ob.height);
			case 'topLeft':
			new Point(ob.x, ob.y);
			case 'topRight':
			new Point(ob.x + ob.width, ob.y);
			case 'center':
			new Point(ob.x + ob.width / 2, ob.y + ob.height / 2);
			case 'centerLeft':
			new Point(ob.x + ob.height / 2, ob.y + ob.height / 2);
			case 'centerRight':
			new Point(ob.x + ob.width - ob.height / 2, ob.y + ob.height / 2);
			case 'centerTop':
			new Point(ob.x + ob.width / 2, ob.y + ob.width / 2);
			case 'centerBottom':
			new Point(ob.x + ob.width / 2, ob.y + ob.height - ob.width / 2);
			default://center
			new Point(ob.x + ob.width / 2, ob.y + ob.height / 2);
		}
	}	
	
}