/**
 *
 * @author ...
 */

package me.cunity.ui;

import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.xml.XML;
import me.cunity.core.Application;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.layout.Alignment;
import me.cunity.ui.Container;
using me.cunity.tools.ArrayTools;

class Column extends Container
{
	
	public function new(node:XML, p:Dynamic) 
	{
		super(node, p);
		gridDims = new Array();
	}
	
	override public function layout() 
	{		
		if (!Application.instance.gridRelayout)
		{
			getChildrenDims();
			if (!fixedWidth)
			{
				if(box.width < cW)
					box.width = cW;
				box.width += contentMargin.left + contentMargin.right;
			}

			if (!fixedHeight)
			{
				if(box.height < cH)
					box.height = cH ;		
				box.height +=  contentMargin.top + contentMargin.bottom;
			}				
		}
		else
		{
			cH = box.height - contentMargin.top - contentMargin.bottom;
		}
		//trace(name + ':' + cW + ' x ' + cH + ' box:' + box);

		//trace(fixedWidth + ':' + fixedHeight +':' + box);
		sameWidth = Parse.att2Bool(cAtts.sameWidth);
		sameHeight = Parse.att2Bool(cAtts.sameHeight);	
		//trace( cells.length + ':' + Std.string(box) + ' initial cH:' + cH);
		//var cH:Float = 0;
		for (c in cells) {//SET SIZE //(AND PAINT BG)	
			if (sameWidth) {
				if (cW > c.box.width)
				{					
					c.box.width = cW;
					c.fixedWidth = true;
					c.updateBox();
				}
			}
			if(sameHeight && cH>c.box.height)
				c.box.height = cH;				
			c.draw();
			if (Application.instance.gridRelayout)
				c.layout();
			//cH +=  c.box.height; //+ margin.top + margin.bottom;	
			//trace(cH);
		}		
		//trace (cW + ' x ' +cH + ':' + name);
		//trace(Std.string(cAtts));
		var aY:Float = 0;
		var aX:Float = 0;
		switch(cAtts.align) {
				case 'CM', 'LM'://'Left | Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				//trace('box:' + box + 'cH:' + cH);
				aY = (box.height - contentMargin.top - contentMargin.bottom - cH) / 2;
				if (aY < 0 ) aY = contentMargin.top;
				case 'CB'://CenterBottom
				//aY = box.height - cH - contentMargin.bottom;
				aY = box.height -  cH - (box.height - maxContentDims.height)/2 - contentMargin.bottom;
				aY = maxContentDims.height - cH;
				//trace('maxContentDims.height:' + maxContentDims.height + ' box.height:' + box.height + ' cH:' + cH + ' contentMargin.bottom:' + contentMargin.bottom);
		}
		//trace(name + ':' + cAtts.align + ':' + box + ' aY:' + aY + ' cH:' + cH);
		//Out.dumpLayout(this);
		for (c in cells) {//PLACE CHILDREN
			if (c.cAtts.position == 'absolute')
			{
				//TODO:IMPLEMENT ABSOLUTE POSITION PARSING
				c.x = 0;
				c.y = 0;
				//trace('box:' + box +' child:' + c.name + 'position:' + c.box + ' root col:' +layoutRoot.cells[0].name + ' box:' + layoutRoot.cells[0].box );
				//Out.dumpLayout(c);
			}
			else switch(cAtts.align) {
				case 'CM'://'Center Middle'
				
				c.x = (box.width - contentMargin.left - contentMargin.right - c.box.width) / 2;
				c.y = aY;	
				//trace(name + ':' + Std.string(box));
				//trace(c.name + ':' + Std.string(c.box) );	
				//case 'LM':
				
				case 'R'://'Right'
				c.x = box.width - c.box.width - c.margin.left;
				c.y = aY;				
				default:
				c.x = aX;
				c.y = aY;	
							
			}
		//if (Application.instance.gridRelayout)
		//trace(aY+ ':' +c.name );					
		//trace(aY+ ' height:' +height + ':' +c.name + ':' + Std.string(c.box) + '\nbounds:'  + c.getBounds(contentView));					
			//c.visible = true;
			c.visible = c.cAtts.visible == null ||  Parse.att2Bool(c.cAtts.visible);
			//trace (c.name + ':' + aY + ':' + c.box.height + ':'  );
			//Out.dumpLayout(c);
			if(c.cAtts.position != 'absolute')
			aY += c.box.height;
		}
		//trace(name +':' + Std.string(box) + ' bgImg:' + bgImg);

		if ( Application.instance.resizing || _parent.resizing)
		{
			 if(bG != null)
				bG.set();			
		}
		else
		{
			if(pendingLayoutContainers != null)
				for (c in pendingLayoutContainers)
					c.layout();			
			if (_parent.cL == Row && !Application.instance.gridRelayout)
			{
				var rowsHs:Array<Float> = new Array();
				for (c in cells)
					rowsHs.push(c.box.height);
				_parent.gridDims.push(rowsHs);
				//trace(name + ':' + Std.string(_parent.gridDims));
			}
		}

	
	}
		
}