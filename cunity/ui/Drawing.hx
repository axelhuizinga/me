package me.cunity.ui;
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.xml.XML;
import haxe.CallStack;
import me.cunity.core.Application;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.graphics.DrawTools;
using me.cunity.graphics.DrawTools;
using me.cunity.graphics.Filter;

/**
 * ...
 * @author axel@cunity.me
 */

class Drawing extends Container
{
	var gfx:Graphics;
	var drawObject:BaseCell;
	var fOb:Array<BitmapFilter>;
	var pBox:Rectangle;
	var s:Sprite;
	
	public function new(xN:XML, pCont:Container) 
	{
		super(xN, pCont); 
		if (cAtts.drawAt != null)
		{
			drawObject = _parent.getChildByID(cAtts.drawAt);
			
			trace(drawObject.name + ' f:' + contentView.filters);
			//fOb = drawObject.contentView.filters;
			fOb = drawObject.filters;
			for (f in contentView.filters)
				fOb.push(f);			
		}
		else 
		{
			drawObject = this;
			//_parent.contentView.addChild(this);				
		}
	}
	
	override public function draw()
	{
		//Out.dumpStack(CallStack.callStack());
		super.draw();
		//return;
		//trace(Type.getClass(drawObject) + ' drawObject.content:' + drawObject.content );
		if (!Application.instance.resizing)
		{
			s = new Sprite();
			drawObject.content.parent.addChild(s);
			gfx = s.graphics;
		}
		
		//s.mouseEnabled = false;
		//drawObject.content.parent.mouseEnabled = false;
		//gfx = cast(drawObject.content, Sprite).graphics;		
				
		
		gfx.clear();
		//trace(drawObject.contentView.getVisibleBounds() + ' - ' + drawObject.getVisibleBounds() + ' - ' );
			//+ drawObject.getChildAt(0).getFiltersRect(drawObject.getChildAt(0).filters).bottom);
		drawObject.filters = fOb;
		pBox = drawObject.contentBox.clone();

		trace('pBox:' + pBox.toString() + ' drawObject.box:' + drawObject.box + ' box:'  + box);
		var xOffset:Float = 0;
		var yOffset:Float = 0;
		var lineStyleOffset:Float = 0;
		var dWidth:Float = Parse.unitString2Float(cAtts.width, maxContentDims.width);
		if (dWidth < 0) dWidth *= -box.width;
		var dHeight:Float = Parse.unitString2Float(cAtts.height, maxContentDims.height);
		trace (dHeight +' box.height:'  + box.height + ' maxContentDims:' + maxContentDims);
		if (dHeight < 0) dHeight *= -box.height;
		//dWidth *= 1 / drawObject.content.scaleX;
		//dHeight *= 1 / drawObject.content.scaleY;
		//trace('dWidth:' + dWidth);
		//trace(cAtts.align);
		if (cAtts.lineStyle != null)
		{
			var lineStyleParam:Array<String> = cAtts.lineStyle.split(',');
			lineStyleOffset = Math.round(Std.parseInt(lineStyleParam[0]) / 2);
			trace('lineStyleOffset:' + lineStyleOffset);
			switch(lineStyleParam.length)
			{
				case 1:
				gfx.lineStyle(Std.parseInt(lineStyleParam[0]), 0, 1.0);
				case 2:
				gfx.lineStyle(Std.parseInt(lineStyleParam[0]), Std.parseInt(lineStyleParam[1]), 1.0);
				case 3:
				gfx.lineStyle(Std.parseInt(lineStyleParam[0]), Std.parseInt(lineStyleParam[1]), Std.parseFloat(lineStyleParam[2]));
			}
		}

		if(pBox!= null) switch(cAtts.place)
		{//TODO:HANDLE ALL POSSIBLE PLACE TYPES
			case 'CB':
			xOffset = pBox.width / 2  - dWidth / 2;
			yOffset = drawObject.box.height;
			//trace(xOffset + ', ' + yOffset);
		}
		
		if (cAtts.beginFill != null)
		{
			var fillParam:Array<String> = cAtts.beginFill.split(',');
			switch(fillParam.length)
			{
				case 1:
				gfx.beginFill(Std.parseInt(fillParam[0]));
				case 2:
				gfx.beginFill(Std.parseInt(fillParam[0]), Std.parseFloat(fillParam[1]));
			}
		}
		
		switch(cAtts.method)
		{
			case 'drawRoundRect':
			/*trace(box);*/
			//trace('dWidth:' + dWidth + ' dHeight:' + dHeight + ' yOffset:' + yOffset + ' lineStyleOffsetyOffset:' + lineStyleOffset);
			/*trace([Parse.unitString2Float(cAtts.x), Parse.unitString2Float(cAtts.y),dWidth ,dHeight, Parse.unitString2Float(cAtts.ellipseWidth), 
				Parse.unitString2Float(cAtts.height, maxContentDims.height)].join(', '));//*/
			gfx.drawRoundRect(Parse.unitString2Float(cAtts.x) + xOffset + lineStyleOffset, 
				Parse.unitString2Float(cAtts.y) + yOffset + lineStyleOffset,
				dWidth - 2*lineStyleOffset ,dHeight - 2*lineStyleOffset,
				//Parse.unitString2Float(cAtts.width, maxContentDims.width), Parse.unitString2Float(cAtts.height, maxContentDims.height), 
				Parse.unitString2Float(cAtts.ellipseWidth, maxContentDims.width), Parse.unitString2Float(cAtts.ellipseHeight, maxContentDims.height)
			);
			if (cAtts.screenMask == 'true')
			{
				//_parent.layoutRoot.screenBox.height = dHeight;
				if(!Application.instance.resizing)
					drawObject.content.parent.addChildAt(_parent.layoutRoot.screenMask, 0);
				//var origin:Point = drawObject.contentView.localToGlobal(new Point(xOffset, yOffset));
				//trace('origin:' + origin + ' drawObject origin:' + drawObject.localToGlobal(new Point(xOffset, yOffset)));
				//_parent.layoutRoot.screenMask.alpha = 0.2;
				//_parent.layoutRoot.screenMask.scaleX = drawObject.content.scaleX;
				//_parent.layoutRoot.screenMask.scaleY = drawObject.content.scaleY;
				_parent.layoutRoot.screenMask.graphics.clear();
				_parent.layoutRoot.screenMask.graphics.beginFill(0);
				_parent.layoutRoot.screenMask.graphics.drawRoundRect(
					Parse.unitString2Float(cAtts.x) + xOffset + lineStyleOffset, Parse.unitString2Float(cAtts.y) + yOffset + lineStyleOffset,
					dWidth - 2*lineStyleOffset, dHeight - 2*lineStyleOffset,
					Parse.unitString2Float(cAtts.ellipseWidth, maxContentDims.width), Parse.unitString2Float(cAtts.ellipseHeight, maxContentDims.height)
				);
				//trace(parent.name + ':' + parent.parent.name);
				//trace(name + ':' + parent);
			}
				//Out.dumpLayout(_parent.layoutRoot.screenMask);
				//Out.dumpLayout(drawObject);
			//trace(drawObject.contentView.getVisibleBounds() + ' - ' + _parent.layoutRoot.screenMask.getVisibleBounds());
		}	
	}	
}