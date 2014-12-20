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

package me.cunity.graphics;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.GraphicsBitmapFill;
import flash.display.IBitmapDrawable;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

typedef GradientFillParam = {
	var type:GradientType;
	var colors:Array<#if flash UInt #else Int #end>;
	var alphas:Array<Float>;
	var ratios:Array<Dynamic>;
	var matrix:Matrix;
	var spreadMethod:SpreadMethod;
	var interpolationMethod:InterpolationMethod;
	var focalPointRatio:Float;
};

//enum BmpDraw<T:DisplayObject, BitmapData> {
enum BmpDraw<T:DisplayObject> {
	one(source:T);
	two(source:T, mat:Matrix);
	three(source:T, mat:Matrix, colorT:ColorTransform);
	four(source:T, mat:Matrix, colorT:ColorTransform, blend:BlendMode);
	five(source:T, mat:Matrix, colorT:ColorTransform, blend:BlendMode, clip:Rectangle);
	six(source:T, mat:Matrix, colorT:ColorTransform, blend:BlendMode, clip:Rectangle,
	smooth:Bool);
}

class Fill 
{
	
	public static function beginGradientFill(grs:Graphics, p:GradientFillParam) {
		grs.beginGradientFill(p.type, p.colors, p.alphas, p.ratios, p.matrix, p.spreadMethod, 
		p.interpolationMethod, p.focalPointRatio);
	}
	
	public static function gradientFill(c:Array<UInt>, a:Array<Float>, r:Array<UInt>):GradientFillParam {
		return {
			type:GradientType.LINEAR,
			colors:c,
			alphas:a,
			ratios:r,
			matrix:null,
			spreadMethod:SpreadMethod.PAD,
			interpolationMethod:InterpolationMethod.LINEAR_RGB,
			focalPointRatio:0.0			
		};
	}
	
	public static function beginCopyFill(p:BmpDraw<DisplayObject>, target:Graphics, repeat:Bool = true):Void {
		//var bData:BitmapData = new BitmapData(Std.int(region.width), Std.int(region.height));
		//var bData:BitmapData = new BitmapData(1, Std.int(region.height), true, 0xffffffff);
		var smooth:Bool = true;
		var region:Rectangle = new Rectangle();
		//var bData:BitmapData = new BitmapData(1, Std.int(region.height));
		var bData:BitmapData = null;
			//bmd2.copyPixels(bmd1, rect, pt, null, null, true);
		var mat:Matrix = new Matrix();
		//mat = p
		//mat.translate(0, region.y);
		//bData.draw(source, mat, null, null, region, smooth);
		switch(p) {
			case one(source):
			bData = new BitmapData(Math.ceil(source.width), Math.ceil(source.height));
			bData.draw(source);
			case two(source, mat):
			bData = new BitmapData(Math.ceil(source.width), Math.ceil(source.height));
			bData.draw(source, mat);
			case five(source, mat, colorT, blend, clip):
			bData = new BitmapData(Math.ceil(clip.width), Math.ceil(clip.height));
			//trace(bData.width + ' x ' + bData.height);
			//trace(mat.toString() + ':' + clip);
			bData.draw(source, mat);
			default:
			trace('oops');
		}
		//bData.draw(source, null, null, null, region, smooth);
		//bData.draw(source);
		//trace( region.toString() +':' + repeat);
		/*var bA:ByteArray = bData.getPixels(new Rectangle(0, 0, 1, region.height));
		
		while (bA.position < bA.length){
			try { bA.readInt(); }
			catch (ex:Dynamic) {
				trace(ex);
				break;
			}
			
		}*/
		//trace(bData.getPixels(new Rectangle(0,0, 1, region.height)).toString());
		target.beginBitmapFill(bData, null, repeat, smooth);
	}
	
}