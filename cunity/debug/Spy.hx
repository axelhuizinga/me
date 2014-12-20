/**
 *
 * @author Axel Huizinga
 */

package debug;
import debug.spy.DisplaySymbol;
import debug.spy.RelationSet;
import debug.spy.SymbolsContainer;
import debug.spy.XRtti;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.display.Loader;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.geom.Matrix;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.xml.XML;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;
import me.cunity.ui.HeadLabel;
import me.cunity.text.Format;
//import me.cunity.tools.ArrayTools;
import me.cunity.tools.ListTools;
import haxe.Http;
import haxe.io.Bytes;
import haxe.Log;
import haxe.Resource;
import haxe.xml.Fast;
//import Type;

import flash.display.DisplayObject;
import flash.external.ExternalInterface;
import flash.Lib;
import haxe.rtti.CType;

//class Spy extends Sprite
class Spy extends Sprite
{
	
	public static var actProps:Dynamic;	
	var rootName:String;
	var swfUrl:String;
	public static var displayClassesRtti:Map<TypeTree>;
	//public static var displayClasses:Array<String>;
	public static var displayClasses:List<String>;

	public static var rootSymbol:DisplaySymbol;
	public static var currentSymbol:DisplaySymbol;
	public static var focusBox:Sprite;
	public static var loadedType:Dynamic;
	public static var loadedReflect:Dynamic;
	public static var spyRoot:Spy;
	public static var ui:Sprite;
	public var autoInit:Bool;
	public static var invertColors:Bool;
	static var rootObject:Dynamic;
	var swfLoader:Loader;
	var tTree:TypeTree;
	public static var displaySymbols:Map<DisplaySymbol>;

	public static var margin:Float = 5.5;
	public static var uiWidth:Float;
	public static var uiHeight:Float;
	public static var readOnly:Map<Map<Bool>>;
	public static var relSetContainer:Sprite;
	public static var symbolsContainer:SymbolsContainer;
	public var labelStyle:Dynamic;
	//public static var myStage:Stage;
	public static var applicationBar:HeadLabel;
	
	//public function new(dC:DisplayObjectContainer, param:Dynamic){
	public function new(param:Dynamic){
			
			//?swfUrl:String, 
			//?showInherited:Null<Bool> = true, ?recursive:Null<Bool> = true, 
			//?manual:Bool = true,	?iC:Bool = false) {
		super();

		spyRoot = this;
		displaySymbols = new Map();
		swfUrl =  param.swfUrl;
		var rttiPath = param.rttiPath == null ? ~/swf$/.replace(swfUrl, 'xml') :param.rttiPath;
		autoInit = (param.autoInit == 'true');
		rootName = param.rootName;
		invertColors = param.invertColors;
		DisplaySymbol.showInherited = param.showInherited;
		DisplaySymbol.recursive = param.recursive;
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, init);
		var request:URLRequest = new URLRequest(rttiPath);
		trace(swfUrl +' - '  +rttiPath);
        loader.load(request);
		//init();
		//loadSwf2Spy();
	}
	
	function loadSwf2Spy(){
		swfLoader = new Loader( );
		swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		swfLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
		swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);		
		swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		var request:URLRequest = new URLRequest(swfUrl);
		var context:LoaderContext = new LoaderContext();
		//context.applicationDomain =  ApplicationDomain.currentDomain;	
		context.applicationDomain =  new ApplicationDomain();
        //trace(context.applicationDomain == ApplicationDomain.currentDomain);	
       // trace(context.applicationDomain.parentDomain == ApplicationDomain.currentDomain);	
		swfLoader.load(request, context);

		var di:DisplayObject = addChild(swfLoader);
		rootSymbol = null;
		//myStage.addEventListener(KeyboardEvent.KEY_UP, this.dispatchKey, false);
		Lib.current.addEventListener(KeyboardEvent.KEY_UP, this.dispatchKey, false);
		ExternalInterface.addCallback("updateFields", updateFields);

	}
	
	public function dispatchKey(event:KeyboardEvent) {
		//trace(event.keyCode);
		handleKey(event.keyCode);
	}
	static function handleKey(kCode:UInt) {
		//trace(kCode);
		switch(kCode) {
			case 37:
			//initCollapse(false);
			case 39:
			//initCollapse(true);
		 }		
	}
	
	
	function updateFields(obName:String, fds:Dynamic) {
		//trace(obName + ':' + Std.string(fds));		
		trace(obName );		
		//trace(Std.string(actProps));
		var keys:Array<String> = Reflect.fields(fds);
		var dSymbol:DisplaySymbol = displaySymbols.get(obName);
		//var updateObj:DisplayObject = displayObjects.get(obName);
		var updateObj:DisplayObject = dSymbol.displayObject;
		//trace(updateObj.parent.getChildIndex(updateObj));
		for (key in keys) {
			//if ( dSymbol.readOnly.get(key)) continue;//SKIP READONLY FIELDS
			if ( readOnly.get(dSymbol.classPath).get(key)) continue;//SKIP READONLY FIELDS
			//trace(key + ':' + Std.string(Reflect.field(actProps, key)) + ' == ' + Reflect.field(fds, key));
			if (Std.string(Reflect.field(actProps, key)) == Reflect.field(fds, key))
				continue;//SKIP UNCHANGED
			if ( dSymbol.fieldType.get(key) == 'Bool'){
				var v:String =  Reflect.field(fds, key);
				//loadedReflect.setField(updateObj, key, (v == 'true' || v == '1'));
				untyped updateObj[key] = (v == 'true' || v == '1');
				dSymbol.fields.set(key,untyped updateObj[key] );
				//Reflect.setField(updateObj, key, (v == 'true' || v == '1'));
				//trace('setBool2:' + Reflect.field(updateObj, key));
				//trace(loadedReflect);
				//trace(loadedReflect == Reflect);
				//trace('setBool2:' + loadedReflect.field(updateObj, key));
			}
			else {
				untyped{
					updateObj[key] = fds[key];
					dSymbol.fields.set(key, fds[key]);
					if (key == 'name') {
						displaySymbols.remove(obName);
						displaySymbols.set(fds[key], dSymbol);
						applicationBar.label.text = dSymbol.labelText = fds[key];
						trace(fds[key]);
					}
				}
			}
		}
		//trace(updateObj.parent.getChildIndex(updateObj));
		DisplaySymbol.activeSymbol.dumpFields();
		DisplaySymbol.drawFocus(updateObj);
	}	
	
	public static function addRtti(fNode:XMLNode) {
		//trace(fNode.attributes.path);
		//return;
		var tTree:TypeTree = null;
		try{
			var nodeXml = Xml.parse(fNode.toString());
			tTree= new haxe.rtti.XmlParser().processElement(nodeXml.firstElement());
		}
		catch (ex:Dynamic) {
			trace(ex);
		}
		displayClassesRtti.set(fNode.attributes.path, tTree);
		//if (fNode.attributes.path == 'me.cunity.ui.VideoClip') trace(tTree);
	}
		
	
	public static function getTypeTree(ob:Dynamic, cP:String):TypeTree {
		//trace(Std.string(ob) +' cP:' + cP);
		if (cP == null) {
			//trace(loadedType);
			//trace(Type.typeof(ob));
			//cP = Type.getClassName(Type.getClass(ob));		
			cP = Type.getClassName(loadedType.getClass(ob));		
		}
		//var cL:Class<Dynamic> = (cP == null) ? Type.getClass(ob) :Type.resolveClass(cP);
		//trace(cP);
		//if (ArrayTools.contains(displayClasses, cP)) {
		if (ListTools.contains(displayClasses, cP)) {
			//trace(cP);
			return displayClassesRtti.get(cP);
		}
		return null;
	}
	
	function init(event:Event) {
		//displayClasses.push(className);
		displayClassesRtti = new Map();
		var xRtti:XRtti = new XRtti(event.target.data);
		displayClassesRtti = xRtti.getXClasses();
		//displayClasses = ArrayTools.It2Array(displayClassesRtti.keys());
		var it:Iterator<String> = displayClassesRtti.keys();
		displayClasses = ListTools.fromIt(it);
		//trace(displayClasses);
		readOnly = new Map();
		it = displayClasses.iterator();
		while (it.hasNext())
			readOnly.set(it.next(), new Map());
		trace(parent.name + ':autoInit:' + autoInit);
		//trace(myStage);
		uiWidth = Lib.current.stage.stageWidth * .3;
		uiHeight = Lib.current.stage.stageHeight;	
		ui = new Sprite();
		parent.addChild(ui);
		ui.x = Lib.current.stage.stageWidth - uiWidth - 2;
		focusBox = new Sprite();
		ui.addChild(focusBox);
		relSetContainer = new Sprite();
		//graphics.lineStyle(0, 0xffffff);
		//graphics.beginFill(0xaaaaaa);
		var cornerRadius:UInt = 6;
		var fillType:GradientType = GradientType.LINEAR;
		var colors:Array<UInt> = [0x111111, 0xAAAAAA, 0xCCCCCC, 0x111111];
		var alphas:Array<Float> = [1.0, 1.0, 1.0, 1.0];
		var rampWidth :UInt = Math.floor(0xFF/ uiWidth * 5);
		var ratios:Array<UInt> = [0x00, rampWidth, 0xFF - rampWidth, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(uiWidth, 20, 0, 0, 0);
		var spreadMethod:SpreadMethod = SpreadMethod.PAD;
		ui.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		//trace(displaySymbols.displayObject.name + ':' +label);
		var tF:TextFormat = new TextFormat();
		tF.font = 'Arial';
		tF.color = 0x000060;
		tF.size = 13;
		applicationBar = new HeadLabel();
		applicationBar.init(tF, 
			{backGroundColor:0xfaca64, width:uiWidth, marginX:margin, marginY:2, cornerRadius:cornerRadius }
		);
		ui.graphics.drawRoundRectComplex(0.0, 0.0 + applicationBar.height, uiWidth, 
		uiHeight - applicationBar.height - 2, 0, 0, cornerRadius, cornerRadius);		
		colors = [0x111111, 0xffca64, 0xfacc64, 0x111111];
		applicationBar.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
		applicationBar.graphics.drawRoundRectComplex(0, 1, uiWidth, applicationBar.height, 
		cornerRadius, cornerRadius, 0, 0);
		applicationBar.addEventListener(MouseEvent.MOUSE_UP, spyIt);
		symbolsContainer = new SymbolsContainer();
		//symbolsContainer.addChild(relSetContainer);		
		
		var scrollMask:Sprite = new Sprite();
		scrollMask.graphics.beginFill(0);
		scrollMask.graphics.drawRect(
			0, margin, uiWidth, uiHeight - applicationBar.height - margin
		);

		//symbolsContainer.mask = scrollMask;
		//ui.addChild(symbolsContainer);
		ui.addChild(scrollMask);
		ui.addChild(applicationBar);
		Out.dumpLayout(ui);
		ExternalInterface.addCallback("handleKey", handleKey);
		//trace(displayClasses);
		loadSwf2Spy();
		//trace(displayClasses);
	}
	
	function initHandler(event:Event):Void {
		trace("initHandler:" + event);
	}

	function ioErrorHandler(event:IOErrorEvent):Void {
		trace("ioErrorHandler:" + event);
	}
	
	
	function loadComplete(?event:Event) {
		//trace(displayClasses);
		var loadedMain:Dynamic = null;
		try{
		trace(swfLoader);        
			loadedMain = swfLoader.contentLoaderInfo.applicationDomain.getDefinition('Main');
			loadedType = swfLoader.contentLoaderInfo.applicationDomain.getDefinition('Type');
			//loadedReflect = swfLoader.contentLoaderInfo.applicationDomain.getDefinition('Reflect');
			//loadedMain.Main();		
			//trace(Type.typeof(loadedMain.Main));
			//trace(swfLoader.content.name);
			//var di:DisplayObject = addChild(swfLoader.content);
			//Out.dumpLayout(swfLoader);
			//Out.dumpLayout(swfLoader.content);
		}
		catch (ex:Dynamic) {
			trace(ex);
		}
		if (autoInit)
			getRootObject();
		else
			applicationBar.label.text = 'Start Spy';

	}
	
	
	function getRootObject() {
		if (rootName != null) {
			var dOC:DisplayObjectContainer = cast(swfLoader.content, DisplayObjectContainer);
			var nC:UInt = dOC.numChildren;
			for (n in 0...nC) {
				var child:DisplayObject = dOC.getChildAt(n);
				if (child.name == rootName) {
					rootObject = child;
					break;
				}
			}
			//rootObject = swfLoader.contentLoaderInfo.applicationDomain.getDefinition('SiteMap');
			rootObject = swfLoader.contentLoaderInfo.applicationDomain.getDefinition(rootName);
			trace(rootObject + ' -> ' + Type.getClassName(rootObject));
			trace(Type.typeof(rootObject.initRoot));
			var dims:Dynamic = rootObject.initRoot('home');
			trace('dims:' + Std.string(dims));
			rootObject.showRoot( { pageHeight:height, menuXslide:0, stageTop:0 } );
			rootObject.drawBg({pageHeight:119, stageTop:0});
		}
		else {	
			var dOC:Dynamic = swfLoader.content;
			rootObject = dOC.getChildAt(0);
			//trace(rootObject.name);
			//var dims:Dynamic = rootObject.initRoot('home');
			//trace('dims:' + Std.string(dims));
			//rootObject.drawBg({pageHeight:119, stageTop:0});
			//rootObject.showRoot({pageHeight:height, menuXslide:0, stageTop:0});
		}
		trace(rootObject.name);
		//trace(ApplicationDomain.currentDomain.getDefinition(Type.getClassName(rootObject)));
		applicationBar.label.text = 'Start Spy :' + rootObject.name;
		//swfLoader.content.x = swfLoader.content.y = 0;
		swfLoader.content.visible = true;
		Out.dumpLayout(swfLoader.content);

		//Out.dumpLayout(swfLoader.content.getChildAt(0));
		//var sm:Dynamic = swfLoader.content.getChildAt(0);
		//sm.initRoot(

	}
	
	function progressHandler(event:ProgressEvent):Void {
		//trace("progressHandler:bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		applicationBar.label.text = 'Loading... '+ Std.string(event.bytesLoaded / event.bytesTotal * 100) + '%';
	}	

	/*function spyObject(swf2spy:DisplayObject, ?iC:Bool = false, ?manual:Bool = false) {
		invertColors = iC;
		//activateManual = manual;
		rootObject = swf2spy;
		init(swf2spy.parent);
		if (!manual)
			spyIt();
	}*/
	
	function spyIt(?event:MouseEvent) {
		if (!autoInit)
			getRootObject();
		trace(flash.Lib.current.name + ':' + rootSymbol);
		if (rootSymbol != null) {
			trace(rootSymbol.root.name + ':' + rootSymbol.parent.name);
			rootSymbol.parent.removeChildAt(rootSymbol.parent.getChildIndex(rootSymbol));
			//flash.Lib.current.removeChildAt(Lib.current.getChildIndex(rootSymbol));
			//displayClasses.pop();
			rootSymbol = null;
			symbolsContainer.reset();
		}
		//var ob:Dynamic = null;
		//var getRootObject:Dynamic = swfLoader.contentLoaderInfo.applicationDomain.getDefinition('getClip');
		trace(rootObject);
		//trace(Type.getClassName(Type.getClass(rootObject)));
		//trace(loadedType.getClass(rootObject));
		
		new DisplaySymbol(rootObject);
		//ExternalInterface.call('dumpObject', rootSymbol);
		//symbolsContainer.layout();
		//rootSymbol.showRelations();
		//rootSymbol.draw();
	}
	
}