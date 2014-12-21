/**
 *
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.ui.menu;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Dictionary;
import flash.xml.XML;
import haxe.CallStack;
import haxe.ds.GenericStack.GenericStack;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap.StringMap;
import me.cunity.core.Application;
import me.cunity.core.Types;
import me.cunity.events.ResourceEvent;
import me.cunity.ui.Screen;

import me.cunity.effects.STween;
import me.cunity.events.BackgroundEvent;
import me.cunity.graphics.Fill;
import me.cunity.graphics.Filter;
import me.cunity.ui.BaseCell;
import me.cunity.ui.DynaBlock;
import me.cunity.ui.Label;
import me.cunity.ui.menu.MenuButton;
import me.cunity.ui.Container;
import me.cunity.ui.menu.MenuContainer;
import me.cunity.ui.menu.MenuRow;
import me.cunity.ui.menu.MenuColumn;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.graphics.Paint;
import me.cunity.text.Metrics;
import me.cunity.tools.FlashTools;
using me.cunity.tools.XMLTools;
import haxe.Timer;

class Menu extends MenuContainer
{

	var app:Application;
	public var activeId:String;
	public var swfId:String;
	//public var client:Client;
	public var contentScreen:Screen;
	public var delay:Int;
	public var sameButtonHeight:Float;
	public var views:Array<BaseCell>;
		 
	public var appBox:Rectangle;
	
	public var idn:Int;
	
	var node:XML;
	var parentScreen:Screen;
	var screenDimmer:STween;
	//public function new(node:XMLNode, clip:DisplayObjectContainer) 
	public function new(xN:XML, p:Screen ) 
	{
		//super(node, null);
		//xNode = xN;
		menuRoot =  this;
		isMenuRoot = true;
		
		idMap = new StringMap<MenuButton>();
		//super(n, p);
		views = new Array();
		super(xN, null);
		_parent = p;
		iDefs = { };
		for (name in Reflect.fields(_parent.iDefs))
			Reflect.setField(iDefs, name, Reflect.field(_parent.iDefs, name));
		//iDefs = _parent.iDefs;
		//iDefs.textFormat = cAtts.textFormat;
		iDefs.styleSheet = null;
		Parse.changeAtts(iDefs, cAtts, ['textFormat']);
		//iDefs = cAtts;
		layoutRoot = _parent.layoutRoot;
		parentScreen = p;
		tabEnabled = false;
		tabChildren = false;
		//trace(id +':' + xNode.toXMLString());
		delay = Std.parseInt(xNode.attribute('delay').toString());
		//contentView = new BaseCell(null, this);
		//addChild(contentView);
		box = p.box;
		//trace(_parent.name + ':' + box + ':' + Std.string(iDefs) + ':' + Std.string(cAtts));
		Parse.inheritAtts(cAtts,  p.cAtts);
		//trace(Std.string(cAtts));
		container2hide = new GenericStack<MenuContainer>();
		app = Application.instance;
		//isInteractive = true;
	}
	
	function getButtonHeight() {
		var dummy:Label = new Label(cAtts);
		dummy.text = 'Äg|';
		var dummyOb:DisplayObject = addChild(dummy);
		var bBox:Rectangle = dummyOb.getBounds(dummyOb);
		if (false && cAtts.filters != null) {
			var buttonFilters:Array<BitmapFilter> = new Array();
			var keys:Iterator<String> = cAtts.filters.keys();
			for (key in keys) {
				//if (key.indexOf('Button_label') > -1)
				if (key == 'Button_label')
					//buttonFilters.push(cAtts.filters.get(key));
					bBox = bBox.union(Filter.getFiltersRect(dummyOb, [cAtts.filters.get(key)]));
			}
			//bBox = bBox.union(Filter.getBoundsWithFilters(dummyOb, buttonFilters));
			sameButtonHeight = bBox.height;
			trace(bBox + ' sameButtonHeight:' + sameButtonHeight);
		}
		else
			sameButtonHeight = dummyOb.getBounds(this).height;
		removeChild(dummyOb);		
	}
	
	//public function create(?actId:String):Rectangle {
	public function create(?actId:String)
	{
		var firstChild = xNode.children()[0];
		var cName = 'menu.Menu' + firstChild.getClassPath();
		trace(cName + ':' + cells.length);
		Out.suspended = true;
		if(cAtts.sameButtonHeight == 'true')
			getButtonHeight();
		activeId =  actId == null ? 'home' :actId;
		//trace(name +' adding:' + cName + ' class:' +DynaBlock.getClass(cName));
		cells.push(Type.createInstance( DynaBlock.getClass(cName), [firstChild, this]));
		//trace(Type.getClass(cells[cells.length - 1]));
		addChild(cells[cells.length - 1]);
		//enabledList.push(activeId);
		Out.suspended = false;
		trace(resourceList);
		//trace(!resourceList.isEmpty());
		if(resourceList != null && !resourceList.isEmpty())
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4resources,false,0,true);
		else		
			layout();
		
		alpha = 0.0;
		trace(cells[0].box.toString());
		//Out.dumpLayout(this);
		//Out.dumpLayout(cells[0]);
		visible = true;
		//Out.suspended = true;
	}
	
	public function activate()
	{
		STween.add(this, 1.0, {alpha:1.0, onComplete:firstLoad});
	}
	
	override public function layout()
	{
		Out.suspended = true;
		//_iBox = null;
		box = app.box;
		//views = new Array();
		applyMargin();//set contentMargin
		super.layout();
		//trace('-----------' + (app.bG != null));

		Out.suspended = false;
		trace('-----------' + box.toString());
		parentScreen.initScreenWithMenu();
		
		if (app.bG != null)
		{
			copyBg();
			//trace('----------- after copyBg' );
			app.bG.addEventListener(BackgroundEvent.CHANGE, copyBg,false,0,true);
		}
		//return cells[0].box;
	}

	function copyBg(evt:Event = null) 
	{		//return;
		
		//Out.suspended = false;
		trace(views.length);
		var i:Int = 1;
		var shadowMargin:Float = 0;
		if (layoutRoot.cAtts.filters)
		{
			var buttonFilter:Dynamic = layoutRoot.cAtts.filters.get('Button_label');
			trace('Button_label.filter:' + buttonFilter);
		}
		for (v in views) 
		{
			var vBox:Rectangle;
			var gfx:Graphics;
			//var contentMargin:Border;
			var coRad:Corners = null;
			var vMatY:Float = 0;
			if (Std.is(v, MenuButton) && v.tooltip != null)
			{
				cast(v, MenuButton).highlight(null);
				gfx = v.tooltip.graphics;
				gfx.clear();
				gfx.lineStyle(0, 0xffffff, .8);
				vBox = v.tooltip.getBounds(Lib.current);		
				/*Out.dumpLayout(v._parent.contentView);
				Out.dumpLayout(v);
				Out.dumpLayout(v.tooltip);*/
				if (false && this.cornerRadius != null)
				{//no cornerRadius used 4 tooltips here
					coRad = Reflect.copy(this.cornerRadius);
					//coRad =  this.cornerRadius ;
					vBox.width +=  coRad.TL * 2 ;
					vBox.height +=  coRad.BR * 2;			
					vBox.offset( -coRad.TL , -coRad.BR);						
				}
				//trace( untyped v.label.text + ' tooltip:' + vBox + ' parentbounds:' + v.getBounds(Lib.current) + ' vMatY:' + vMatY) ;
			}
			else
			{				
				vBox = v.getBounds(Lib.current);
				vBox.width = v._parent.box.width;
				vBox.height = v._parent.box.height;			
				gfx = v.graphics;
				coRad = v._parent.cornerRadius;
				//trace(v._parent.name +' vBox:' + vBox + ':' + Std.string(v._parent.contentMargin) + ':' + Std.string(coRad) + ' mask:' + v.mask.getBounds(Lib.current));
			}
			//trace(v.parent.name +' vBox:' + vBox + ' parent:' + v.parent.getBounds(Lib.current) + ' mask:' + v.mask.getBounds(Lib.current));
			v.alpha = 1.0;
			var cBox:Rectangle = vBox.clone();
			cBox.x = 0;
			cBox.width = 1;
			var mat:Matrix = new Matrix();
			mat.translate(0, -cBox.y);
			//mat.translate(0, vMatY );
			//trace(cBox.toString()+':'+ v.parent.name);
			Fill.beginCopyFill(five(cast app.bG, mat, null, null, cBox), gfx, false);
			//v.graphics.lineStyle(0, 0xffffff);
			if (coRad != null)
			{	
				switch(coRad.method)
				{
					case 'drawRoundRect':
					//trace(_parent.margin.left+', '+_parent.margin.top +', '+
						//_parent.box.width + _parent.coRad.TR * 2+', '+ _parent.box.height + _parent.coRad.BR * 2+', '+ _parent.coRad.TR * 2+', '+_parent.coRad.BR * 2);
					Out.fTrace('x:@ y:@ w:@ h:@ TL:@ BR:@', [-v._parent.contentMargin.left, -v._parent.contentMargin.top,
						vBox.width,
						vBox.height,
						coRad.TL,  coRad.BR]);
					gfx.drawRoundRect( -coRad.TL, -coRad.TR, vBox.width, vBox.height, coRad.TL * 2, coRad.BR * 2);
					case 'drawRoundRectComplex':
					/*Out.fTrace('x:@ y:@ w:@ h:@ TL:@ TR:@ BL:@ BR:@', [-v._parent.contentMargin.left, -v._parent.contentMargin.top,
						vBox.width,
						vBox.height,
						coRad.TL, coRad.TR, coRad.BL, coRad.BR]);*/
				/*	trace(-v._parent.contentMargin.left +', '+ -v._parent.contentMargin.top +', '+
						vBox.width+', '+
						vBox.height+', '+
						coRad.TL+', '+ coRad.TR+', '+ coRad.BL+', '+ coRad.BR);
				*/
					gfx.drawRoundRectComplex(
						//-v._parent.contentMargin.left, -v._parent.contentMargin.top,
						0, 0,
						vBox.width,
						vBox.height,
						coRad.TL, coRad.TR, coRad.BL, coRad.BR);
				}			
			}
			else			
			gfx.drawRect(0, 0, vBox.width, vBox.height);
			if (Std.is(v, MenuButton) && v.tooltip != null)
				v.reset(null);		
		}

		//Out.suspended = true;
	}
	
	
	public function hideRoot() 
	{
		for (x in container2hide)
			hideContainer(x);
	}
	
	public function hideContainer(con:MenuContainer) {
		con.hide();
		container2hide.remove(con);
		if (contentScreen != null && contentScreen.cAtts.hideOnMenu && container2hide.isEmpty())
			dimScreen(true);
		//trace(container2hide.isEmpty());
	}
	
	public function dimScreen(?reset:Bool=false)
	{
		if (screenDimmer != null)
			STween.removeTween(screenDimmer);
		screenDimmer = STween.add(contentScreen, .5, { alpha:reset? 1.0:0.3 } );
	}
	
	public function firstLoad()
	{
		//id = activeId;
		trace(activeId + ':' + parentScreen);		
		//Out.dumpLayout(this);
		//parentScreen.frame.loadScreen(id);
		parentScreen.addFrames(activeId);
	}
		
	public function mainLoad(id:String, dSprite:MenuContainer = null) 
	{
		trace(id + ':' + app + ':' + dSprite);
		if (dSprite != null && dSprite.xNode.attribute('obj').toString() != '') {
			//	HANDLE INTERNAL FUNCTIONS
			var baseObj:BaseCell = (
				dSprite.xNode.attribute('rel').toString() == '@' ? app :
				FlashTools.numTarget(dSprite.xNode.attribute('rel').toString().split('@'))
			);
			//trace(target.name + ':' + Type.getClass(target) + ':' + dSprite.xNode.attribute('rel').toString());
			if (baseObj != null) {
				try {
					trace(baseObj.name + ':' + Type.getClass(baseObj) + ':' + dSprite.xNode.attribute('rel').toString());
					var obj:Dynamic = (dSprite.xNode.attribute('obj').toString() == '@' ? Application.instance :
						Reflect.field(baseObj, dSprite.xNode.attribute('obj').toString()));
					//trace(obj + ':'  + dSprite.xNode.attribute('method').toString());
					var method:Dynamic = Reflect.field(obj, dSprite.xNode.attribute('method').toString());
					trace(method + ':' + Reflect.isFunction(method));
					if(method == app.mailto)
					{
						//case app.mailto:
						Reflect.callMethod(null, method, [dSprite]);		
					}
					else{
						var arguments:Array<String> = ( dSprite.xNode.attribute('arg').toString() == '' ? []:
							dSprite.xNode.attribute('arg').toString().split(','));
						Reflect.callMethod(null, method, arguments);						
					}
				}
				catch (ex:Dynamic) { trace(ex);}
			}
			return;
		}
		parentScreen.frame.loadScreen(id);
	}
	
	
	public  function loadSuccess(id:String) 
	{
		trace(id);
		for(c in cells[0].cells)
			if (c.id == id)
			{
				trace('settingState of:' +  c.id);
				c.interactionState = InteractionState.DISABLED;
				//trace('setState of:' +  c.id + ' 2:' + c.interactionState);
			}
		//trace(idMap.keys().length);
		for (c in idMap.iterator())
		{
			if (c.id == id)
			{
				if(c.cells.length==0)
				c.interactionState = InteractionState.DISABLED;
			}
			else if (activeId != null && c.id == activeId)
				c.interactionState = InteractionState.ENABLED;
			//trace(c.id + ' == ' +id);
		}
		activeId = id;
		parent.setChildIndex(this, parent.numChildren - 1);//keep on top
		if (app.userStateChange)
		{			
			app.userStateChange = false;
		}
	}
	
	
	function wait4resources(evt:ResourceEvent) {
		trace(resourceList.isEmpty());
		trace(cL +' event class:'  + evt.params.cL);
		if (evt.params.cL != cL)
			return;//	NOT 4 ME
		//trace(name +' complete ;-)'  );
		removeEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4resources, false);
		resourceList = null;
		//resourceList = new GenericStack<DisplayObject>();
		trace(box);
		layout();
		//nextTask();
	}
	
}