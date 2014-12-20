package me.cunity.php.applet;

/**
 * ...
 * @author axel@cunity.me
 */

typedef DateRange = 
{
	@:optional var begin:Date;
	@:optional var end:Date;
	@:optional var days:Float;
}

typedef GetParam =
{
	@:optional var content:String;
	@:optional var dateRange:DateRange;
	@:optional var max:Int;
}

class ServiceParam
{
	public var appPath:String;
	public var baseDir:String;
	public var mediaPath:String;
	public var maxfilesize:String;
	public var maxfiles:String;	
	
	public function new(init:Dynamic)
	{
		for (key in Reflect.fields(init))
			Reflect.setField(this, key, Reflect.field(init, key));
	}
}