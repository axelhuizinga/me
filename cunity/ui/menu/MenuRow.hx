/**
 *
 * @author ...
 */

package me.cunity.ui.menu;

import flash.display.Bitmap;
import flash.geom.Rectangle;

import flash.xml.XML;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.layout.Alignment;
import me.cunity.ui.BaseCell;
import me.cunity.ui.menu.MenuContainer;

class MenuRow extends MenuContainer
{

	public function new(node:XML, p:MenuContainer) 
	{
		super(node, p);
	}
	
	override 	function getChildrenDims() {
		maxW = maxH  = cW = cH = 0;
		getMaxDims();		
		applyMargin();		
		//dynamicBlocks  = new TypedDictionary<BaseCell, Array<Float>>();		
		for (c in cells) {
			c.layout();
			cW +=  c.box.width;
			if (c.box.height > maxH) 
				maxH = c.box.height;
			//if (c.cAtts.expand != null)
				//dynamicBlocks.set(c, c.cAtts.expand.split(',').map2(Std.parseInt));
			//trace(c.name + '::height' + c.box.height);
		}
		cH = maxH;
	}	
	
	//override public function layout() :Rectangle
	override public function layout()
	{		
		getChildrenDims();		
		if (!fixedWidth)
		{
			if(box.width < cW)
				box.width = cW;
			box.width += contentMargin.left + contentMargin.right;				
		}
		trace(box);
		if (!fixedHeight)
		{
			if(box.height < cH)
				box.height = cH;		
			box.height +=  contentMargin.top + contentMargin.bottom;				
			trace(box.height);
		}			
		//box.width += margin.left + margin.right;
		//box.height +=  margin.top + margin.bottom;
		//trace(name + ':' + box);
		//if (dynamicBlocks.length > 0)
			//trace(dynamicBlocks.length);
		sameWidth = Parse.att2Bool(cAtts.sameWidth);
		sameHeight = Parse.att2Bool(cAtts.sameHeight);
		
		for (c in cells) {//SET SIZE //(AND PAINT BG)
			//trace(sameWidth +' maxW:' + maxW + ' c.box.width:' + c.box.width);			
			if (sameWidth && maxW > c.box.width) {
				c.box.width = maxW;
			}
			if(sameHeight && maxH>c.box.height)
				c.box.height = maxH;
			//c.draw();	
			//trace(cW + ' c:' + c.name + ' width:' + c.box.width);
		}			
		//trace (cW + ' x ' +cH + ' margin.left:' + margin.left + ' margin.top:' + margin.top);
		
		//trace(cAtts.align + ' margin.top:' + margin.top + ' box:'+ Std.string(box));
		//trace(maxW);
		var aY:Float = margin.top;
		var aX:Float = margin.left;
		switch(cAtts.align) 
		{
				case 'CM'://'Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				aX = (box.width - cW) / 2;
		}
		for (c in cells) {//PLACE CHILDREN
			switch(cAtts.align) {
				case 'CM'://'Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				c.x = aX;
				c.y = (box.height - c.box.height) / 2;	

				case 'CB'://'Center Bottom'
				c.x = aX;
				c.y = box.height - c.box.height;
				case 'LM'://'Left Middle'
				//if (cells.length != 1)
					//throw('Vertical align middle works only for one child');
				c.x = aX;
				c.y = (box.height - c.box.height) / 2;	
				//trace(c.getBounds(this.contentView));
				case 'RM'://'Right Middle'
				if (cells.length != 1)
					throw('Vertical align middle works only for one child');
				c.x = box.width - c.box.width;// - c.margin.left;
				c.y = (box.height - c.box.height) / 2;						
				case 'C'://'Center'
				c.x = (box.width - c.box.width) / 2;
				//trace(aY +':' + c.margin.top);
				c.y = aY ;// + c.margin.top;
				case 'R'://'Right'
				c.x = box.width - c.box.width;// - c.margin.left;
				c.y = aY;
				default://'TL' = toplefty
				c.x = aX;
				c.y = aY;
			}
			if (c.content != null) {				
				c.content.x = c.x + c.contentMargin.left;// + c.margin.left;
				c.content.y = c.y + c.contentMargin.top;// + c.margin.top;	
			}
			c.draw();	
			//trace(name + ':' + Std.string(box)+ ' -> ' + c.name + ':' + Std.string(c.box));			
			//trace(c.name + ':' + Std.string(c.box));			
			c.visible = true;
			aX += c.box.width;
		}
		if (!Std.is(_parent, Menu)) {//INIT SUBMENU MASK
			menuRoot.views.push(contentView);
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
			for (p in props) {
				if (p == 'onComplete')
					continue;
				Reflect.setField(contentView.mask, p, Reflect.field(pMask.hide, p));	
				//Reflect.setField(contentView.dMask, p, Reflect.field(pMask.hide, p));	
				//trace('set:' + p + ' 2:' + Reflect.field(pMask.hide, p) + ' == ' + Reflect.field(contentView.mask, p) +
				//' versus:' + Reflect.field(pMask.show, p));
			}
		}
		//_parent.visible = true;
		//trace(name +':' + _parent.visible +':' + _parent.isMenuRoot + Std.string(box));
		visible = true;
	}
}