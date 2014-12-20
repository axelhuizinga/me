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
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.Capabilities;
import flash.xml.XML;
import flash.xml.XMLList;
import haxe.CallStack;
import haxe.ds.StringMap;
import me.cunity.data.Cookie;
import me.cunity.events.LayoutEvent;
import me.cunity.core.Application;
import me.cunity.core.Types;
import me.cunity.data.Parse;

import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.BackgroundEvent;
import me.cunity.graphics.Paint;
import me.cunity.graphics.Fill;
import me.cunity.layout.Alignment;
import me.cunity.tools.ArrayTools;
import me.cunity.tools.FlashTools;
import me.cunity.ui.BaseCell;
using me.cunity.tools.XMLTools;

typedef ColorSetter = Array<String>->Void;

class BackGround extends Shape
{
	var _alpha:Float;
	var bData:BitmapData;
	var bgImg:Image;
	var _isDynamic:Bool;
	var _parent:Container;
	var relBg:BaseCell;
	public var currentId(default, null):String;
	var cAtts:Dynamic;
	var colorSetters:Array<ColorSetter>;
	
	public var backGrounds:StringMap<Dynamic>;
	
	public function new(p:Container) 
	{
		super();	
		//visible = false;
		_parent = p;
		//_isDynamic = _parent.cAtts && _parent.cAtts.dynamicBg == 'true';
		_isDynamic = _parent.cAtts.dynamicBg == 'true';
		/*if (Std.is(_parent, Application))
		_parent.addChild(this);
		else*/
		//PLACE BELOW CONTENT VIEW
		_parent.addChildAt(this, 0);
		//_parent.contentView.addChildAt(this, 0);
		//_parent.addChild(this);
		backGrounds = new StringMap();
		colorSetters = new Array();
		cacheAsBitmap = true;
		//visible = true;
		//trace(_parent.name + ':' + p.cAtts.BackGround);
	}
	
	public function add(xN:XML, sel:Bool = false) 
	{
		var id:String = xN.attribute('id').toString();
		//trace(sel + ' set ' + id + ':' + Std.string(XConfig.getAttributes(xN)));
		var cA:Dynamic = xN.getAttributes();
		//trace(' sel:' + sel + ' :' + Std.string(cA));
		if(!_parent.layoutRoot.willTrigger(LayoutEvent.LAYOUT_COMPLETE))
		_parent.layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, draw,false,0,true);
		if (cA.fillMethod == 'bitmapFill') 
		{
			cA.bgImg =  new Image(
				new XML(
				'<Image  src="' + cA.url + '" alpha="' +
				Parse.baseCellTypes.alpha(cA.alpha) + '" />'), _parent
			);
			_parent.layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, draw,false,0,true);
		}
		backGrounds.set(id, cA);	
		if (sel) 
		{
			cAtts = cA;
			select(id);		
			if (cAtts.fadeIn == 'true')	
			{
				alpha = 0.0;
				_alpha = Parse.baseCellTypes.alpha(cAtts.alpha);
			}
			else
				alpha = Parse.baseCellTypes.alpha(cAtts.alpha);
		}
		//trace('');
	}
	
	public function addCallback(cs:ColorSetter)
	{
		colorSetters.push(cs);
		//Out.dumpStack(CallStack.callStack());
	}
	
	public function removeCallback(cs:ColorSetter)
	{
		colorSetters.remove(cs);
	}	
	
	public function select(id:String) 
	{
		//trace('id:' + id + ' currentId:' + currentId + ':' + alpha + ':' + alpha + ':' + _isDynamic);
		if (id == currentId)
			return;
		cAtts = backGrounds.get(id);
		if (cAtts.fillMethod == 'bitmapFill') 
		{
			trace(_parent.name + ' oooops not complete:' +!cAtts.bgImg.isComplete);
			if(!cAtts.bgImg.isComplete)
			return;
		}
		draw();
		if (!_isDynamic)
			return;
		if (Application.instance.menu != null && _parent == Application.instance) 
			updateMenu(id);
		currentId = id;
		for (cs in colorSetters)
		{
			cs(getColors());			
		}
		if(Cookie.isEnabled())
			Cookie.set( { BackGround:id } );
	}
	
	public function updateMenu(id:String)
	{
		for (c in Application.instance.menu.idMap.iterator())
		{
			if (c.id == id)
				c.interactionState = InteractionState.DISABLED;
			else if (currentId != null && c.id == currentId)
				c.interactionState = InteractionState.ENABLED;
			//trace(c.id + ' == ' +id + ' currentId:' + currentId);
		}		
	}
	
	public function set(?id:Dynamic) {
		//trace('_parent.name:' + _parent.name+ ' id:' + id + ' currentId:' + currentId);
		if (id)
			select(id);
		dispatchEvent(new BackgroundEvent(BackgroundEvent.CHANGE));
	}
	
	public function getColors():Array < String > {
		return  cAtts.colors == null ? null :ArrayTools.map(
			cAtts.colors.split(','), StringTools.trim
		);
	}
	
	public function getColor(i:Int):Null<UInt> {
		var colors:Array<String> = getColors();
		if (colors == null || colors.length<i+1)
			return null;
		return Std.parseInt( ArrayTools.map(
			colors, StringTools.trim
		)[i]);
	}
	
	function updateMenu2() 
	{
		//	TODO:DYNAMIC ADDING OF BACKGROUNDS
	}	
	
	public function fadeIn() 
	{		
		if (cAtts.fadeIn == 'true') {
			
			STween.add (this, 1.0, { alpha:cAtts.alpha == null ? 1.0 :cAtts.alpha //, onComplete:drawBg
			} );
			cAtts.fadeIn = false;
		}
		
		//trace('alpha:' + cAtts.alpha);
	}
	
	public function draw(?evt:Dynamic) 
	{
		graphics.clear();
		var param:Dynamic = { top:0, left:0, type:null, spreadMethod:null, interPolationMethod:null, 
			focalPointRatio:null };
		trace(name +':' + Std.string(cAtts));
		//trace(Std.string(_parent.name + ':' + _parent.box));
		//Out.dumpStack(CallStack.callStack());
		switch(cAtts.fillMethod) 
		{
			case 'bitmapFill':	
			_parent.layoutRoot.removeEventListener(LayoutEvent.LAYOUT_COMPLETE, draw, false);
			if (!Application.instance.resizing) 
			{
				addEventListener(BackgroundEvent.CHANGE, draw,false,0,true);
			}
			bData = cAtts.bgImg.drawScaledData(_parent.box, Alignment.MIDDLE,  
			{
				blendColor:(cAtts.blendColor == null ? 0:Parse.att2UInt(cAtts.blendColor))
			});
			//trace('getPixel32(100, 100):' + bData.getPixel32(100, 100));
			graphics.beginBitmapFill(bData, null, false, true);
			//return;
			case 'gradientFill':
			param.width = _parent.box.width;
			param.height = _parent.box.height;
			Parse.applyToObject(param, Parse.gradientTypes, cAtts);
			//trace(Std.string(param));
			//TODO:SWITCH ON FILL GRADIENT TYPE
			param.fillType = FillType.verticalGradient(param);
			if (_parent.cornerRadius == null)
			{
				Paint.drawRect(graphics, param);		
				return;
			}
			else
				Paint.beginFill(graphics, param);	
			case 'copyBg':
			//trace(relBg);
			if (relBg == null) 
			{
				relBg = (cAtts.rel == '@' ? Application.instance :
				FlashTools.numTarget(cAtts.rel.split('@')));
				//trace(relBg);
				if (relBg == null)//NOTHING TO COPY FROM
					return;
				//_parent.layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, draw,false,0,true);
				if (!Application.instance.resizing)
				{
					if (cAtts.fadeIn != 'false')
						alpha = 0;
					relBg.bG.addEventListener(BackgroundEvent.CHANGE, draw, false, 0, true);		
					_parent.layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, draw,false,0,true);
				}
				return;
			}
			var cBox:Rectangle = _parent.box.clone();//CLIPBOX
			cBox.y = _parent.getBounds(relBg).y;
			cBox.width = 1;
			var mat:Matrix = new Matrix();
			mat.translate(0, -cBox.y);
			//trace('source.alpha:' + relBg.bG.alpha);
			//trace(_parent.name + ' source::cBox:' + cBox);
			Fill.beginCopyFill(five(cast relBg.bG, mat, null, null, cBox), graphics);
			case 'fill':
			Parse.applyToObject(param, Parse.graphicsTypes, cAtts);
			//trace(Std.string(param.fill));
			if (param.fill)
				Reflect.callMethod(graphics, Reflect.field(graphics, 'beginFill'), param.fill);
			if (param.lineStyle)
				Reflect.callMethod(graphics, Reflect.field(graphics, 'lineStyle'), param.lineStyle);
			default:
			//throw('fill method:' + cAtts.fillMethod + ' not implemented!');
			//use floodFill
			
		}
		paint();				
		//trace(cAtts.alpha + ':' + alpha);
	}
	
	function paint()
	{
		trace (cAtts.fillMethod + _parent.name +':' + Std.string(_parent.cornerRadius) + ':' + _parent.box);
		//Out.dumpStack(CallStack.callStack());
		//graphics.clear();
		if (_parent.cornerRadius != null)
		{
			//trace(_parent.cornerRadius.method);
			switch(_parent.cornerRadius.method)
			{
				case 'drawRoundRect':
				//trace(_parent.margin.left+', '+_parent.margin.top +', '+
					//_parent.box.width + _parent.cornerRadius.TR * 2+', '+ _parent.box.height + _parent.cornerRadius.BR * 2+', '+ _parent.cornerRadius.TR * 2+', '+_parent.cornerRadius.BR * 2);
				graphics.drawRoundRect(_parent.margin.left, _parent.margin.top,
					_parent.box.width - _parent.margin.left - _parent.margin.right, 
					_parent.box.height - _parent.margin.top - _parent.margin.bottom, 
					_parent.cornerRadius.TR * 2, _parent.cornerRadius.BR * 2);
				case 'drawRoundRectComplex':
				trace(_parent.margin.left+', '+ _parent.margin.top+', '+
					Math.round(_parent.box.width - _parent.margin.left - _parent.margin.right) +', '+
					Math.round(_parent.box.height - _parent.margin.top - _parent.margin.bottom)+', '+
					_parent.cornerRadius.TL+', '+ _parent.cornerRadius.TR+', '+ _parent.cornerRadius.BL+', '+ _parent.cornerRadius.BR);

				graphics.drawRoundRectComplex(_parent.margin.left, _parent.margin.top,
					Math.round(_parent.box.width - _parent.margin.left - _parent.margin.right) ,
					Math.round(_parent.box.height - _parent.margin.top - _parent.margin.bottom),
					_parent.cornerRadius.TL, _parent.cornerRadius.TR, _parent.cornerRadius.BL, _parent.cornerRadius.BR);
			}
		}
		else
			graphics.drawRect(_parent.margin.left, _parent.margin.top, _parent.box.width - _parent.margin.left - _parent.margin.right, 
			_parent.box.height - _parent.margin.top - _parent.margin.bottom);		
		//Out.dumpLayout(this);
		if (cAtts.fadeIn == 'true')
			{
				//alpha = 0.0;
				fadeIn();		
			}
		//Out.dumpLayout(this.parent);
		//trace(this._parent.name);
	}
	
	public function destroy()
	{
		if (bData != null)
			bData.dispose();
		if (bgImg != null)
			bgImg.destroy();
		bgImg = null;
	}	
}