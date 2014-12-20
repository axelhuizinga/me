/**
 *
 * @author ...
 */

package me.cunity.ui;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BitmapFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.StyleSheet;
import haxe.ds.ObjectMap;
//import sandy.HaxeTypes.Haxe;

import flash.xml.XML;
import flash.xml.XMLList;
import haxe.ds.GenericStack;
import haxe.CallStack;
import haxe.Timer;
import me.cunity.animation.LookAtMouse;
import me.cunity.animation.TimeLine;
import me.cunity.data.Parse;
import me.cunity.tools.ArrayTools;

import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.ResourceEvent;
import me.cunity.graphics.Filter;
import me.cunity.layout.Alignment;
import me.cunity.core.Application;
import me.cunity.core.Types;
import me.cunity.text.Format;
import me.cunity.ui.BaseCell;
import me.cunity.ui.progress.Progress;
using  me.cunity.tools.ArrayTools;
using me.cunity.tools.XMLTools;

class Container extends BaseCell
{	
	public var actChildIndex:UInt;
	public var actScreen:Screen;
	public var children:XMLList;
	public var enabled:Bool;
	public var fixedChildrenDims:Dims;
	public var gridDims:Array<Array<Float>>;
	public var resourceList(default, set):GenericStack<DisplayObject>;	
	//public var childrenAdding:Bool;
	//public var idMap:flash.utils.TypedDictionary<BaseCell, String>;
	public var timeLine:TimeLine;
	public var initObjects:Array<Dynamic>;
	public var gridRelayout:Bool;
	public var resizing:Bool;
	public var screenBox:Rectangle;
	public var screenMask:Sprite;
	
	var actChild:BaseCell;
	var aTween:STween;
	var pendingLayoutContainers:Array<BaseCell>;
	//var dynamicBlocks:flash.utils.TypedDictionary<BaseCell, Array<Float>>;	
	var dynamicBlocks:ObjectMap<BaseCell, Dynamic>;	
	var isCompositing:Bool;
	var isHiding:Bool;
	var isShowing:Bool;
	var pMask:Dynamic;
	var sameWidth:Bool;
	var sameHeight:Bool;
	var maxW:Float;
	var maxH:Float;
	var cW:Float;
	var cH:Float;
	var cVFilters:Array<BitmapFilter>;
	
	public function new(xN:XML, p:Container) 
	{
		cells = new Array();		
		//contentView = new BaseCell(null, this);
		contentBox = new Rectangle();
		super(xN, p);
		contentView = new BaseCell(null, this);
		//contentView.blendMode = BlendMode.LAYER;
		content = addChild(contentView);
		//trace(p == null );
		//if (p == null || Std.is(this, Application))
		if (p == null || xN.elements('Frame').length() >0)
			return;

		timeLine = _parent.timeLine;
		//trace( _parent.name + ':'  + _parent.iDefs);
		iDefs = _parent.iDefs;
		if (cAtts != null && cAtts.filter != null && iDefs.filters !=null)
		{
			cVFilters = new Array();
			var filterNames:Array<String> = cAtts.filter.split(',');
			//trace(filterNames);
			for (f in filterNames)
			{
				//trace(f + ':' + iDefs.filters.get(f));
				cVFilters.push(iDefs.filters.get(f));
			}
			//trace(cVFilters.length);
			contentView.filters = cVFilters;
			//content.filters = cVFilters;
		}
		children = xNode.elements();
		//trace ((this == layoutRoot) + ' || ' +  (this == menuRoot));
		if (this == layoutRoot || this == menuRoot)
			resourceList = new GenericStack<DisplayObject>();
		//
		if (Std.is(this, Screen) && cAtts.textFormat)
		{
			//iDefs.styleSheet = null;
			//iDefs.textFormat = cAtts.textFormat;
			trace(iDefs.textFormat);
		}
		addChildren();			
	}
	
	
	public function addChildren() 
	{
		for (actChildIndex in 0...children.length()) 
		{
			var child:XML = children[actChildIndex];
			var cName:String = child.name();
			//
			switch(cName) {
				case 'BackGround':			
				if (bG == null)
					bG = new BackGround(this);
				bG.add(child, child.attribute('id').toString() == cAtts.BackGround);		
				case 'Copy':
				if (pendingLayoutContainers == null)
						pendingLayoutContainers = new Array();		
				pendingLayoutContainers.push(new Copy(child, this));
				
				case 'Drawing':
				cells.push(new Drawing(child, this));
				case 'Filters':
				Filter.menuRoot = menuRoot;
				cAtts.filters = Filter.addFilters(child, cAtts.filters);		

				case 'StyleSheet'://TODO. test nested StyleSheet handling
				cAtts.styleSheet = new  StyleSheet();
				cAtts.styleSheet.parseCSS(xNode.toString());
				case 'TextField':
				if(cAtts.textField == null)
					cAtts.textField = { };
				Parse.inheritAtts(cAtts.textField, Format.getTextFieldArgs(xNode));
				case 'TextFormat':
				//TODO test nested TextFormat handling
				Format.createFormat(cAtts.textAtts, child);
				case 'TimeLine':
				timeLine = new TimeLine(this, child);
				//case 'Tween', 'PathTween', 'STween' :
				//_parent.timeLine.addTween(this, child);
				case 'Tween', 'PathTween', 'STween', 'Screen' :
				//case  'Screen' :
				//these are handled not here
				continue;
				
				case 'LookAtMouse':
				new LookAtMouse(xNode, this);
				
				default:
				//trace(child.name());
				cName = child.getClassPath();
				//trace(child.name());
				//trace(cName);
				/*#if debug
				try{
					//var actChild:Dynamic = Type.createInstance(DynaBlock.getClass(cName), [child, this]);
					// = DynaBlock.create(child, this);
					//var actChild:Dynamic = DynaBlock.create(child, this);
					//if(DynaBlock.getClass(cName) == Login
					var actChild:Dynamic = DynaBlock.create(child, this);
					//trace(cells.length + ':'  + actChild.id + ':' + actChild +':' +  contentView);
					cells.push(actChild);
					contentView.addChild(actChild);
					//trace(name +' add:' +cName + ' 2 contentView:' + contentView + ' @depth:' + contentView.getChildIndex(actChild));
				}
				catch (ex:Dynamic)
				{
					trace(ex + ':' + name +' adding:' + cName + ':' + DynaBlock.getClass(cName));
				}
				#else*/
				var actChild:Dynamic = DynaBlock.create(child, this);
				//trace(cells.length + ':'  + actChild + ':' + contentView);
				if (Std.is(actChild, BaseCell) )
				{
					cells.push(actChild);
					contentView.addChild(actChild);					
				}					
				//#end
			}
		}
	}	

	
	public function center():Void
	{
		x = (Lib.current.stage.stageWidth - width) / 2;
	}
	
	public function getChildByID(cID:String, deep:Bool = true):BaseCell
	{
		for (c in cells)
		{
			if (deep && Std.is(c, Container))
			{
				var con:Container = cast(c, Container);
				var res:BaseCell = con.getChildByID(cID, deep);
				if (res != null)
					return res;
			}
			if (c.id == cID)
				return c;
		}
		return null;
	}
	
	function getChildrenDims() 
	{		
		maxW = maxH  = cW = cH = 0;
		getMaxDims();
		applyMargin();

		dynamicBlocks  = new ObjectMap <BaseCell, Dynamic>();
		//var exp:Array<Float> = new Array();
		//CONTAINER LAYOUT BEHAVES LIKE COLUMN LAYOUT
		//var dims:Dims = { width:0, height:0 };
		var fixedSum:Float = 0;
		//fixedChildrenDims = { width:0.0, height:0.0 };
		//TODO:HANDLE DYNAMICS BETTER
		for (c in cells) {
			//c.layout();
			c.getBox();//PARSE ATTS AND GET FIXED CHILD DIMS
			//if (c.box.width > maxW) 
				//maxW = c.box.width;
			if (c.box.height < 0)
				dynamicBlocks.set(c, { width:0.0, height:-c.box.height } );		
			else if(c.cAtts.position != 'absolute')
				fixedSum += c.box.height;
			//trace(c.name +':' + c.box + ':' + c.getBounds(contentView));
		}
		//trace(name + ' max:' + maxW + ' x ' + maxH) ;
		var usableHeight:Float = (fixedHeight? box.height - margin.top - margin.bottom :maxContentDims.height) - fixedSum;
		//trace(name + 'usableHeight:' + usableHeight + ' fixedSum:' + fixedSum + ' box:' + box.height);

		for (k in dynamicBlocks.keys())
		{
			k.box.height = dynamicBlocks.get(k).height * usableHeight;
			k.updateBox();
			//trace(k.name + ':' + k.box.height);
		}
		for (c in cells)
		{
			c.layout();
			if (c.cAtts.position != 'absolute')
			{
				if (cW < c.box.width)
					cW = c.box.width;				
				cH += c.box.height;
				//trace(name + ' cW:' + cW + ' cH:' +cH + ':' + c.box);
			}
		}
	}
	
	override public function layout()
	{//Column style layout
		//trace(name);
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
				box.height = cH;		
			box.height +=  contentMargin.top + contentMargin.bottom;				
		}
		//Out.dumpStack(CallStack.callStack());
		if(false){
			if(_parent != null)
			trace(name + ':initial cH:' + cH + ' box:' + box  + ':' + maxContentDims + ':' + _parent.name + ':' + _parent.cL +
				' _parent.box:' + _parent.box + ' cells:'+ cells.length);
			else
			trace(name + ':initial cH:' + cH + ' box:' + box  + ':' + maxContentDims );
		}
		for (c in cells) 
		{//SET SIZE //(AND PAINT BG)
			c.draw();
			//trace(Std.string(c.box) +':' + cH + ' c.margin.top:' + c.margin.top);
		}
		//trace(box + ' cH:' + cH);
		//trace(name +':' + cL +':' +Type.getSuperClass(cL) );
		var aY:Float = 0;// margin.left;
		var aX:Float = 0;// margin.top;
		//trace(box);
		switch(cAtts.align) {
				case 'CM'://'Center Middle'
				aY = (box.height  - cH) / 2;
				aX = (box.width  - cW) / 2;
				case 'C':
				aY = 0;
		}		
		if(cL == Frame)
		trace(aY + ' margin:' + Std.string(margin));
		for (c in cells) 
		{//PLACE CHILDREN	
			//if(Application.instance.resizing)trace(name +' child:' + c.name + ' child.box:' + c.box + ' c.x:' + c.x + ' c.y:' + c.y); 			
			switch(cAtts.align) {
				case 'C', 'CM'://'Center Middle'
				c.x =  (box.width - c.box.width) / 2;
				c.y = c.contentMargin.top + aY;					
				default:
				c.x =  aX;
				c.y =  aY;								
			}
			//if(Application.instance.resizing)
			//if(cL == Overlay)
			//trace(name +' child:' + c.name + ' child.box:' + c.box + ' c.x:' + c.x + ' c.y:'+ c.y);
			//if (c.id == 'frameBorder')
				//Out.dumpLayout(c);
			//Timer.delay(function() { Out.dumpLayout(c); }, 3000);
			//trace(name + ':' + Std.string(box) + ' -> ' + c.name + ':' + Std.string(c.box));				
			if (false && c.content != null) {					
				c.content.x = c.x;// + c.margin.left;
				c.content.y = c.y;// + c.margin.top;		
				//trace('content:' + c.content.x  + ' x ' + c.content.y );
			}			
			//c.visible = true;
			//trace (c.label.text + ':' + aY + ':' + c.box.height);
			//Out.dumpLayout(c, true);
			if(c.cAtts.position != 'absolute')
			aY += c.box.height;
			c.visible = cAtts.visible == null || Parse.att2Bool(cAtts.visible);
			//c.visible = Parse.att2Bool(cAtts.visible);
		}
		//trace(name +':' + Std.string(box) + ' bgImg:' + bgImg);
		/*if (bgImg != null) {
			drawBgImg();	
		}*/
		//x = box.x;
		//y = box.y;	
			//bG.select(xNode.elements('BackGround')[0].attribute('id').toString());
		if (Application.instance.resizing)
		{
			if (bG != null)
				bG.set();			
		}
		else 
		{
			if(pendingLayoutContainers != null)
				for (c in pendingLayoutContainers)
					c.layout();					
		}


	}
	
	public function initHideMethod(direction:String, method:String = 'SLIDE') 
	{
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
						width:box.width,
						onComplete:finishShow
					}
				}
			}
		}
		//trace(Std.string(pMask));
	}
	
	public function finishHide() {
		//trace(isHiding);
			visible = false;
		isHiding = false;
		//menuRoot.container2hide.delete(this);
		//trace(menuRoot.container2hide.isEmpty());
	}
	
	public function finishShow() {
		//trace(isShowing+':' + Std.string(pMask.show));
		//trace(name);
		//trace(contentView.getBounds(Lib.current) + ' mask:' + contentView.mask.getBounds(Lib.current));
		isShowing = false;
	}
		
	override public function hide() {
		//trace (isHiding);
		if (isHiding)
			return;
		isHiding = true;
		isShowing = false;
		if (aTween != null)
			STween.removeTween(aTween);
		aTween = STween.add (contentView.mask, 0.5, pMask.hide );		
		//aTween = STween.add (contentView.dMask, 0.5, pMask.hide );		
		//contentView.mask.x = -width;
	}
	
	
	override public function show() 
	{
		trace(isShowing +':' + Std.string(pMask.show));
		if (isShowing)
			return;
		visible = true;
		//trace(name + ' added2 container2hide');
		//trace(name + ':' + pMask);
		if (aTween != null)
			STween.removeTween(aTween);
		aTween = STween.add (contentView.mask, 0.5, pMask.show );
		isShowing = true;
		isHiding = false;
		//contentView.mask.x = 0;
	}
	
	public function addResource(res:DisplayObject)
	{
		if (resourceList == null)
		{
			//trace(name + ':' + _parent.name);
			resourceList = new GenericStack<DisplayObject>();
			//addEventListener(ResourceEvent.RESOURCES_COMPLETE, resourceReady,false,0,true);
		}
		resourceList.add(res);
	}
	
	public function wait4children(evt:ResourceEvent) 
	{
		trace(name);
		if (evt.params.cL != cL)
			return;//	NOT 4 ME		
		if (resourceList == null)
		{
			trace(name + ':' + _parent.name);
			return;
		}
		resourceList = null;
		removeEventListener(ResourceEvent.RESOURCES_COMPLETE, wait4children);
		layout();
	}
	
	public function resourceReady(res:DisplayObject)
	{
		if (resourceList == null)
		{			
			trace(name + '::tryin 2 remove:' + res.name + ':' + resourceList);
			Out.dumpStack(CallStack.callStack());
			return;
			
		}		
		resourceList.remove(res);
		//trace(name + '::removin:' + res.name + ':' + resourceList.isEmpty());
		if (resourceList.isEmpty())
		dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCES_COMPLETE, {cL:Type.getClass(this)}));
		//TODO:replace by simple callback
	}
	
	public function setMouseEnabled(iO:InteractiveObject, recursive:Bool = false, enabled:Bool = false)
	{
		try
		{
			iO.mouseEnabled = enabled;		
		}
		catch (ex:Dynamic)
		{
			return;
		}

		if (recursive && iO.parent != null && iO.parent != contentView)
		{
			setMouseEnabled(iO.parent, recursive, enabled);
		}
	}
	
	override public function destroy()
	{
		try{
			while(contentView.numChildren>0)
			{
				var child:Dynamic = contentView.removeChildAt(0);
				//if (Type.getInstanceFields(Type.getClass(child)).contains('destroy'))
				//var cName:String = '';
				//child.name;
				//trace(child);
				if (child != null) {
					//cName = child.name;
					//trace(child + ':' + cName);
					child.destroy();
					//trace( ' successfuly destroyed:' + cName);
				}
				//child = null;
			}
			children = null;
			super.destroy();
		}
		catch (ex:Dynamic) { trace(ex);}
	}
	
	function set_resourceList(rL:GenericStack<DisplayObject>):GenericStack<DisplayObject>
	{
		resourceList = rL;
		trace(name + '-----------------' + (resourceList == null ?  null :resourceList.isEmpty()));
		return resourceList;
	}
	
}