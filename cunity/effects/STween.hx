/**
* STween
*
*	A Tween class derived from http://hesselboom.com/htween
*
* @author Axel Huizinga axel@cunity.me
*/

package me.cunity.effects;

import flash.display.Shape;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.Lib;
import haxe.CallStack;
import me.cunity.debug.Out;

class STween
{
	
	public static var version :Float = 0.1;
	
	public function new (object :Dynamic, finish :Int, properties :Dynamic, ease :Dynamic)
	{
		onComplete = properties.onComplete;
		onCompleteParams = properties.onCompleteParams ? properties.onCompleteParams :[];
		onUpdate = properties.onUpdate;
		onUpdateParams = properties.onUpdateParams ? properties.onUpdateParams :[];
		
		_object = object;
		_start = Lib.getTimer ();
		_finish = finish;
		_properties = { };
		for (prop in Reflect.fields (properties))
			Reflect.setField(_properties, prop, Reflect.field(properties, prop));
		Reflect.deleteField (_properties, "onComplete");
		Reflect.deleteField (_properties, "onCompleteParams");
		Reflect.deleteField (_properties, "onUpdate");
		Reflect.deleteField (_properties, "onUpdateParams");
		_initial = {};
		for (prop in Reflect.fields (_properties))
		{
			Reflect.setField (_initial, prop, Reflect.field (_object, prop));
			if (Std.is (Reflect.field (properties, prop), String))//relative to current;
				Reflect.setField (_properties, prop, Reflect.field (object, prop) + Std.parseFloat(Reflect.field (properties, prop)) );
			else
			Reflect.setField (_properties, prop, Reflect.field (_properties, prop));
		}
		_ease = ease;
	}
	
	public static function add (object :Dynamic, duration :Float, properties :Dynamic, ?ease :Dynamic) :STween
	{
		if (object == null)
		{
			trace('NULL object cannot be tweened :-(');
			return null;
		}
		if (duration < 0.001) duration = 0.001;
		if (ease == null)
			ease = easeOut;
		var _tween :STween = new STween (object, Math.floor (duration * 1000), properties, ease);
		var _prev :STween = _latest;		
		if (_prev != null) _prev.next = _tween;
		_tween.prev = _prev;
		_latest = _tween;
		
		if (!_initiated)
		{
			_listener = new Shape ();
			_listener.addEventListener ("enterFrame", update,false,0,true);
			_initiated = true;
		}
		//Out.dumpStack(CallStack.callStack());
		return _tween;
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
	}
	
	public static function easeOut (t :Float, b :Float, c :Float, d :Float) :Float{
		/*var val  = b + (c - b) * (t /= d);
		trace(val);
		return val;*/
		return  b + (c - b) * (t /= d);
	}
	
	static function update (e :Event)
	{
		var time :Int = Lib.getTimer ();
		var sTween :STween = _latest;
		while (sTween != null)
		{
			var time_diff :Int = time - sTween._start;
			if (time_diff >= sTween._finish)
				time_diff = sTween._finish;
			#if debug
			var prop:String = '';
			try {
			#end	
			for (prop in Reflect.fields (sTween._properties)) {
				Reflect.setField (sTween._object, prop, sTween._ease (time_diff, Reflect.field (sTween._initial, prop), Reflect.field (sTween._properties, prop), sTween._finish));
			}
			#if debug
			}
			catch(ex:Dynamic)
			{
				trace(prop +':' + ex);
				STween.removeTween(sTween);
			}
			#end
			if (sTween.onUpdate != null)
				sTween.onUpdate.apply (null, sTween.onUpdateParams);
			if (time_diff == sTween._finish)
			{
				if (sTween.prev != null) sTween.prev.next = sTween.next;
				if (sTween.next != null) sTween.next.prev = sTween.prev;
				if (_latest == sTween)
					if (sTween.prev != null) _latest = sTween.prev;
					else _latest = null;
				if (sTween.onComplete != null)
					sTween.onComplete.apply (null, sTween.onCompleteParams);
			}
			sTween = sTween.prev;
		}
	}
	
	public var _object :Dynamic;
	var _start :Int;
	var _finish :Int;
	var _properties :Dynamic;
	var _initial :Dynamic;
	var _ease :Dynamic;
	var prev :STween;
	var next :STween;
	var onComplete :Dynamic;
	var onCompleteParams :Array<Dynamic>;
	var onUpdate :Dynamic;
	var onUpdateParams :Array<Dynamic>;
	static var _latest :STween;
	static var _listener :Shape;
	static var _initiated :Bool;
	
}