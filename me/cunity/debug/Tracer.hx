package me.cunity.debug;

/**
 * ...
 * @author axel@cunity.me
 */

extern class Tracer
#if js_kit implements npm.Package.Require<"tracer","*"> #end
{

	public static function console(?options:Dynamic):Tracer;
	public static function colorConsole(?options:Dynamic):Tracer;
	public static function dailyfile(options:Dynamic):Tracer;
	
	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function log(format:String):Void;
	
	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function trace(format:String):Void;
	
	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function debug(format:String):Void;
	
	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function info(format:String):Void;

	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function warn(format:String):Void;	
	
	@:overload(function(format:String, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	@:overload(function(format:String, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic, p:Dynamic)  : Void {} )
	public function error(format:String):Void;	
		
}