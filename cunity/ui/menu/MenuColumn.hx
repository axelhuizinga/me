/**
 *
 * @author ...
 */

package me.cunity.ui.menu;

import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.xml.XML;
import me.cunity.core.Application;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.layout.Alignment;
import me.cunity.ui.BaseCell;
import me.cunity.ui.menu.MenuContainer;
using me.cunity.tools.ArrayTools;

class MenuColumn extends MenuContainer// implements  Layout
{
	
	public function new(node:XML, p:Dynamic) 
	{
		super(node, p);
	}
		
	override 	function getChildrenDims() {
		if (Application.instance.resizing)
			return;
		maxW = maxH  = cW = cH = 0;
		getMaxDims();		
		applyMargin();		
		//dynamicBlocks  = new TypedDictionary<BaseCell, Array<Float>>();		
		for (c in cells) {
			c.layout();
			cH +=  c.box.height;
			if (c.box.width > maxW) 
				maxW = c.box.width;
			//if (c.cAtts.expand != null)
				//dynamicBlocks.set(c, c.cAtts.expand.split(',').map2(Std.parseInt));
			//trace(c.name + '::height' + c.box.height);
		}
		cW = maxW;// + margin.left + margin.right;
		//cH +=  margin.top + margin.bottom;	
	}	
	
	//override public function layout() :Rectangle 
	override public function layout()
	{		
		getChildrenDims();		

		if (!fixedWidth)
		{
			if(box.width < cW)
				box.width = cW;
			Out.suspended = false;			//trace(box.width);
			box.width += contentMargin.left + contentMargin.right;				
			trace(box.width);		Out.suspended = true;
		}

		if (!fixedHeight)
		{
			if(box.height < cH)
				box.height = cH;		
			box.height +=  contentMargin.top + contentMargin.bottom;				
		}			
		//box.width += margin.left + margin.right;
		//box.height +=  margin.top + margin.bottom;		
		//trace(name + ':' + box +' margin:' + Std.string(margin));
		sameWidth = Parse.att2Bool(cAtts.sameWidth);
		sameHeight = Parse.att2Bool(cAtts.sameWidth);	
		//trace( cells.length + ':' + Std.string(box) + ' initial cH:' + cH);
		//var cH:Float = 0;
		for (c in cells) {//SET SIZE //(AND PAINT BG)	
			if (sameWidth && maxW>c.box.width)
					c.box.width = maxW;
			//trace(c.box.height + ' maxH:'  + maxH);
			if(sameHeight && maxH>c.box.height)
				c.box.height = maxH;			
		
			//c.draw();
		}	
		
		//trace (cW + ' x ' +cH + ':' + name);
		//trace(Std.string(cAtts));
		var aY:Float = 0;
		var aX:Float = 0;
		var aY:Float = contentMargin.top;
		var aX:Float = contentMargin.left;
		switch(cAtts.align) {
				case 'CM', 'LM'://'Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				aY = (box.height - cH) / 2;
				case 'CB'://CenterBottom
				aY = box.height - cH;
		}
		/*Out.suspended = false;
		trace(Std.string(cAtts) + 'aX:' + aX);
		Out.suspended = true;*/
		for (c in cells) {//PLACE CHILDREN
			switch(cAtts.align) {
				case 'CM'://'Center Middle'
				c.x = (box.width - c.box.width) / 2;
				c.y = aY;	
				//trace(name + ':' + Std.string(box));
				//trace(c.name + ':' + Std.string(c.box));	
				//case 'LM':
				default:
				c.x = aX;
				c.y = aY;				
			}
			//trace(aY+ ':' +c.name + ':' + Std.string(c.box));					
			if (c.content != null) {	
				c.content.x = c.x + c.contentMargin.left;// + c.margin.left;
				c.content.y = c.y + c.contentMargin.top;// + c.margin.top;	
			}			
			c.draw();
			c.visible = true;
			//trace (c.label.text + ':' + aY + ':' + c.box.height);
			//Out.dumpLayout(c, true);
			aY += c.box.height;
		}
		//draw();
		//ADD MASK FOR SUBMENU
		if (!Std.is(_parent, Menu)) {
			menuRoot.views.push(contentView);
			//if (cAtts.filter == 'true')
		//contentView.filters = [cAtts.filters.get('SubMenu')];
			
			switch(cAtts.pack) {
				case 'TLTL':
				
				case 'TRTL':
				
				case 'TLBL':
				initHideMethod('UP');				
				case 'BRBL':
				initHideMethod('RIGHT');		
			}
			addMask();
			//if(cAtts.pack == 'BRBL' )addMask();
			var props = Reflect.fields(pMask.hide);
			for (p in props){
				if (p == 'onComplete')
					continue;
				Reflect.setField(contentView.mask, p, Reflect.field(pMask.hide, p));	
				//Reflect.setField(contentView.dMask, p, Reflect.field(pMask.hide, p));	
				//trace('set:' + p + ' 2:' + Reflect.field(pMask.hide, p) + ' == ' + Reflect.field(contentView.mask, p) +
				//' versus:' + Reflect.field(pMask.show, p));
			}
		}

	}
		
}