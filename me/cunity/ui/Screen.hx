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

package me.cunity.ui;
//import feffects.Tween;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.Font;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.ds.GenericStack.GenericStack;
import haxe.ds.StringMap.StringMap;
import me.cunity.ui.menu.Menu;
import me.cunity.text.Format;

import flash.xml.XML;
import flash.xml.XMLList;
import haxe.CallStack;
import haxe.Timer;
import me.cunity.data.Parse;
import me.cunity.graphics.Filter;
import me.cunity.data.Cookie;
import me.cunity.data.Parse;

import me.cunity.fonts.RuntimeFontLoader;
import me.cunity.graphics.Fill;


import me.cunity.debug.MemoryTracker;
import me.cunity.core.Application;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.LayoutEvent;
import me.cunity.events.ResourceEvent;
import me.cunity.ui.progress.Progress;
import me.cunity.ui.progress.CircleProgress;
import me.cunity.ui.progress.ProgressInfo;
import me.cunity.service.Auth;

using me.cunity.tools.XMLTools;

class Screen extends Container
{
	var frames:Array<Frame>;
	var framesList:XMLList;
	var defs:XMLList;
	var param:Dynamic;
	var startFade:Date;
	var uiFont:String;	
	//var xIndex:Int;
	var progressDisplays:StringMap<Progress>;	
	
	public var frame:Frame;
	public var firstScreenID:String;
	public var userState:AuthStatus;
	public var userStateChange:Bool;
	public var menu:Menu;
	public var menuHandle:Shape;
	public var textFormats:StringMap<TextFormat>;
	public var progress:Progress;
	public var startLayoutTime:Float;
	
	public function new(xN:XML, pCont:Container, par:Dynamic = null) 
	{		
		layoutRoot = this;
		//layoutRoot = _parent.layoutRoot;
		//Out.dumpStack(CallStack.callStack());
		//trace(xN.attribute('id').toString());
		#if debug
		MemoryTracker.track(this, Type.getClassName(Type.getClass(this)));
		#end
		//enabledList = new Array();
		initObjects = new Array();
		//effects = new Array();
		param = (par != null) ? par :{ };		
		xNode  = xN;
		id = xNode.attribute('id').toString();
		name = (id != '') ? id :xNode.name();		
		progressDisplays = new StringMap<Progress>();
		_parent = pCont;
		init(xN);
		//Parse.changeAtts(_parent.iDefs, cAtts, ['textFormat']);
		_parent.layoutRoot = this;
		super(xN, pCont); 	
		//super(xN, this); 	
		//trace( _parent.name + ':'  + Std.string(_parent.iDefs) + ':' + Std.string(iDefs));
		_alpha = alpha;
		if (xN.attribute('fadeIn').toString() != 'false')
			alpha = 0.0;

		trace(_parent.name + ':' +Std.string(iDefs) + ' box:' + box + ' param:' + Std.string(param));
		if (this == Application.instance)
			Application.instance.setGlobal('resize',  resizeNow);
	}
	
	public function startLayout()
	{
		//ONLY CALLED FOR APPLICATION LOADED SCREENS
		if (box.width < _parent.box.width)
		{
			x = (_parent.box.width - box.width) / 2;
		}
		startLayoutTime = Timer.stamp();
		if(resourceList != null )
		trace(name + ':'  + !resourceList.isEmpty());
		if(resourceList != null && !resourceList.isEmpty())
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children,false,0,true);
		else
			layout();	
	}
	
	public function init(xN:XML) 
	{			
		//INIT UI RESOURCES		
		cells = new Array();
		defs = xN.removeChildren('Def');
		//trace(defs.length());
		//framesList = xN.removeChildren('Frame');
		framesList = xN.elements('Frame');
		//xNode = xN.copy();
		xNode = xN;
		cAtts = xN.getAttributes();
		//cAtts.filters = new Map<String,Dynamic>();
		//trace(Std.string(cAtts) + ':' + (cAtts.filters:Map<String,Dynamic>).exists('no'));
		margin = {
			top:.0,
			right:.0,
			bottom:.0,
			left:.0
		};
		Parse.applyToObject(this, Parse.baseCellTypes, cAtts);
		//if(Std.is(this, Screen))
		//cL = Type.getClass(this)
		getBox();
		//screenBox = box.clone();
		//trace(name+ ' class:' + Type.getClass(this) + ':' + cL + ' box:' + Std.string(box));
		//if (_parent == Application.instance)

	if (Type.getClass(this) == Application) trace(Lib.current.stage.height +' stage.height:' + Lib.current.stage.stageHeight + ' stage.width:' + 
		Lib.current.stage.stageWidth);
		resourceList = new GenericStack<DisplayObject>();
		var bgs:XMLList =	defs.elements('BackGround');
		
		if (bgs.length() > 0)
			bG = new BackGround(this);
		
		for (i in 0...bgs.length())
			bG.add(bgs[i], bgs[i].attribute('id').toString() == cAtts.BackGround);
		if (bG != null)
				bG.select(cAtts.BackGround);
		
		var pgs:XMLList = defs.elements('Progress');
		if (pgs.length() > 0)
		{			
			progressDisplays.set(pgs[0].attribute('id').toString(), new Progress(pgs[0], this));
		}
		trace(!resourceList.isEmpty());
		if(!resourceList.isEmpty())
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4init,false,0,true);
		else
			initUI();
		//addEventListener(Event.ENTER_FRAME, wait4resources);
	}
	
	function getDefault(name:String, key:String = 'id'):String {
		var els:XMLList = defs.descendants(name);
		//trace(els);
		if (els.length() == 0)
			return null;
		return els[0].attribute(key).toString();
	}
	
	function initUI() 
	{
		//resourceList = new GenericStack<DisplayObject>();
		//TODO:ADD CONFIG CONTROL 4 THE USED PROGRESS CLASS #
		//Out.dumpStack(CallStack.callStack());
		if (Type.getClass(this) == Application)
		{
			if(ExternalInterface.available)
				ExternalInterface.call('showStage');
			alpha = 1.0;
			textFormats = new StringMap<TextFormat>();
		}
		else { 
			//return;
		}
		//trace('CircleProgress:' + progressDisplays.exists('CircleProgress') + ':'  + cells.length);
		//Out.dumpLayout(this);
		if (progressDisplays.exists('CircleProgress'))
		{
			progress = progressDisplays.get('CircleProgress');

			addChild(progress);

			progress.show();

			//Out.dumpLayout(progress);
		}

		var defList:XMLList = defs.elements();
		//trace(defList.length());
		for (xIndex in 0...defList.length()) 
		{
			var defNode:XML = defList[xIndex];
			var cName:String = defNode.name();
			switch(cName) {
				case 'BackGround', 'Progress':
				//skip already handled on init
				case 'Filters':
				//Filter.menuRoot = menuRoot;
				cAtts.filters = Filter.addFilters(defNode, cAtts.filters);		
				//trace('addedFilters:' + Std.string(cAtts.filters));
				case 'StyleSheet'://TODO. PARSE STYLESHEET(S) 4 FONT(S) TO LOAD
				cAtts.styleSheet = new StyleSheet();
				cAtts.styleSheet.parseCSS(defNode.toString());
				//Out.dumpObject(cAtts.styleSheet);
				//trace('cAtts.styleSheet.styleNames:' + Std.string(cAtts.styleSheet.styleNames));
				case 'TextField':
				if(cAtts.textField == null)
					cAtts.textField = { };
				Parse.inheritAtts(cAtts.textField, Format.getTextFieldArgs(defNode));
				//trace(Std.string(cAtts.textField));
				case 'TextFormat':				
				var allFonts:Array<Dynamic> = Font.enumerateFonts();
				var aF:Font = null;
				uiFont = defNode.attribute('font').toString();
				cAtts.textFormat = uiFont;
				var fontLoaded:Bool = false;
				for (aF in allFonts) 
				{
					if (aF.fontName == uiFont) 
					{
						fontLoaded = true;		
						break;
					}
				}

				if (!fontLoaded)
				{
					textFormats.set(uiFont, Format.initTextFormat(new TextFormat(), defNode.getAttributes()));
					new RuntimeFontLoader(
					{
						fontLib:'design/swfFonts/' + uiFont + '.swf',
						updateProgress:(progress != null && progress.hasUpdate ? progress.update :null)
					}, this);		
				}
				default:
				//NONO
				throw(cName);
			}
		}
		visible = true;
		trace((cAtts.menu == 'true') + ':' + resourceList.isEmpty());
		if(!resourceList.isEmpty())
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4resources,false,0,true);
		else
			addFrames();
			//cAtts.menu == 'true' ? loadMenu() :addFrames();
	}
	
	public override function getBox() 
	{
		var refDims:Dynamic = {};
		if (Std.is(this, Application))
		{
			// GET COOKIE OR TAKE DEFAULT
			if (Cookie.isEnabled())
			{
				Cookie.all();
				cAtts.BackGround =  Cookie.has('BackGround') ?	Cookie.get('BackGround') :getDefault('BackGround');
				if (Cookie.has('locale'))
					Application.instance.currentLocale = Cookie.get('locale');
				trace(Cookie.has('locale') + ':' + Application.instance.currentLocale);
			}
			else
				cAtts.BackGround = getDefault('BackGround');
			trace('cAtts.BackGround :' + cAtts.BackGround );	
			
			refDims = { width:Lib.current.stage.stageWidth, height:Lib.current.stage.stageHeight};
		}		
		else		
			refDims = { width:Std.int(_parent.screenBox.width), height:Std.int(_parent.screenBox.height) };
		//if(Std.is(this, Screen))
		box = new Rectangle(
			Parse.att2Float(cAtts.x),
			Parse.att2Float(cAtts.y),
			cAtts.width == null ? refDims.width :
				(cAtts.width.indexOf('%') > -1) ? Std.parseFloat(cAtts.width)/100 * refDims.width :
				Std.parseFloat(cAtts.width),
			cAtts.height == null ? refDims.height :
				(cAtts.height.indexOf('%') > -1) ? Std.parseFloat(cAtts.height)/100 * refDims.height :
				Std.parseFloat(cAtts.height)
		);
		if (this != Application.instance && box.width > 0 && cAtts.maxWidth < box.width)
			box.width = cAtts.maxWidth;//EXPERIMENTAL - TODO:ADD RELATIVE(%)		
		maxContentDims = box.clone();
	}
	
	public function addFrames(?fId:String)
	{
		firstScreenID = fId == null ? cAtts.home :fId;
		trace(name + ':'+ cAtts.home  +' :' + fId);
		if (frames != null)
		{
			frame.getScreen(firstScreenID);
			return;
		}
		frames = new Array();
		trace(framesList.length());
		//Out.dumpStack(CallStack.callStack());
		for (i in 0...framesList.length())
		{
			frames.push(new Frame(framesList[i], this));
			//if (i == 0 && cAtts.menu == 'true' ) 
			if (frames[frames.length - 1].isMainFrame && cAtts.menu == 'true' ) 
				addChildAt(frames[frames.length - 1], getChildIndex(menu));
			else
				addChild(frames[frames.length - 1]);
		}
		if (framesList.length() > 0)
			frame = frames[0];
	}

	override public function layout()
	{
		//removeEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children);
		trace(name + ':' + alpha + ' _parent:' + _parent.name + ' cells:' + cells.length );			
		maxW = maxH  = cW = cH = 0;
		//getDims();
		//super.layout();
		getChildrenDims();
		for (c in cells) {
	
			c.draw();
			//setMouseEnabled(c.parent, true, true);
			trace(c.name + ' mouseEnabled:' + c.mouseEnabled);
		}
		var aY:Float = 0;
		var aX:Float = 0;
		switch(cAtts.align) {
				case 'CM'://'Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				aY = (box.height - margin.top - margin.bottom - cH) / 2;
		}
		//trace('aY:' + aY + ' cH:' + cH + ' box.height:' + box.height);
		for (c in cells) {//PLACE CHILDREN
			switch(cAtts.align) 
			{
				case 'C','CM'://'Center[ Middle]'
				c.x = (box.width - c.box.width) / 2;
				c.y = aY;	
				trace(name + ' height:' +height +' box:' + Std.string(box) + ' -> ' + c.name + ':' + Std.string(c.box) + '\n' +
				c.getBounds(contentView));	
				default:
				c.x =  aX;
				c.y =  aY;				
			}
			//c.box.x = c.x;
			//c.box.y = c.y;						

			c.visible = true;
			//trace (c.name + ':' + aY + ':' + c.box.height);
			//Out.dumpLayout(c, true);
			//Column based layout
			if(c.cAtts.position != 'absolute')
				aY += c.box.height;
		}
		//trace(aY + ' c.name:' + c.name + ' c.marginY:' + c.marginY +' c.height:' +  c.height);	
		//trace(box.toString() + ':' + alpha);
		/*if (bgImg != null) {
			drawBgImg();	
		}*/
		visible = true;
		//trace(name + ':' + visible +':' +param.firstScreen + 'Application.instance.resizing:' + Application.instance.Application.instance.resizing);
		for (member in initObjects)
			member.init();
		if (param.cB != null){
			param.cB();	
		}
		//if (_parent.Application.instance.resizing)
			//_parent.Application.instance.resizing = false;
		if(param.firstScreen && !Application.instance.resizing )
		//if(param.firstScreen || Application.instance.Application.instance.resizing)
			fadeIn();
		//Out.dumpLayout(this, true);		
		if (Application.instance.resizing)
		{
			resizeMenu();
			if (frames == null)
			{
				trace(name + ':' + cAtts.menu +' hmm...');
			}
			else
			for (f in frames)
				f.resize();
			if(this == Application.instance)
			Application.instance.resizing = false;
		}
		//else
		//{
			dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_COMPLETE));
		//}
	}
	
	public function fadeOut(?cB:Dynamic) {
		STween.add (this, 1.0, { alpha:0.0, onComplete:cB, onCompleteParams:[this] } );
	}
	

	public function resizeMenu():Float
	{
		if (menu != null) 
		{
			menu.layout();
			//Out.dumpLayout(menu);
			//screenBox.height =  box.height - menu.cells[0].box.height;			
			return menu.cells[0].box.height;			
		}
		return 0.0;
	}
		
	function loadMenu() {
		//TODO XCONFIG SITE MENU PATH	
		//trace(menu);
		if (menu != null)//NONO
			Out.dumpStack(CallStack.callStack());
		//new me.cunity.core.MenuLoader('site/' + Lib.current.loaderInfo.parameters.locale +'/');
		new me.cunity.core.MenuLoader('site/');
	}
	
	//public function addMenu(menuData:String = null) 
	public function addMenu(menuData:XML = null) 
	{
		var activeId = cAtts.home == null ?  'home' :cAtts.home;
		//if (xNode.elements('Menu').length() == 0){
		if (menuData == null)
		{
			// WE HAVE NO MENU :-(
			screenBox = new Rectangle(0, 0, box.width, box.height );
			addFrames();
			//loadScreen(activeId == null ? 'home' :activeId);
		}
		else
		{
			//trace(layoutRoot + ':' + resourceList);
			//menu = new Menu(new XML(menuData), this);
			menu = new Menu(menuData, this);
			addChild(menu);
			trace(Lib.current.loaderInfo.url +':' + activeId);
			menu.create(activeId);
			//screenBox = new Rectangle(0, 0, box.width, box.height - menu.cells[0].box.height*2 - cH);
			//	TODO:CONFIGURE MENU MARGIN
					
		}
	}
	
	function onResize(evt:Event) {
		trace(evt.target.stageWidth + 'x' + evt.target.stageHeight + ':' +Application.instance.resizing);
		if (Application.instance.resizing)
			return;
		Application.instance.resizing = true;
		#if debug
		BaseCell.aMNames = new StringMap<Array<Array<StackItem>>>();
		#end
		//stage.removeEventListener(Event.RESIZE, onResize);
		Timer.delay(doResize, 500);
	}
	
	function doResize()
	{
		trace(name);
		layoutRoot = this;
		getBox();
		trace(box);
		if (bG != null)
			bG.draw();			
		layout();		

	}
	
	public function resizeNow()
	{
		Application.instance.resizing = true;
		doResize();
	}

	
	function wait4init(evt:Event) 
	{
		trace(name +' init complete ;-)'  );
		removeEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4init, false);
		//resourceList = null;
		resourceList = new GenericStack<DisplayObject>();
		if (cAtts.menu == 'true') 
		{
			//menuHandle = new Shape();
			//addResource(menuHandle);
			//loadMenu();
		}
		initUI();
	}
	
	public function initScreenWithMenu()
	{
		screenBox = new Rectangle(0, 0, box.width, box.height - menu.cells[0].box.height);
		trace(name + ':'  + box + ':'  + screenBox);			
		//var menuRootBox:Rectangle = menu.create(activeId);
		//trace(menuRootBox);
		if (bG != null)
			bG.updateMenu(bG.currentId);	
		//addFrames();
		if (cL == Application)
			Application.instance.locale();
		menu.activate();
	}
	
	function wait4resources(evt:ResourceEvent) 
	{
		trace(cL +' event class:'  + evt.params.cL);
		if (evt.params.cL != cL)
			return;//	NOT 4 ME
		trace(name +' complete ;-)'  );
		removeEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4resources, false);
		//resourceList = null;
		resourceList = new GenericStack<DisplayObject>();
		trace(box);
		if (progress != null)
		{			
			progress.fade();
			progress = null; 
		}		
		//if (cAtts.menu != 'true')			addFrames();
		//cAtts.menu == 'true' ? initScreenWithMenu() :addFrames();
		cAtts.menu == 'true' ? loadMenu() :addFrames();
		//nextTask();
	}

}