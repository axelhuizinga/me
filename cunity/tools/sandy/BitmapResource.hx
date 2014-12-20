/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.tools.sandy;

import flash.display.BlendMode;
import flash.display.DisplayObjectContainer;
import flash.display.PixelSnapping;
import flash.display.Stage;
import flash.geom.ColorTransform;
import me.cunity.layout.Alignment;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;


class BitmapResource 
{
	public var bmp:Bitmap;
	public var alpha:Float;
	
	public function new(cn:String) 
	{
		//trace(cn);
		switch(cn)
		{
			case 'Earth':
			bmp = new Earth();
			case 'RingMap':
			bmp = new RingMap();
			case 'Sky':
			bmp = new Sky();
		}
		trace(cn + ':' + bmp.width);
		alpha = 1.0;
	}
	
	public function createBackGround(container:DisplayObjectContainer)
	{
		var stage:Stage = container.stage;
		if (Type.getClass(container.getChildAt(0)) == Bitmap)
			container.removeChildAt(0);
		container.addChildAt( drawScaled(new Rectangle(0,0,stage.stageWidth, 200), Alignment.TOPLEFT),0);			
	}

	public function drawScaled(drawBox:Rectangle,  ?align :Alignment, ?dAtts:Dynamic):Bitmap 
	{
		return new Bitmap(drawScaledData(drawBox, align, dAtts), PixelSnapping.NEVER, true);		
	}	

	public function drawScaledData(drawBox:Rectangle,  ?align :Alignment, ?dAtts:Dynamic):BitmapData
	{
		if (dAtts == null)
			dAtts = { blendColor:0};
		trace(Std.string(dAtts));
		var blendColor:UInt = dAtts.blendColor;
		trace(blendColor + ':' + drawBox + ':'  + bmp);
		var matrix:Matrix = new Matrix();
		trace((drawBox.width / bmp.width) + ':' +  (drawBox.height / bmp.height));
		var scale:Float = Math.max(drawBox.width / bmp.width, drawBox.height / bmp.height);
		var w:Float = bmp.width * scale;
		var h:Float = bmp.height * scale;
		var tX:Float = 0.0;
		var tY:Float = 0.0;
		switch(align)
		{
			case Alignment.LEFT, Alignment.TOPLEFT, Alignment.BOTTOMLEFT :
				tX = 0;				
			case Alignment.RIGHT, Alignment.TOPRIGHT, Alignment.BOTTOMRIGHT :
				tX =  drawBox.width - w/2;
			default ://MIDDLE
				//tX = 0.5 * (drawBox.width - w) + w/2;
				tX = (drawBox.width - w)/2;
				//trace(tX);
		}		
		switch(align)
		{
			case Alignment.TOP, Alignment.TOPLEFT, Alignment.TOPRIGHT :
				tY = 0;				
			case Alignment.BOTTOM, Alignment.BOTTOMLEFT, Alignment.BOTTOMRIGHT :
				tY = drawBox.height - h/2;	
			default ://MIDDLE					
				tY = 0.5 * (drawBox.height - h) + h/2;
		}		
		var scaled:BitmapData = 
			new BitmapData(Math.ceil(drawBox.width), Math.ceil(drawBox.height), true, blendColor);
		var cTrans:ColorTransform = (alpha != 1.0 ? new ColorTransform(1, 1, 1, alpha) :null);
		//trace(alpha +':' + cTrans);
		trace(alpha +' scale:' + scale + ' tx:'+ tX + ' ty:' + tY);
		scaled.draw(bmp, new Matrix(scale, 0, 0, scale, tX, tY), cTrans,
			BlendMode.OVERLAY, null, true);
		return scaled;
	}	
}