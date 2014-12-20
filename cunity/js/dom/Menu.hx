package me.cunity.js.dom;

import js.Boot;
import js.Browser;
import js.html.*;
import js.JQuery;
import js.Lib;
import me.cunity.js.data.Parse;
import me.cunity.js.dom.MenuItem;
import me.cunity.js.dom.SubMenu;
import me.cunity.js.dom.BaseCell;
import me.cunity.js.dom.Container;
import me.cunity.debug.Out;
/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

 
class Menu extends Container
{
	var guiObject:GuiObject;
	var doc:Document;
	
	public var menuBox:Container;	
	public var menuRoot:SubMenu;
	public var w:Int;
	public var h:Int;
	public var mWin:MenuWindow;
	
	public function new(mO:GuiObject, p:Element) 
	{
		super(null, 'div');
		guiObject = mO;
		doc = Browser.document;
		mWin = cast Browser.window;
		mWin.options = mO.options;
		mWin.options.isCrawler = Parse.getParam('_escaped_fragment_') != null;
		mWin.menuLinks = new Array();
		w = h = 0;
		menuBox = this;
		//menuBox = new Container(null, 'div');
		trace(menuBox.id);
		p.appendChild(menuBox.node);
		menuBox.element.className = 'menu';
		menuBox.applet = menuBox;
		menuBox.id = mO.id;
		var jWin:JQuery = new JQuery(Browser.window);
		//w = menubox.width = jwin.width();
		//h = menubox.height = jwin.height();
		width = jWin.width();
		height = jWin.height();
		
		var jBox = new JQuery(menuBox.element);
		jBox.width(width);
		jBox.height(height);
		//menuRoot = buildContainer(GuiObject, menuBox);
		menuRoot = new  SubMenu(menuBox, guiObject);
		trace(' align:' + menuRoot.align +':' + mO.align + ' pack:' + menuRoot.pack + ':' + mO.pack 
			+ ' class:' + menuRoot.className);
		layout();
		//layout(menuRoot, parentContainer);
		//trace(applet.
		Out.dumpLayout(menuRoot.element);
		trace(menuRoot.node.nodeName + ':' + menuRoot.element.offsetWidth +' x ' + menuRoot.element.offsetHeight 
			+ ':' +menuRoot.node.parentNode.parentNode);
		//trace('<textarea rows="10" cols="80">' + menuRoot.node.parentNode.innerHTML + '</textarea>');
		var mainFrame:JQuery = new JQuery('.mainFrame');
		mainFrame.height(menuRoot.jQ.offset().top);
		var mR:SubMenu = menuRoot;
		mainFrame.mouseover(function(evt:JqEvent) { mR.hideAll(null); } );
		//mainFrame.css('opacity', '0');
		//mainFrame.css('display', 'block');
		//mainFrame.animate({opacity:1});
		//Out.dumpLayout(mainFrame.toArray()[0]);
		Out.dumpLayout(element);
	}
	
	override public function layout(isResizing:Bool = false)
	{
		#if debug
		//Lib.window.document.getElementById("haxe:trace").style.height = 
			//(Lib.window.innerHeight - menuRoot.node.offsetHeight) + 'px';
		#end	
		menuRoot.layout();
		trace(Std.string(menuBox.jQ.offset()) + ':' + menuRoot.height + ':' + menuRoot.jQ.height());
		//Out.dumpLayout(menuBox.node);
		//trace(menuRoot.items[menuRoot.items.length - 1].jQ.html());
		//menuBox.jQ.offset( { left:null, top:Lib.window.innerHeight - menuRoot.height});
		//trace(menuBox.node.innerHTML);
		//Out.dumpLayout(menuRoot.items[menuRoot.items.length - 1].node);
		//Out.dumpLayout(untyped menuRoot.items[menuRoot.items.length - 1].node.firstChild);
		//Out.dumpLayout(menuBox.node);
	}
	
	function addElement(name:String, p:Element, ?attr:Dynamic<String>):Element
	{
		var el:Element = doc.createElement(name);
		if(attr != null)
			for (key in Reflect.fields(attr))
				el.setAttribute(key, Reflect.field(attr, key));
		p.appendChild(el);
		return el;
	}
	
/*	function addText(text:String, p:HtmlDom):HtmlDom
	{
		var domText:HtmlDom = doc.createTextNode(text);
		p.appendChild(domText);
		return domText;
	}*/
}