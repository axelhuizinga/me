/**
 *
 * @author ...
 */

package me.cunity.effects;

/**
 *
 * @author ...
 */

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.external.ExternalInterface;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.Lib;

typedef PropParams = {
	//action:String,
	duration:Int,
	actual:Dynamic,
	final:Dynamic,
	finish:Int,
	initial:Dynamic,
	prop:String
}
class TweenBack extends Sprite{
	
	var action:String;
	var lastAction:String;
	var duration:Int;
	var finish:Int;
	var actual:Float;
	//var final:Float;
	//var initial:Float;
	var start:Int;
	var timeToGoBack:Float;
	var dOb:DisplayObject;
	var running:Bool;
	var props:Array<PropParams>;
	
	public function new(oB:DisplayObject, prop:Array<PropParams>, ?startObject:DisplayObject, ?dur:Int = 1500){
		super();
		dOb = oB;
		duration = dur;//overall duration must be higher than individual durations
		props = prop;
		var p:PropParams = null;
		for (p in props) {
			if (p.duration > duration)
				p.duration = duration;
		}
		
		//ExternalInterface.addCallback("go",  go);
		if (startObject != null)
			startObject.addEventListener(MouseEvent.ROLL_OVER, go,false,0,true);
		//ExternalInterface.addCallback("toggleRun",  toggleRun);
		addEventListener ("enterFrame", update);
		running = false;
		action = 'none';
		dOb.addEventListener(MouseEvent.ROLL_OUT, goBack,false,0,true);
		dOb.addEventListener(MouseEvent.ROLL_OVER, stopGoBack,false,0,true);
	}
	
	public function go(?evt:Event){
		//trace(dOb.alpha);
		trace(action);
		if (action == 'go')
			return;
		action = 'go';
		start  = Lib.getTimer();
		var diff:Dynamic = null;
		var current:Dynamic = null;
		var p:PropParams = null;
		//finish = start + Math.floor(duration * dOb.alpha );
		//finish = Math.floor(duration * (1 - dOb.alpha) );
		for (p in props) {
 			p.actual = Reflect.field(dOb, p.prop);
			current = p.final - p.actual;
			if (current == 0) {// already final
				p.finish = p.duration;
			}
			else{
				diff = p.final - p.initial;		
				if (diff==0)
					throw('initial and final have to be different!');
				p.finish = Math.floor(p.duration *  Math.abs(current/diff));
			}
		}
		//dOb.visible = true;
		//ExternalInterface.call("menuState", 'visible', 1);
	}
	
	public function goBack(?evt:Event){
		action = 'goBack';
		var diff:Dynamic = null;
		var current:Dynamic = null;		
		start  = Lib.getTimer();		
		for (p in props) {
 			p.actual = Reflect.field(dOb, p.prop);
			current = p.final - p.actual;
			if (current == 0) {// already final
				p.finish = p.duration;
			}
			else{
				diff = p.final - p.initial;		
				if (diff==0)
					throw('initial and final have to be different!');
				p.finish = Math.floor(p.duration *  1 - Math.abs(current/diff));
			}			
			//p.finish = Math.floor(p.duration * p.actual);
		}		
	}
	
	public function stopGoBack(?evt:Event){
		action = 'goPermanent';
		start  = Lib.getTimer();
		var diff:Dynamic = null;
		var current:Dynamic = null;		
		for (p in props) {
 			p.actual = Reflect.field(dOb, p.prop);
			current = p.final - p.actual;
			if (current == 0) {// already final
				p.finish = p.duration;
			}
			else{
				diff = p.final - p.initial;		
				if (diff==0)
					throw('initial and final have to be different!');
				p.finish = Math.floor(p.duration *  Math.abs(current/diff));
			}
		}
		//dOb.visible = true;
	}
	
	public function update(evt:Event) {
		/*if(lastAction != action){
			trace(action);
			lastAction = action;
		}*/
		var timeDiff = Lib.getTimer() - start;
		var finished:Bool = true;
		switch(action){
			case 'goPermanent':
				for (p in props) {
					p.actual = Reflect.field(dOb, p.prop);
					trace(action +'-' +p.actual +':' + p.final +':' +timeDiff +' < '+p.finish);
					if (timeDiff < p.finish) {
						finished = false;
						//var actTime:Int = (timeDiff > p.finish) ? p.finish :timeDiff;
						Reflect.setField(dOb, p.prop, Tween.easeOut(timeDiff, p.initial, p.final, p.finish));					
					}
					else {
						Reflect.setField(dOb, p.prop, p.final);
					}
				}
				if(finished)
					action = 'none';
			case 'go':
				for (p in props) {
					p.actual = Reflect.field(dOb, p.prop);
					trace(action +'-' +p.actual +':' + p.final +':' +timeDiff +' < '+p.finish);
					if (timeDiff < p.finish) {
						finished = false;
						//var actTime:Int = (timeDiff > p.finish) ? p.finish :timeDiff;
						Reflect.setField(dOb, p.prop, Tween.easeOut(timeDiff, p.initial, p.final, p.finish));					
					}					
					else {
						Reflect.setField(dOb, p.prop, p.final);
					}
				}
				if(finished){
					action = 'prepareToGoBack';		
						timeToGoBack = duration;
						start  = Lib.getTimer();
						finish = duration;				
				}
			case 'goBack':
				for (p in props) {
					p.actual = Reflect.field(dOb, p.prop);
					trace(action +'-' +p.actual +':' + p.final +':' +timeDiff +' < '+p.finish);
					if (timeDiff < p.finish) {
						finished = false;
						//var actTime:Int = (timeDiff > p.finish) ? p.finish :timeDiff;
						Reflect.setField(dOb, p.prop, Tween.easeOut(timeDiff, p.final, p.initial, p.finish));					
					}
					else {
						Reflect.setField(dOb, p.prop, p.initial);
					}
				}
				if(finished){
					action = 'none';
					//ExternalInterface.call("menuState", 'visible', 0);
					//dOb.visible = false;
				}
			case 'prepareToGoBack':
				trace(action +'-' +timeToGoBack);
				if(timeToGoBack>0)
					timeToGoBack = Tween.easeOut(timeDiff, duration, 0, finish);
				else
					goBack();
		}
	}
	/*
	function toggleRun() {
		if (running){
			removeEventListener("enterFrame", update);
			running = false;
		}
		else {
			addEventListener ("enterFrame", update);
			running = true;
		}
	}
	*/
	public static function easeOut (t :Float, b :Float, c :Float, d :Float) :Float
	{ /*t:diff
		b:initial
		c:final
		d:finish
		*/var ot = t;
		//		var res:Float =  -c * (t /= d) * (t - 2) + b;
		var res:Float = b + (c - b) * (t /= d);
		if(ot<50)
		trace('final:' + c + ' initial:' + b + ' time:' + ot + ' finish:' + d + '  current:' + res);
		return res;
			//return -c * (t /= d) * (t - 2) + b;
	}
}