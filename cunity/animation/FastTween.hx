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

package me.cunity.animation;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import me.cunity.debug.Out;
//import me.cunity.animation.geometry.IPath2D;
//import me.cunity.ui.BaseCell;
//import singularity.geom.IParametric;
import singularity.geom.Parametric;

class FastTween //extends EventDispatcher
{
	static var _latest:FastTween;
	static var _listener:Shape;
	static var _initiated:Bool;
	
	var begin:Int;
	var duration:Int;
	var start:Int;
	var prev:FastTween;
	var next:FastTween;
	var onComplete:Dynamic;
	var onUpdate:Dynamic;
	var onCompleteParams:Array<Dynamic>;
	var onUpdateParams:Array<Dynamic>;
	var _properties :Dynamic;
	var _initial :Dynamic;
	//var dOb:BaseCell;
	var dOb:Dynamic;
	var trans:Float->Float->Float->Float->Float;	

	public function new(obj:Dynamic, d:UInt, properties:Dynamic, sta:UInt = 0,
		t:Float->Float->Float->Float->Float = null ) 
	{
		//super();
		onComplete = properties.onComplete;
		onCompleteParams = properties.onCompleteParams ? properties.onCompleteParams :null;
		onUpdate = properties.onUpdate;
		onUpdateParams = properties.onUpdateParams ? properties.onUpdateParams :null;
		/*if (onComplete != null)
			onCompleteParams.unshift(this);
		if (onUpdate != null)
			onUpdateParams.unshift(this);*/
		dOb = obj;
		duration = d;
		start = sta;
		begin = Lib.getTimer();
		//trans = (t == null)? Transition.linear:t;
		trans = t;
		_properties = { };
		for (prop in Reflect.fields (properties))
			Reflect.setField(_properties, prop, Reflect.field(properties, prop));
		Reflect.deleteField (_properties, "onComplete");
		Reflect.deleteField (_properties, "onCompleteParams");
		Reflect.deleteField (_properties, "onUpdate");
		Reflect.deleteField (_properties, "onUpdateParams");
		_initial = { };
		
		for (prop in Reflect.fields (_properties))
		{
			//calculate relative change
			//var targetVal = Reflect.field (_properties, prop) - Reflect.field (dOb, prop);
			//trace(dOb +':'+prop + ':' + Reflect.field (_properties, prop) + ' initial:' + Reflect.field (dOb, prop) );
			//trace(prop + ':' + Reflect.field (dOb, prop) +' targetVal:' + Reflect.field (_properties, prop) - Reflect.field (dOb, prop) );
			Reflect.setField (_initial, prop, Reflect.field (dOb, prop));
			if(prop == 'path')
				Reflect.setField (_properties, prop, Reflect.field (_properties, prop));
			else
				Reflect.setField (_properties, prop,  Reflect.field (_properties, prop) - Reflect.field (dOb, prop));
		}
		//trace('initial:' + Std.string(_initial));
		//trace('end:' + Std.string(_properties));

	}
	
	public static function add(obj:Dynamic, d:UInt, p:Dynamic,
		t:Float->Float->Float->Float->Float = null, sta:UInt = 0 ):FastTween
	{
		//var _fTween = new FastTween(bS, d, p, sta, t);
		var _fTween = new FastTween(obj, d, p, sta, t == null ? Transition.linear:t);
		var _prev:FastTween = _latest;
		if (_prev != null) _prev.next  = _fTween;
		_fTween.prev = _prev;
		_latest = _fTween;
		if (!_initiated)
		{
			_listener = new Shape ();
			_listener.addEventListener ("enterFrame", update,false,0,true);
			_initiated = true;
		}		
		
		return _fTween;
	}

	public static function removeAllTweens() {
		while (_latest != null)
			removeTween(_latest);		
	}
	
	public static function removeTween (fTween :FastTween)
	{
		if (fTween.prev != null) fTween.prev.next = fTween.next;
		if (fTween.next != null) fTween.next.prev = fTween.prev;
		if (_latest == fTween) _latest = fTween.prev;
		if (_latest == null) {
			_listener.removeEventListener ("enterFrame", update, false);
			_initiated = false;
			//trace('back2zero');
		}
		//else trace(_latest + ':' + _latest.prev);
	}

	static function update (e :Event)
	{
		var time :Int = Lib.getTimer ();
		var fTween :FastTween = _latest;
		//trace(fTween);
		while (fTween != null)
		{
			var time_diff :Int = time - fTween.begin;
			if (time_diff >= fTween.duration)
				time_diff = fTween.duration;
			//DO THE ACTUAL TWEENING HERE
			if(fTween._properties.path == null){
				for (prop in Reflect.fields (fTween._properties)) {
					/*trace(prop +' time_diff:' +time_diff +' _initial:' + Reflect.field (fTween._initial, prop) + ' current:' 
						+ Reflect.field (fTween._properties, prop) +' new:'+ fTween.trans(
							time_diff, 
							Reflect.field (fTween._initial, prop), 
							Reflect.field (fTween._properties, prop), 
							fTween.duration
						));*/
					Reflect.setField (fTween.dOb, prop, 
						fTween.trans(
							time_diff, 
							Reflect.field (fTween._initial, prop), 
							Reflect.field (fTween._properties, prop), 
							fTween.duration
						)
					);
				}		
			}
			else{
				try{
				var p:Pos = fTween._properties.path.getPos(fTween.trans(time_diff, 0.0, 1.0, fTween.duration));
				fTween.dOb.x = p.x;
				fTween.dOb.y = p.y;
				}
				catch (ex:Dynamic) {
					trace(Std.string(fTween._properties));
					throw(fTween._properties.path + ':' + ex);
					//Out.suspended = true;
				}
			}
			if (fTween.onUpdate != null)
			{
				if(fTween.onUpdateParams != null)
					fTween.onUpdate(fTween.onUpdateParams);
				else
					fTween.onUpdate();
			}
			if (time_diff >= fTween.duration)
			{
				/*if (fTween.prev != null) fTween.prev.next = fTween.next;
				if (fTween.next != null) fTween.next.prev = fTween.prev;
				if (_latest == fTween)
					if (fTween.prev != null) _latest = fTween.prev;
					else _latest = null;*/
				if (fTween.onComplete != null)
				{
					if(fTween.onCompleteParams != null)
						fTween.onComplete(fTween.onCompleteParams);
					else
						fTween.onComplete();
				}
				//trace(fTween.onComplete);
				//Out.dumpLayout(fTween.dOb);
				//Out.dumpLayout(fTween.dOb.parent.parent);
				//Out.dumpLayout(fTween.dOb.parent.parent.parent.parent);
				removeTween(fTween);
				//DONE
			}
			fTween = fTween.prev;
		}
	}	
	
}