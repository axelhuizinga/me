package me.cunity.ui;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.xml.XML;
import haxe.CallStack;
import haxe.Timer;
import me.cunity.core.Application;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
using me.cunity.graphics.DrawTools;
/**
 * ...
 * @author axel@cunity.me
 */

//class Copy extends BaseCell
class Copy extends Container
{	
	var isCopied:Bool;
	
	public function new(xN:XML, p:Container) 
	{
		super(xN, p);
		isCopied = false;
		trace(contentView.name +':' +contentView.mouseEnabled + ' layoutRoot:'  + layoutRoot +' visible:' + visible);
		contentView.mouseEnabled = false;
	}
	
	override public function layout()
	{
		var href:BaseCell = _parent.getChildByID(cAtts.href);
		//var source:DisplayObject =  Std.is(href, Container) ? href.contentView :href;
		//var source:DisplayObject =  href;
		var bmp:Bitmap = null;
		if (!isCopied)
		{
			var cAB:Bool = href.cacheAsBitmap;
			//var cAB:Bool = source.cacheAsBitmap;
			if(!cAB)
				href.cacheAsBitmap = true;
			//var bmp:Bitmap = source.copy(
			bmp = href.copy(
				//new BitmapData(Math.ceil(href.width), Math.ceil(href.height), true, 0));
				new BitmapData(Math.ceil(href.width), Math.ceil(href.height), true, 0), false);
				//new BitmapData(Math.ceil(href.width), Math.ceil(href.height), true, 0xffffffff));
			addChild(bmp);
			//STween.add(this, 5, { y:2500 } );
			//Out.dumpLayout(bmp);
			if(!cAB)
				href.cacheAsBitmap = false;
			//we have no dims
			box = new Rectangle(0, 0, 0, 0);
			iDefs = _parent.iDefs;
			//trace(box.toString() + ':' + Std.string(iDefs));
			//trace(cAtts.swapDepths + ' :' + href._parent.contentView.getChildIndex(href));
			if (cAtts.swapDepths == 'true')
				//_parent.addChildAt(this, 0);
				href.addChildAt(this, 0);
				//href.contentView.addChildAt(this, 0);
			else
				//_parent.addChild(this);
				href.addChild(this);

			//trace('addedCopy2:' + id + ' at:' + href.getChildIndex(this));
			//Out.dumpLayout(source);
			//Out.dumpLayout(this);		
			if (!isCopied && cAtts != null && cAtts.filter != null && iDefs.filters !=null)
			{
				//trace(iDefs.filter +':' + iDefs.filters);
				var cVFilters = new Array();
				//trace(cAtts.filter +':' + iDefs.filters.exists(cAtts.filter));
				var filterNames:Array<String> = cAtts.filter.split(',');
				//trace(filterNames);
				for (f in filterNames)
				{
					trace(f + ':' + iDefs.filters.get(f).toString());
					//Out.dumpObject(iDefs.filters.get(f));
					cVFilters.push(iDefs.filters.get(f));
				}
				filters = cVFilters;
			}		
			//ONLY ONCE
			isCopied = true;
			visible = true;
		}
		else
		{
			//this.scaleX = href.contentView.getChildAt(0).scaleX;
			//this.scaleY = href.contentView.getChildAt(0).scaleY;
			//this.scaleX = href.content.scaleX;
			//this.scaleY = href.content.scaleY;
			//TODO:CORRECT RESIZE
		}
	}
	
}