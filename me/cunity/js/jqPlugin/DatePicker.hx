package me.cunity.js.jqPlugin;

/**
 * ...
 * @author ...
 */
extern class DatePicker implements js.jquery.Plugin
{

	@:overload public function datepicker(?options:Dynamic):js.jquery.JQuery;
	
	@:overload public static function datepicker(dp:JQuery, ?options:Dynamic):js.jquery.JQuery;
	
}