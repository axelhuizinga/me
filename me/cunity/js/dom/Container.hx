package me.cunity.js.dom;
import jQuery.*;
import me.cunity.debug.Out;
import me.cunity.js.debug.Util;
import me.cunity.js.dom.Base;
//import me.cunity.js.layout.BaseCell;
import me.cunity.js.layout.Types;
import js.html.*;
/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Container extends BaseCell
{
	//public var align:Align;
	//public var items:Array<BaseCell>;
	//public var orient:Orient;
	public var packRel:Array<String>;

	
	public var firstLayoutDone:Bool;
	
	public function new(p:Container=null, name:String = null, ?cfg:Dynamic = null, ?doc:Document) 
	{
		super(p, name, cfg, doc);		
		align =  (cfg && cfg.align != null ? cfg.align :Align.TOPLEFT );
		orient =  (cfg && cfg.orient != null ? cfg.orient :Orient.L2R );
		pack =  (cfg && cfg.pack != null ? cfg.pack :Pack.TOPLEFT );
		if(cfg)
			packRel = cfg.packRel;
		cAtts.isRoot = cfg && cfg.isRoot;
		items = new Array();
		//trace(id + ' align:' + align + ' pack:' + pack);
	}
	
	public function initFromDom(el:Element, cfg:Dynamic = null):Void
	{
		//container.node = node;
		element = el;
		document = el.ownerDocument;
		//isRoot = true;
		parent = this;
		//cAtts = { styles:{}};
		jQ = new JQuery(el);	
		if(cfg){
			for (p in ['width', 'height', 'id'])
				Reflect.setField(cAtts, p, Reflect.field(cfg, p));
			
			packRel = cfg.packRel;
			
			if (cfg.style)
			{
				cAtts.style = cfg.style;
				element.setAttribute('style', cfg.style);
			}
			if (id == null)
				id = cAtts.id;
			if (cfg.className)
			{
				if (cfg.overrideClass)
					jQ.attr('class', cfg.className);
				else
					jQ.addClass(cfg.className);
				className = cAtts.className = jQ.attr('class');
			}
			trace(Std.string(cAtts));
		}
		//trace(Std.string(cfg));
		trace(Std.string(packRel));
		cAtts.display = jQ.css('display');
	}
	
	public function layout(isResizing:Bool = false)
	{
		//jQ.css('display', 'inline');
		if(firstLayoutDone)
			reset();
		//trace(jQ.css('display'));
		//Out.dumpLayout(node);
		getBox();
		width = fixedWidth == null ? 0 :fixedWidth;
		height = fixedHeight == null ? 0 :fixedHeight;
		if(width>0||height>0)trace(id + ':' + width  +  ' x ' + height);
		var clientW:Int = 0;
		var clientH:Int = 0;
		var cx:Int = 0;
		var cy:Int = 0;
		//trace('id:' +node.id + ' align:' + align + ' pack:' + pack);
		
		switch(orient)
		{
			case Orient.L2R, Orient.R2L://ROW
			for (item in items)
			{
				clientW += item.width;
				//trace (item.height)
				if (clientH < item.height)
					clientH = item.height;
			}			
			
			case Orient.T2B, Orient.B2T://COLUMN
			//clientH = Std.parseInt(jQ.css('padding-top')) + Std.parseInt(jQ.css('padding-bottom'));
			for (item in items)
			{
				item.reset();
				//Out.dumpLayout(node);
				clientH += item.height;
				if (clientW < item.width)
					clientW = item.width;
				//trace(item.jQ.css('display'));
				/*if (id == 'main_0_1_1')
				{
					trace('clientW:' + clientW + ':' + untyped item.text);					
					//Out.dumpLayout(item.node);
				}*/
				item.jQ.css('display', 'block');
				item.jQ.css('overflow', 'visible');
			}	
			
		}
		//if (id == 'main_0_1_1')
		//trace('oops:' + node.innerHTML);
		if (Std.is(applet, Menu)) { 
			jQ.css('display', 'block');
			jQ.css('position', 'absolute'); 			
		}
		else if (fixedWidth != null || fixedHeight != null )
			jQ.css('position', 'relative'); 	

		width = (fixedWidth == null ? clientW :fixedWidth);
		height = (fixedHeight == null ? clientH :fixedHeight);

		jQ.width(width);
		jQ.height(height);		
			
		switch(pack)
		{
			case Pack.BLEFT, Pack.BRIGHT, Pack.BOTTOM:
			y = parent.height - height;
			switch(pack)
			{
				case Pack.BRIGHT:
				case Pack.BOTTOM:
				default:
				x = 0;
			}
			case Pack.BRBL:
			x = parent.parent.x + parent.parent.jQ.outerWidth();
			y = parent.jQ.offset().top + parent.height;
			if (orient == Orient.B2T)
				//trace (id + ':' + parent.id +':' + parent.jQ.offset().top+ '::' + parent.parent.y );
				y -= height;
				y -= height;
			case Pack.CENTER:
				x = Math.round((jQ.parent().width() - width) / 2);
			//if (!firstLayoutDone)
				//jQ.wrap('<center></center>');
			case Pack.TLBL:
			trace(id +':' + Type.getClassName(Type.getClass(parent)) + ':' + parent.id );
			x = parent.x;
			y = parent.parent.y - jQ.outerHeight();
			default:
		}
		//PUT CONTAINER
		if(x != 0 || y != 0)
		jQ.offset( { left:x, top:y } );

		
		if (!cAtts.isRoot )
		{
			//trace('hide:' + id + ':' + className);
			//jQ.css('opacity', 0);
			//jQ.hide();
			//trace(id + ' hidden? ' + jQ.css('display'));
		}else
		jQ.css('visibility', 'visible');
		//PUT CHILDREN
		switch(orient)
		{
			case Orient.R2L, Orient.L2R://horizontal
			switch(align)
			{
				case Align.CENTER:
				cx = Math.round((width - clientW) / 2);
				default://TOPLEFT				
			}				
			for (item in items)
			{
				//trace(untyped item.text + ':' + cx + ' itemW:' + item.width + ' outerWidth:' + item.jQ.outerWidth(true));
				item.jQ.offset( { top:y, left:cx } );
				item.x = cx;
				//trace(untyped item.text + ':' + cx + ' itemW:' + item.width + ' outerWidth:' + item.jQ.outerWidth(true)
					//+ ' position:' + item.jQ.css('position'));
				cx += item.width;
			}
			case Orient.B2T, Orient.T2B://vertical
			switch(align)
			{
				case Align.MIDDLE:
				cy = Math.round((height - clientH) / 2);
				for (item in items)
				{
					//trace(untyped item.text + ':' + cx + ' itemW:' + item.width + ' outerWidth:' + item.jQ.outerWidth(true));
					item.jQ.offset( { top:cy, left:null } );
					item.jQ.css('display', 'block');
					cy += item.height;
				}
				default://TOPLEFT - uses native block layout			
			}					
		}
		//Out.dumpLayout(node);
		//trace(Std.string(jQ.offset( )) + jQ.css('position'));	
		firstLayoutDone = true;

	}
	
	public function add(el:BaseCell)
	{
		
	}
	
}