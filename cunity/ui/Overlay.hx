package me.cunity.ui;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.xml.XML;
import haxe.ds.GenericStack;
import haxe.CallStack;
import me.cunity.core.Application;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.LayoutEvent;
import me.cunity.events.ResourceEvent;
import me.cunity.ui.BaseCell;
import me.cunity.ui.Container;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Overlay extends Container
{
	var pCell:BaseCell;
	
	public function new(xN:XML, p:BaseCell) 
	{
		resourceList = new GenericStack<DisplayObject>();
		pCell = p;
		//_parent = p.layoutRoot;
		//getBox();
		layoutRoot = this;
		//super(xN, this);
		super(xN, p.layoutRoot);
		p.layoutRoot.addChild(this);
		_alpha = alpha;
		alpha = 0;
		if (cAtts.autoHide != false)
			addEventListener(MouseEvent.MOUSE_MOVE, close, false,0,true);
		//box = _parent.box.clone();
		trace (resourceList.isEmpty() + ' added2:' + p.name);
		if (resourceList.isEmpty())
			layout();
		else
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children,false,0,true);
	}
	
	override public function addChildren()
	{
		getMaxDims();
		getBox();
		super.addChildren();		
	}
	
	override public function layout()
	{
		//getMaxDims();
		//getBox();
		super.layout();
		//box = Application.instance.frame.actScreen.box.clone();
		/*switch(cAtts.pack)
		{
			case 'CM'://CENTERMIDDLE
			x = (_parent.box.width - box.width) / 2;
			y = (_parent.box.height - box.height) / 2;
			default:
			throw('not implemented :-(');
		}*/
		//if (bG != null)
			//bG.select(xNode.elements('BackGround')[0].attribute('id').toString());
		visible = true;
		fadeIn();
		trace(this + ':' + box);
		try {
			//Out.dumpLayout(this);
		}
		catch (ex:Dynamic)
		{
			Out.dumpStack(CallStack.callStack());
		}
		drawBgs(this);
	}
	
	function drawBgs(cnt:Container)
	{
		for (c in cnt.cells)
		{
			if (Std.is(c.cL, Container))
				drawBgs(cast c);
			else
			{
				if (c.bG != null)
					c.bG.draw();
			}
		}
	}
	
	
	public function close(_)
	{
		pCell.removeOverlay();
	}
	
}