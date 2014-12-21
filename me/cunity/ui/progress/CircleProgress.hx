package me.cunity.ui.progress;

	import flash.accessibility.Accessibility;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.Lib;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.xml.XML;
	import flash.xml.XMLList;
	import haxe.Resource;
	import haxe.CallStack;
	
	import me.cunity.debug.Out;
	import me.cunity.tools.FlashTools;
	import me.cunity.ui.Container;
	import me.cunity.ui.BaseCell;
	import me.cunity.core.Types;
	using me.cunity.tools.XMLTools;
	
	class CircleProgress extends ProgressRunnable
	{
		
		var bgColor:UInt;
		var slices:Int;
		var radius:Int;
		//var sliceHeight:Float;
		//var sliceWidth:Float;
		var sliceRadius:Float;
		var maskClip:Sprite;
		var imgBox:Sprite;
		var image:DisplayObject;
		var imgRotation:Int;
		var counter:TextField;
		var countDown:Int;
		var count:Int;
		var lastCount:Int;
		var readyCallback:Dynamic->Void;
		var pro:Progress;
		public var countBox:Rectangle;
		
		public function new(xN:XML, p:Progress)
		{
			super(xN, p);//?slices:Int = 12, ?radius:Int = 24
			name = xNode.getXPath();
			p.psRun = this;
			pro = p;
			//trace(p.psRun);
			//p.childrenPending++;
			if (layoutRoot != null)
				layoutRoot.resourceList.add(this);			
			//cAtts = XConfig.getAttributes(xNode);
			var radius = Std.parseInt(cAtts.radius);
			var slices =  Std.parseInt(cAtts.slices);
			this.bgColor = cAtts.bgColor != null ? Std.parseInt(cAtts.bgColor):0xaaaaaa;
			//trace(0xaaaaaa +':'+cAtts.bgColor + ':' + Std.string(this.bgColor));
			this.slices = cAtts.slices != null ? Std.parseInt(cAtts.slices):12;
			this.radius = cAtts.radius != null ? Std.parseInt(cAtts.radius):80;
			//sliceHeight = this.radius / 10;
			//sliceWidth = this.radius / 3;
			sliceRadius = this.radius / 8;
			imgRotation = -8;
			drawSlices();
			var bytes:ByteArray = cast (Resource.getBytes('CircleProgress').getData(), ByteArray);	
			var loader:Loader = new Loader();	
			configureListeners(loader.contentLoaderInfo);
			//var request:URLRequest = new URLRequest(xNode.attribute('imgUrl').toString());
			loader.loadBytes(bytes);
			addChild(loader);
			visible = true;
			var cBSize = Math.sqrt(2 * Math.pow( (radius / 16 * 15), 2));
			countBox = new Rectangle(radius + sliceRadius -cBSize/2, radius + sliceRadius -cBSize/2, cBSize, cBSize);
		}

		private function configureListeners(dispatcher:EventDispatcher):Void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler,false,0,true);
			//dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler,false,0,true);
			//dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
		}
		
		private function completeHandler(event:Event):Void {
			event.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler, false);
			//event.target.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false);
			//event.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false);		
			imgBox = new Sprite();
			image = imgBox.addChild(event.target.content);
			imgBox.mask = maskClip;
			imgBox.graphics.beginFill(bgColor);
			addChild(imgBox);
			addChild(maskClip);
			imgBox.x = imgBox.y = radius;
			image.scaleX = image.scaleY = (radius+5)*2/image.width;
			//trace('imgWidth:' + image.width + ' scale:' + image.scaleX);
			image.x = image.y = -image.width / 2;
			//trace('imgWidth:' + image.width + ':' + Std.string(imgBox.getBounds(this)));
			imgBox.graphics.drawRect(-imgBox.width/2, -imgBox.height/2, imgBox.width, imgBox.height);
			box = new Rectangle(0, 0, radius * 2, radius * 2);
			layoutRoot.resourceReady(this);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):Void {
			trace("securityErrorHandler:" + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):Void {
			trace("ioErrorHandler:" + event);
		}		
		
		function drawSlices():Void
		{
			var i:Int = slices;
			var degrees:Int = Std.int(360 / slices);
			maskClip = new Sprite();
			while (i-->0)
			{
				var slice:Shape = getSlice();
				//slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Int = Std.int((degrees * i) * Math.PI / 180);
				maskClip.addChild(slice);
				//trace(Std.string(slice.getBounds(this)));
				slice.rotation = -degrees * i;
				slice.x = slice.y = radius;
			}		
		}
		
		function getSlice():Shape
		{
			var slice:Shape = new Shape();
			slice.graphics.beginFill(0x0);
			//slice.graphics.drawCircle(radius - sliceRadius,  -sliceRadius / 2, sliceRadius);
			slice.graphics.drawRoundRect(radius - sliceRadius*2.5,  -sliceRadius / 2, sliceRadius*2.5, 
				sliceRadius, sliceRadius/2, sliceRadius/2);
			slice.graphics.endFill();
			return slice;
		}
		
		override public function run(evt:Dynamic) {
			imgBox.rotation += imgRotation;
		}
		
		override public function getBox() 
		{
			//trace(box);
			//Out.dumpStack(CallStack.callStack());
			pro.box = box;
			//draw();
			//return box;
		}
	}
