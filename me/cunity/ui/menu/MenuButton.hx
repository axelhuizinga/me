/**
 *
 * @author ...
 */

package me.cunity.ui.menu;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventPhase;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import haxe.Resource;
import me.cunity.debug.Out;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.Lib;
import flash.net.URLRequest;
import flash.xml.XML;
import me.cunity.data.Parse;
import me.cunity.core.Application;
import me.cunity.ui.Container;
import me.cunity.ui.BaseCell;
import me.cunity.ui.Label;
import me.cunity.geom.Rotate;
import me.cunity.graphics.Fill;
import me.cunity.graphics.Filter;
import me.cunity.core.Types;
import me.cunity.text.Metrics;
import haxe.Timer;
import me.cunity.ui.Link;

class MenuButton extends MenuContainer
{
	var _isHiding:Bool; 
	var _stopAutoHide:Bool;
	var _isShowing:Bool;
	var _slideIn:Bool;
	var bmpLoader:Loader;
	var hoverFilter:Dynamic;
	var keepActive:Bool;
	var buttonHandler:Dynamic->Void;
	var tooltipY:Float;
	
	public var labelFilter(default, null):BitmapFilter;
	public var label:Label;

	//public static var lMask:DisplayObject;
	
	public function new(node:XML, p:MenuContainer) 
	{
		super(node, p);
		if (cAtts.url != null)
		{//SETUP LINK
			buttonMode = true;
			var mAtts:Dynamic = cAtts;
			addEventListener(MouseEvent.CLICK, function(evt:Event)
				{
					Link.go(mAtts);
				},false,0,true
			);
		}		
		if (cAtts.method == 'locale')
			Application.instance.registerLocale(id);
		isInteractive = true;
		label = new Label(iDefs);
		label.text = cAtts.text;
		if (cAtts.img)
		{
			var bytes:ByteArray = cast (Resource.getBytes(cAtts.img).getData(), ByteArray);	
			trace('bytes.length:' + bytes.length);
			menuRoot.addResource(this);	
			bmpLoader = new Loader();
			bmpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete,false,0,true);
			bmpLoader.loadBytes(bytes);	
		}
		
		if (menuRoot != null) {		
			if (bmpLoader != null)
			{
				tooltip = new Sprite();
				tooltip.alpha = 0;
				tooltip.addChild(label);
				//addChild(tooltip);
				addChild(tooltip);
				tooltip.buttonMode = false;
				content = _parent.contentView.addChild(bmpLoader);
				menuRoot.views.push(this);
				/*Out.suspended = false;
				trace(Std.string(iDefs));
				Out.suspended = true;*/
			}
			else
			content = _parent.contentView.addChild(label);
		}
		else
		{
			if (layoutRoot != null)
				layoutRoot.resourceList.add(this);	
			addChildAt(label, 0);
		}

		if (iDefs.filters != null) 
		{
			var lFilters:Array<Dynamic> = [];
			labelFilter = iDefs.filters.get('Button_label') != null ? iDefs.filters.get('Button_label'):null;
			//trace('labelFilter:' + labelFilter);
			if (labelFilter != null)
				lFilters.push(labelFilter);				
			hoverFilter = iDefs.filters.get('Button_label_MOUSE_OVER');			
			if (labelFilter != null) 
				content.filters = [labelFilter];			
		}		 

		label.border = false;
		label.borderColor = 0xffffff;

		if (menuRoot != null)
		{
			if( menuRoot.sameButtonHeight > 0)
				box.height = menuRoot.sameButtonHeight;			
		}
	
		interactionState = InteractionState.HOVER;
		
		if (cAtts.listen != null) 
		{
			var listeningObject:BaseCell = this;
			while (listeningObject._parent != null) {
				listeningObject = listeningObject._parent;
				if (listeningObject.id == cAtts.to) 
					break;
			}
			//trace(this.name + ' listeningObject:' + listeningObject.name);
			switch(cAtts.listen) {
				case 'LINK':
				buttonHandler =  cast( listeningObject).linkHandler;
			}
		}		
	}
	
	function onComplete(evt:Event)
	{
		//trace(Std.string(menuRoot != null) + ':' + Std.string(layoutRoot != null));
		evt.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete, false);
		
		if (menuRoot != null)
			menuRoot.resourceReady(this);
		else if (layoutRoot != null)
			layoutRoot.resourceReady(this);
	}
	
	static var once:Bool = false;
	override public function layout()
	{
		box = content.getBounds(content);	
		//box = (bmpLoader == null ? new Rectangle(0, 0, content.width ,  content.height) :content.getBounds(content));	
		box.width += margin.left + margin.right;
		box.height += margin.top + margin.bottom;
		applyMargin();
		//if(Application.instance.resizing) throw('oops');
		//trace(box.toString() + ' = ' + content.getBounds(content).toString());
		super.layout();
		if (bmpLoader != null)
		{
			tooltipY = -bmpLoader.content.height - menuRoot.contentMargin.top;			
		
			//tooltip.y = -bmpLoader.content.height - menuRoot.contentMargin.top;
			if (hoverFilter)
			{
				if (hoverFilter.distance)
					tooltipY -= hoverFilter.distance;
					//tooltip.y -= hoverFilter.distance;
				if (hoverFilter.blurY)
					tooltipY -= hoverFilter.blurY;
					//tooltip.y -= hoverFilter.blurY;
			}
			tooltip.x = contentMargin.left + bmpLoader.content.width * .3;
			tooltip.y = tooltipY;
			/*Out.suspended = false;		
			trace(Std.string(menuRoot.cornerRadius) + ':' + label.x);
			Out.suspended = true;*/
		}		
		if (Application.instance.resizing)
			return;
		if(cAtts.interactionState == 'DISABLED')
		{
			enabled = false;		
			interactionState = InteractionState.DISABLED;
		}
		else {
			if (id != '')
				interactionState = InteractionState.ENABLED;
			else
				interactionState = InteractionState.HOVER;			
		}
		if (_initialState == null)
			_initialState = interactionState;
		//trace(id=='' ? cAtts.text :id + ':' + _interactionState);
	}
	
	public function onPress(evt:MouseEvent) {
		label.filters = [];
	}
	
	override public function reset(?evt:Dynamic) {
		if (bmpLoader != null)
		{
			tooltip.y = Application.instance.box.height + 10;
			tooltip.alpha = 0;
		}
		/*if (bmpLoader != null)		
			bmpLoader.filters = (labelFilter != null) ? [labelFilter] :[];
		else
			label.filters = (labelFilter != null) ? [labelFilter] :[];*/
		content.filters = (labelFilter != null) ? [labelFilter] :[];
		//if(bG!=null && !keepActive)bG.alpha = 0.0;
		//trace(label.text +':' + evt.target.name + ':' + cells.length);
		if (cells.length > 0) {
			menuRoot.hideContainer(cast cells[0]);
		}
	}

	public function highlight(evt:MouseEvent) {
		//evt.preventDefault();
		//trace(evt.target.name + ':' + evt.currentTarget.name);
		if (cells.length > 0 )
			cells[0].show();
		if (hoverFilter != null)
		/*else
			label.filters = [hoverFilter];*/
			content.filters = [hoverFilter];
		if (bmpLoader != null)
		{
			tooltip.y = tooltipY;
			tooltip.alpha = 1;
		}
	}
	
	public function action(evt:MouseEvent) {
		//if (!enabled)
		//trace(_interactionState);
		if (id == 'contact')
			return;
		if (interactionState != InteractionState.ENABLED)
			return;
		var t:String = ( cAtts.target == null) ? 'null' :cAtts.target;
		trace(id + ' mainLoad:' + id + ' target:' + t);
		evt.stopImmediatePropagation();
		if (menuRoot != null)
		{
			menuRoot.mainLoad(id, this);
			menuRoot.hideRoot();		
		}
		else
			buttonHandler(evt);
	}
	
	
	public function buttonAction() {
		contentView.alpha = 0.0;
		//cells[0].contentView.alpha = 0.0;
		trace(contentView.alpha);
	}
	
	override 	public function draw():Void {
		//if (id != '')trace(id+':' + Std.string(box));		
		var gfx:Graphics = graphics;
		var dBox:Rectangle = box.clone();
		if (menuRoot == null)
		{
			gfx = contentView.graphics;
			//gfx.lineStyle(0.5, 0xffffff);
			dBox.x -= margin.left;
			dBox.y -= margin.top;
		}
		//gfx.clear();
		//cAtts.border = 'true';
		if (cAtts.border == 'true') 
		{	
			var color:UInt = 0;
			if (cAtts.borderColor != null)
				color =  Std.parseInt(cAtts.borderColor);
			else
				color = 0x00a000;
			gfx.lineStyle(0, color, 0.5);
		}
		gfx.beginFill(0, 0.0);//TRANSPARENT FILL TO HAVE MOUSE_OVER WORK ON BUTTON BOX
		gfx.drawRect(dBox.x, dBox.y, dBox.width, dBox.height);		
	}
	
	override public function set_interactionState(s:InteractionState)
	{
		//trace(_interactionState+ ' == '+ s);
		if(interactionState == s)//not changed
			return interactionState;
		
		super.interactionState = s;
		
		switch(interactionState)
		{
			case InteractionState.ACTIVE:
			//do nothing here
			case InteractionState.DISABLED:
				removeEventListener(MouseEvent.MOUSE_OVER, highlight, false);
				removeEventListener(MouseEvent.MOUSE_OUT, reset, false);
				if (id != '') {
					removeEventListener(MouseEvent.MOUSE_UP, action, false);
					removeEventListener(MouseEvent.MOUSE_DOWN, onPress, false);
				}
				content.alpha = 0.5;
				buttonMode = false;
				interactionState = s;
			case InteractionState.ENABLED:
				addEventListener(MouseEvent.MOUSE_OVER, highlight,false,0,true);
				addEventListener(MouseEvent.MOUSE_OUT, reset,false,0,true);
				if(id != ''){
					addEventListener(MouseEvent.MOUSE_UP, action,false,0,true);
					addEventListener(MouseEvent.MOUSE_DOWN, onPress,false,0,true);
					//trace(id +':action mouse listener set' );
				}
				content.alpha = 1.0;
				buttonMode = true;
				content.filters = (labelFilter != null) ? [labelFilter] :[];
				interactionState = s;
			case InteractionState.HOVER:
				addEventListener(MouseEvent.MOUSE_OVER, highlight,false,0,true);
				addEventListener(MouseEvent.MOUSE_OUT, reset,false,0,true);
				content.alpha = 1.0;
				buttonMode = false;
				content.filters = (labelFilter != null) ? [labelFilter] :[];
		}
		trace(id=='' ? cAtts.text :id + ':' + interactionState + ':');
		return interactionState;
	}
}