/**
 *
 * @author Axel Huizinga
 */

package me.cunity.graphics;
import me.cunity.debug.Out;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.xml.XMLNode;
import me.cunity.ui.Container;

class BitmapLoader extends Loader
{

	var _attributes:Dynamic;
	public var bData:BitmapData;
	var _onCompleteCallback:Void -> Void;
	var _img:Dynamic;
	
	//public function new(p:Container, img:XMLNode) 
	public function new( img:Dynamic) 
	{
		super();
		//cacheAsBitmap = true;
		//_parent = p;
		_img = img;
		if(img.onCompleteCallback != null)
		//_onCompleteCallback = Reflect.field(_parent, img.onCompleteCallback);
		this._onCompleteCallback =  img.onCompleteCallback;
		contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete,false,0,true);
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
		var request:URLRequest = new URLRequest(img.href);
		load(request);
	}
	
	function getBitmapData(content:DisplayObject) {
		bData = new BitmapData(Std.int(content.width), Std.int(content.height));
		var mat:Matrix = new Matrix();
		bData.draw(content, mat);
	}
	
	//public function drawBgImage(bgDims:Dynamic, g:Graphics) {
	public function drawBgImage(bgDims:Dynamic, s:Sprite) {
		//{menuXslide:menuXslide, menuTop:bBox.y}
		trace(bgDims.menuXslide + ':' + bgDims.menuTop + ' :' + bgDims.windowHeight);
		bData = new BitmapData(1, Std.int(height), true);
		var mat:Matrix = new Matrix();
		var cRect:Rectangle = new Rectangle(0, 0, 100, bgDims.height);
		bData.draw(this, mat);
		//var bmp = new Bitmap(bData, PixelSnapping.AUTO, true);

		mat.createBox(1, bgDims.windowHeight / height,  0, 0, -bgDims.menuTop);
		s.graphics.beginBitmapFill(bData, mat);
		s.graphics.drawRect(0, 0, s.parent.stage.stageWidth, s.parent.stage.stageHeight);
		s.graphics.endFill();
		trace (Std.string(bData.getPixel32(10, 0) & 0xffffff)); 
		//bData.scroll(0, Std.int(-bgDims.menuTop));
		trace (Std.string(bData.getPixel32(10, 120))); 
		//trace(bmp.width +' x ' + bmp.height );
		//return new Bitmap(bData);
	}	
	
	function onComplete(event:Event) {
		//trace(Std.string(this == event.target.loader));
		var info:LoaderInfo = contentLoaderInfo;
		//trace(event.target + "loaderURL=" + info.loaderURL + " url=" + info.url);
		var content:DisplayObject = info.content;
		getBitmapData(content);
		if (_img.modify != null) {
			switch(_img.modify) {
				case 'makeSeamlessX':
				var fMatrix:Matrix = new Matrix();
				fMatrix.scale( -1, 1);
				fMatrix.translate(content.width*2, 0);

				var sBitmap:BitmapData = new BitmapData(
					Std.int(content.width * 2), Std.int(content.height)
					);
				sBitmap.draw(content, fMatrix);
				sBitmap.copyPixels(
					bData, new Rectangle(0, 0, bData.width, bData.height), new Point(0, 0)
				);
				bData = sBitmap;
			}
		}
		
		//_parent.bgBitmapLoaded = true;
		if(_onCompleteCallback != null)
			//_parent._onCompleteCallback.apply(null);
			_onCompleteCallback();
		//trace(_parent.name +':'+Std.string(_parent._onCompleteCallback==null));
	}
	
	function onError(event:IOErrorEvent) {
		trace("ioErrorHandler:" + event);
	}
}