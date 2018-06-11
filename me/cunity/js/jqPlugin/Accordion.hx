package me.cunity.js.jqPlugin;

/**
 * ...
 * @author axel@paradiseprojects.de
 */

extern class Accordion implements js.jquery.Plugin
{
	public var panels:Array<js.html.HtmlElement>;
	
	@:overload public function accordion(options:Dynamic):js.jquery.JQuery;
	@:overload public function accordion(op:String, field:String):js.jquery.JQuery;
	@:overload public function accordion(op:String, ?field:String, ?val:Dynamic):js.jquery.JQuery;
	
}