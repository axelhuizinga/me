package me.cunity.js.dom;

import js.Browser;
import js.html.*;
import js.JQuery;
import js.Lib;
import me.cunity.debug.Out;
import me.cunity.js.data.Parse;
//import me.cunity.js.layout.BaseCell;
import me.cunity.js.layout.Types;

//using me.cunity.js.layout.BaseCell;
//using me.cunity.js.jqx.ext.Common;
import me.cunity.js.jqx.ext.Common;
/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */


class GuiObject implements Dynamic
{
	public function new(){}
	public var pack:Pack;
	public var options:Dynamic;
	public var align:Align;
	public var orient:Orient;
	public var items:Array<Dynamic>;
}

typedef OffSet =
{
	var left:Null<Int>;
	var top:Null<Int>;
}

class BaseCell 
{
	var cAtts:Dynamic;
	public var className(default, set):String;
	public var effects:Dynamic;
	public var enabled:Bool;
	public var element:Element;
	public var node:Node;
	public var alpha:Float;
	public var id(default, set):String;
	public var jQ:JQuery;
	public var offset(default, set):OffSet;
	public var fixedHeight:Int;
	public var fixedWidth:Int;
	public var height:Int;
	public var width:Int;
	public var parent:Container;
	public var subMenu:SubMenu;
	public var applet:Container;
	public var x:Int;
	public var y:Int;
	public var pack:Pack;
	public var options:Dynamic;
	public var align:Align;
	public var orient:Orient;
	public var items:Array<Dynamic>;
	
	var document:Document;
	
	inline function _(sel:Dynamic, ?context):JQuery { return untyped window.jQuery(sel); }
	
	public function new(p:Container, name:String = null, ?cfg:Dynamic, ?doc:Document) 
	{
		parent = p == null ? cast(this, Container) :p;
		if (options == null)
			options = { };
		Common.extend(options, cfg);
		cAtts = { styles:{}};
		document = doc == null ?  Browser.document :doc;
		if (name == null)
			return;		
			
		element = document.createElement(name);
		if(cfg){
			for (p in ['width', 'height', 'id'])
				Reflect.setField(cAtts, p, Reflect.field(cfg, p));
			//trace(Std.string(cAtts));
			if (cfg.style)
			{
				cAtts.style = cfg.style;
				element.setAttribute('style', cfg.style);
			}
			else
			{
				cAtts.style = '';
			}
			
			for (name in ['alpha', 'className'])
			{
				switch(name)
				{
					default:
					if (Reflect.field(cfg, name))
					{
						Reflect.setField(this, name, Reflect.field(cfg, name));
						Reflect.setField(cAtts, name, Reflect.field(cfg, name));
					}
					case 'alpha':
					alpha = (cfg.alpha ? Std.parseFloat(cfg.alpha) :1.0);
				}				
			}
		}
		jQ = new JQuery(element);
		if (parent != this)
		{
			id = parent.id + '_' + (id == null ? Std.string(parent.node.childNodes.length) :id);
			
			applet = parent.applet;
			if (Std.is(this, Container) && Std.is(applet, Menu) )
				applet.jQ.prepend(element);
				//applet.node.appendChild(node);
			else
				parent.node.appendChild(element);
			cAtts.display = jQ.css('display');
			
		}
		//else trace(node.id + ':' + node.nodeName + ' parent:' + (parent == null ? 'null' :parent.node.id + ':' + parent.node.nodeName));
	}
	
	public static function createGuiObject(mObject:Dynamic):GuiObject
	{
		trace('pack:' + Type.createEnum(Pack, mObject.pack));
		var gO:GuiObject = new GuiObject();
		for (f in Reflect.fields(mObject))
		{
			switch(f)
			{
				case 'align':
				gO.align = mObject.align != null ? Type.createEnum(Align, mObject.align) :null;
				case 'orient':
				gO.orient = mObject.orient != null ? Type.createEnum(Orient, mObject.orient) :Orient.L2R;
				case 'pack':
				gO.pack = (mObject.pack != null ? Type.createEnum(Pack, mObject.pack) :Pack.TOPLEFT);
				default:
				Reflect.setField(gO, f, Reflect.field(mObject, f));
			}
		}
		for (f in ['crawlable'])
			if (Reflect.field(mObject, f))
				Reflect.setField(gO.options, f, Reflect.field(mObject, f));
		//trace('<pre>' + Std.string(gO) + '</pre>');
		trace('packRel:' + gO.packRel);
		return gO;
	}	
	
	public function getBox()
	{			
		//CHECK 4 RELATIVE AND FIXED SIZING / POSITION		
		if (cAtts.width) {
			//fixedWidth = true; //TODO:IMPLEMENT OVERFLOW	
			//trace(name + ':' + cell + ':'  + maxContentDims);
			var wUnit:Dynamic = Parse.unitString(cAtts.width);
			//trace( Std.string(wUnit) );		
			if (wUnit)			
			fixedWidth = switch(wUnit[0])
			{
				case '%':// relative to parent cell
				//trace(wUnit + '->' + _parent.name);
				//trace(wUnit + '->' + _parent.maxContentDims);
				Std.int(Std.parseInt(wUnit[1]) / 100) * parent.width;
				//Std.int(Std.parseInt(wUnit[1]) / 100) * parent.content().width;
				//Std.parseFloat(wUnit[1]) / 100 * maxContentDims.width;
				//cAtts.wUnit = '%';
				case '*'://take what you still can get - the value 0.0...1.0 denotes percentage of available space defaults to 1.0 = 100%
				var val = Std.parseInt(wUnit[1]);
				//trace( name +':' + wUnit.toString() + ':' + val);
				(val==0) ? -1 :-val;
				default://px
				Std.parseInt(wUnit[1]);				
			}
			//trace(cell.width);
		}
		if (cAtts.height) {
			//fixedHeight = true;
			var hUnit:Dynamic = Parse.unitString(cAtts.height);
			//trace( Std.string(hUnit) );
			if (hUnit)
			fixedHeight = switch(hUnit[0])
			{
				case '%':// relative to parent cell
				//Std.parseFloat(hUnit[1]) / 100 * maxContentDims.height;
				Std.int(Std.parseInt(hUnit[1]) / 100) * parent.height;
				//Std.int(Std.parseInt(hUnit[1]) / 100) * parent.content().height;
				//cAtts.hUnit = '%';
				case '*'://take all you still can get - the value 0.0...1.0 denotes percentage of available space defaults to 1.0 = 100%
				var val = Std.parseInt(hUnit[1]);
				//trace( name +':' + hUnit.toString() + ':' + val);
				(val==0) ? -1 :-val;
				default://px
				Std.parseInt(hUnit[1]);				
			}
		}				
	}
	
	public function hideAll(target:BaseCell):Void
	{
		//handled by subclasses
	}
	
	public function reset()
	{
		if(Std.is(this, Container))width = height = 0;
		/*if (!cAtts.width) cAtts.width = jQ.width();
		else if(!Math.isNaN(cAtts.width))jQ.width(cAtts.width);
		if (!cAtts.height) cAtts.height = jQ.height();
		else if(!Math.isNaN(cAtts.height))jQ.height(cAtts.height);*/
		if(cAtts.style){
		element.setAttribute('style', cAtts.style);
		for (k in Reflect.fields(cAtts.styles))
			jQ.css(k, Reflect.field(cAtts.styles, k));
		}
		//trace(id + ':' + jQ.width() + ':' + cAtts.width + ' x ' + cAtts.height + 'isContainer:' + Std.is(this, Container));		
		//Out.dumpLayout(node);
		if(!Std.is(this, Container))
			jQ.css('display', cAtts.display);
	}
	
	public function set_className(cN:String):String
	{
		var current:String = element.className;
		className = element.className = cN;
		return current;
	}

	public function set_offset(off:OffSet):OffSet
	{
		offset = off;
		if (off.left != null)
			x = off.left;
		if (off.top != null)
			y = off.top;
		//JQuery.of(node).offset(offset);
		return off;
	}

	public function set_id(i:String):String
	{
		var current:String = element.getAttribute('id');
		this.id = i;
		element.setAttribute('id', i);
		return current;
	}
	
	public static function create(name:String, ?attr:Dynamic<String>, ?doc:Document):BaseCell
	{
		var dC:BaseCell = new BaseCell(null, name, attr, doc);
		if(attr != null)
			for (key in Reflect.fields(attr))
				dC.element.setAttribute(key, Reflect.field(attr, key));
		return dC;
	}
	
	function addText(text:String, p:Node):Node
	{
		var domText:Text = document.createTextNode(text);
		p.appendChild(domText);
		return domText;
	}	
}