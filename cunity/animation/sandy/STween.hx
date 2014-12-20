/**
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

package me.cunity.animation.sandy;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import me.cunity.debug.Out;
import me.cunity.animation.Transition;
//import me.cunity.ui.BaseCell;
//import singularity.geom.IParametric;
import singularity.geom.Parametric;

class STween// extends EventDispatcher
{
	static var _latest:STween;
	static var _listener:Shape;
	static var _initiated:Bool;
	
	var begin:Int;
	var duration:Int;
	var start:Int;
	var prev:STween;
	var next:STween;
	var doUpdate:Dynamic;
	var timeLine:me.cunity.animation.TimeLine;
	var onComplete:Dynamic;
	var _property :Dynamic;
	var _initial :Dynamic;
	//var dOb:BaseCell;
	var dOb:Dynamic;
	var trans:Float->Float->Float->Float->Float;	

	public function new(cB:Dynamic, d:UInt, properties:Dynamic, t:Float->Float->Float->Float->Float = null ) 
	{
		//super();
		doUpdate = cB;
		onComplete = properties.onComplete;
		timeLine = properties.timeLine;
		duration = d;
		begin = Lib.getTimer();
		trans = t;
		_property = properties.values[0] - properties.values[1];
		_initial = properties.values[1];
	}
	
	public static function add(cB:Dynamic, d:UInt, p:Dynamic,
		t:Float->Float->Float->Float->Float = null ):STween
	{
		var _sTween = new STween(cB, d, p, t == null ? Transition.linear:t);
		var _prev:STween = _latest;
		if (_prev != null) _prev.next  = _sTween;
		_sTween.prev = _prev;
		_latest = _sTween;
		if (!_initiated)
		{
			_listener = new Shape ();
			_listener.addEventListener ("enterFrame", update,false,0,true);
			_initiated = true;
		}		
		
		return _sTween;
	}

	public static function removeAllTweens() {
		while (_latest != null)
			removeTween(_latest);
		
	}
	
	public static function removeTween (sTween :STween)
	{
		if (sTween.prev != null) sTween.prev.next = sTween.next;
		if (sTween.next != null) sTween.next.prev = sTween.prev;
		if (_latest == sTween) _latest = sTween.prev;
		if (_latest == null) {
			_listener.removeEventListener ("enterFrame", update, false);
			_initiated = false;
			trace('back2zero');
		}
		else
			trace(_latest + ':' + _latest.prev);
	}

	static function update (e :Event)
	{
		var time :Int = Lib.getTimer ();
		var sTween :STween = _latest;
		while (sTween != null)
		{
			var time_diff :Int = time - sTween.begin;

			if (time_diff >= sTween.duration)
				time_diff = sTween.duration;
			sTween.doUpdate(
				sTween.trans(
					time_diff - sTween.start, 
					sTween._initial,
					sTween._property, 
					sTween.duration
				)
			);
			if (time_diff == sTween.duration)
			{
				if (sTween.prev != null) sTween.prev.next = sTween.next;
				if (sTween.next != null) sTween.next.prev = sTween.prev;
				if (_latest == sTween)
					if (sTween.prev != null) _latest = sTween.prev;
					else _latest = null;
				trace(sTween.onComplete);
				if (sTween.onComplete != null)
					sTween.onComplete();
			}
			sTween = sTween.prev;
		}
	}	
	
}