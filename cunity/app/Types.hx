package me.cunity.app;

/**
 * ...
 * @author axel@cunity.me
 */

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

enum UserLevel
{
	guest;
	admin;
	authUser;
}

