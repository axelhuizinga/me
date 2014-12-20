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
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.Capabilities;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.xml.XML;
import flash.xml.XMLList;
import haxe.CallStack;
import haxe.Timer;

import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.events.BackgroundEvent;
import me.cunity.events.LayoutEvent;
import me.cunity.graphics.Color;
import me.cunity.graphics.Fill;

import me.cunity.ui.form.Form;

import me.cunity.core.Application;
import me.cunity.text.Format;
import me.cunity.tools.FlashTools;


import org.libspark.ui.SWFWheel;
using me.cunity.tools.XMLTools;

class Text extends BaseCell
{
	public var tF:TextField;
	var bgShape:Shape;
	var relBg:BaseCell;
	var imgRefs:List<DisplayObject>;
	var linkTarget:Dynamic;
	var sBarWidth:Int;
	var textMargin:Float;
	
	static var tCount:Int = 0;
	//var xNode:XML;
	
	public function new(xN:XML, p:Container) 
	{
		super(xN, p);
		sBarWidth = 0;
		//trace(name + ' visible:' + visible);
		tF = new TextField();
		tF.name = Std.string(tCount++);
		//Format.applyTextFieldTypes(tF, cAtts, ['antiAliasType', 'autoSize', 'gridFitType', 'multiline', 'embedFonts', 'wordWrap']);
		Format.applyTextFieldTypes(tF, cAtts, ['antiAliasType', 'autoSize', 'gridFitType', 'multiline', 'embedFonts', 'sharpness', 'thickness','text']);
		tF.condenseWhite = true;
		trace('Application.instance.cAtts.styleSheet:' + Application.instance.cAtts.styleSheet + ' autosize:' + tF.autoSize);
		//tF.autoSize = TextFieldAutoSize.NONE;
		textMargin = 0;
		if (Application.instance.cAtts.styleSheet != null && cAtts.type != 'INPUT')
		{			
			tF.styleSheet = Application.instance.cAtts.styleSheet;
			var bodyStyle:Dynamic = tF.styleSheet.getStyle('body');
			if (bodyStyle != null)
			{
				if (Reflect.field(bodyStyle, 'marginLeft') != null)
					textMargin += Std.parseFloat(Reflect.field(bodyStyle, 'marginLeft'));
				else
					textMargin += 8;
				if (Reflect.field(bodyStyle, 'marginRight') != null)
					textMargin += Std.parseFloat(Reflect.field(bodyStyle, 'marginRight'));
				else
					textMargin += 8;
			}
			//trace(Reflect.field(bodyStyle, 'marginRight'));
		}

		//else if (cAtts.textFormat != null)
		else
		{
			var textFormat:String = (cAtts.textFormat != null ? cAtts.textFormat :iDefs.textFormat);
			tF.defaultTextFormat = Application.instance.textFormats.get(textFormat);
			textMargin = tF.defaultTextFormat.leftMargin + tF.defaultTextFormat.rightMargin;
			//tF.defaultTextFormat = Application.instance.textFormats.get(cAtts.textFormat);
		}
		//tF.borderColor = 0xff00ff;
		//tF.border = true;
		if (xNode.children().length() > 0) 
		{
			//trace(xNode.toString());
			/*var html = xNode.getInnerHTML();
			html = ~/\r|\n/g.replace(html, '');
			html = ~/\s{2,}/g.replace(html, ' ');
			tF.htmlText = html;*/
			tF.htmlText = xNode.getInnerHTML();
			try
			{
				var images:XMLList = xNode.descendants('img');
				trace( images.length());
				if (images.length() > 0)
				{
					tF.addEventListener(Event.CHANGE, onChange, false, 0, true);
					imgRefs = new List();
					if (layoutRoot != null)
						layoutRoot.resourceList.add(this);	
				}
				for (i in 0...images.length())
				{
					imgRefs.add(tF.getImageReference(images[i].attribute('id').toString()));
					if (images[i].attribute('id').toString().indexOf('mailto:') == 0)
					{
						imgRefs.last().addEventListener(
							MouseEvent.CLICK, function(evt:MouseEvent) { Application.instance.mail(images[i].attribute('id').toString()); }, false, 0, true);
						imgRefs.last().addEventListener(	
							MouseEvent.MOUSE_OVER, function(evt:MouseEvent) { 
								Mouse.cursor =  MouseCursor.BUTTON; }, false, 0, true);
						imgRefs.last().addEventListener(	
							MouseEvent.MOUSE_OUT, function(evt:MouseEvent) { 
								Mouse.cursor =  MouseCursor.AUTO; }, false, 0, true);						
					}
				}
			}
			catch (ex:Dynamic)
			{
				trace(ex);
			}
			
		}
		
		content = addChild(tF);
		
		if (cAtts.backgroundColor != null && cAtts.backgroundColor.indexOf('@') == 0) {
			this.xNode = xNode.setAttribute("backgroundColor=0x" + 
				StringTools.hex(Application.instance.bG.getColor(0), 6)
				//StringTools.hex(Color.newFromInt(Application.instance.bG.getColor(0)).ComplementaryColor()._uint, 6)
			);
			var _tF:TextField = tF;
			//Application.instance.bG.addCallback( { f:function(c:UInt) {tF.backgroundColor = c; }, i:1});
			Application.instance.bG.addCallback( function(c:Array<String>) { _tF.backgroundColor = Std.parseInt(c[0]);} );
			//trace(xNode.attribute('backgroundColor').toString());
		}
		//(Application.instance.cAtts.filters:Map<String,Dynamic>).
		if (cAtts.filter != null && (Application.instance.cAtts.filters:Map<String,Dynamic>).exists(cAtts.filter))
			tF.filters = [Application.instance.cAtts.filters.get(cAtts.filter)];
		
		if (cAtts.copyBg != null) {
			relBg = (xNode.attribute('rel').toString() == '@' ? Application.instance :
			FlashTools.numTarget(xNode.attribute('rel').toString().split('@')));
			if (relBg != null)
			{
				alpha = 0;
				layoutRoot.addEventListener(LayoutEvent.LAYOUT_COMPLETE, bGCopy,false,0,true);
				relBg.bG.addEventListener(BackgroundEvent.CHANGE, bGCopy,false,0,true);				
			}
		}
		
		trace (cAtts.listen) ;
		if (cAtts.listen != null) {
			var listeningObject:BaseCell = this;
			if (cAtts.to == null || cAtts.to.indexOf('@') == 0)//GET LINK FROM CONFIG
			{
				switch(cAtts.listen) {
					case 'LINK':
					linkTarget = Reflect.field(Application.instance, cAtts.to.substr(1));
					trace(cAtts.to + ':'  + linkTarget);
					addEventListener(TextEvent.LINK, forwardLink, false, 0, true);
					case 'GLOBAL':
					trace('208 added callGlobal listener');
					addEventListener(TextEvent.LINK, callGlobal, true, 0, true);
				}			
			}
			else	
			{
				while (listeningObject._parent != null && listeningObject != listeningObject._parent) {
					listeningObject = listeningObject._parent;
					if (listeningObject.id == cAtts.to) 
						break;
				}
				//trace(this.name + ' listeningObject:' + listeningObject.name);
				switch(cAtts.listen) {
					case 'LINK':
					addEventListener(TextEvent.LINK, cast(listeningObject, Form).linkHandler,false,0,true);
				}
			}
		}
		
		if (cAtts.form != null) {
			var form:BaseCell = this;
			while (form._parent != null) {
				form = form._parent;
				if (form.id == cAtts.form) 
					break;
			}
			cast(form, Form).variables.set(cAtts.name, this);			
			//trace(cAtts.name + '  isset:'  + cast(form, Form).variables.exists(cAtts.name));
		}
		if (cAtts.type == 'INPUT')
		{
			tF.multiline = false;
			tF.selectable = true;
			tF.addEventListener(FocusEvent.FOCUS_IN, selectAll, false, 0, true);
			tF.addEventListener( MouseEvent.MOUSE_UP, selectAll);
			//trace(Lib.current.loaderInfo.parameters.browser);
			if (Lib.current.loaderInfo.parameters.browser =='chrome')
			{
				//chrome Alt GR workaround needed :-(
				if( Capabilities.os.toLowerCase().indexOf('windows') != -1 )
				{
					//tF.restrict = '^[@qQ]';
					tF.addEventListener( KeyboardEvent.KEY_UP, _onWindowsKey );
				}
			}

		}
		Format.setTextFieldArgs(tF , xNode);
		//trace(alpha + ':' + tF.alpha);
	}
	
	static var specialChars = ['ü', 'ä', 'ö', 'ß'];
	static var specialCharsUpper = ['Ü', 'Ä', 'Ö', '?'];
	
	function  _onWindowsKey(evt:KeyboardEvent)
	{
		if( evt.keyCode == 81 || evt.keyCode == 69)
		{
			if( evt.altKey && evt.ctrlKey)
			{
				var text:String = tF.text;
				trace(text +':' + tF.length +'-' +  tF.caretIndex );
				
				var tail:String = tF.text.substr(tF.caretIndex, tF.length - tF.caretIndex);
				trace( tail);
				tF.text = tF.text.substr( 0, tF.caretIndex - 1) + (evt.keyCode == 81 ? '@' :'€') + tail;				
			}
		}		
	}
	
	public function selectAll(evt:Event)
	{
		trace(tF.text);
		tF.setSelection(0, tF.text.length);
		stage.focus = this.tF;	
	}
	
	override public function destroy()
	{
		if (cAtts.copyBg != null)
		{
			layoutRoot.removeEventListener(LayoutEvent.LAYOUT_COMPLETE, bGCopy, false);
			relBg.bG.removeEventListener(BackgroundEvent.CHANGE, bGCopy, false);
		}
		super.destroy();
		//trace('content:' + content + ' tF:' + tF);
	}
	
	function forwardLink(evt:TextEvent)
	{
		linkTarget(evt.text);
	}
	
	function callGlobal(evt:TextEvent)
	{
		trace(evt.text +':' + evt.text );
		var args:Array<String> = evt.text.split(',');		
		Application.instance.getGlobal(args.shift())(args[0]);
	}
	
	override public function getBox() {
		box = new Rectangle();
		super.getBox();	
		tF.autoSize = TextFieldAutoSize.NONE;
		updateBox();
	}
	
	override public function updateBox()
	{
		getMaxDims();
		applyMargin();
		
		var tW:Float = tF.width;
		var tH:Float = tF.height;
		tF.autoSize = TextFieldAutoSize.NONE;
		if (!fixedWidth)
		{		
			//tF.autoSize = TextFieldAutoSize.NONE;
			tF.width = (tF.textWidth + textMargin + 4 < maxContentDims.width  ?  tF.textWidth + textMargin + 4:
				maxContentDims.width);
			box.width = tF.width + contentMargin.left + contentMargin.right;
		}
		else
		{
			//tF.autoSize = TextFieldAutoSize.NONE;
			tF.width = box.width - contentMargin.left - contentMargin.right;
			var dummy = tF.textHeight;
			//trace('tF.width:' + tF.width + ' tF.textHeight:' + tF.textHeight + ' tF.wordWrap:' + tF.wordWrap +' tF.autoSize:' + tF.autoSize);
		}		
		//if (cAtts.autoSize == null)
		//trace(name + ':' + tF.width + ':' + fixedWidth + 'textMargin:' + textMargin + ' textWidth :' + tF.textWidth + ' maxContentDims.width:' + maxContentDims.width);

		if (!fixedHeight)
		{	
			//tF.autoSize = TextFieldAutoSize.NONE;	
					
			//trace(tF.textHeight + ':'  + maxContentDims.height + ':' + tF.autoSize );
			tF.height = (tF.textHeight + 4 < _parent.maxContentDims.height  ? tF.textHeight + 4 :_parent.maxContentDims.height );
			//if(cL != ScrollableText )
			box.height =  tF.height + contentMargin.top + contentMargin.bottom;
			//trace(maxContentDims.height +' - ' + margin.top + ' - ' + margin.bottom + ' tF.height:' + tF.height );
		}
		else
		{
			//tF.autoSize = TextFieldAutoSize.NONE;			
			tF.height = box.height - contentMargin.top - contentMargin.bottom;
			//trace(tF.textHeight + ':' + tF.height + ':' + box + ':' + _parent.maxContentDims);
		}		
		//trace(name +':' + tW + ' x ' + tH + ' -> ' + tF.width  + ' x ' + tF.height + ':' + tF.multiline + ':' + tF.wordWrap);
		//trace('htmlText:' + tF.htmlText);
	}
	
	function onChange(evt:Event)
	{
		trace(tF.textHeight);
		//_parent.resourceReady(imgRefs.pop());
		imgRefs.pop();
		if (imgRefs.isEmpty())
		{			
			tF.removeEventListener(Event.CHANGE, onChange, false);
			if (layoutRoot != null)
				layoutRoot.resourceReady(this);
		}		
	}
	
	public function resize()
	{
		
	}
	
	override public function layout() 
	{
		if (Application.instance.gridRelayout)
		{
			//TODO:FLEXIBLE ALIGNMENT
			//tF.border = true;
			//trace('box:' + box  + ' contentBox:' + contentBox + ' maxContentDims:' + maxContentDims);
			//trace(box.width  - contentMargin.left - contentMargin.right > tF.width);
			if (box.width  - contentMargin.left - contentMargin.right > tF.width)
				content.x = contentMargin.left + (box.width - contentMargin.left - contentMargin.right - tF.width) / 2;
			if (box.height  - contentMargin.top - contentMargin.bottom > tF.height)
				content.y = contentMargin.top + (box.height - contentMargin.top - contentMargin.bottom - tF.height) / 2;	
			return;
		}
			
		//trace(tF.autoSize + ' tF.width:' + tF.width + ' tf.height:'+tF.height+' box:' + box + ' margin:' + Std.string(margin));
		if (cAtts.setFocus == 'true')
		{			
			stage.focus = this.tF;	
			this.tF.setSelection(0, 0);
		}
		//visible = true;
		//Out.dumpLayout(this);
		//trace(tF.alpha + ':' + tF.blendMode + ':' + tF.sharpness + ':' + tF.thickness);
	}
	
	function bGCopy(evt:Event) 
	{		
		if (Type.getClass(getChildAt(0)) == Shape)
			//removeChildAt(0);
			cast(getChildAt(0), Shape).graphics.clear();
		else {
			bgShape = new Shape();
			addChildAt(bgShape, 0);
		}
		trace(alpha +':' + bgShape.alpha + ' = ' + cAtts.copyBg);
		bgShape.alpha = Std.parseFloat(cAtts.copyBg);
		//var myBox:Rectangle = tF.getBounds(layoutRoot);
		var myBox:Rectangle = tF.getBounds(relBg);
		//var myBox:Rectangle = box;
		var cBox:Rectangle = myBox.clone();//CLIPBOX
		var cBox:Rectangle = box.clone();//CLIPBOX
		//cBox.x = 0;
		cBox.y = tF.getBounds(relBg).y - margin.top;
		cBox.width = 1;
		//cBox.height += margin.top + margin.bottom;
		var mat:Matrix = new Matrix();
		mat.translate(0, -cBox.y);
		Fill.beginCopyFill(five(cast relBg.bG, mat, null, null, cBox), bgShape.graphics);
		if (cornerRadius != null)
		{
			switch(cornerRadius.method)
			{
				case 'drawRoundRect':
				/*trace(margin.left+', '+margin.top +', '+
					tF.width + cornerRadius.TR * 2+', '+ tF.height + cornerRadius.BR * 2+', '+ cornerRadius.TR * 2+', '+cornerRadius.BR * 2);*/
				bgShape.graphics.drawRoundRect(margin.left, margin.top,
					tF.width + cornerRadius.TR * 2, tF.height + cornerRadius.BR * 2, cornerRadius.TR * 2, cornerRadius.BR * 2);
				case 'drawRoundRectComplex':
				bgShape.graphics.lineStyle(0, 0xff00ff);
				//Out.dumpObject(cornerRadius);
				/*trace(margin.left+', '+ margin.top+', '+
					(tF.width + Math.max(cornerRadius.TR, cornerRadius.BR) + Math.max(cornerRadius.TL, cornerRadius.BL))+', '+
					(tF.height + Math.max(cornerRadius.TL, cornerRadius.TR) + Math.max(cornerRadius.BL, cornerRadius.BR))+', '+
					cornerRadius.TL+', '+ cornerRadius.TR+', '+ cornerRadius.BL+', '+ cornerRadius.BR);*/
				bgShape.graphics.drawRoundRectComplex(margin.left -  Math.max(cornerRadius.TL, cornerRadius.BL) , 
				margin.top - Math.max(cornerRadius.TL, cornerRadius.TR),
					tF.width + Math.max(cornerRadius.TR, cornerRadius.BR) + Math.max(cornerRadius.TL, cornerRadius.BL),
					tF.height + Math.max(cornerRadius.TL, cornerRadius.TR) + Math.max(cornerRadius.BL, cornerRadius.BR),
					cornerRadius.TL, cornerRadius.TR, cornerRadius.BL, cornerRadius.BR);
			}
		}
		else
			bgShape.graphics.drawRect(margin.left, margin.top, myBox.width, myBox.height);

		//STween.add(this , 1.0, { alpha:1.0 } );
		//trace('done.........');
	}
	
}