/**
 *
 * @author Axel Huizinga
 */

package debug.spy;
import debug.Spy;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.display.Sprite;
import haxe.rtti.CType;
import me.cunity.tools.ArrayTools;
import me.cunity.tools.ClassTools;
import me.cunity.ui.Label;
import Type.ValueType;

//class DisplaySymbol extends Sprite
class DisplaySymbol extends Sprite
{

	public static var w:Float = 15;
	public static var h:Float = 15;
	public static var margin:Float = 2;
	public var childAnchorPoint(getChildAnchor, null):Point;
	public var parentAnchorPoint(getParentAnchor, null):Point;
	public var children:Map<DisplaySymbol>;
	//public var children:Array<DisplaySymbol>;
	public var collapsed:Bool;	
	public var index:Int;
	public var level:Int;
	public var classPath:String;
	public var labelText:String;
	var parentSymbol:DisplaySymbol;
	var readOnly:Map<Bool>;
	var relSet:RelationSet;
	public static var activeSymbol:DisplaySymbol;
	public static var recursive:Bool;
	public static var showInherited:Bool;
	public var displayObject:DisplayObject;
	public var fields:Map<Dynamic>;
	public var fieldType:Map<Dynamic>;	
	static var dotBmpH:BitmapData;
	static var dotBmpV:BitmapData;
	
	public static function initDottedBmp():Void {
		var invertColors:Bool = Spy.invertColors;
		var fG:UInt = Spy.invertColors ? 0xffffeeee :0xffaa0000;
		dotBmpH = new BitmapData(4, 1, true, 0xFFFFFFFF);
		dotBmpV = new BitmapData(1, 4, true, 0xFFFFFFFF);
		for (i in 0...4) {
			if ((i + 4) % 4 == 0){
				dotBmpH.setPixel32(i, 0, fG);
				dotBmpV.setPixel32(0, i, fG);
				//trace('setPixel:' + i);
			}
			else{
				dotBmpH.setPixel32(i, 0, 0x00ffffff);
				dotBmpV.setPixel32(0, i, 0x00ffffff);
			}
		}
	}
	
	public function new(dOb:DisplayObject, ?pSymbol:DisplaySymbol = null) 
	{
		super();
		displayObject = dOb;
		parentSymbol = pSymbol;
		//trace(dOb);
		//children = new Array();
		children = new Map();
		collapsed = false;		
		level = 0;
		//index = idx;
		fields = new Map();
		fieldType = new Map();
		readOnly = new Map();		
		//trace(parentSymbol +' displayObject:' + displayObject.name + ' -> DisplaySymbol:' + name);
		if (parentSymbol != null)
			level = parentSymbol.level + 1;
			//getLevel();
		else{
			Spy.rootSymbol = this;
			level = 0;
		}
		//Spy.symbolsContainer.addSymbol(this);
			/*trace(parentSpyObject.displayObject.name + ' level:' + level + ' index:' +index + ' parent:' +
				parentSpyObject.parentSpyObject.displayObject.name
			);*/
		//}
		/*switch(form) {
			case 'class'
		}*/
		
		//alpha = 0.5;
		labelText = displayObject.name;
		//Spy.symbolsContainer.addChild(this);
		//this.addEventListener(MouseEvent.ROLL_OVER, showLabel);
		//this.addEventListener(MouseEvent.MOUSE_UP, dumpFields);
		Spy.displaySymbols.set(dOb.name, this);
		getFields();
		//trace(classPath + ':' + recursive);
		//trace(displaySymbol +' level:' + displaySymbol.level +' index:' +  displaySymbol.index);
		if (recursive && 
			ClassTools.hasSuperClass(dOb, 'flash.display.DisplayObjectContainer', Spy.loadedType)){//try {
			var dObC:DisplayObjectContainer = cast(dOb, DisplayObjectContainer);
			var nC:Int = dObC.numChildren;
			//trace(nC );
			for (c in 0...nC) {
				var child:Dynamic = dObC.getChildAt(c);
				//trace(c + ':' + displayObject.name + ':' + Type.getClassName(Type.getClass(child)) + ':'+ child.name);
				if ( ClassTools.hasSuperClass(child, 'flash.display.DisplayObject', Spy.loadedType)) {
					//var sP:Spy = new Spy(this, child, showInherited, true);
					//children.push(new DisplaySymbol(child, this));
					var childSymbol:DisplaySymbol = new DisplaySymbol(child, this);
					children.set(childSymbol.labelText, childSymbol);
				}
				//trace(c);
			}			
		}

	/*	if (this.children.length > 0) {
			relSet = new RelationSet(this);
			for (child in children)
				relSet.addChildSymbols(child);
			//relSet.draw();
			Spy.relSetContainer.addChild(relSet);
		}*/
		//if (rootSymbol == this)
			//symbolsContainer.addChild(relSetContainer);
		//var di:DisplayObject = dC.addChild(this);
		//trace(di.name);
		//draw();
	}
	
	//function getFields(ob:DisplayObject, ?cP:String = null):Classdef {
	function getFields( ?cP:String = null):Classdef {
		var tTree:TypeTree = Spy.getTypeTree(displayObject, cP);
		//trace(tTree + ':' + displayObject +':' + cP);
		if (tTree == null)	return null;
		//trace(Type.enumConstructor(tTree));
		if (Type.enumConstructor(tTree) == 'TClassdecl') {
			var cDef:Classdef = Type.enumParameters(tTree)[0];
			//trace(cDef.fields.length);
			if (this.classPath == null){
				classPath = cDef.path;
				readOnly = Spy.readOnly.get(classPath);
			}
			var fIt:Iterator<ClassField> = cDef.fields.iterator();
			while (fIt.hasNext()){
				var n:ClassField = fIt.next();
				//trace(n.name);
				if (n.name == 'new'|| n.name == 'rtti')
					continue;
				if (n.get != haxe.rtti.Rights.RNo) {
					var value:Dynamic = Reflect.field(displayObject, n.name);
					//trace(Reflect.field(displayObject, n.name) == 
					//Spy.loadedReflect.field(displayObject, n.name) );
					//if (Type.getClass(value) != null && 
					/*if (Type.getClass(value) != null && 
					ClassTools.hasSuperClass(value, 'flash.display.DisplayObject')){
						fields.set(n.name, value.name);
						if(!readOnly.exists(n.name)) readOnly.set(n.name, true);
						continue;
					}
					else*/
						fields.set(n.name,  Reflect.field(displayObject, n.name));
				}
				if (n.set == haxe.rtti.Rights.RNo)
					if (!readOnly.exists(n.name)) readOnly.set(n.name, true);
				//trace(Type.enumConstructor(n.type));
				//if(Type.enumConstructor(n.type) == 'CEnum') trace(Type.enumParameters(n.type)[0]);
				if (Type.enumConstructor(n.type) == 'CEnum' && Type.enumParameters(n.type)[0] == 'Bool')
					fieldType.set(n.name, 'Bool');		
			}
			if (showInherited && cDef.superClass != null) {
				//trace(cDef.superClass );
				getFields(cDef.superClass.path);
			}
			return cDef;
		}
		return null;
	}
	
	public function dumpFields(event:MouseEvent=null) {
		if (event != null && event.shiftKey) {			
			//flash.Lib.current.stage.focus = Spy.rootSymbol.applicationBar;
			//return Spy.initCollapse(Spy.currentSymbol.collapsed);
			//return Spy.initCollapse(collapsed);
		}
		if (DisplaySymbol.activeSymbol != null)
			DisplaySymbol.activeSymbol.alpha = 0.5;
		DisplaySymbol.activeSymbol = this;
		alpha = 1.0;
		DisplaySymbol.drawFocus(displayObject);		
		var keys:Array<String> = ArrayTools.stringIt2Array(fields.keys(), true);
		//trace(keys);if (!readOnly.exists(n.name)) 
		var fieldList:Array<String> = new Array();
		Spy.actProps = {};
		for (key in keys) {
			var value:Dynamic = fields.get(key);
			var typeValue:ValueType = Type.typeof(value);
			switch(typeValue) {
				case TBool:
				fieldList.push(key);
				addField(key, value);
				case TClass(c):
				if (Type.getClassName(Type.getClass(value)) == 'String'){
					addField(key, value);
					fieldList.push(key);
				}
				case TInt:
				addField(key, value);
				fieldList.push(key);
				case TFloat:
				addField(key, value);
				fieldList.push(key);
				default:
				continue;								
			}
		}
		ExternalInterface.call('updateList', Spy.actProps, fieldList, 			
		 classPath, displayObject.name);
		//ArrayTools.It2Array(readOnly.keys()), classPath, displayObject.name);
		return;
	}
		
	function addField(key:String, value:String) {
		if(key=='visible')trace(value);
		//trace(key);
		Reflect.setField(Spy.actProps, key, value);
		//Spy.loadedReflect.setField(Spy.actProps, key, value);
	}
		
	function getChildAnchor() {
		var cP:Point = getRect(Spy.symbolsContainer).topLeft;
		cP.y += h / 2;
		return cP;
	}
	
	function getParentAnchor() {
		var cP:Point = getRect(Spy.symbolsContainer).bottomRight;
		cP.y -= h / 2;
		return cP;
	}
	
	function getLevel() {
		var lObject:DisplayObject = displayObject;
		trace(Spy.rootSymbol.name + ' .. ' + lObject.name);
		while (lObject != Spy.rootSymbol){
			level++;
			lObject = lObject.parent;
			trace( '  parent... ' + lObject.name);
		}
	}
	

	function showLabel(event:Event) {
		//event.target.label.visible = true;
		Spy.currentSymbol = this;
		Spy.applicationBar.label.text = event.target.labelText;
	}
	
	public static function drawFocus(ob:DisplayObject) {
		if (dotBmpH == null) initDottedBmp();
		var fRect:Rectangle = ob.getRect(Spy.focusBox);
		//trace(Std.string(fRect));
		Spy.focusBox.graphics.clear();
		Spy.focusBox.graphics.lineStyle(1, 0);
		untyped Spy.focusBox.graphics.lineBitmapStyle(dotBmpH);
		Spy.focusBox.graphics.moveTo(fRect.left, fRect.top);
		Spy.focusBox.graphics.lineTo(fRect.right, fRect.top);		
		Spy.focusBox.graphics.moveTo(fRect.left, fRect.bottom);
		Spy.focusBox.graphics.lineTo(fRect.right , fRect.bottom);
		untyped Spy.focusBox.graphics.lineBitmapStyle(dotBmpV);
		Spy.focusBox.graphics.moveTo(fRect.right , fRect.bottom);
		Spy.focusBox.graphics.lineTo(fRect.right, fRect.top);
		Spy.focusBox.graphics.moveTo(fRect.left, fRect.top);
		Spy.focusBox.graphics.lineTo(fRect.left, fRect.bottom);
	}
}