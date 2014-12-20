/**
 *
 * @author Axel Huizinga
 */

package me.cunity.graphics;
import me.cunity.debug.Out;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;
import me.cunity.graphics.Paint;

class ImageLib extends Sprite
{
	var bData:BitmapData;
	
	public function new(symbolName:String) 
	{
		super();
		//var inst:Dynamic = Type.createInstance(Type.resolveClass(symbolName), []);
		trace(symbolName);
		var inst:Dynamic = Type.createEmptyInstance(Type.resolveClass(symbolName));
		//trace(inst);
		var sprite:Sprite = flash.Lib.attach(symbolName);
		sprite.visible = false;
		bData = new BitmapData(Math.floor(sprite.width), Math.floor(sprite.height), true);
		var mat:Matrix = new Matrix();
		bData.draw(sprite, mat);
	}
	
	public function drawRect(par:Dynamic) {// required rect:Retangle, fillType:FillType, 
		var mat:Matrix = new Matrix();
		trace(Std.string(par.fillType) + ' \nrect:' + Std.string(par.rect));
		trace('Stage.height:' + stage.height);
		var fType:FillType = cast(par.fillType, FillType );
		switch(fType) {
			case verticalGradient(p):
			mat.createBox(
				p.pageWidth == null ? 1:p.pageWidth / bData.width,
				p.pageHeight == null ? 1:p.pageHeight / bData.height,
				p.rotation == null ? 0 :p.rotation,
				p.stageLeft == null ? 0 :p.stageLeft,
				p.stageTop == null ? 0 :-p.stageTop
			);
		}
		graphics.beginBitmapFill(bData, mat);
		graphics.drawRect(par.rect.left, par.rect.top, par.rect.width, par.rect.height);
		graphics.endFill();	
		//Out.dumpLayout(this);
	}

}