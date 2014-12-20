/**
 *
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.ui;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import haxe.xml.Fast;
import flash.xml.XML;
import haxe.CallStack;
import haxe.ds.StringMap;
import me.cunity.animation.LookAtMouse;
import me.cunity.animation.TimeLine;
import me.cunity.data.Parse;
import me.cunity.ui.menu.MenuButton;
import me.cunity.ui.menu.MenuColumn;
import me.cunity.ui.menu.MenuRow;

import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.BackgroundEvent;
import me.cunity.events.LayoutEvent;
import me.cunity.layout.Alignment;
import me.cunity.core.Application;
import me.cunity.core.Types;
import me.cunity.ui.menu.Menu;
import singularity.geom.Parametric;
using me.cunity.graphics.DrawTools;
using me.cunity.graphics.Filter;
using me.cunity.tools.ArrayTools;
using me.cunity.tools.Xml;

typedef Corners = { //CSS STYLE CLOCKWISE ORDER
	var TR:Float;
	var BR:Float;
	var BL:Float;
	var TL:Float;
	var method:String;
}

typedef Border = {//CSS STYLE CLOCKWISE ORDER
	var top:Float;
	var right:Float;
	var bottom:Float;
	var left:Float;
}

typedef Dims =
{
	var width:Float;
	var height:Float;
}

class BaseCell extends Sprite
{
	public var bG:BackGround;
	public var cAtts:Dynamic;
	public var cells(default, null):Array<BaseCell>;
	
	public var content:DisplayObject;
	public var cornerRadius(default, null):Corners;
	public var cL:Class<Dynamic>;
	public var diObj:DisplayObject;
	public var filterDims:Rectangle;
	public var box:Rectangle;//OUTER BOX INCLUSIVE MARGIN - TRANSPARENT
	//public var borderBox:Rectangle;//BORDER BOX INCLUSIVE BORDER 
	//public var paddingBox:Rectangle;
	public var contentBox:Rectangle;
	
	public var contentView:BaseCell;
	public var keepVisible:Bool;
	public 	var id:String;
	public var layoutRoot(default, null):Container;	
	public var menuRoot(default, null):Menu;
	public var maxContentDims:Rectangle;
	public var fixedWidth:Bool;
	public var fixedHeight:Bool;
	public var borderWidth:Border;	
	public var margin:Border;	
	public var contentMargin:Border;	
	public var overlay:Overlay;
	public var padding:Border;	
	public var isComplete:Bool; 
	public var refPoint:Pos;
	public var interactionState(default, set):InteractionState;	
	public var dMask:Shape;
	public var path:Parametric;
	public var _parent:Container;
	public var loadedInst(default, null):Dynamic;
	public var iDefs(default, null):Dynamic; //inheritableDefs
	public var tooltip:Sprite;
	
	var _alpha:Float;	
	var initialMatrix:Matrix;
	var _initialState:InteractionState;
	//var _interactionState:InteractionState;		
	var isInteractive:Null<Bool>;
	var bgImg:Image;
	var xNode:XML;
	
	#if debug
	public static var aMNames:StringMap<Array<Array<StackItem>>> = new haxe.ds.StringMap<Array<Array<StackItem>>>();
	#end
	
	function applyMargin()
	{
		//TODO:IMPLEMENT RELATIVE MARGINS
		//trace(Std.string(border));
		//trace(borderWidth.left + ':' + borderWidth.right);
		if (contentMargin != null)
		{
			trace(name + ' again!!!' + Std.string(contentMargin));
			//return;
		}
		contentMargin = { top:borderWidth.top / 2, right:borderWidth.right / 2, bottom:borderWidth.bottom / 2, left:borderWidth.left / 2 };
		contentMargin.top += margin.top;
		contentMargin.right += margin.right;
		contentMargin.bottom += margin.bottom;
		contentMargin.left += margin.left;	
		
		if(cL!= MenuButton && cornerRadius != null) switch(cornerRadius.method)
		{
			case 'drawRoundRect':
			contentMargin.left += cornerRadius.TL;
			contentMargin.right += cornerRadius.TL;
			contentMargin.top += cornerRadius.BR ;
			contentMargin.bottom += cornerRadius.BR ;
			
			case 'drawRoundRectComplex':		
			contentMargin.left += Math.max(cornerRadius.TL, cornerRadius.BL);
			contentMargin.right += Math.max(cornerRadius.TR, cornerRadius.BR);
			contentMargin.top += Math.max(cornerRadius.TL, cornerRadius.TR);
			contentMargin.bottom += Math.max(cornerRadius.BL, cornerRadius.BR);						
		}
		//trace(name + ':' + maxContentDims + ':' + contentMargin.left + ':' + contentMargin.right + ' content:' + content);
		if (content != null)
		{
			if (cL != MenuColumn && cL != MenuRow)
			{
				content.x = contentMargin.left;
				content.y = contentMargin.top;	
				//trace(name + ' content:' +content.name);
			}
			//trace(name + ':' + Std.string(contentMargin) + ':' + (untyped content == contentView));
			#if debug2
			var cStack:Array<StackItem> = CallStack.callStack();
			var cSColl:Array<Array<StackItem>> = null;
			if (aMNames.exists(name))
			{
				trace(name);
				cSColl = aMNames.get(name);
				cSColl.push(cStack.slice(1, 5));
				for( a in cSColl)
				 trace(Std.string(a));
			}
			else
			{
				cSColl = [cStack.slice(0, 6)];
				aMNames.set(name, cSColl);
			}
			
			#end
		}

		if (maxContentDims != null)
		{
			if (fixedWidth && box.width < maxContentDims.width)
				maxContentDims.width = box.width;
			if (fixedHeight && box.height < maxContentDims.height)
				maxContentDims.height = box.height;			
			maxContentDims.width -= (contentMargin.left + contentMargin.right);
			maxContentDims.height -= (contentMargin.top + contentMargin.bottom);			
		}		
		//trace(name +':'  +  (this == menuRoot) + ' old box.height:' + aB.height + ' box.height:' + box.height);
	}

	public function fadeIn() 
	{
		//if (xNode.attribute('fadeIn').toString() != 'false')
		if (cAtts.fadeIn != 'false')
			STween.add (this, 1.0 , { alpha:_alpha } );			
	}	
		
	public function destroy()
	{
		try{
			if(bG != null)bG.destroy();
			if (bgImg != null) bgImg.destroy();
			var refs:Array<Dynamic> = [bG, bgImg, _parent, layoutRoot, cL, id, cAtts, iDefs, cells, xNode];
			for (p in refs)
				p = null;
			while (numChildren > 0)
			{
				var child:Dynamic = removeChildAt(0);
				if (child != null)
				{
					//var cName:String = child.name;
					//trace(child + ':' + cName);
					if (Type.getInstanceFields(Type.getClass(child)).contains('destroy'))
						child.destroy();
					child = null;	
					//trace('Successfully destroyed:' + cName);
				}		
			}
			cAtts = null;
		}
		catch (ex:Dynamic) { trace (ex); }
		//trace('done :-)');
	}
	
	public function createOverlay(oN:XML, id:String)
	{
		overlay = new Overlay(oN, this);
		//addChild(overlay);
		//overlay.layout();
	}
	
	function removeOverlay()
	{
		if (overlay != null)
		{
			overlay.parent.removeChild(overlay);
			overlay.destroy();
			overlay = null;
		}
	}
	
	
	public function new(xN:XML, p:Container) 
	{
		super();
		cL = Type.getClass(this);
		//iDefs = Application.instance.cAtts;
		_parent = p;		
		if (xN == null){
			//trace(Type.getClass(this));
			xNode = new XML(null);
			if(p != null)
			cAtts = p.cAtts;
			return;
		}
		//isComplete = true;
		xNode  = xN;
		id = xNode.attribute('id').toString();
		name = (id != '') ? id :xNode.name();
		//trace(name +':' + id + ' _parent == this:' + (_parent == this));
		//trace(_parent.name +':' + _parent.cells);
		if (_parent != null ) {
			name = (_parent == this ? '' :_parent.name + '.' ) + name + Std.string(_parent.cells.length);		
		}
		//trace(name +':' + id);
		cAtts = xNode.getAttributes();
		padding = margin = {
			top:.0,
			right:.0,
			bottom:.0,
			left:.0
		};
		Parse.applyToObject(this, Parse.baseCellTypes, cAtts);
		if (p != null && _parent.cAtts.padding)
			margin = {
				top:margin.top + _parent.padding.top,
				right:margin.right + _parent.padding.right,
				bottom:margin.bottom + _parent.padding.bottom,
				left:margin.left + _parent.padding.left				
			}
		//applyMargin();
		//trace(name + ':' + Std.string(padding)+ ':' + Std.string(margin));
		//trace(name + ':' + layoutRoot);

		if (box == null)
		{
			//applyMargin();
			//getBox();	
			box = new Rectangle();	
		}
		if (p == null || menuRoot == this)
			return;
		menuRoot = _parent.menuRoot;
		if(layoutRoot == null)
			layoutRoot = _parent.layoutRoot;
		iDefs = layoutRoot.cAtts;
		iDefs = Application.instance.cAtts;
		//trace(name + ':' + Std.string(iDefs));
		if (menuRoot != null)
			return;// HANDLE  NOMENU ELEMENTS BELOW
		//if(Std.is(layoutRoot, Frame))
			//mouseEnabled = false;
		//trace(name +':' + mouseEnabled);
		var children = xNode.children();
		for (i in 0...children.length()) {
			var child:XML = children[i];
			switch(child.name()) {
				case 'Tween', 'PathTween', 'STween' :
				_parent.timeLine.addTween(this, child);
				//trace(name +':added:' + child.name());
			}
		}			

		if (cAtts.align == null)
			cAtts.align = _parent.cAtts ? _parent.cAtts.align :'TL';
		
		if (cAtts.url != null)
		{//SETUP LINK
			buttonMode = true;
			var mAtts:Dynamic = cAtts;
			addEventListener(MouseEvent.CLICK, function(evt:Event)
				{
					Link.go(mAtts);
				}
			);
		}

	}
	

	
	function scaleToFit()
	{
		var wScale:Float = 1;
		var hScale:Float = 1;

		//	preserveAspectRatio has been parsed into an object with align(String) and meet(Bool) properties
		if (!cAtts.preserveAspectRatio.meet) 
		{// 	SLICE
			trace('still not implemented :-(');
		}
		else
		{
			if (contentBox.width > maxContentDims.width)
				wScale =  (maxContentDims.width - margin.left - margin.right) / contentBox.width;				
			//trace('contentBox :' + contentBox + ' maxContentDims:' + maxContentDims);
			if (contentBox.height > maxContentDims.height)
				hScale =  maxContentDims.height / contentBox.height;		
				//hScale =  (maxContentDims.height - margin.top - margin.bottom) / contentBox.height;		
			var scale:Float = Math.min(wScale, hScale);
			//trace( box + ':' + wScale + ' x ' + hScale + ' scaled.height:' + (contentBox.height * scale + margin.top + margin.bottom));
			//var mat:Matrix = new Matrix();//contentView.transform.matrix;	
			var mat:Matrix = new Matrix();			
			if (scale != 1)
			{				
				contentBox.width *= scale;	
				contentBox.height *= scale;	
				box.width = contentBox.width + margin.left + margin.right;
				box.height = contentBox.height + margin.top + margin.bottom;
				mat.scale(scale, scale);				
			}		
			//TODO:IMPLEMENT ALIGN
			switch(cAtts.preserveAspectRatio.align)
			{
				case 'xMidyMax'://CENTER_BOTTOM
				trace(box + ' - ' + contentBox.height +' - ' + margin.top + ':' + (box.height - contentBox.height ));
				mat.translate( (box.width - contentBox.width) / 2,	 //-contentBox.y);				
					 margin.top);				
			}
			//mat.translate( -box.x, -box.y);
			//trace(mat.toString());
			content.transform.matrix = mat;
			/*var gfx:Graphics = content.graphics;
			gfx.lineStyle(0, 0xff00ff);
			gfx.moveTo(box.width / 2, 0);
			gfx.lineTo(box.width / 2, 22);*/
			//Out.dumpLayout(content);
		}
	}

	public function getBox()
	{			
		//trace(name);
		if(Std.is(this, Container))
		box = new Rectangle();
		//CHECK 4 RELATIVE AND FIXED SIZING / POSITION		
		if (cAtts.width) {
			fixedWidth = true; //TODO:IMPLEMENT OVERFLOW	
			//trace(name + ':' + box + ':'  + maxContentDims);
			var wUnit:Dynamic = Parse.unitString(cAtts.width);
			//trace( Std.string(wUnit) );		
			if (wUnit)			
			box.width = switch(wUnit[0])
			{
				case '%':// relative to parent box
				//trace(wUnit + '->' + _parent.name);
				//trace(wUnit + '->' + _parent.maxContentDims);
				Std.parseFloat(wUnit[1]) / 100 * _parent.maxContentDims.width;
				//Std.parseFloat(wUnit[1]) / 100 * maxContentDims.width;
				//cAtts.wUnit = '%';
				case '*'://take what you still can get - the value 0.0...1.0 denotes percentage of available space defaults to 1.0 = 100%
				var val = Std.parseFloat(wUnit[1]);
				//trace( name +':' + wUnit.toString() + ':' + val);
				(val==0) ? -1 :-val;
				default://px
				Std.parseFloat(wUnit[1]);				
			}
			//trace(box.width);
		}
		if (box.width > 0 && cAtts.maxWidth < box.width)
			box.width = cAtts.maxWidth;//EXPERIMENTAL - TODO:ADD RELATIVE(%)
		if (cAtts.height) {
			fixedHeight = true;
			var hUnit:Dynamic = Parse.unitString(cAtts.height);
			//trace( Std.string(hUnit) );
			if (hUnit)
			box.height = switch(hUnit[0])
			{
				case '%':// relative to parent box
				//Std.parseFloat(hUnit[1]) / 100 * maxContentDims.height;
				Std.parseFloat(hUnit[1]) / 100 * _parent.maxContentDims.height;
				//cAtts.hUnit = '%';
				case '*'://take what you still can get - the value 0.0...1.0 denotes percentage of available space defaults to 1.0 = 100%
				var val = Std.parseFloat(hUnit[1]);
				//trace( name +':' + hUnit.toString() + ':' + val);
				(val==0) ? -1 :-val;
				default://px
				Std.parseFloat(hUnit[1]);				
			}
		}			
		
		if (cAtts.preserveAspectRatio)
			trace(name + ':' + contentBox +' > ' +  maxContentDims);
			//trace(contentBox.width +' > ' +  maxContentDims.width + ' || ' + contentBox.height + ' > ' +  maxContentDims.height);
		if (cAtts.preserveAspectRatio && (contentBox.width > maxContentDims.width || contentBox.height > maxContentDims.height))
		{
			//trace(cAtts.preserveAspectRatio + ' && ' +box.width +' > '+ maxContentDims.width + ' || ' + box.height + ' > ' + maxContentDims.height);
			scaleToFit();
		}		
	}
	
	public function updateBox()
	{
		
	}

	public function getMaxDims():Void
	{//	GET AVAILABLE PARENT DIMS
		//if (cL == Screen)
		if (Std.is(this, Screen))
			return;
		var ref:BaseCell = this;
		//trace(ref.name);
		//var res:Rectangle = new Rectangle();
		maxContentDims = new Rectangle();
		while (ref._parent != null && (maxContentDims.width == 0 || maxContentDims.height == 0))
		{
			ref = ref._parent;
			//if (ref.cL == Screen)
			if (Std.is(ref, Screen) || Std.is(ref, Frame))
			{
				maxContentDims = ref.maxContentDims.clone();
				//trace(cL +':' + ref.cL + ' ref.box:' + ref.box + ' maxContentDims:' + maxContentDims);
				//return ref.box;
			}
			//trace(ref.name + ':' +Type.getClass(ref) +':' + ref);
			if (ref.box.width > 0 && maxContentDims.width == 0)
			{
				maxContentDims.width = ref.maxContentDims.width;
			}
			if (ref.box.height > 0 && maxContentDims.height == 0)
			{
				maxContentDims.height = ref.maxContentDims.height;
			}
		}
		trace(name + ' maxContentDims:' + maxContentDims);
	}
	
	//public function layout():Rectangle 
	public function layout() 
	{
		if ( Application.instance.resizing && bG != null)
			bG.set();			
	}
	
	function addMask() 
	{
		var maskShape:Shape = new Shape();
		maskShape.graphics.beginFill(0xffffff);
		//maskShape.graphics.drawRect(box.left, box.top, box.width, box.height);
		//maskShape.graphics.drawRect(box.left, box.top, box.width+contentMargin.left+contentMargin.right, box.height);
		maskShape.graphics.drawRect(
			box.left, box.top,// - contentMargin.top, 
			//box.left - contentMargin.left, box.top - contentMargin.top, 
			box.width + contentMargin.left + contentMargin.right, box.height + contentMargin.top +  contentMargin.bottom
			);
			/*Out.suspended = false;
			Out.fTrace('x:@ y:@ w:@ h:@', [box.left - contentMargin.left, box.top - contentMargin.top, 
			box.width + contentMargin.left + contentMargin.right, box.height + contentMargin.top +  contentMargin.bottom]);
			Out.suspended = true;*/
		//maskShape.alpha = 0.50;
		addChild(maskShape);
		contentView.mask = maskShape;
		//contentView.dMask = maskShape;
	}

	
	public function draw():Void 
	{
		//SET SIZE & HOVER TARGET OF SPRITE BY DRAWING A <DUMMY> BG
		//if (id != '') trace(id+':' + Std.string(box));
		//if(cL == MenuColumn)
		//trace(name + ':' + Std.string(box));
		graphics.clear();
		if (cAtts.backgroundColor) {
			graphics.beginFill(cAtts.backgroundColor, cAtts.backgroundAlpha);
			//trace(cAtts.backgroundColor +', ' + cAtts.backgroundAlpha );
		}
		else
			graphics.beginFill(0, 0);
		//if (cL == Frame)
			//graphics.beginFill(0, 0.5);
			//trace(name + ' border:' + cAtts.border + ' box:' + box);
		if (cAtts.border == 'true') 
		{	//trace(name + ' border:' + cAtts.border + ' box:' + box);
			var color:UInt = 0;
			if (cAtts.borderColor != null)
				color =  Std.parseInt(cAtts.borderColor);
			else
				color = (Type.getClass(this) == Text ? 0xff80ff :0x00a000);
			graphics.lineStyle(0, color, 0.5);
		}

		graphics.drawRect(0, 0, box.width, box.height);
	}
	
	public function enable(?s:Bool) 
	{
		throw('should be handled by subclass');
	}
	
	public function reset(?evt:Dynamic) 
	{
		throw('should be handled by subclass');
	}
	
	public function set_interactionState(s:InteractionState):InteractionState
	{
		//var previous:InteractionState = _interactionState;
		interactionState = s;
		for (c in cells)
		{
			if (c.isInteractive)
			{	trace(name +' set:' + c.name + '2:' + s);
				switch(s)
				{
					case InteractionState.ACTIVE:
					//
					case InteractionState.DISABLED:
					//
					c.interactionState = interactionState;					
					case InteractionState.ENABLED:
					c.interactionState = interactionState;
					case InteractionState.HOVER:
					//
				}
			}
		}
		return interactionState;
	}
	
	/*public function getState():InteractionState
	{
		return _interactionState;
	}*/
	
	public function hide() {
		trace('Containers only');
	}
	
	public function show() {
		trace('Containers only');
	}
}