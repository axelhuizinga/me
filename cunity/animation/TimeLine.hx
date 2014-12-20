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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.animation;
import flash.events.Event;
import haxe.ds.StringMap.StringMap;
//
#if flash
import flash.xml.XML;
import flash.xml.XMLList;
#else
//import js
import flash.xml.XML;
import flash.xml.XMLList;
#end
import haxe.CallStack;
import haxe.Timer;
import me.cunity.data.Parse;
import me.cunity.debug.Out;
import me.cunity.ui.Container;

import me.cunity.events.LayoutEvent;
import me.cunity.ui.BaseCell;
import me.cunity.animation.Types;


class TimeLine
{
	public var xNode:XML;
	public var duration:Int;
	var start:UInt;
	var tweens:Array<BCTween> ;
	var screenPlay:StringMap<DynaTween>;
	public var storyBoard:Array<String>;//takes a list of functionnames
	var parent:Container;
	public var current(default, null):Int;
	public var onUpdate:Dynamic;

/**
* @description 	Constructor:new TimeLine( bC:Container, xN:XML) 
*
* @param bC:BaseCell = TimeLine Container
* @param  xN:XML TimeLine config node
*
* @return new TimeLine instance
*
*/	
	public function new(p:Container, xN:XML) 
	{
		xNode = xN;
		storyBoard = (
			xN.attribute('storyBoard').length() != 0 ? xN.attribute('storyBoard').toString().split(',') :[]);
		duration = Std.parseInt(xN.attribute('duration').toString());	
		start =	(xN.attribute('start').toString() == '' ? 0:	Std.parseInt(xN.attribute('start').toString()));
		trace(storyBoard.length);
		if( storyBoard.length > 0 )
		{
			screenPlay = new StringMap<DynaTween>();
			current = 0;
		}
		else
		{
			tweens = new Array();
		}
		if (p == null)
			return;
		p.addEventListener(LayoutEvent.LAYOUT_COMPLETE, init,false,0,true);
		trace('added LayoutEvent Listener to ' + p.name);
		parent = p;
	}
	
	function init(evt:LayoutEvent)
	{
		parent.removeEventListener(LayoutEvent.LAYOUT_COMPLETE, init, false);
		if (storyBoard.length > 0) {
			runKey(storyBoard[current]);		
		}
		else
		{
			if (start > 0)
				Timer.delay(run, start);
			else
				run();			
		}

	}
/**
* @description 	method addTween( bC:BaseCell, xN:XML) 
*
* @param bC:BaseCell to tween
* @param  xN:XML xml config node
*
* @return Void
*
*/	
	public function addTween(bC:BaseCell, xN:XML,  s:Dynamic = null ) //BaseCell2Tween , Tween config node
	{
		//nodes.set(xN, bC);
		//Out.dumpStack(CallStack.callStack());
		trace(xN.toString());
		if (screenPlay != null)
		{
			//if (screenPlay.exists(xN.attribute('id').toString()))
			//if (xN.attribute('id').toString() == 'headline')				throw('hmmm...');
			screenPlay.set(xN.attribute('id').toString(), { bC:bC, xNode:xN, starter:s } );
		}
		else
			tweens.push( { xNode:xN, bC:bC } );
	}
	
	public function next()
	{
		trace(current +'==' + Std.string(storyBoard.length - 1)+ ':' + storyBoard[current] );
		//if (current == storyBoard.length - 1)
			//return;
		if(storyBoard[current] != null)
			runKey(storyBoard[current]);		
	}
	
	public function run()
	{
		//trace('hmm...');
		//Out.dumpStack(CallStack.callStack());
		for(t in tweens){
			switch(t.xNode.name()) {
				case 'Tween':
				if(t.xNode.attribute('start').toString() == '')
				TweenFactory.create(t.xNode, t.bC);
				else {
					var xN:XML = t.xNode;
					var bC:BaseCell = t.bC;
					Timer.delay(function() { TweenFactory.create(xN, bC); }, Std.parseInt(t.xNode.attribute('start').toString()));
				}
				case 'PathTween':
				if (t.xNode.attribute('start').toString() == '')
				PathTweenFactory.create(t.xNode, t.bC);
				else
				{
					var xN:XML = t.xNode;
					var bC:BaseCell = t.bC;
					Timer.delay(function() { PathTweenFactory.create(xN, bC);}, Std.parseInt(t.xNode.attribute('start').toString()));
				}
			}
		}
	}
	
	function runKey(id:String)
	{
		var t:DynaTween = screenPlay.get(id);
		//trace(Std.string(screenPlay));
		//trace(id + ':' + Std.string(t) + ':'  + screenPlay.keys().hasNext());
		//dumpScreenPlay();
		if (t == null)
			return;
		//trace(t.xNode.name());
		switch(t.xNode.name()) {
			case 'Tween':
			if(t.xNode.attribute('start').toString() == '')
			TweenFactory.create(t.xNode, t.bC);
			else {
				var xN:XML = t.xNode;
				var bC:BaseCell = t.bC;
				Timer.delay(function() { TweenFactory.create(xN, bC); }, Std.parseInt(t.xNode.attribute('start').toString()));
			}
			case 'PathTween':
			if(t.xNode.attribute('start').toString() == '')
			PathTweenFactory.create(t.xNode, t.bC);
			else
			{
				var xN:XML = t.xNode;
				var bC:BaseCell = t.bC;
				Timer.delay(function() { PathTweenFactory.create(xN, bC);}, Std.parseInt(t.xNode.attribute('start').toString()));
			}
			case 'STween':
			if (t.starter == null)
			{
				trace(t.bC.loadedInst + ':' + t.xNode.attribute('id').toString() + ':' + t.bC.loadedInst.storyBoard.get(t.xNode.attribute('id').toString()));
				//return;
				t.starter = t.bC.loadedInst.storyBoard.get(t.xNode.attribute('id').toString());
			}
			trace(t.starter +':' + id);
			t.starter();
			//t.bC.go(storyBoard[current]);
			
		}		
		current++;
	}
	
	public function runNextKey(arg:Dynamic = null)
	{
		//var key:String = (id == null ? storyBoard[current++] :id);
		//trace(current + ':' + storyBoard[current]);
		/*if (arg == null)
			runKey(storyBoard[current]);
		else*/
		runKey(storyBoard[current]);
		//current++;
	}
	
	function onComplete(fT:Array<Dynamic>) {
		trace(fT.toString());
		//Out.dumpLayout(fT[0].parent);
	}
	
	public function destroy()
	{
		FastTween.removeAllTweens();
	}
	
	public function dumpScreenPlay()
	{
		trace(current);
		var keys:Iterator<String> = screenPlay.keys();
		var loopMax:Int = 10;
		while (loopMax-- > 0 && keys.hasNext())
			trace(keys.next());
	}
}