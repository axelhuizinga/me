package me.cunity.js.dom;

import js.Browser;
import js.html.*;
import js.Lib;
import js.JQuery;
import me.cunity.debug.Out;
//import me.cunity.js.layout.BaseCell;
import me.cunity.js.dom.Container;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */
typedef MenuWindow = 
{ > DOMWindow,
	var menuLinks:Array<LinkElement>;
	var options:Dynamic;
}
 
class MenuItem extends Container
{	
	var link:LinkElement;
	public var href(default, set):String;
	public var linkBox:JQuery;
	public var text(default, set):String;
	var menuWindow:MenuWindow;
	var menuLinks:Array<LinkElement>;

	
	public function new(p:Container, ?cfg:Dynamic, ?doc:Document) 
	{
		super(p, 'a', doc);
		//linkBox = new BaseCell(this, 'div', { className:'linkBox' } ).jQ;
		link = cast node;
		menuWindow = cast(cast(p, SubMenu).applet, Menu).mWin;
	}
	
	public static function add2(p:Container, ?cfg:Dynamic, ?doc:Document):MenuItem
	{
		var mI:MenuItem = new MenuItem(p, cfg, doc);

		for (p in Reflect.fields(cfg))
		{
			switch(p)
			{
				case 'href':
				mI.href = cfg.href == null ? '' :cfg.href;
				case 'text':
				mI.text = cfg.text;
				default:
				Reflect.setField(mI, p, Reflect.field(cfg, p));
			}			
		}
		if (mI.href == '')
			mI.jQ.addClass('disabled');
		//p.appendChild(mI.link);
		return mI;
	}
	
	public function show(evt:JqEvent):Void
	{
		//if(parent.enabled)
		//if(parent.parent.node.className != 'menu')
		trace(id + ' target:' + link.target);
		//if (id == 'main_0_0_1_0_1_2' ||id == 'main_0_4_1_1_1_0_1_0')
		//untyped Lib.window.dumpXml(parent.node);
		//Out.dumpLayout(parent.node);
		//if (id == 'main_0_4_1_1_1_0_1_0')
		//untyped Lib.window.dumpXml(parent.node);
		parent.hideAll(this);
	}
	
	public function dump(evt:JqEvent):Void
	{
		trace(jQ.css('display'));
		Out.dumpLayout(element);
		trace(parent.jQ.css('display'));
		//Out.dumpLayout(parent.node);		
	}
	
	public function set_href(hR:String):String
	{
		var current:String = link.href;
		//Reflect.setField(this, 'href', hR);
		try{
			//if (hR.indexOf('#') > -1 || menuWindow.options.crawable != 'true'  || ~/^http/.match(hR))
			//TODO:CHECK WHY THE VERSION ABOVE BREAKS WITH EREG MATCHING AGAINST STRING CONTAINING '/'
			if (hR.indexOf('#') > -1 || menuWindow.options.crawable != 'true'  || hR.indexOf('http') == 0)
			{
				link.href = hR;			
			}
			else// if (menuWindow.options.crawable == 'true' && ! ~/^http/.match(hR))
			{
				menuWindow.menuLinks.push(link);
				if (menuWindow.options.isCrawler)
				{
					if (Browser.window.location.search.length > 1)
					link.href =  (Browser.window.location.search.length > 1) ? '&' :' ?'  + '_escaped_fragment_=' + StringTools.urlEncode(hR);
				}
				else
				{
					link.href =  "#!" + hR;// + '/';
					//link.href =  hR;
					//link.target = 'mainFrame';
					link.rel = 'address:' + hR;
					
				}
			}
			href = link.href;
		}
		catch (ex:Dynamic)
		{throw(hR);}
		//trace(link.href + ':' + (menuWindow.options.crawable == 'true') + '&&' +( ! ~/^http/.match(hR)));
		return current;
	}
	
	public function set_text(t:String):String
	{
		var current:String = jQ.html();
		
		text = t;
		jQ.html(t);
		//width = JQuery.of(linkBox).outerWidth(true);
		width = jQ.outerWidth(true);
		//height = JQuery.of(linkBox).outerHeight(true);
		height = jQ.outerHeight(true);
		if (id == 'main_0_1_1_1' )
		{
			trace(parent.jQ.html() + ':' + t);
			trace('width:' + width + ':' + element.offsetWidth + ':' + jQ.html());
		}
		return current;
	}
	
}