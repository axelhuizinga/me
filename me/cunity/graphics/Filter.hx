/**
 *
 * @author ...
 */

package me.cunity.graphics;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.xml.XMLList;
import haxe.ds.StringMap.StringMap;
import me.cunity.data.Parse;

import me.cunity.debug.Out;

import flash.filters.GlowFilter;
import flash.filters.DropShadowFilter;
import flash.xml.XML;
using me.cunity.tools.XMLTools;
//import DrawTools;
using me.cunity.graphics.DrawTools;

class Filter
{
	public static var menuRoot:Dynamic;
	
	public static function addFilter(di:DisplayObject, filter:BitmapFilter):Void
	{
		var f:Array < BitmapFilter> = cast di.filters;
		f.push(filter);
		di.filters = f;
	}
	
	public static function addFilters(xml:XML, ?f:StringMap<Dynamic>= null):StringMap<Dynamic> {
		var children:XMLList = xml.elements();
		var filters:StringMap<Dynamic> = (f==null) ? new StringMap() :f;
		for (i in 0 ... children.length()) {
			var child:XML = children[i];
			var name:String = child.name();
			if (name == null)
				continue;
			var p:Dynamic = child.getAttributes();
			var filter:Dynamic = null;
			//trace(p.method);
			switch(p.method) {
				case 'GlowFilter':
				//trace([p.color, p.alpha, p.blurX, p.blurY, p.strength,p.quality,
					//Parse.att2Bool(p.inner), Parse.att2Bool(p.knockout)].join(', '));
				filter = new GlowFilter(
					Parse.att2IntNull(p.color), Parse.att2FloatNull(p.alpha), Parse.att2FloatNull(p.blurX), Parse.att2FloatNull(p.blurY), 
					Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					Parse.att2Bool(p.inner), Parse.att2Bool(p.knockout)
				);								
				case 'GradientGlowFilter':				
				var alphas = new Array<Float>();
				Parse.att2Array(alphas, p.alphas);
				var ratios = new Array<UInt>();
				Parse.att2Array(ratios, p.ratios);
				var colors = new Array<UInt>();
				Parse.att2Array(colors, p.colors);
				var type:BitmapFilterType = 
					#if flash Type.createEnum(BitmapFilterType, p.type) #else Reflect.field(BitmapFilterType, p.type) #end
					;
				/*Out.fTrace("dist:@angle:@colors:@alphas:@ratios:@blurX:@blurY:@strength:@quality:@type:@knockout:", [	Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Std.string(colors), Std.string(alphas), Std.string(ratios), 
					Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					type, Parse.att2Bool(p.knockout)]);*/
				filter = new GradientGlowFilter(
					Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), colors, alphas, ratios, Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					type, Parse.att2Bool(p.knockout)
				);							
				case 'BevelFilter':				
				var type:BitmapFilterType = #if flash Type.createEnum(BitmapFilterType, p.type) #else Reflect.field(BitmapFilterType, p.type) #end
					;
				/*Out.fTrace("dist:@angle:@highColor:@highAlpha:@shadowColor:@shadowAlpha:@blurX:@blurY:@strength:@quality:@type:@knockout:", [	Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Parse.att2IntNull(p.highlightColor), Parse.att2FloatNull(p.highlightAlpha), 
					Parse.att2IntNull(p.shadowColor),  Parse.att2FloatNull(p.shadowAlpha), Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					type, Parse.att2Bool(p.knockout)]);*/
				filter = new BevelFilter(
					Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Parse.att2IntNull(p.highlightColor), Parse.att2FloatNull(p.highlightAlpha), 
					Parse.att2IntNull(p.shadowColor),  Parse.att2FloatNull(p.shadowAlpha), Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					type, Parse.att2Bool(p.knockout)
				);							
				case 'GradientBevelFilter':				
				var alphas = new Array<Dynamic>();
				Parse.att2Array(alphas, p.alphas);
				var ratios = new Array<Dynamic>();
				Parse.att2Array(ratios, p.ratios);
				var colors = new Array<Dynamic>();
				Parse.att2Array(colors, p.colors);
				var type:BitmapFilterType = 
					#if flash Type.createEnum(BitmapFilterType, p.type) #else Reflect.field(BitmapFilterType, p.type) #end
					;
				//trace(Std.string(p));
				/*Out.fTrace("dist:@angle:@colors:@alphas:@ratios:@blurX:@blurY:@strength:@quality:@type:@knockout:", [	Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Std.string(colors), Std.string(alphas), Std.string(ratios), 
					Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					type, Parse.att2Bool(p.knockout)]);*/
				filter = new  GradientBevelFilter(
					Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), colors, alphas, ratios, Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					Std.string(p.type).toLowerCase(), Parse.att2Bool(p.knockout)
				);		
				//Out.dumpObject(filter);
				
				case 'DropShadowFilter':	
				//var isSuspended:Bool = Out.suspended;
				//Out.suspended = false;
				
			/*	Out.fTrace("p.distance:@ p.angle:@ p.color:@ p.alpha:@ p.blurX:@ p.blurY:@ p.strength:@ p.quality:",
					[Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Parse.att2IntNull(p.color), 
					Parse.att2FloatNull(p.alpha),	Parse.att2FloatNull(p.blurX), Parse.att2FloatNull(p.blurY), 
					Parse.att2FloatNull(p.strength), Parse.att2IntNull(p.quality)]);*/
				filter = new DropShadowFilter(
					Parse.att2FloatNull(p.distance), Parse.att2FloatNull(p.angle), Parse.att2IntNull(p.color), Parse.att2FloatNull(p.alpha), 
					Parse.att2FloatNull(p.blurX), 
					Parse.att2FloatNull(p.blurY), Parse.att2FloatNull(p.strength),
					Parse.att2IntNull(p.quality),
					Parse.att2Bool(p.inner), Parse.att2Bool(p.knockout), Parse.att2Bool(p.hideObject)
				);	
				//Out.dumpObject(filter);
				//if (isSuspended)
					//Out.suspended = true;
				/**/
			}
			filters.set(p.id, filter);
		}
		//trace(Std.string(filters));
		return filters;
	}
	
	public static function getFiltersRect(diObj:DisplayObject, filters:Array<BitmapFilter> = null):Rectangle 
	{
		if(filters == null)
			filters = diObj.filters;
		var bData:BitmapData = new BitmapData(Std.int(diObj.width), Std.int(diObj.height), true,0);
		diObj.filters = [];
		bData.draw(diObj);
		//var dBounds:Rectangle = diObj.getBounds(diObj);
		//var sourceRect = bData.getColorBoundsRect(0xFFFFFFFF, 0x000000, true);
		var sourceRect = bData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		//var sourceRect = bData.getColorBoundsRect(0xFF, 0, false);
		diObj.filters = filters;
		var dBounds:Rectangle = sourceRect.clone();
		//trace('dBounds:'+dBounds);
		//trace('sourceRect:'+sourceRect);
		//trace('bData.rect:'+bData.rect + ':' + filters.length);
		for (f in filters){
			//trace(bData.generateFilterRect(sourceRect, f));
			dBounds = dBounds.union(bData.generateFilterRect(sourceRect, f));
			//trace(dBounds);
		}
		return dBounds;		
	}
	
}