/**
 *
 * @author ...
 */

package me.cunity.ui.menu;

import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.StyleSheet;
import flash.xml.XML;
import flash.xml.XMLList;
import haxe.ds.GenericStack;
import haxe.ds.StringMap;
import me.cunity.animation.LookAtMouse;
import me.cunity.animation.TimeLine;
import me.cunity.data.Parse;
import me.cunity.debug.Out;

import me.cunity.effects.STween;
import me.cunity.graphics.Filter;
import me.cunity.layout.Alignment;
import me.cunity.core.Application;
import me.cunity.core.Types;
import me.cunity.text.Format;
import me.cunity.ui.BackGround;
import me.cunity.ui.Container;
import me.cunity.tools.ArrayTools;
using me.cunity.tools.XMLTools;
import me.cunity.ui.DynaBlock;

class MenuContainer extends Container
{	
	public var container2hide:GenericStack<MenuContainer>;
	public var idMap:StringMap<MenuButton>;
	var isMenuRoot:Bool;
	
	public function new(xN:XML, p:MenuContainer) 
	{
		super(xN, p);
	}

	
	override public  function addChildren() {
		for (actChildIndex in 0...children.length()) {
		//while(actChildIndex < children.length()){
			var child:XML = children[actChildIndex];
			var cName:String = child.name();
			//trace(cName);
			switch(cName) {
				case 'BackGround':			
				if (bG == null)
					bG = new BackGround(this);
				bG.add(child, child.attribute('id').toString() == cAtts.BackGround);				
				case 'Filters':
				Filter.menuRoot = menuRoot;
				cAtts.filters = Filter.addFilters(child, cAtts.filters);				
				case 'StyleSheet'://TODO. test nested StyleSheet handling
				cAtts.styleSheet = new  StyleSheet();
				cAtts.styleSheet.parseCSS(xNode.toString());
				case 'TextField':
				cAtts.textField = { };
				Parse.inheritAtts(cAtts.textField, Format.getTextFieldArgs(xNode));
				case 'TextFormat':
				//TODO test nested TextFormat handling
				Format.createFormat(cAtts.textAtts, child);
				case 'TimeLine':
				timeLine = new TimeLine(this, child);
				
				case 'Tween', 'PathTween' :
				if (timeLine == null)
				{
					trace('Tweens need a Timeline!');
					continue;
				}
				timeLine.addTween(this, child);
				//trace('added:' + child.name());
				case 'LookAtMouse':
				new LookAtMouse(xNode, this);
				
				default:
				//trace(child.name());
				cName = 'menu.Menu' + child.getClassPath();
				//trace(child.name());
				//trace(name +' adding:' + cName + ':' + DynaBlock.getClass(cName));
				var actChild:Dynamic = Type.createInstance(DynaBlock.getClass(cName), [child, this]);
				if(actChild.cL == MenuButton)
				//menuRoot.idMap.set(actChild, actChild.id);
				menuRoot.idMap.set(actChild.id, actChild);
				cells.push(actChild);
				addChild(actChild);
			}
		}
	}

	override public function layout() 
	{
		/*if (isMenuRoot)
		{
			getMaxDims();
			getBox();
		}*/
		getChildrenDims();

		if (isMenuRoot)
		{
			getBox();
			//applyMargin();
		trace(name + ':' + box + ' cells:' + cells.length);
		}
		for (c in cells) {//SET SIZE //(AND PAINT BG)
			//c.draw();
		}	
		//trace (name +':' + cells.length + ' :' + cW + ' x ' +cH + ' box:' + Std.string(box));
		//trace(Std.string(cAtts));
		var aY:Float = 0;// margin.top;
		var aX:Float = 0;//margin.left;
		for (c in cells) 
		{//PLACE CHILDREN
			//trace(c.cAtts.pack);
			switch(c.cAtts.pack) {
				case 'CM'://	CENTERMIDDLE
				c.x = (box.width - c.box.width) / 2;
				c.y = (box.height - c.box.height) / 2;				
				case 'BC':// BOTTOMCENTER
				c.x = (box.width - c.box.width) / 2;
				c.y = box.height - c.box.height;
				//trace(Std.string(DynamicSprite.application.box));
				case 'TLTL':
				c.x = c.box.right;
				c.y = c.box.top;
				case 'TRTL':
				c.x = c.box.right;
				c.y = c.box.top;
				case 'TLBL':
				//c.x = contentMargin.left;
				c.x = - c.contentMargin.left;
				//c.y = contentMargin.top - c.box.height + c.contentMargin.top + c.contentMargin.bottom;	
				c.y =  - c.box.height;
	
				//trace(Std.string(c.box));
				//Out.dumpLayout(c.box);
			case 'BRBL':
				Out.suspended = false;
				trace( cL + ':box.width:' + box.width + 'c.box.height:' + c.box.height + ' x  ' + c.box.width + ' cW:' + 
				cW + ':' + (isMenuRoot ? 'isMenuRoot' :Std.string(maxW) + ':' + _parent.width + ':' + _parent.box.width));
				//Out.suspended = true;
				//trace(Std.string(contentView.getRect(contentView)));
				//c.x = box.width - Math.max(c.cornerRadius.TL, c.cornerRadius.BL);
				c.x = cL == MenuButton ? _parent.width:
					box.width - Math.max(_parent.cornerRadius.TR, _parent.cornerRadius.BR);// - c.contentMargin.left;
				//c.x = box.width + contentMargin.left;
				//c.y = box.height - c.box.height + (c.contentMargin.top - contentMargin.top) + (c.contentMargin.bottom-contentMargin.bottom);		
				c.y = box.height - c.box.height + (c.contentMargin.bottom-contentMargin.bottom);		
				//c.y = box.height - c.box.height ;		
				//initHideMethod('RIGHT', c.box);
				default:
				c.x  = aX;
				c.y = aY;
				//trace (c.label.text + ':' + aY + ':' + c.box.height);
				aY = c.y + c.box.height;// + margin.top;			
				//trace(c.name +' aY:' + aY + ' ' +c.x + 'x' + c.y +' c.margin.left:' + c.margin.left);
			}			

			c.visible = (this == menuRoot);
				//c.visible = false;// HIDE SUBMENUS
			//Out.dumpLayout(c);
			//trace(c.numChildren);
			//trace(c.name + ' c.x:' +c.x + ' c.y:' + c.y +':' + Std.string(c.box));
			trace(name + ' x:' +x + ' y:' + y +':' + Std.string(box));
		}
	}
	
	override public function initHideMethod(direction:String, method:String = 'SLIDE') {
		switch(method) {
			case 'SLIDE':
			switch(direction) {
				case 'UP':
				pMask = {
					hide:{
						y:box.height,
						height:0,
						onComplete:finishHide
					},
					show:{
						y:0,
						height:box.height,
						onComplete:finishShow
					}
				}
				case 'RIGHT':
				pMask = {
					hide:{
						width:0,
						onComplete:finishHide
					},
					show:{
						width:box.width + contentMargin.left + contentMargin.right,
						onComplete:finishShow
					}
				}
			}
		}
		//trace(Std.string(pMask));
	}
	
	override public function finishHide() {
		//trace(isHiding);
		if (!isMenuRoot)
			visible = false;
		isHiding = false;
	}
	
	override public function show() {
		//trace(name +':' +isShowing +':' + Std.string(pMask.show));
		if (isShowing || Lambda.has(menuRoot.container2hide, this))
		//if (isShowing )
			return;
		visible = true;
		if (menuRoot.contentScreen != null && menuRoot.contentScreen.cAtts.hideOnMenu && menuRoot.container2hide.isEmpty())		
			menuRoot.dimScreen();
		//aTween = STween.add (contentView.dMask, 0.5, pMask.show );
		menuRoot.container2hide.add(this);
		if (aTween != null)
			STween.removeTween(aTween);
		aTween = STween.add (contentView.mask, 0.5, pMask.show );
		isShowing = true;
		isHiding = false;
		//contentView.mask.x = 0;
	}	
	
}