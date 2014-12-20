package me.cunity.php.smarty;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */
enum Arguments
{
	d(d:Dynamic);
	s(s:String);
	sA(sa:Array<String>);
	sd(s:String, d:Dynamic);
	sdb(s:String, d:Dynamic, b:Bool);
}

typedef AppendArg = 
{
	
}

extern class Smarty 
{

	public function append(vn:Dynamic, ?v:Dynamic, ?merge:Bool):Void;
	public function appendByRef(name:String, v:Dynamic, merge:Bool):Void;
	public function assign(arg:Arguments):Void;
	public function assignByRef(s:String, v:Dynamic):Void;
	public function clearAllAssign():Void;
	public function clearAllCache(?expireTime:Int):Void;
	public function clearAssign(arg:Arguments):Void;
	public function clearCache(template:String, ?cacheId:String, ?compileId:String, ?expireTime:Int):Void;
	public function clearCompiledTemplate(template:String, ?compileId:String, ?expireTime:Int):Void;
	public function clearConfig(?name:String):Void;
	public function compileAllConfig(?ext:String, ?force:Bool, ?timelimit:Int, ?maxerror:Int):Void;
	//public function clearAssign():Void;

	public function new() :Void;
	
}