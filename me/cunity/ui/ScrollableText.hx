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

import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.xml.XML;
import haxe.Timer;
import me.cunity.debug.Out;

import me.cunity.effects.STween;
import me.cunity.events.BackgroundEvent;
import me.cunity.events.LayoutEvent;
import me.cunity.graphics.Fill;


import me.cunity.core.Application;
import me.cunity.text.Format;
//import me.cunity.tools.FlashTools;
import me.cunity.ui.control.ScrollBar;

using me.cunity.tools.XMLTools;


class ScrollableText extends Text
{
	//public var tF:TextField;
	//var relBg:BaseCell;
	var sBar:ScrollBar;
	//var sBar:TextScrollBar;
	
	var _viewBox:Sprite;
	//var startLayout:Float;
	
	public function new(xNode:XML, p:Container) 
	{
		super(xNode, p);
		sBarWidth = 15;
		//tF.addEventListener(Event.SCROLL, onScroll);
	}
	
	function onScroll(evt:Event):Void
	{
		tF.scrollV = 0;
	}
	
	override public function destroy()
	{
		if (cAtts.scrollbarColor == '_bG' )
			Application.instance.bG.removeCallback(sBar.tint);		
		if (sBar != null)
		{
			sBar.destroy();
			removeChild(sBar);
			sBar = null;
		}
		super.destroy();
		
	}
	
	/*override function addChildren()
	{
		//nothing to add here
	}*/
	
	function setMask():DisplayObject {
		if (tF.mask == null)
		{
			_viewBox = new Sprite();			
			_viewBox.x = contentMargin.left;
			_viewBox.y = contentMargin.top;			
			addChild(_viewBox);
			tF.mask = _viewBox;
		}
		//tF.borderColor = 0xff00ff;
		//tF.border = true;		
		//if (tF.mask != null){ //we need to redraw only
		trace(tF.autoSize + ' viewBox.width:' + (box.width - sBarWidth - margin.left - margin.right) + 
			'  viewBox.height:' + (box.height - contentMargin.top - contentMargin.bottom));
		_viewBox.graphics.clear();
		_viewBox.graphics.beginFill(0xaaaaaa, 0.2);
		_viewBox.graphics.drawRect(0, 0, 
			//contentBox.width, contentBox.height);
			box.width - contentMargin.left - contentMargin.right, box.height - contentMargin.top - contentMargin.bottom);
		return _viewBox;

	}
	
	override public function layout()
	{
		tF.wordWrap = true;
		//trace(box + ' tF.width:' + tF.width);
		super.layout();		
		//trace(box + ' tF.width:' + tF.width );
		//box.width += 20;
		tF.width -= 20;
		trace(box + ' tF.width:' + tF.width + ' tF.height:' + tF.height + ' tF.textHeight:'  + tF.textHeight +' autosize:' + tF.autoSize);
		//tF.autoSize = TextFieldAutoSize.NONE;
		tF.height = tF.textHeight + 4;
		//if (!fixedHeight && tF.height + contentMargin.top + contentMargin.bottom <= maxContentDims.height)
		if (!fixedHeight)
		{			
			//box.height = tF.height + contentMargin.top + contentMargin.bottom;
			box.height = tF.height + contentMargin.top + contentMargin.bottom <= maxContentDims.height ? 
				tF.height + contentMargin.top + contentMargin.bottom :maxContentDims.height;
			trace(box);
		}
		trace(tF.autoSize + ' tF.width:' + tF.width + ' tF.height:' +tF.height + ':' + tF.getBounds(this) + ':' + fixedHeight);
		tF.mouseWheelEnabled = false;
		if (sBar == null) 
		{//CREATE SCROLLBAR ON LAYOUT ROOT READY
			alpha = 0;
			//trace(Timer.stamp() - startLayout);
			layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, addScrollBar);
		}
		else
		{//RESIZE ONLY
			
			//sBar.resize(new Rectangle(0, 0, _viewBox.width, _viewBox.height));
			sBar.resize(new Rectangle(0, 0, box.width - contentMargin.left - contentMargin.right, box.height - contentMargin.top - contentMargin.bottom));
		}
		setMask();
	//	trace(tF.width+ ' textWidth' + tF.textWidth+ ' box:' + box + 'marginWidth:' + (margin.left + margin.right));
		
		//return box;
	}
	
	override public function resize()
	{
		if(sBar != null)
		sBar.resize(new Rectangle(0, 0, box.width - contentMargin.left - contentMargin.right, box.height - contentMargin.top - contentMargin.bottom));
	}
		
	override function bGCopy(evt:Event) 
	{		
		//trace(relBg);
		//trace(Timer.stamp() - startLayout);
		if (Type.getClass(getChildAt(0)) == Shape)
			removeChildAt(0);
		var s:Shape = new Shape();
		s.alpha = Std.parseFloat(cAtts.copyBg);
		addChildAt(s, 0);
		//var myBox:Rectangle = tF.getBounds(layoutRoot);
		var myBox:Rectangle = tF.getBounds(relBg);
		//var myBox:Rectangle = box;
		var cBox:Rectangle = myBox.clone();//CLIPBOX
		cBox.x = 0;
		cBox.y = tF.getBounds(layoutRoot).y;
		cBox.width = 1;
		cBox.height += margin.top;//DON'T GET WHY WE NEED THIS HERE...
		var mat:Matrix = new Matrix();
		//mat.translate(0, -(cBox.y - margin.top));
		mat.translate(0, -cBox.y);
		Fill.beginCopyFill(five(cast relBg.bG, mat, null, null, cBox), s.graphics);
		s.graphics.drawRect(margin.left, margin.top, myBox.width, myBox.height);
		//s.graphics.drawRect(margin.left/2, margin.top/2, myBox.width - margin.left, myBox.height - margin.top);
		//s.graphics.drawRect(0, margin.top/2, myBox.width - margin.left, myBox.height - margin.top);
		STween.add(this , 1.0, { alpha:1.0 } );
		//trace('done.........');
	}
	
	function addScrollBar(evt:Event)
	{
		//trace(Timer.stamp() - startLayout);
		layoutRoot.removeEventListener(LayoutEvent.LAYOUT_COMPLETE, addScrollBar, false);
		//setMask();
		var trackColor:UInt = (cAtts.scrollbarColor == '@bG' ? Application.instance.bG.getColor(0) :0xaaaaaa);
		var gripColor:UInt = (cAtts.scrollbarColor == '@bG' ? Application.instance.bG.getColor(1) :0x884400);
		//trace(StringTools.hex(trackColor, 6) + ' - ' + StringTools.hex(gripColor, 6));
		if (tF.styleSheet != null) {
			trace(tF.styleSheet.transform(tF.styleSheet.getStyle('body')).color);
			//trackColor = tF.styleSheet.transform(tF.styleSheet.getStyle('body')).color;
		}
		//c:Dynamic, tc:UInt, gc:UInt, gpc:UInt, grip:UInt, tt:Int, gt:Int, ea:Int, hs:Bool, sT:Bool = false)
		//sBar = new ScrollBar(tF, new Rectangle(0, 0, mDi.width, mDi.height)
		//tF.background = true;
		//tF.backgroundColor = 0;
		trace(tF.parent);
		//Out.dumpLayout(this, true);
		trace(layoutRoot.box + ':' + _viewBox.width +' x ' +  _viewBox.height + ' sBar:' + sBarWidth);
		//sBar = new ScrollBar(tF, new Rectangle(0, 0, maxContentDims.width, maxContentDims.height),
		sBar = new ScrollBar(tF, new Rectangle(0, 0, _viewBox.width, _viewBox.height),
			trackColor, gripColor, 0x05b59a, 0x888888, sBarWidth, sBarWidth, 8, true, 
			Math.ceil(tF.height / tF.numLines));
		if (cAtts.scrollbarColor == '_bG' )
			Application.instance.bG.addCallback(sBar.tint);
		//addChild(sBar);
		//STween.removeAllTweens();
		STween.add(this , 1.0, { alpha:1.0} );
	}

}