package me.cunity.data;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

extern class EasyCookie 
{

	public static function all():Array<Array<Dynamic>>;
	
	
	public static function get(key:String):String;
	
	public static function has(key:String):Bool;
	
	public static function keys():Array<String>;
	
	public static function remove(key:String):Dynamic;
	
	public static function set(key:String, val:Dynamic, ?opt:Dynamic):Dynamic;
	
	
	public static var version:String;
	
	public static var enabled:Bool;	
	

}