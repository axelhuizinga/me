/**
 *
 * @author Axel Huizinga
 */

package me.cunity.display.mask;
import flash.MovieClip;
//import me.cunity.display.mask.Mask;

class Clock extends Mask
//class Clock extends MovieClip
{
	var x:Float;
	var y:Float;
	var startAngle:Float;
	public var arc:Float;
	var radius:Float;
	var yRadius:Float;
	var props:Dynamic;
	
	public function new() 
	{
		super();
		
		trace(props);
		//this.lineTo(100,100);
		//draw();
		trace(x +',' +y);
	}
	
	public function setStartAngle(sA:Float) {
		startAngle = sA;
	}
	
	public function setArc(aA:Float) {
		arc = aA;
	}
	/*
function masktweenclock($dur){
	global $mWidth,	$mHeight;
	$w=$mWidth; $h=$mHeight; 
	$dur=($dur)-2;
	$sprite = new SWFSprite();	
	$cnt=0;
	while($cnt++<$dur){
		if($cnt>1){ $sprite->remove($f1); }
		$inc=easeInOutQuad ($cnt, 0, 360, $dur);
		$shape = new SWFShape(); 
		$r = $w > $h ? $h :$w;
		drawWedge ($shape,0,"cccccc","ff0000",0,0,0,$inc, $r);
		$f1=$sprite->add($shape);
		$f1->moveto($w/2,$h/2);
		$sprite->nextframe();
	}
	return $sprite;
}*/
	
	//function drawWedge(x:Float, y:Float, startAngle:Float, arc:Float, radius:Float, yRadius:Float) {
	function draw() {
		// ==============
		// mc.drawWedge() - by Ric Ewing (ric@formequalsfunction.com) - version 1.3 - 6.12.2002
		//
		// x, y = center point of the wedge.
		// startAngle = starting angle in degrees.
		// arc = sweep of the wedge. Negative values draw clockwise.
		// radius = radius of wedge. If [optional] yRadius is defined, then radius is the x radius.
		// yRadius = [optional] y radius for wedge.
		// ==============
		// Thanks to:Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
		// ==============
		//trace(x +',' +y);
		this.clear();
		if (props.Line != null) {
			lineStyle(props.Line.thickness, props.Line.color, props.Line.alpha);
			trace('lineStyle:' + props.Line.thickness + ', ' +  props.Line.color +', ' + props.Line.alpha);
		}
		if (props.SolidFill != null) {
			beginFill(props.SolidFill.color, props.SolidFill.alpha);
		}
		// move to x,y position
		this.moveTo(x, y);
		// if yRadius is undefined, yRadius = radius
		if (yRadius == null) {
			yRadius = radius;
		}
		// Init vars
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		// limit sweep to reasonable numbers
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment.
		segAngle = arc/segs;
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
			theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		// draw the curve in segments no larger than 45 degrees.
		if (segs>0) {
			// draw a line from the center to the start of the curve
			ax = x+Math.cos(startAngle/180*Math.PI)*radius;
			ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;
			this.lineTo(ax, ay);
			//trace('lineTo:' + ax +',' +ay);
			// Loop for drawing curve segments
			for ( i in 0...segs) {
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*radius;
				by = y+Math.sin(angle)*yRadius;
				cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
				this.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center
			this.lineTo(x, y);
		}
	}
		
}