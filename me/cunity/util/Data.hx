package me.cunity.util;
import haxe.ds.StringMap;

/**
 * ...
 * @author axel@cunity.me
 */
//@:keep
 class Data
{

	 public static function copy(source:Dynamic) 
	{
		var c:Dynamic = { };
		var fields:Array<String> = Reflect.fields(source);
		for (f in fields)
			Reflect.setField(c, f, Reflect.field(source, f));
		return c;
	}
	
	public static function mcopy<T>(source:StringMap<T>, ?target:StringMap<T>):StringMap<T>
	{
		var c:StringMap<T> = (target == null ?new StringMap() : target);
		for (k in source.keys())
			c.set(k, source.get(k));
		return c;
	}
	
	public static function copy2map<T>(source:Dynamic):StringMap<T>
	{
		var c:StringMap<T> = new StringMap();
		for (k in Reflect.fields(source))
			c.set(k, Reflect.field(source,k));
		return c;
	}
	
}