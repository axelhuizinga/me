package me.cunity.js.debug;
import js.Browser;
import jQuery.*;
import js.Lib;
import me.cunity.debug.Out;
//import me.cunity.js.layout.BaseCell;
import me.cunity.js.dom.Base;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Util 
{

	public static function drawBox2(p:BaseCell, cfg:Dynamic) 
	{
		//var dbox:BaseCell = BaseCell.create('div', { style:"position:absolute;background-color:#811;" } );
		var dbox:BaseCell = BaseCell.create('div');
		//p.node.appendChild(dbox.node);
		Browser.document.body.appendChild(dbox.node);
		var nJq:JQuery = new JQuery(dbox.element);
		nJq.css('z-index', '100');
		nJq.css('visibility', 'visible');
		nJq.css('position', 'absolute');
		nJq.css('background-color', '#811');
		nJq.offset( { top:cfg.top, left:cfg.left } );
		nJq.width(cfg.width);
		nJq.height(cfg.height);
		//nJq.show();
		//trace(nJq.css('background-color'));
		Out.dumpLayout(dbox.element);
	}
	
}