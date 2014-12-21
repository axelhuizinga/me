/**
 *
 * @author Axel Huizinga
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

package me.cunity.fonts;
import flash.events.ProgressEvent;
import flash.utils.ByteArray;
import format.swf.Data;
import format.abc.Data;
import flash.events.IOErrorEvent;
import haxe.ds.IntMap.IntMap;
import me.cunity.debug.Out;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import haxe.io.Bytes;
import me.cunity.ui.Container;
import me.cunity.ui.BaseCell;


class RuntimeFontLoader extends BaseCell
{
	var fontName:String;
	var param:Dynamic;
	var fontClassNames:Array<String>;
	
	public function new( p:Dynamic, parent:Container) 
	{//cBack:Void->Void, fCNames:Array<String>=null
		super(null, null);
		_parent = parent;
		layoutRoot = _parent.layoutRoot;
		if (_parent.resourceList != null)
			_parent.resourceList.add(this);
		else if (layoutRoot.resourceList != null)
			layoutRoot.resourceList.add(this);		
		param = p;
		var loader:Loader = new Loader();
		var ctx:LoaderContext = new LoaderContext();
		ctx.applicationDomain = new ApplicationDomain();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler,false,0,true);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler,false,0,true);
		loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler,false,0,true);
		//trace('fontLib:' + fontLib);
		var slashOrBackslash = ~/\\/.match(p.fontLib) ? '\\' :'/';
		fontName = new EReg(".*"+slashOrBackslash,null).replace(p.fontLib, '');
		fontName = ~/\.swf/.replace(fontName, '');
		
		//trace(Std.string(fontName));
		//trace(fontName);
		var req:URLRequest = new URLRequest(p.fontLib);
		//trace(req.url);
		loader.load(req, ctx);
	}
	
	function getFontClasses(data:ByteArray):Array<String>
	{
		var classNames:Array<String> = new Array();
		#if flash
		var swfReader = new format.swf.Reader(new haxe.io.BytesInput(Bytes.ofData(data)));
		var header = swfReader.readHeader();
		var tags = swfReader.readTagList();
		var ids:IntMap<String>=new IntMap<String>();
		for (t in tags) {
			//trace(t);
			switch (t)
			{
				case TFont(id, data):
					ids.set(id, 'TFont');
				case TSymbolClass(symbols):
					for (s in symbols)
						if (ids.exists(s.cid))
							classNames.push(s.className);
				default:
			}
		}
		#end
		return classNames;
	}
	
	function completeHandler(event:Event):Void {		
		fontClassNames =  param.fontClassNames == null ? getFontClasses(event.target.bytes) :param.fontClassNames;
		trace(fontClassNames);
		try {			
			for (fC in fontClassNames) {
				//trace(fC +':' + Type.typeof(fC) +':' + event.target.applicationDomain.getDefinition(fC));				
				var fontClass:Class < Font > = event.target.applicationDomain.getDefinition(fC);
				//trace(fC + ':' + Type.createInstance(fontClass, []).fontName);
				//trace(fC + ':' + Type.createInstance(fontClass, []).fontStyle);
				//continue;
				Font.registerFont(fontClass);
			}
		}
		catch (ex:Dynamic) {
			trace(ex);
		}
		if (param.cB != null)
		{
			//param.cbArgs
			Reflect.callMethod(null, param.cB, param.cbArgs);
		}
		//isComplete = true;
		if(layoutRoot !=null)
			layoutRoot.resourceReady(this);
	}
	
	
	function errorHandler(evt:IOErrorEvent) {
		trace(evt.text);
	}
	
	function progressHandler(event:ProgressEvent):Void {
        //trace("progressHandler:bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		if(param.updateProgress!= null) param.updateProgress(Math.round(100 * event.bytesTotal / event.bytesLoaded));
    }
	
}