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
import flash.display.BlendMode;
import flash.display.Loader;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.xml.XML;
import haxe.Timer;
import me.cunity.core.Application;
import me.cunity.debug.MemoryTracker;


import me.cunity.layout.Alignment;

class Image extends BaseCell
{
	
	var cB:Dynamic;
	public var bmp:Bitmap;
	var bData:BitmapData;
	
	
	public function new(xNode:XML, p:Container, cB = null) 
	{
		super(xNode, p);
		//trace(xNode.toXMLString());
		//trace(cB);
		#if debug
		MemoryTracker.track(this, Type.getClassName(Type.getClass(this)));
		#end
		if (xNode == null)
			return;
		this.cB = cB;
		if (layoutRoot != null)
			layoutRoot.resourceList.add(this);			
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete,false,0,true);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler,false,0,true);
		var req:URLRequest = new URLRequest(xNode.attribute('src').toString());
		loader.blendMode = BlendMode.LAYER;
		loader.cacheAsBitmap = true;
		loader.load(req);
	}
	
	public function copy() :Image{
		var copyImg = new Image(null, null);
		copyImg.content = copyImg.addChild ( new Bitmap (bData, PixelSnapping.AUTO, true) );
		copyImg.content.x = margin.left;
		copyImg.content.y = margin.top;
		copyImg.box = box;
		return copyImg;
	}
	
	function onComplete(evt:Event) {
		//trace(evt.target.loader.contentLoaderInfo + ':' + cB);
		evt.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete, false);
		evt.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler, false);
		//evt.target.loader = null;
		//removeEventListener
		bData = new BitmapData (Math.round (evt.target.content.width),
			Math.round (evt.target.content.height), true, 0
		);
		//trace(_parent.name );
		bData.draw ( evt.target.content );
		//bmp = new Bitmap (bData, PixelSnapping.AUTO, true);
		bmp = new Bitmap (bData, PixelSnapping.NEVER, true);
		var s:Sprite = new Sprite();
		//bmp.x = bmp.width / -2;//	
		//bmp.y = bmp.height / -2;// 		
		if (cAtts.filter != null && (Application.instance.cAtts.filters:Map<String,Dynamic>).exists(cAtts.filter))
			s.filters = [Application.instance.cAtts.filters.get(cAtts.filter)];		
		s.addChild(bmp);
		//s.x =  bmp.width / 2 + margin.left;
		//s.y = bmp.height / 2 + margin.top;		
		//s.x =  margin.left;
		//s.y = margin.top;		
		content = this.addChild (s);
		//trace(_parent.name + 'added:' + content + ':' + evt.target.loader.contentLoaderInfo.url  + ' parent:' + parent);
		contentBox = new Rectangle(margin.left, margin.top, evt.target.width, evt.target.height);
		box.width = evt.target.width + margin.left + margin.right;
		box.height = evt.target.height + margin.top + margin.bottom;
		//isComplete = true;
		trace(box);
		if (layoutRoot != null)
		{
			/*var img = this;
			var lR = layoutRoot;
			Timer.delay(function() { lR.resourceReady(img); }, 500);*/
			layoutRoot.resourceReady(this);
		}
		if (cB != null)
			cB();
	}
	
	public function drawScaledData(drawBox:Rectangle,  ?align :Alignment, ?dAtts:Dynamic):BitmapData
	{
		if (dAtts == null)
			dAtts = { blendColor:0};
		//trace(Std.string(dAtts));
		var blendColor:UInt = dAtts.blendColor;
		//trace(blendColor + ':' + drawBox + ':'  + content);
		var matrix:Matrix = new Matrix();
		var scale:Float = Math.max(drawBox.width / content.width, drawBox.height / content.height);
		var w:Float = content.width * scale;
		var h:Float = content.height * scale;
		trace(w +' x ' + h + ' drawBox:' + drawBox + ' scale:'  + scale);
		var tX:Float = 0.0;
		var tY:Float = 0.0;
		switch(align)
		{
			case Alignment.LEFT, Alignment.TOPLEFT, Alignment.BOTTOMLEFT :
				tX = w/2;				
			case Alignment.RIGHT, Alignment.TOPRIGHT, Alignment.BOTTOMRIGHT :
				tX =  drawBox.width - w/2;
			default ://MIDDLE
				//tX = 0.5 * (content.width - drawBox.width);
				tX = 0.5 * (drawBox.width - w);
				
		}		
		switch(align)
		{
			case Alignment.TOP, Alignment.TOPLEFT, Alignment.TOPRIGHT :
				tY = h/2;				
			case Alignment.BOTTOM, Alignment.BOTTOMLEFT, Alignment.BOTTOMRIGHT :
				tY = drawBox.height - h/2;	
			default ://MIDDLE					
				//tY = 0.5 * (content.height - drawBox.height);
				tY = 0.5 * (drawBox.height - h);
		}		
		trace(tX + ' x ' + tY);
		var scaled:BitmapData = 
			new BitmapData(Math.ceil(drawBox.width), Math.ceil(drawBox.height), true, blendColor);
		var alp:Null<Float> = Std.parseFloat(xNode.attribute('alpha').toString());
		var cTrans:ColorTransform = (alp != null ? new ColorTransform(1, 1, 1, alp) :null);
		scaled.draw(content, new Matrix(scale, 0, 0, scale, tX, tY), cTrans, BlendMode.OVERLAY, null, true);
		return scaled;
	}
	
	public function drawScaled(drawBox:Rectangle,  ?align :Alignment, ?dAtts:Dynamic):Bitmap 
	{
		var scaled:Bitmap = new Bitmap(drawScaledData(drawBox, align, dAtts), PixelSnapping.NEVER, true);
		return scaled;
	}
	
	function errorHandler(evt:IOErrorEvent) {
		trace(evt.text);
	}	
	
	override public function getBox()
	//override public function layout()
	{
		getMaxDims();
		applyMargin();	
		super.getBox();
	}
	
	override public function destroy()
	{
		bmp = null;
		bData.dispose();
		bData = null;
		super.destroy();
	}

}