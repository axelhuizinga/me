package;

/**
 * ...
 * @author axel@cunity.me
 */
typedef Compiled = Dynamic->?Dynamic->String;
/*{
	function ret(context:Dynamic, ?execOptions:Dynamic):String;
};*/

/*typedef Helper = 
{
	function helper(?a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic, ?e:Dynamic):String;
};*/

typedef Helper = Dynamic;

//TODO:
//Handlebars.logger.WARN}

@:keep
 extern class Handlebars
{
	 public static var partials:Dynamic;

	public static function compile(template:String, ?options:Dynamic):Compiled;
	public static function precompile(template:String, ?options:Dynamic):Compiled;
	
	@:overload(function(partials:Dynamic):Void{})
	public static function registerPartial(name:String, partial:Dynamic):Void;
	public static function unregisterPartial(name:String):Void;
	
	@:overload(function(partials:Dynamic):Void{})
	public static function registerHelper(name:String, helper:Helper):Void;
	public static function unregisterHelper(name:String):Void;	 
	
	@:overload(function(partials:Dynamic):Void{})
	public static function registerDecorator(name:String, helper:Helper):Void;
	public static function unregisterDecorator(name:String):Void;	 	
	
	public static function SafeString(html:String):String;
	
	public static function createFrame(data:Dynamic):Void;
	public static function create():Handlebars;
	public static function noConflict():Handlebars;
	
	public static function log(level:Int, message:String):Void;
	
	
}