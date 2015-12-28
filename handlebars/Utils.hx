package handlebars;

/**
 * ...
 * @author axel@cunity.me
 */
@:keep
@:native('Handlebars.Utils')
extern class Utils
{

	public static function isEmpty(value:Dynamic):Bool;
	public static function extend(obj:Dynamic, value:Dynamic):Void;
	public static function toString(obj:Dynamic):String;
	public static function isArray(obj:Dynamic):Bool;
	public static function isFunction(obj:Dynamic):Bool;
	public static function appendContextPath(contextPath:String, id:String):String;
	
	
}