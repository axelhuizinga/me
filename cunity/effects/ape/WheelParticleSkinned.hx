/**
 *
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.effects.ape;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.events.Event;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.cove.ape.CircleParticle;
import org.cove.ape.Vector;
//import org.cove.ape.WheelParticle;

class WheelParticleSkinned extends CircleParticle
{
	//private var originalSprite:Sprite;
	private var maxBlur:Float;
	private var offset:Float;
	private var angleDelta:Float;
	
	private var blurRect:Rectangle;
	private var blurPoint:Point;
	private var blurBitmap:Bitmap;
	private var blurBitmapData:BitmapData;
	private var sourceBitmapData:BitmapData;
	private var blurFilter:BlurFilter;
	
	private var rotationMatrix:Matrix;
	private var radians:Float;
	public var angle(default, setAngle):Float;
	public var angularVelocity(default,setAngularVelocity):Float;

	public var useMotionBlur(default, set_motionBlur):Bool;	
	
	public function new (
				x:Float,
				y:Float,
				radius:Float,
				?_opt_fixed:Null<Bool>,
				?_opt_mass:Null<Float>,
				?_opt_elasticity:Null<Float>,
				?_opt_friction:Null < Float >,
				?_opt_motionBlur:Bool = false){
					
		super(x, y, radius, fixed, mass, elasticity, friction);
		useMotionBlur = _opt_motionBlur;
		angle = 0;
	}
	
	public function set_motionBlur(?mB:Bool = false):Bool{		
		var tmp = useMotionBlur;
		useMotionBlur = mB;
		return tmp;
	}
	
	public function setAngle(dA:Float):Float {// degree
		radians = dA * Math.PI / 180;
		angle = dA;
		//rp.prev = rp.curr;
		//rp.curr = new Vector(Math.cos(rad) * radius, Math.sin(rad) * radius);
		paint();
		return angle;
	}

	public function setAngularVelocity(s:Float):Float {
		angularVelocity = s;
		return s;
	}
		
	public override function init():Void {
		cleanup();
		if (displayObject != null) {
			initDisplay();
			if (useMotionBlur){
				maxBlur = 40;
				//maxLoop = 0;
				var maxDimension = maxBlur + Math.sqrt(
					displayObject.width * displayObject.width + displayObject.height * displayObject.height);
				offset = maxDimension / 2;
				//trace(maxDimension + ':' + untyped  displayObject.width);
				rotationMatrix = new Matrix();
				sourceBitmapData = new BitmapData(Math.ceil(maxDimension), Math.ceil(maxDimension), true);
				blurBitmapData = new BitmapData(Math.ceil(maxDimension), Math.ceil(maxDimension), true);
				blurRect = blurBitmapData.rect;
				blurPoint = new Point();
				blurFilter = new BlurFilter(0, 0, BitmapFilterQuality.HIGH);
				blurBitmap = new Bitmap(blurBitmapData, PixelSnapping.AUTO, true);
				blurBitmap.x = blurBitmap.y = -offset;
				sprite.removeChild(displayObject);
				sprite.addChild(blurBitmap);								
			}
		} else {
			sprite.graphics.clear();
			sprite.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			sprite.graphics.beginFill(fillColor, fillAlpha);
			sprite.graphics.drawCircle(0, 0, radius);
			sprite.graphics.endFill();
		}
		paint();
	}
	
	public static var doTrace:Int = 3;
	/**
	 * The default painting method for this particle. This untyped __is__(method,called) automatically
	 * by the <code>APEngine.paint()</code> method. If you want to define your own custom painting
	 * method, then create a subclass of this class and override <code>paint()</code>.
	 */
	public override function paint():Void {
		if (useMotionBlur) {
			var oldPos:Point = new Point(sprite.x, sprite.y);
			var currPos:Point = new Point(curr.x, curr.y);			
			var distance:Float = Point.distance(oldPos, currPos);
			var directionAngle:Float = Math.atan2(currPos.y - oldPos.y, currPos.x - oldPos.x);

			rotationMatrix.identity();
			rotationMatrix.translate(-displayObject.width/2, -displayObject.height/2);
			rotationMatrix.rotate(-directionAngle);
			rotationMatrix.translate(offset, offset);
			
			sourceBitmapData.fillRect(blurBitmapData.rect, 0);
			sourceBitmapData.draw(displayObject, rotationMatrix);
			blurFilter.blurX = Math.min(maxBlur-10, distance * 1);
			blurBitmapData.applyFilter(sourceBitmapData, blurRect, blurPoint, blurFilter);			
			sprite.rotation = directionAngle * 180 / Math.PI + angle;
			if (doTrace >0) {
				doTrace-- ;
				trace(sprite.rotation + ' dirAngle:' + directionAngle * 180 / Math.PI + ' angle:' + angle);
			}
		}
		else {
			sprite.rotation = angle;
			if (doTrace >0) {
				doTrace-- ;
				trace(sprite.rotation + ' angle:' + angle);
			}			
		}
		sprite.x = curr.x;
		sprite.y = curr.y;
	}
	
	public override function update(dt:Float):Void {
		var cTemp:Vector = curr.clone();
		super.update(dt);
		//rp.update(dt);
	}
	
}