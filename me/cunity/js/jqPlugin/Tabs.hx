package me.cunity.js.jqPlugin;

/**
 * ...
 * @author axel@paradiseprojects.de
 */

extern class Tabs implements js.jquery.Plugin{

	@:overload public function tabs(?options:Dynamic):js.jquery.JQuery;
	@:overload public function tabs( op:String, ?field:String, ?val:Dynamic):js.jquery.JQuery{};
	
	public function instance(?options:Dynamic):js.jquery.JQuery;
	
}