/**
 *
 * @author Axel Huizinga
 */

package me.cunity.ui.mask;
import flash.display.GradientType;
import flash.geom.Matrix;
//import flash.MovieClip;
//import me.cunity.display.mask.Mask;

class Circle extends Mask
{

	var radius:Float;
	var softRadius:Float;
	var props:Dynamic;
	var cP:Float;

	public function new(cx:Float, cy:Float, cR:Float, ?soft:Float=.15, ?open:Bool = false ) 
	{
		super();
		trace('cR:' +cR + ' soft:' + soft + ' isSoft:' + Std.string(soft == 0));
		x = cx;
		y = cy;
		cP = cx>cy ? cx :cy;
		softRadius = soft * cR;
		radius = cR  + softRadius;
		trace(cx +',' + cy + ' r:' + radius + ' soft:' + softRadius);
		draw();
		if (!open) scaleX = scaleY = 0.0;
	}
	
	public override function draw() {
		//trace(radius);
		this.graphics.clear();
		if (softRadius == 0) {
			graphics.beginFill(0);		
			trace('solid');
		}
		else {
			trace('gradient');
			var m:Matrix = new Matrix();
			m.createGradientBox(radius * 2, radius * 2, 0, -radius,  -radius);
			graphics.beginGradientFill(GradientType.RADIAL, 
			//[0, 0, 0], [1,1,0],[0, 250, 255]);		
			//[0, 0, 0], [1,1,0],[0, 250, 255]);		
			[0, 0, 0], [1,1,0],[0, 255*1-softRadius, 255], m);		
		}
		graphics.drawCircle(0, 0, radius);
		//graphics.drawCircle(x, y, radius);
		trace(width + ' x ' + height + ' r:' + radius+ ' soft:' + softRadius);
		/*trace(radius);
		this.clear();
		beginFill(0);

		// move to x,y position
		this.moveTo(x+radius, y);
		// if radius is undefined, radius = radius

		// Init vars
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;

		var	arc:Int = 360;
		segs = Math.ceil(Math.abs(arc)/45);
		segAngle = arc/segs;
		theta = -(segAngle/180)*Math.PI;
		angle = -(0/180)*Math.PI;

		for ( i in 0...segs) {
			angle += theta;
			angleMid = angle-(theta/2);
			bx = x+Math.cos(angle)*radius;
			by = y+Math.sin(angle)*radius;
			cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
			cy = y+Math.sin(angleMid)*(radius/Math.cos(theta/2));
			this.curveTo(cx, cy, bx, by);
		}*/

	}
	
	
	
}