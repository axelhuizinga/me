package me.cunity.graphics;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import haxe.io.Bytes;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef BytesBox = {
	var data:Bytes;
	var bounds:Rectangle;
 }

class DrawTools 
{
	public function new(){}
	public static function copy(source:IBitmapDrawable, bData:BitmapData, crop:Bool = true):Bitmap
	{
		bData.draw(source, null, null, BlendMode.OVERLAY);
		var bounds :Rectangle = bData.getColorBoundsRect(0xFFFFFFFF, 0, false);
		//trace(bounds.toString());
		if(!crop)
			return new Bitmap(bData);
		var bDataCrop = new BitmapData(Math.ceil(bounds.width), Math.ceil(bounds.height), true , 0);
		bDataCrop.copyPixels(bData, bounds, new Point(bounds.x, bounds.y));
		bData.dispose();
		return new Bitmap(bDataCrop);
	}
	
	public static function getVisibleBounds(source:DisplayObject, ?skipFilters:Bool = false):Rectangle
	{
		var f:Array<BitmapFilter> = null;
		//var data:BitmapData = new BitmapData(Math.floor(source.width), Math.floor(source.height), true, 0x00000000);
		var data:BitmapData = new BitmapData(Math.round(source.width), Math.round(source.height), true, 0);
		trace(Math.floor(source.width) +' x ' +  Math.floor(source.height));
		if (skipFilters)
		{			
			f = source.filters;
			source.filters = [];
		}
		data.draw(source);
		var bounds :Rectangle = data.getColorBoundsRect(0xFF000000, 0, false);
		if (skipFilters)
			source.filters = f;
		data.dispose();
		return bounds;
	}

	public static function getData(source:DisplayObject):BytesBox
	{
		var data:BitmapData = new BitmapData(Math.floor(source.width), Math.floor(source.height), true, 0x00000000);
		data.draw(source);
		var bounds :Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
		var pixels:ByteArray = data.getPixels(bounds);
		data.dispose();	
		return {
			data:Bytes.ofData(cast pixels),
			bounds:bounds
		}
	}
}