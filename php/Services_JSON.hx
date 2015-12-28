package php;

/**
 * ...
 * @author axel@cunity.me
 */
extern class Services_JSON
{
	public static inline var SERVICES_JSON_LOOSE_TYPE:Int   = 16;
	
	public static inline var SERVICES_JSON_SUPPRESS_ERRORS:Int   = 32;

	public function new(?use:Int) :Void;
	
	public function decode(str:String):Dynamic;
	
	public function encode(data:Dynamic):String;
	
	static function __init__():Void {
		untyped __call__('require_once', '/srv/www/htdocs/flyCRM/php/JSON.php');
	}
	
}