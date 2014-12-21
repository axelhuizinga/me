package me.cunity.js.dom;

import js.html.*;
import js.Lib;
import js.JQuery;
import me.cunity.debug.Out;
//import me.cunity.js.layout.BaseCell;
import me.cunity.js.dom.Base;
import me.cunity.js.dom.Container;
import me.cunity.js.layout.Types;
/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class SubMenu extends Container
{	
	//public var itemsBox:HtmlDom;
	//public var displayStates:Map<Dynamic>;

	public var submenuMargin:Int;
	public var eventMask:Node;
	
	override public function layout(isResizing:Bool = false)
	{
		super.layout();
		for (item in items)
			if (item.subMenu != null)
				item.subMenu.layout();			
		trace(id + ':' +  (parent.element.className == 'menu') +' pack:' + pack + ' cAtts.isRoot' + cAtts.isRoot);
		//if (parent.node.className == 'menu') 
		//jQ.show();
		enabled = cAtts.isRoot;
		//if (!cAtts.isRoot )
		//jQ.css('position', 'absolute');
		if (!cAtts.isRoot )
		{
			switch(pack)//TOPLEVEL REMAINS VISIBLE
			{			
				case Pack.TLBL:
				effects = {
					show:
					{
						height:jQ.height(),
						top:jQ.css('top'),
						paddingBottom:jQ.css('padding-bottom'),
						opacity:1
					},
					hide:
					{
						height:0,
						top:parent.parent.jQ.css('top'),
						//top:0,
						paddingBottom:'0px',
						opacity:0
					}
				}
				trace(effects.hide.top +'==' +  parent.parent.jQ.css('top') + ':' +parent.parent.jQ.offset().top + '=>' +Std.string(effects.show.top) );
				//trace(jQ.offset().top + '==' +Std.string(effects.show.top) + '->' + Std.string(effects.hide.top) + ':' + node.style.cssText);
				jQ.animate(effects.hide, 0);

				//Out.dumpLayout(node);
				//enabled = false;
				jQ.css('visibility', 'visible');
				//trace(id +':' +parent.parent.jQ.css('top') + '==' + node.offsetTop + '->' + parent.parent.jQ.offset().top + ':' + node.style.cssText);
				//trace('<textarea rows="5" cols="100">' + node.parentNode.innerHTML + '</textarea>');
				case Pack.BRBL:
				effects = {
					show:
					{
						width:jQ.width(),
						paddingLeft:jQ.css('padding-left'),
						opacity:1
					},
					hide:
					{
						width:0,
						paddingLeft:'0px',
						opacity:0
					}		
				}
				//jQ.css('width', '0px');
				jQ.animate(effects.hide, 0);
				jQ.css('visibility', 'visible');
					default:
			}
			element.style.display = 'none';
		}
		//trace(id + ':' + jQ.css('overflow'));
	
	}
	
	override public function hideAll(target:BaseCell):Void
	{
		/*if (target != null)
			trace(id +'->' + target.id + ':' + (target.subMenu != null ? Std.string(target.subMenu.effects.show) + ':' + 
			Std.string(target.subMenu.effects.hide):'null submenu'));
		*/
		for (item in items)
		{
			if (item == target)
			{				
				item.jQ.toggleClass('over', true);
				//trace("hasClass('over'):" + item.jQ.hasClass('over'));
			}
			else
				item.jQ.toggleClass('over', false);
			if (item == target || item.subMenu == null)
				continue;
			item.subMenu.hideAll(null);
			if (item.subMenu.jQ.css('opacity') != '0')
			{
				//item.subMenu.jQ.stop().animate(item.subMenu.effects.hide, 300);
				item.subMenu.jQ.stop().animate(item.subMenu.effects.hide, 300, 'linear'
			, function() 
			{
				trace('dims:' + item.subMenu.jQ.width() +' x ' + item.subMenu.jQ.height());
				item.subMenu.node.style.display = 'none';
			});
				item.subMenu.enabled = false;
				//item.subMenu.eventMask.style.display = 'block';
			}			
		}//jQ.css('overflow', 'visible');
		if (target != null && target.subMenu != null)
		{			
			trace(target.subMenu.jQ.width() ); target.subMenu.enabled = true;
			target.subMenu.element.style.display = 'block';
			target.subMenu.jQ.stop().animate(target.subMenu.effects.show, 500, 'linear'
			, function() 
			{
				trace('style:' + target.subMenu.element.style.cssText);
				trace(target.subMenu.id + ' this:' + untyped this + ':'  + (target.subMenu.node == untyped this));
				//Out.dumpLayout(target.subMenu.node);
				//Out.dumpLayout(target.subMenu.eventMask);
				//
				//target.subMenu.eventMask.style.display = 'none';
			});			
		}
	}
	
	//public function new(p:Container, ?cfg:GuiObject, ?doc:Document) 
	public function new(p:Container, ?cfg:GuiObject, ?doc:Document) 
	{
		super(p, 'div', cfg, doc);
		//submenuMargin = cfg.submenuMargin;
		//displayStates = new Map();
		enabled = cfg.enabled ?cfg.enabled :true;
		
		for (name in Reflect.fields(cfg))
		{
			switch(name)
			{
				case 'items', 'width', 'height', 'id', 'align', 'orient', 'pack':
				continue;
				default:
				Reflect.setField(this, name, Reflect.field(cfg, name));
			}			
		}
		if(parent.element.className != 'menu') switch(pack)//no gap for toplevel menu
		{
			case Pack.TLBL:
			//if(items != null)			items[items.length - 1].jQ.css('margin-bottom', Std.string(submenuMargin));
			//jQ.css('display', 'block');
			jQ.css('padding-bottom', Std.string(submenuMargin) + 'px');
			Reflect.setField(cAtts.styles, 'padding-bottom', Std.string(submenuMargin) + 'px');
			//jQ.offset( { top:y - submenuMargin, left:null } );
			//jQ.height(height + submenuMargin);
			//trace(jQ.css('margin-bottom') + ':' + Std.string(submenuMargin) + ' height:' + jQ.height() + ' display:' + jQ.css('display'));
			case Pack.BRBL:
			jQ.css('padding-left', Std.string(submenuMargin) + 'px');
				Reflect.setField(cAtts.styles, 'padding-left', Std.string(submenuMargin) + 'px');
			//jQ.width(width + submenuMargin);
			case Pack.BLTL:
			case Pack.BLBR:
			default:
		}		
		//trace(Std.string(Reflect.fields(cfg)) + ':' + className + ' submenuMargin:' + submenuMargin);
		
		for (item in cfg.items)
		{
			var att:Dynamic = {href:item.href, text:item.text };
			//var li:HtmlDom = addElement('li', ul);
			//var mItem:MenuItem  = MenuItem.add2(sM.itemsBox, att);
			var mItem:MenuItem  = MenuItem.add2(this, att);
			//var mItem:MenuItem  = cast addElement('a', li, att);
			//addText(item.text, mItem);
			items.push(mItem);
			if (item.subMenu != null)
			{
				//var subMenuObj:GuiObject = cast item.subMenu;
				if (item.subMenu.submenuMargin == null)
					item.subMenu.submenuMargin = submenuMargin;
				//var subMenuObj:GuiObject = BaseCell.createGuiObject(item.subMenu);
				//trace(item.subMenu.align + ':'  + subMenuObj.align);
				//subMenuObj.id = mO.id + '_' + Std.string(Lambda.indexOf(mO.items, item));
				//for (i in 0...item.subMenu.items.length)
					//subMenuObj.items.push(item.subMenu.items[i]);
				//mItem.subMenu = add2(p, subMenuObj);
				mItem.subMenu = new SubMenu(mItem, BaseCell.createGuiObject(item.subMenu));
				//mItem.subMenu.node.style.display = 'none';
				//if(subMenuObj.submenuMargin == null)// &&  sM.node.parentNode.className == 'menu')
					//mItem.subMenu.submenuMargin = Menu.instance.submenuMargin;
				//trace(mItem.subMenu.id +' sM.align:' + mItem.subMenu.align);
					
			}
			mItem.jQ.bind('mouseover', mItem.show);
			//else mItem.jQ.bind('mouseover', mItem.dump);	
		}		
	}
	
}