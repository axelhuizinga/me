/**
 *
 * @author ...
 */

package me.cunity.ui;

import flash.display.Bitmap;
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.geom.Rectangle;
import haxe.ds.ObjectMap;

import flash.xml.XML;
import me.cunity.core.Application;
import me.cunity.data.Parse;
import me.cunity.layout.Alignment;
import me.cunity.tools.ArrayTools;
import me.cunity.ui.BaseCell;
import me.cunity.ui.Container;
using me.cunity.tools.ArrayTools;

class Row extends Container// implements  Layout
{

	public function new(node:XML, p:Dynamic) 
	{
		super(node, p);
		gridDims = new Array();
	}
	
	override function getChildrenDims()
	{
		maxW = maxH  = cW = cH = 0;
		getMaxDims();			
		applyMargin();
		//dynamicBlocks  = new TypedDictionary < BaseCell, Array<Float> > ();
		dynamicBlocks  = new ObjectMap <BaseCell, Dynamic> ();
		var fixedSum:Float = 0;
		//var dims:Dims =  { width:0.0, height:0.0 };
		for (c in cells) {
			c.getBox();
			//trace(name + ':' + c.name + ':' + c.box);
			if (c.box.width < 0)
			{
				dynamicBlocks.set(c, { width:-c.box.width, height:0.0 }  );		
				//trace('set :' +c.name + ':' + Std.string(dims) + ':' +Std.string(dynamicBlocks.get(c)) );
			}
			else if(c.cAtts.position != 'absolute' )
				fixedSum += c.box.width;
		}
		//fixedSum = cW;
		//trace(fixedWidth + ' fixedSum/cW:' + fixedSum);
		//trace(name + ' max:' + cW + ' x ' + maxH + ' dynamicBlocks:' + dynamicBlocks.keys().length + ' maxContentDims:'  + maxContentDims) ;
		//var usableWidth:Float = (fixedWidth? box.width:maxContentDims.width) - margin.left - margin.right - fixedSum;
		var usableWidth:Float = (fixedWidth ? box.width - margin.left - margin.right :maxContentDims.width) - fixedSum;
		//trace('usableWidth:' + usableWidth);
		//trace(name + ' usableWidth:' + usableWidth + ' dynamicBlocks:' + ArrayTools.map2(dynamicBlocks.keys(),
			//function(k:BaseCell) { return k.name; } ).join(', '));
		for (k in dynamicBlocks.keys())
		{
			//trace(k.name + ':' + k.box.width + ':' + k.fixedWidth);
			k.box.width = dynamicBlocks.get(k).width * usableWidth;
			k.updateBox();
			//k.applyMargin();
			//k.getMaxDims();
			//cW += k.box.width;
			//trace(k.name + ':' + k.box.width);
		}	
		for (c in cells) 
		{
			c.layout();
			if (c.cAtts.position != 'absolute' )
			{
				if (cH < c.box.height)
					cH = c.box.height;
				cW += c.box.width;			
			}
		}		
	}
	
	override public function layout()
	{		
		getChildrenDims();		
		trace(name + ' fixedWidth:'  + fixedWidth + ':' + box.toString() + ' cW:' + cW + ' maxContentDims:' + maxContentDims + 'children:' + cells.length);
		if (!fixedWidth)
		{
			if(box.width < cW)
				box.width = cW;
			box.width += contentMargin.left + contentMargin.right;				
		}

		if (!fixedHeight)
		{
			if(box.height < cH)
				box.height = cH;		
			box.height +=  contentMargin.top + contentMargin.bottom;				
		}			
		//if (dynamicBlocks.length > 0)
			//trace(dynamicBlocks.length);
		sameWidth = Parse.att2Bool(cAtts.sameWidth);
		sameHeight = Parse.att2Bool(cAtts.sameWidth);
		
		//trace(name +' cells.length:' + cells.length + ':' + box);		
		if (gridDims.length > 1)//MORE THAN ONE COLUMN IN THIS ROW
			{
				//trace(name + Std.string(gridDims));
				var subRowsDims:Array<Float> = new Array();
				for (col in gridDims)
				{
					for (ri in 0...col.length)
					{
						if (Math.isNaN(subRowsDims[ri]) || col[ri] > subRowsDims[ri])
							subRowsDims[ri] = col[ri];
					}
				}
				trace(name + Std.string(subRowsDims));
				Application.instance.gridRelayout = true;
				var sum:Float = subRowsDims.sum();
				for (c in cells) 
				{
					c.box.height = sum + c.contentMargin.top + c.contentMargin.bottom;
					for (ri in 0...c.cells.length)
					{
						c.cells[ri].box.height = subRowsDims[ri];
						//trace(c.cells[ri].name + ':' + ri + ':' + c.cells[ri].box.height);
					}					
					c.layout();					
				}
				Application.instance.gridRelayout = false;
			}	
		
		var ci:Int = 0;
		
		for (c in cells) 
		{//SET SIZE //(AND PAINT BG)
			//trace(sameWidth +' maxW:' + maxW + ' c.box.width:' + c.box.width);			
			if (sameWidth && maxW > c.box.width) 
				c.box.width = maxW;
			if(sameHeight && maxH > c.box.height)
				c.box.height = maxH;
			//CHECK 4 BUTTONS CONTENTVIEW DIMS				DO WE NEED THIS ???
			//else if (c.contentView != null && c.contentView.height > c.box.height)
				//c.box.height = c.contentView.height;
			//Out.dumpLayout(contentView);
			if (cAtts.backgroundColors)
			{
				var colors:Array<UInt> = cast(cAtts.backgroundColors, String).split(',').map2(Parse.att2UInt);
				//colors;
				var bgI:Int = (ci++ % 2);
				c.cAtts.backgroundColor = colors[bgI];
				if (cAtts.backgroundAlphas)
				{
					var alphas:Array<Float> = cast(cAtts.backgroundAlphas, String).split(',').map2(Parse.att2Float);
					c.cAtts.backgroundAlpha = alphas[bgI];
					trace(c.cAtts.backgroundColor + ':' + c.cAtts.backgroundAlpha);
				}
				else
					c.cAtts.backgroundAlpha = 1.0;
			}
			c.draw();	
			//Parse.applyToObject(c.contentView, Parse.formTypes, c.cAtts);
			//cW +=  c.box.width;// + margin.left + margin.right;	
			//trace(cW + ' c:' + c.name + ' width:' + c.box.width);
		}
		//cH = maxH + margin.top + margin.bottom;
		//cW +=  margin.left + margin.right;				
		//trace (cW + ' x ' +cH + ' margin.left:' + margin.left + ' margin.top:' + margin.top);
		//trace(cAtts.align + ' margin.top:' + margin.top + ' box:'+ Std.string(box));
		//trace(maxW);
		var aY:Float = 0;// margin.top;
		var aX:Float = 0;// margin.left;
		var gfx:Graphics = contentView.graphics;
		switch(cAtts.align) {
			case 'CM', 'CT', 'CB', 'C'://'Vertical Center'
			aX = (box.width - contentMargin.left - contentMargin.right - cW) / 2;
			//trace('cW:' + cW + ' margin.left:' + margin.left + ' box.width:' + box.width);
			/*gfx.lineStyle(1, 0x00ff00, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE);
			gfx.moveTo(aX,  box.height + 50);
			gfx.lineTo(aX + cW, box.height + 50);
			gfx.lineStyle(1, 0xff0000, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE);*/
		}
		for (c in cells) {//PLACE CHILDREN
			//if (c.cAtts.position == 'absolute')
				//continue;
			//if(Application.instance.resizing)
			switch(cAtts.align) {
				case 'CM'://'Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				c.x =  aX;
				//c.y =  (box.height - margin.top - margin.bottom - c.box.height) / 2;	
				c.y =  (box.height - contentMargin.top - contentMargin.bottom - c.box.height) / 2;	
				//trace(c.y +':' + c.box + ':' + c.maxContentDims + ':' + box);
				case 'CB'://'Center Bottom'
				c.x =   aX;
				c.y = box.height - contentMargin.bottom - contentMargin.top - c.box.height;// - margin.bottom;
				//trace('aX:' + aX + ':' + c.name + ' c.x:' + c.x + ' c.y:' + c.y + ' c.margin:' + Std.string(c.margin));
				//gfx.moveTo(aX, box.height);
				//gfx.lineTo(aX, box.height + 50);
				//case 'CT':
				//should go default
				case 'LM'://'Left Middle'
				c.x =  aX;
				//c.y = margin.top + (box.height - margin.top - margin.bottom - c.box.height) / 2;	
				c.y  = 0;
				//trace(c.name +':' + c.x + ',' + c.y +':' + c.box + ':' + contentBox);
				//trace(getBounds(layoutRoot).y + ' child:' + c.getBounds(layoutRoot).y);
				case 'RM'://'Right Middle'
				//if (cells.length != 1)
					//throw('Vertical align middle works only for one child');
				c.x = box.width - c.box.width;// - c.margin.left;
				c.y = (box.height - margin.top - margin.bottom - c.box.height) / 2;						
				case 'C'://'Center'
				c.x = (box.width - c.box.width) / 2;
				//trace(aY +':' + c.margin.top);
				c.y = aY;// + c.margin.top;
				trace(aY +':' + c.y);
				case 'R'://'Right'
				c.x = box.width - c.box.width;// - c.margin.left;
				c.y = aY;
				default://'TL' = toplefty
				c.x = aX;
				c.y = aY;

			}
			//if(name == 'Application0.mainFrame0.Screen2.Column0.Row1')
				//trace(box + ' child:' + c.name + ' child.box:' + c.box + ' c.x:' + c.x + ' c.y:'+ c.y);				
			//if(Application.instance.resizing)trace(name +' child:' + c.name + ' child.box:' + c.box + ' c.x:' + c.x + ' c.y:'+ c.y);
			//trace(name + ':' + Std.string(box)+ ' -> ' + c.name + ':' + Std.string(c.box));			
			//trace(c.name + ':' + Std.string(c.box));		
			c.visible =  (c.cAtts.visible == null ? true :Parse.att2Bool(c.cAtts.visible ));
			//c.visible = true;
			aX += c.box.width;
		}
		//_parent.visible = true;
		//trace(name +':' + _parent.visible +':' + _parent.isMenuRoot + Std.string(box));
		//visible = true;
		/*if (bgImg != null) {
			drawBgImg();
		}*/
		if (!Application.instance.resizing)
		{
			if(pendingLayoutContainers != null)
				for (c in pendingLayoutContainers)
					c.layout();	
			if (_parent.cL == Column)
			{
				var colsWs:Array<Float> = new Array();
				for (c in cells)
					colsWs.push(c.box.width);
				_parent.gridDims.push(colsWs);
			}	
		}
		else
		{
					
			if (bG != null)
				bG.set();				
		}
	}
}