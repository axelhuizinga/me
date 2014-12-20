/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.ui;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.xml.XML;
//import format.swf.Data;
//import format.swf.Reader;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import me.cunity.core.Application;
//mport me.cunity.animation.ScreenPlay;
import me.cunity.animation.TimeLine;
import me.cunity.debug.Out;

typedef ScreenPlay = {
	public var storyBoard:StringMap<Dynamic>;
	public var directorTimeLine:TimeLine;
	public var nextCall:Dynamic;
	public var nextKey:Dynamic;
	public function init(w:Float , h:Float ):Void;
}

class SWF extends BaseCell
{

	//var screenPlay:ScreenPlay;
	var screenPlay:Dynamic;
	var loadedMain:Class<Dynamic>;
	
	public function new(xN:XML, p:Container) 
	{
		super(xN, p);
		if (layoutRoot != null)
			layoutRoot.resourceList.add(this);	
		var loader = new Loader();
		var ctx:LoaderContext =  new LoaderContext();
		ctx.applicationDomain = new ApplicationDomain();
		//ctx.applicationDomain = ApplicationDomain.currentDomain;ApplicationDomain.currentDomain
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler,false,0,true);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler,false,0,true);		
		//loader.load(new URLRequest(xN.attribute('src').toString()), ctx);
		trace('going2load:' +xN.attribute('src').toString());
		loader.load(new URLRequest(xN.attribute('src').toString()));
	}
	
	
	function completeHandler(evt:Event)
	{
		evt.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler, false);
		evt.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler, false);
		trace('hmm...' + Std.string(cAtts));
		loadedInst = Lib.current.assets.get(id);
		trace(id + ':' + loadedInst);
		if (_parent.timeLine != null)//TODO:CONFIGURE THIS
		{
			loadedInst.nextCall = _parent.timeLine.runNextKey;
		}
		if(layoutRoot !=null)
			layoutRoot.resourceReady(this);
	}
	
	
	override public function layout()
	//override public function layout():Rectangle
	{
		getMaxDims();
		applyMargin();
		super.layout();
		trace(Std.string(box) +':' + Std.string(maxContentDims));
		if (loadedInst != null)
		{
			if( !contains(loadedInst))
				addChild(loadedInst);
			trace(loadedInst.loaderInfo );
			//Out.dumpLayout(loadedInst);
			//loadedInst.init(box.width - margin.left - margin.right, box.height - margin.top - margin.bottom, 
			if (Application.instance.resizing)
			{				
				var scale:Float = Math.max(maxContentDims.width / loadedInst.width , maxContentDims.height / loadedInst.height  );
				//Out.dumpLayout(loadedInst);
				var aM:Matrix = loadedInst.transform.matrix;
				trace('scale:' + scale + ' actMatrix:' + aM);
				aM.translate( -aM.tx, -aM.ty);
				aM.scale(scale, scale);
				aM.translate((maxContentDims.width - loadedInst.width * scale) / 2, (maxContentDims.height - loadedInst.height * scale) / 2);
				loadedInst.transform.matrix = aM;
				//loadedInst.x = (maxContentDims.width - loadedInst.width * scale) / 2;
				//loadedInst.y = (maxContentDims.height - loadedInst.height * scale) / 2;
				//loadedInst.scaleX = loadedInst.scaleY = scale;
				//loadedInst.resize(maxContentDims.width, maxContentDims.height);
			}
			else
				loadedInst.init(maxContentDims.width, maxContentDims.height, 
					{ longitude:Std.parseFloat(Lib.current.loaderInfo.parameters.longitude) } );
			//loadedInst.finalYRot = Std.parseFloat(Lib.current.loaderInfo.parameters.longitude);
			//Out.dumpLayout(loadedInst);
		}
		
	}
	
	function errorHandler(evt:IOErrorEvent)
	{
		trace(evt.toString());
	}
	
}