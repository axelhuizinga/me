package me.cunity.js;

import js.jquery.*;

/**
 * ...
 * @author axel@cunity.me
 */ 

 class JqueryUI 
{	
	public static function tabs(tb:JQuery, ?options:Dynamic) :JQuery
	{
		return untyped tb.tabs(options);
	};	
	
	/*@:overload(function(ac:JQuery, op:String, ?field:String, ?val:Dynamic):Dynamic{})
	@:overload(function(ac:JQuery, op:String, ?field:String, ?val:Dynamic):JQuery { } )
	public static function accordion(ac:JQuery, ?options:Dynamic):JQuery
	{
		return untyped ac.accordion(options);
	}*/
	
	/*public static function datepicker(dp:JQuery, ?options:Dynamic):JQuery
	{
		//trace(options);
		return untyped dp.datepicker(options).attr("placeholder", DateTools.format(Date.now(), '%d.%m.%Y'));
	}*/
	
	public static function editable(e:JQuery, ?options:Dynamic):JQuery
	{
		return untyped e.editable(function( value, settings ) {
			date.html( value );
		}, options);
	}	
	
}