package me.cunity.ui;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap.StringMap;

import flash.Lib;
import haxe.CallStack;
import me.cunity.animation.LookAtMouse;
import me.cunity.animation.TimeLine;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.LayoutEvent;
import me.cunity.events.ResourceEvent;
import me.cunity.graphics.DrawTools;
import me.cunity.tools.ArrayTools;
import me.cunity.ui.BaseCell;
import me.cunity.ui.menu.Menu;

import flash.xml.XML;
import flash.xml.XMLList;
import haxe.Timer;
import haxe.ds.GenericStack;

import me.cunity.core.Application;
import me.cunity.core.ScreenLoader;



import HXAddress;
//import SWFAddressEvent;

using me.cunity.graphics.DrawTools;
using me.cunity.graphics.Filter;
using me.cunity.tools.ArrayTools;
using me.cunity.tools.StringTool;
using me.cunity.tools.XMLTools;


/**
 * ...
 * @author axel@cunity.me
 */

class Frame extends Container
{	
	var screensList:XMLList;
	var actScreenTitle:String;
	var bgs:XMLList;
	var parentScreen:Screen;
	var actScreenId:String;
	var screenLoader:ScreenLoader;
	public var screenLoaderData:Dynamic;
	var screenView:Container;
	
	public var history:Array<String>;
	public var isMainFrame(default, null):Bool;
	//var title:String;
	
	public function new(xN:XML, pCont:Container) 
	{
		_parent = pCont;
		parentScreen = cast(pCont, Screen);
		layoutRoot = this;
		history = new Array();
		/*screenMasks = new Array();
		for (i in [0, 1])
		{
			var screenMask:Sprite = new Sprite();
			screenMask.visible = false;
			screenMasks.push(screenMask);
		}*/
		screenMask = new Sprite();
		screenMask.visible = false;
		//screenMask.mouseEnabled = false;
		//addChild(screenMask);
		//super(null, pCont);
		isMainFrame = Parse.att2Bool(xN.attribute('isMainframe').toString());
		init(xN);
		
		//bgs =	xN.removeChildren('BackGround');
		super(xN, pCont);
		screenView = cast(getChildByID('screenView'), Container);
		trace(contentView.name +':' + contentView.mouseEnabled );
		mouseEnabled = false;
		alpha = 1.0;
		visible = true;
		//Out.dumpLayout(this);
		trace(cAtts.title);
		//}
		//Out.dumpStack(CallStack.callStack());
		screenLoaderData = { };
		trace(isMainFrame + ':' + Std.string(cAtts));
		if (isMainFrame)
		Application.instance.setGlobal('loadScreen',  loadScreen);
		if (Std.is(parentScreen, Application))
			parentScreen.startLayout();
	}	
	
	public function init(xN:XML)
	{
		actScreenId = flash.Lib.current.loaderInfo.parameters.home == null ? 'home' :
			flash.Lib.current.loaderInfo.parameters.home;
		var defs:XMLList = xN.removeChildren('Def');
		screensList = xN.removeChildren('Screen');
		//resourceList = new GenericStack<DisplayObject>();
	}
		
	public function loadScreen(id:String)
	{
		#if debug
		BaseCell.aMNames = new StringMap<Array<Array<StackItem>>>();
		#end

		//Out.dumpStack(CallStack.callStack());
		//Out.dumpLayout(this);
		trace(id + ':' + Std.string(Lib.current.loaderInfo.parameters));
		HXAddress.setValue(id);
	}
	
	function updateScreenBox()
	{
		var maskRef:XML = xNode.xmlWithAttribute('screenMask', 'true');
		if (maskRef != null)
		{
			screenBox = screenMask.getBounds(parent);
			screenBox.offset( -x, -y);
			trace('screenBox:' + screenBox + ' mouseEnabled:' + mouseEnabled);
			//Out.dumpLayout(screenMask);
		}

		screenView.x = screenBox.x;
		screenView.y = screenBox.y;		
	}
	
	public function createScreen(sxNode:XML, id:String)
	{
		trace(id + ':'  + parentScreen.firstScreenID + ':' + sxNode.name() + ' screenBox:'  + screenBox);
		//Out.dumpStack(CallStack.callStack());
		//trace(sxNode.toXMLString());
		//return;
		var sc:Screen = new Screen(sxNode, this,
			(actScreen == null && sxNode.attribute('fadeIn').toString() != 'false') ? {firstScreen:true} :null);
		//screenView.addChildAt(sc,0);
		screenView.addChild(sc);
		//var maskRef:XML = xNode.xmlWithAttribute('screenMask', 'true');
		if (xNode.xmlWithAttribute('screenMask', 'true') != null)
		{
			//Out.dumpLayout(screenMask);
			screenView.mask = screenMask;
		}
			
		trace(screenView.mask == screenMask);
		//sc.x = screenBox.x;
		//sc.y = screenBox.y;
		trace(buttonMode + ':' + sc.name +' y;' + sc.y + '  sc.mouseEnabled:' +  sc.mouseEnabled +':' + sc.buttonMode);		
		sc.startLayout();	
		actScreenTitle = (sxNode.attribute('title').toString() == '') ? sxNode.attribute('id').toString().ucFirst():
			sxNode.attribute('title').toString();
		
		trace(actScreenTitle + ':' + actScreen);
		if (actScreen != null) 
		{
			//actScreen.fadeOut(activateScreen);
			activateScreen(actScreen, sc);
		}
		else{
			if (isMainFrame) 
			{
				Application.instance.setTitle(cAtts.title);
				HXAddress.setTitle(HXAddressManager.formatTitle(id));
			}
			actScreen = sc;
		}
		
		if (parentScreen.menu != null)
		{
			parentScreen.menu.contentScreen = sc;
			parentScreen.menu.loadSuccess(id);
		}
		
	}	
	
	public function getScreen(id:String)//from current xml or load one
	{
		var sxNode:XML = screensList.getElementWithAttVal('id', id);
		trace(id + ':' + Reflect.field(sxNode, "@id") + ':' +  Std.string(Lib.current.loaderInfo.parameters));
		//Out.dumpStack(CallStack.callStack());
		switch (history.length)
		{
			case 0:
			history.push(id);
			case 1:
			if (id != history[history.length - 1])
				history.push(id);
			default:
			if (id != history[history.length - 1])
				history.push(id);			
			else if(id == history[history.length - 2])
				history.pop();
		}
				
		if (isMainFrame)
			Application.instance.cAtts.home = id;
		if (sxNode == null) //screen not in home config - try to load it...
		{
			trace(screenLoader);
			//screenLoader = null;
			//if(screenLoader == null)
				screenLoader = new ScreenLoader(this, id);
			//else
			//	screenLoader.loadScreen(id);
			return;
		}
		
		createScreen(sxNode, id);
	}
	
	function activateScreen(oldScreen:Screen, newScreen:Screen)// show it after it has been loaded
	{
		try {
			actScreen = newScreen;
			trace(screenView.getChildIndex(actScreen) + ':' + screenBox.toString() + ' = ' + screenMask.getBounds(parent));
			screenView.removeChild(oldScreen);
			//removeChild(oldScreen);
			trace(screenView.getChildIndex(actScreen) + ' oldScreen.id :' + oldScreen.id + ' ->' + actScreen.id);
			actScreen.fadeIn();
			oldScreen.fadeOut(destroyScreen);
			//Application.instance.setTitle(cAtts.title+ ' ' + actScreenTitle);
		}
		catch (ex:Dynamic) {
			trace(ex);
		}
	}
	
	function destroyScreen(oldScreen:Screen)
	{
			oldScreen.destroy();
			oldScreen = null;		
	}
	

	//function onChange(evt:#if flash SWFAddressEvent #else Event #end) 
	function onChange(pathNames:Array<String>) 
	{
		trace(pathNames + ':' + parentScreen.firstScreenID + ' HXAddress.getValue():' +  HXAddress.getValue() + ' firstScreenID:' + parentScreen.firstScreenID);
		//Out.dumpStack(CallStack.callStack());
		//trace(pathNames._path);
		//trace(pathNames._pathNames.toString());
		//trace(title);
		if (pathNames.length >0 ) 
		{			
			getScreen(HXAddress.getValue());
			//getScreen(~/%2F/g.replace(pathNames.value, '/'));
			return;
		}
		//if(parentScreen.firstScreenID != 'home')
		getScreen(parentScreen.firstScreenID);
	}	
	
	override public function addChildren()
	{
		//children = xNode.elements();
		//cells = new Array();
		//Out.dumpStack(CallStack.callStack());
		super.addChildren();				
		//addEventListener("enterFrame", wait4children);
		trace ('resourceList.isEmpty:' + resourceList.isEmpty());
		if(resourceList.isEmpty())
			layout();		
		else
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children,false,0,true);
	}
	
	override function getChildrenDims() 
	{
		maxW = maxH  = cW = cH = 0;
		getMaxDims();	
		//trace(maxContentDims);
		applyMargin();
		//trace(maxContentDims);
		//dynamicBlocks  = new TypedDictionary < BaseCell, Array<Float> > ();
		dynamicBlocks  = new ObjectMap <BaseCell, Dynamic>();
		//var exp:Array<Float> = new Array();
		//CONTAINER LAYOUT BEHAVES LIKE COLUMN LAYOUT
		//var dims:Dims = { width:0, height:0 };
		var mH:Float = (parentScreen.menu != null) ? parentScreen.menu.cells[0].box.height:0;
		var fixedSum:Float = 0;
		for (c in cells) {
			//c.layout();
			c.getBox();//PARSE ATTS AND GET CHILD DIMS
			//if (c.box.width > maxW) 
				//maxW = c.box.width;
			if (c.box.height < 0)
				dynamicBlocks.set(c, { width:0.0, height:-c.box.height } );		
			else if(c.cAtts.position != 'absolute')
				fixedSum += c.box.height;
			//trace(c.name +' position:' + c.cAtts.position + ' c.box:' + c.box + ':' + c.getBounds(contentView));
		}
		//cW = maxW;
		//cH = maxH;
		trace(name + ' margin.top:' + margin.top + ' margin.bottom:' +  margin.bottom + ' mH:' + mH) ;
		var usableHeight:Float = (fixedHeight? box.height - margin.top - margin.bottom :maxContentDims.height) - fixedSum - mH;
		//trace(name + 'usableHeight:' + usableHeight + ' fixedSum:' + fixedSum + 
			//' box:' + box+ ' maxContentDims.height:' + maxContentDims);
		
		for (k in dynamicBlocks.keys())
		{
			k.box.height = dynamicBlocks.get(k).height * usableHeight;
			trace(k.name + ':' + k.box.height);
		}
		for (c in cells)
		{
			if (c.id == 'screenView')
				continue;
			c.layout();
			if (c.cAtts.position != 'absolute')
			{
				if (cW < c.box.height)
					cW = c.box.height;				
				cH += c.box.height;
			}
		}
		screenBox = new Rectangle(0, 0, box.width, box.height - cH  - mH - margin.top - margin.bottom);		
		var screenView = getChildByID('screenView');
		if (screenView != null)
		{
			//TODO:CHECK 4 SCREENMASK BORDER WIDTH	
			screenView.box = screenBox.clone();
			//screenView.box.top -= 3;
			screenView.box.width -= 6;
			screenView.box.height -= 6;
			screenView.draw();
			screenView.layout();
		}
		//trace(cH + ' cells:' +cells.length + ' menu.height:' + mH + ' screenBox:' + screenBox.toString()); 
	}
	
	override public function layout()
	{ 
		//trace(_parent.maxContentDims);
		//Out.dumpStack(CallStack.callStack());
		getBox();
		//maxContentDims.height = screenBox.height;
		super.layout();
		x = (_parent.box.width - box.width) / 2;
		draw();
		//trace( x + ' box:' + box + ' maxContentDims:' +maxContentDims + ' screenBox:' + screenBox + ' :cH:' + cH);
		//trace(cL +':' + cAtts.alpha + ':'  + alpha);
		//TODO:FLEXIBLE LAYOUT 
		//var mH:Float = (parentScreen.menu != null) ? parentScreen.menu.cells[0].box.height :0;
		//trace(cH + ' cells:' +cells.length + ' menu.height:' + menu);
		//trace(Application.instance.resizing + ':' + name + ' layoutRoot:' + layoutRoot.name);		
		if (Application.instance.resizing)
		{	//return;
			//Application.instance.resizing = false;
			if (actScreen != null) {
				updateScreenBox();
				actScreen.resizeNow();
			}
			return;
		}
		else
		{//FIRST LAYOUT  - INIT BG*/
			var maskRef:XML = xNode.xmlWithAttribute('screenMask', 'true');
			if (maskRef != null)
			{
				screenBox = screenMask.getBounds(parent);
			//screenView.x = screenBox.x;
			//screenView.y = screenBox.y;
				screenBox.offset( -x, -y);
				trace('screenBox:' + screenBox + ' mouseEnabled:' + mouseEnabled);
				//Out.dumpLayout(screenMask);
				//screenView.mask = screenMask;
			}
			//else 
			//{
			screenView.x = screenBox.x;
			screenView.y = screenBox.y;					
		}
		//if(parentScreen.firstScreenID != 'main')
		if ( isMainFrame )
		{
			trace('isMainFrame - adding onChange2HXAddress');
			HXAddress.change.add (onChange);
			//HXAddressManager.init();
			//SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange, false, 0, true); 	
		}
		trace('URL:' + Lib.current.loaderInfo.url);
		if (timeLine != null)
			dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_COMPLETE));
	}
	
	/*function removeChildren()
	{
		while(contentView.numChildren>0)
		{
			var child:Dynamic = contentView.removeChildAt(0);
			if (Type.getInstanceFields(Type.getClass(child)).contains('destroy'))
				child.destroy();
			child = null;
		}
	}*/
	
	public function resize()
	{
		trace(Application.instance.resizing);
		layoutRoot = this;

		if (resourceList != null && !resourceList.isEmpty())
		{
			trace('oops');
			addEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children, false, 0, true);
		}
		else
			layout();
	}

}