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

package me.cunity.ui.progress;
import flash.display.DisplayObject;
import flash.display.GraphicsGradientFill;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GradientGlowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.xml.XML;
import haxe.CallStack;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.ui.Container;
import me.cunity.ui.DynaBlock;
import me.cunity.graphics.Fill;
import me.cunity.tools.MathTools;
import me.cunity.ui.progress.ProgressRunnable;

class Progress extends Container
{
	
	public var psRun:ProgressRunnable;
	public var infoTextField:TextField;
	public var hasUpdate:Bool;
	var hideCallback:Dynamic;
	
	public function new(node:XML, p:Container) 
	{
		super(node, p);
		hasUpdate = node.children().length() > 1;
		//trace(name  + ' hasUpdate:' + hasUpdate + ' visible:'  + visible);
	}
	
	//override public function layout():Rectangle {
	//override public function layout() {
	override public function show() {
		alpha = 0.0;
		//Out.dumpStack(CallStack.callStack());
		psRun.getBox();
		y =  (_parent.box.height  - box.height) / 2 ;
		x = (_parent.box.width - box.width) / 2;
		visible = true;
		startRun();
		STween.add (this, 0.5, { alpha:1.0, onComplete:null } );
	}
	
	public function fade(?cB:Dynamic) {
		hideCallback = cB;
		STween.add (this, 1.0, {alpha:0.0, onComplete:stopRun});
	}
	
	function startRun() 
	{
		//Out.dumpStack(CallStack.callStack());
		addEventListener('enterFrame', psRun.run, false, 0, true);
		//Out.dumpLayout(this);
		//trace('hmm:' + infoTextField.text + ' visible:' + infoTextField.visible + ' font:' + infoTextField.defaultTextFormat.font);
		if (infoTextField != null) {
			infoTextField.autoSize = TextFieldAutoSize.NONE;
			infoTextField.text = '0%';
			infoTextField.parent.visible = true;
		}
	}
	
	function stopRun() {
		removeEventListener('enterFrame', psRun.run, false);
		//Out.dumpStack(CallStack.callStack());

		//trace('REMOVED :-)');
		if (hideCallback != null)
			hideCallback();
	}
	
	function run(evt:Event) {
		psRun.run(evt);
	}
	
	public function update(v:Int) 
	{
		infoTextField.text = v > 95 ? '100%' :Std.string(v) + '%';
	}

}