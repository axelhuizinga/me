package me.cunity.graphics; 
	
import flash.geom.Point;
	
	/**
	* The Path class saves a collection of line drawing commands to represent a path.
	* Using the path class you can draw all of or a segment of that path in a movie clip
	* or get locations and orientations along the path to have objects follow it.
	*
	* Note:People using Flash MX 2004 will have to use a custom flash.geom.Point class
	* 
	* @usage
	* <pre><code>import com.senocular.drawing.Path;
	* // create a path instance that draws in _root
	* var myPath:Path = new Path();
	* // draw a square in the path
	* myPath.moveTo(50, 50);
	* myPath.lineTo(100, 50);
	* myPath.lineTo(100, 100);
	* myPath.lineTo(50, 100);
	* myPath.lineTo(50, 50);
	* // draw the path in _root
	* graphics.lineStyle(0, 0, 100);
	* myPath.draw(graphics);
	* </code></pre>
	* @author Trevor McCauley, senocular.com
	* @version 2.2.0
	 */
	class Path  {
		
		public var length(getLength, null) :Float ;
		public var moveToHasLength(getMoveToHasLength, setMoveToHasLength) :Bool;
		public var position(getPosition, setPosition) :Point;
		var _lengthValid:Bool ;
		var _length:Int ;
		var _moveToHasLength:Bool ;
		var _position:Point;
		var _segments:Array<Dynamic>;

		// Constructor
		/**
		 * Constructor. Creates a new path instance
		 */
		public function new(){
			
			_lengthValid = true;
			_length = 0;
			_moveToHasLength = false;
			init();
		}
		
		// Public Properties
		/**
		 * The approximate length of the total path in pixels. 
		 * @see moveToHasLength
		 */
		public function getLength():Float {
			if (!_lengthValid) {
				_lengthValid = true;
				_length = 0;
				var seg:PathSegment;
				var i:Int = _segments.length;
				while (i--){
					seg = _segments[i];
					if (_moveToHasLength || !(Std.is( seg, PathMoveSegment))){
						_length += seg.length;
					}
				}
			}
			return _length;
		}
		/**
		 * Determines whether or not moveTo commands are treated
		 * as line segments therefore adding to the total length of the path
		 * @see length
		 */
		public function getMoveToHasLength():Bool{
			return _moveToHasLength;
		}
		public function setMoveToHasLength(b:Bool):Bool{
			_lengthValid = false;
			_moveToHasLength = b;
			return b;
		}
		/**
		 * The current position of the drawing pen based on the last drawing command used.
		 * If you want to move the pen position without invoking a moveTo command, set
		 * this property to a new point at the desired location
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 */
		public function getPosition():Point{
			return _position.clone();
		}
		public function setPosition(p:Point):Point{
			_position = p.clone();
			_segments.push(new PathSegment(_position));
			return p;
		}
		
		// Public Methods
		/**
		 * Moves the current drawing position to (x, y).
		 * @param x An integer indicating the horizontal location to move the drawing position
		 * @param y An integer indicating the vertical location to move the drawing position
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function moveTo(x:Float, y:Float):Void {
			if (_moveToHasLength){
				_lengthValid = false;
			}
			var end:Point = new Point(x, y);
			_segments.push(new PathMoveSegment(_position, end));
			_position = end;
		}
		/**
		 * Creates a line in the path from the current drawing position
		 * to (x, y); the current drawing position is then set to (x, y).
		 * @param x An integer indicating the horizontal position of the end anchor point of the line
		 * @param y An integer indicating the vertical position of the end anchor point of the line
		 * @see moveTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function lineTo(x:Float, y:Float):Void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathLineSegment(_position, end));
			_position = end;
		}
		/**
		 * Creates a curve in the path from the current drawing position to
		 * (x, y) using the control point specified by (cx, cy). The current  drawing position is then set
		 * to (x, y).
		 * @param cx An integer that specifies the horizontal position of the control point of the curve
		 * @param cy An integer that specifies the vertical position of the control point of the curve
		 * @param x An integer that specifies the horizontal position of the end anchor point of the curve
		 * @param y An integer that specifies the vertical position of the end anchor point of the curve
		 * @see moveTo
		 * @see lineTo
		 * @return Nothing
		 */
		public function curveTo(cx:Float, cy:Float, x:Float, y:Float):Void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathCurveSegment(_position, new Point(cx, cy), end));
			_position = end;
		}
		/**
		 * Creates a circle segment in the path from the current drawing position to
		 * (x, y) using a third intermediary point (cx, cy) which lies on the circular path
		 * between the current drawing position and (x, y). The current  drawing position is then set
		 * to (x, y).
		 * @param cx An integer that specifies the horizontal position of the control point of the circle segment
		 * @param cy An integer that specifies the vertical position of the control point of the circle segment
		 * @param x An integer that specifies the horizontal position of the end anchor point of the circle segment
		 * @param y An integer that specifies the vertical position of the end anchor point of the circle segment
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function circleTo(cx:Float, cy:Float, x:Float, y:Float):Void {
			_lengthValid = false;
			var end:Point = new Point(x, y);
			_segments.push(new PathCircleSegment(_position, new Point(cx, cy), end));
			_position = end;
		}
		/**
		 * Clears all drawing commands in the path
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return nothing
		 */
		public function clear():Void {
			init();
		}
		/**
		 * Draws the saved path into the target object passed.
		 * @param target The object receiving a copy of the drawing commands saved to the path instance
		 * @param startt A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to start drawing in the target
		 * @param endt A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to stop drawing in the target
		 * @see moveTo
		 * @see lineTo
		 * @see curveTo
		 * @return Nothing
		 */
		public function draw(target:Dynamic, ?startt:Int = 0, ?endt:Int = 1):Void {
			startt = cleant(startt, 0);
			endt = cleant(endt, 1);
			if (endt < startt){
				draw(target, startt, 1);
				draw(target, 0, endt);
				return;
			}
			var segments:Array<Dynamic> = getSegmentsToDraw(startt, endt);
			if (segments.length){
				target.moveTo(segments[0]._start.x, segments[0]._start.y);
				var n:Int = segments.length;
				var i:Int;
				for (i in 0...n){
					segments[i].draw(target);
				}
			}
		}
		/**
		 * Gets the location of a point on the path at a specific location along the path
		 * @param t A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to find a point
		 * @return point along the path at the t location along the path
		 * @see angleAt
		 */
		public function pointAt(t:Float):Point {
			t = cleant(t);
			if (t == 0){
				return _segments[0].pointAt(t);
			}else if (t == 1){
				var last:Int = _segments.length - 1;
				return _segments[last].pointAt(t);
			}
			var tLength:Int = t*length;
			var curLength:Int = 0;
			var lastLength:Int = 0;
			var seg:PathSegment;
			var n:Int = _segments.length;
			var i:Int;
			for (i in 0...n){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (tLength <= curLength){
					return seg.pointAt((tLength - lastLength)/seg.length);
				}
				lastLength = curLength;
			}
			return new Point(0, 0);
		}
		/**
		 * Gets the angle in radians of a point on the path at a specific location along the path
		 * @param t A float between 0 and 1 where 0 is the start of the path and 1 is the end of
		 * the path to find an angle
		 * @return angle along the path at the t location along the path
		 * @see pointAt
		 */
		public function angleAt(t:Float):Float {
			t = cleant(t);
			var tLength:Int = t*length;
			var curLength:Int = 0;
			var lastLength:Int = 0;
			var seg:PathSegment;
			var n:Int = _segments.length;
			var i:Int;
			for (i in 0...n){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (tLength <= curLength){
					return seg.angleAt((tLength - lastLength)/seg.length);
				}
				lastLength = curLength;
			}
			return 0;
		}
		
		// Private Methods
		function init():Void {
			_lengthValid = false;
			_segments = new Array();
			_position = new Point(0,0);
		}
		function cleant(t:Float, ?base:Int = 0):Float {
			if (isNaN(t)) t = base;
			else if (t < 0 || t > 1){
				t %= 1;
				if (t == 0) t = base;
				else if (t < 0) t += 1;
			}
			return t;
		}
		function getSegmentsToDraw(startt:Float, endt:Float):Array<Dynamic> {
			if (startt == 0 && endt == 1) return _segments;
			
			var startLength:Int = startt*length;
			var endLength:Int = endt*length;
			var curLength:Int = 0;
			var lastLength:Int = 0;
			var starti:Int = -1;
			var endi:Int = -1;
			var segStartt:Int = 0;
			var segEndt:Int = 1;
			var newSegments:Array<Dynamic> = new Array();
			var seg:PathSegment;
			var n:Int = _segments.length;
			var i:Int;
			
			for (i in 0...n){
				seg = _segments[i];
				if ((_moveToHasLength || seg._command != "moveTo") && seg.length){
					curLength += seg.length;
				}else{
					continue;
				}
				if (startLength < curLength && starti == -1){
					starti = i;
					segStartt = (startt == 0) ? 0 :(startLength - lastLength)/seg.length;
				}
				if (endLength <= curLength){
					endi = i;
					segEndt = (endt == 1) ? 1 :(endLength - lastLength)/seg.length;
					break;
				}
				lastLength = curLength;
			}
			if (endt == 1) endi = n-1;
			if (starti < 0 || endi < 0){
				return newSegments;
			}
			newSegments = _segments.slice(starti, endi + 1);
			if (starti == endi){
				if (segStartt != 0 || segEndt != 1){
					newSegments[0] = newSegments[0].segment(segStartt, segEndt);
				}
			}else{
				if (segStartt != 0){
					newSegments[0] = newSegments[0].segment(segStartt, 1);
				}
				if (segEndt != 1){
					var last:Int = newSegments.length - 1;
					newSegments[last] = newSegments[last].segment(0, segEndt);
				}
			}
			return newSegments;
		}
	}
