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
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.cove.ape.CircleParticle;

/**
 * A circle shaped particle with DisplayObject Skin.
 */

class CircleParticleSkinned extends CircleParticle {


	//private var _useMotionBlur:Bool;

	/**
	 * @param x The initial x position of this particle.
	 * @param y The initial y position of this particle.
	 * @param radius The radius of this particle.
	 * @param fixed Determines if the untyped __is__(particle,fixed) or not. Fixed particles
	 * are not affected by forces or collisions and are good to cast(use,surfaces).
	 * Non-fixed particles move freely in response to collision and forces.
	 * @param mass The mass of the particle.
	 * @param elasticity The elasticity of the particle. Higher values mean more elasticity or 'bounciness'.
	 * @param friction The surface friction of the particle.
	 * @param motionBlur  inspired from Vladimir Tsvetkov's as3 version */
	
	//private var originalSprite:Sprite;
	
	private var maxBlur:Float;
	private var offset:Float;
	
	private var blurRect:Rectangle;
	private var blurPoint:Point;
	private var blurBitmap:Bitmap;
	private var blurBitmapData:BitmapData;
	private var sourceBitmapData:BitmapData;
	private var blurFilter:BlurFilter;
	
	private var rotationMatrix:Matrix;
	public var useMotionBlur(default, set_motionBlur):Bool;

	
	public function new (
			x:Float,
			y:Float,
			radius:Float,
			?_opt_fixed:Null<Bool>,
			?_opt_mass:Null<Float>,
			?_opt_elasticity:Null<Float>,
			?_opt_friction:Null<Float>,
			?_opt_motionBlur:Bool = false) {
		var fixed:Bool = _opt_fixed==null ? false :_opt_fixed;
		var mass:Float = _opt_mass==null ? 1 :_opt_mass;
		var elasticity:Float = _opt_elasticity==null ? 0.3 :_opt_elasticity;
		var friction:Float = _opt_friction==null ? 0 :_opt_friction;

		super(x, y, radius, fixed, mass, elasticity, friction);
		_radius = radius;
		useMotionBlur = _opt_motionBlur;

	}
	
	public function set_motionBlur(?mB:Bool = false):Bool{		
		var tmp = useMotionBlur;
		useMotionBlur = mB;
		return tmp;
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
			//distance = 5;
			//directionAngle = Math.PI / 4;
			rotationMatrix.identity();
			rotationMatrix.translate(-displayObject.width/2, -displayObject.height/2);
			rotationMatrix.rotate(-directionAngle);
			rotationMatrix.translate(offset, offset);
			
			//blurBitmapData.fillRect(blurRect, 0);
			sourceBitmapData.fillRect(blurBitmapData.rect, 0);
			//blurBitmapData.fillRect(blurBitmapData.rect, 0);
			//blurBitmapData.fillRect(blurBitmapData.rect, 0xff00ff00);
			/*blurBitmapData.fillRect(blurRect, 0xff00ff00);*/
			sourceBitmapData.draw(displayObject, rotationMatrix);
			//blurBitmapData.draw(displayObject, rotationMatrix);
			
			blurFilter.blurX = Math.min(maxBlur-10, distance * 2);
			//if (maxLoop++ < 22) trace(distance + ' blurFilter.blurX:' + blurFilter.blurX);
			blurBitmapData.applyFilter(sourceBitmapData, blurRect, blurPoint, blurFilter);
			//blurBitmapData.applyFilter(blurBitmapData, blurRect, blurPoint, blurFilter);
			
			sprite.rotation = directionAngle * 180 / Math.PI;
			/*sprite.graphics.clear();
			sprite.graphics.lineStyle(0, 0);
			sprite.graphics.drawRect(0, 0, sprite.width, sprite.height);
			sprite.graphics.moveTo(0, 0);
			sprite.graphics.drawRect(0, 0, blurRect.width, blurRect.height);*/
		}
		sprite.x = curr.x;
		sprite.y = curr.y;
	}
	
}