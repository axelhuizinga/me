/**
 *
 * @author ...
 */

package me.cunity.ui;

import flash.display.Graphics;
import flash.events.EventPhase;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import me.cunity.debug.Out;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.Lib;
import flash.net.URLRequest;
import flash.xml.XML;
import me.cunity.data.Parse;
import me.cunity.text.Format;

//import me.cunity.interfaces.IInteractive;
import me.cunity.ui.Container;
import me.cunity.ui.BaseCell;
import me.cunity.geom.Rotate;
import me.cunity.graphics.Filter;
import me.cunity.core.Types;
import me.cunity.text.Metrics;
import haxe.Timer;

class Button extends Container// implements IInteractive
{
	var _isHiding:Bool; 
	var _stopAutoHide:Bool;
	var _isShowing:Bool;
	var _slideIn:Bool;
	var hoverFilter:Dynamic;
	var keepActive:Bool;
	var buttonHandler:Dynamic->Void;
	//var _initialState:InteractionState;
	//var _interactionState:InteractionState;
	
	//public var interactionState(default, setState):InteractionState;

	public var labelFilter(default, null):BitmapFilter;
	public var label:Label;
	//public static var lMask:DisplayObject;
	
	public function new(node:XML, p:Container) 
	{
		super(node, p);
		isInteractive = true;
		//label = new Label(cAtts);
		//trace(Std.string(iDefs));
		label = new Label(iDefs);
		var className:String = Reflect.field(cAtts, 'class');
		if (Reflect.field(iDefs, 'class') || className != null)
		{
			if (className == null)
				className = Reflect.field(iDefs, 'class');
			label.htmlText  = '<p class="' + className + '">' +cAtts.text + '</p>';
		}
		else
			label.text = cAtts.text;
		//label.tabEnabled = Format.textFieldTypes.tabEnabled(cAtts.tabEnabled);
		tabEnabled = Format.textFieldTypes.tabEnabled(cAtts.tabEnabled);
		//label.htmlText = cAtts.text;
		//trace(_parent.name +':' + _parent.contentView + children.length());
		//trace(cAtts.textFormat + ' menuRoot:' + menuRoot);
		//trace(Std.string(cAtts));
		//1throw('ooops');
		//trace(node.toXMLString());
		label.x = margin.left;
		label.y = margin.top;			
		content = addChildAt(label, 0);
		//label.border = true;

		//trace(name + ' ???:' + (false || cAtts.filters != null));
		if (iDefs.filters && cAtts.filters == null) {
			cAtts.filters = iDefs.filters;
			labelFilter = cAtts.filters.get('Button_label') !=null ? cAtts.filters.get('Button_label'):null;
			hoverFilter = cAtts.filters.get('Button_label_MOUSE_OVER') != null ? cAtts.filters.get('Button_label_MOUSE_OVER'):null;
			box = Filter.getFiltersRect(label, filters);
			if (labelFilter != null) label.filters = [labelFilter];			
		}		
		else {
			box = label.getBounds(label);	
			//trace(box.toString());
		}
		//trace(box.toString());
		//trace(cAtts.filters + ':' + label.defaultTextFormat.font + ':' + label.embedFonts);
		box.width += margin.left + margin.right;
		box.height += margin.top + margin.bottom;			
		interactionState = InteractionState.HOVER;
		
		if (cAtts.listen != null) {
			//var listeningObject:IContainer = this;
			var listeningObject:Dynamic = this;
			while (listeningObject._parent != null) {
				listeningObject = listeningObject._parent;
				if (listeningObject.id == cAtts.to) 
					break;
			}
			//trace(this.name + ' listeningObject:' + listeningObject.name);
			switch(cAtts.listen) {
				case 'LINK':
				buttonHandler =  listeningObject.linkHandler;
			}
		}		
	}
	
	//override public function layout():Rectangle
	override public function layout()
	{
		//tabEnabled = true;
		//trace(label.tabEnabled + ':' + tabEnabled);
		//trace(label.tabEnabled + ':' + tabEnabled);
		box = content.getBounds(content);	
		//box = (bmpLoader == null ? new Rectangle(0, 0, content.width ,  content.height) :content.getBounds(content));	
		box.width += margin.left + margin.right;
		box.height += margin.top + margin.bottom;	
		applyMargin();
		super.layout();
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
		//trace(id + ':' + _interactionState);
		//return box;
	}
	
	public function onPress(evt:MouseEvent) {
		label.filters = [];
		//if (bG != null) bG.alpha = _parent.cAtts.backGroundAlpha;
		//trace(bG.alpha) ;
		//Out.dumpLayout(label);
		//Out.dumpLayout(contentView);
		//Out.dumpLayout(this);
		//Out.dumpLayout(cast _parent);
	}
	
	override public function reset(?evt:Dynamic) {
		label.filters = (labelFilter != null) ? [labelFilter] :[];
		//if(bG!=null && !keepActive)bG.alpha = 0.0;
		//trace(label.text +':' + evt.target.name + ':' + cells.length);
		if (cells.length > 0)
			cells[0].hide();
	}
	
	override public function set_interactionState(s:InteractionState)
	{
		
		if(interactionState == s)//not changed
			return interactionState;
		
		//_interactionState = s;
		super.set_interactionState(s);
		
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
				label.alpha = 0.5;
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
				label.alpha = 1.0;
				buttonMode = true;
				label.filters = (labelFilter != null) ? [labelFilter] :[];
				interactionState = s;
			case InteractionState.HOVER:
				addEventListener(MouseEvent.MOUSE_OVER, highlight,false,0,true);
				addEventListener(MouseEvent.MOUSE_OUT, reset,false,0,true);
				label.alpha = 1.0;
				buttonMode = false;
				label.filters = (labelFilter != null) ? [labelFilter] :[];
		}
		//trace(id + ':' + _interactionState);
		return interactionState;
	}

	public function highlight(evt:MouseEvent) {
		if (cells.length > 0)
			cells[0].show();
		if(hoverFilter != null)
		label.filters = [hoverFilter];
		//if(bG!=null)bG.alpha = 100;
	}
	
	public function action(evt:MouseEvent) {
		//if (!enabled)
		//trace(_interactionState);
		if (interactionState != InteractionState.ENABLED)
			return;
		var t:String = ( cAtts.target == null) ? 'null' :cAtts.target;
		trace(id + ' mainLoad:' + id + ' target:' + t +' handler:' + buttonHandler);
		evt.stopImmediatePropagation();
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
		gfx.beginFill(0x0000ff, 0.0);//TRANSPARENT FILL TO HAVE MOUSE_OVER WORK ON BUTTON BOX
		gfx.drawRect(dBox.x, dBox.y, dBox.width, dBox.height);
	}
}