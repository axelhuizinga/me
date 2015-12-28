package me.cunity.php.db;
import haxe.extern.EitherType;

/**
 * ...
 * @author axel@cunity.me
 */
extern class MySQLi_STMT
{

	public var affected_rows:Int;

	public var error:String;
	
	public var field_count:Int;
	
	public var insert_id:Int;
	
	public var num_rows:Int;
	
	public var param_count:Int;
	
	public function new():Void;
	
	//TODO: DEFINE RELATED CONSTANTS
	public function attr_set(attr:Int, mode:Int):Bool;
	
	public function attr_get(attr:Int):Int;

	@:overload(function(types:String, var1:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic, var7:Dynamic):Bool{})
	public function bind_param(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic, var7:Dynamic, var8:Dynamic):Bool;
	
	
	@:overload(function(types:String, var1:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic):Bool{})
	@:overload(function(types:String, var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic, var7:Dynamic):Bool{})	
	public function bind_result(var1:Dynamic, var2:Dynamic, var3:Dynamic, var4:Dynamic, var5:Dynamic, var6:Dynamic, var7:Dynamic, var8:Dynamic):Bool;
	
	public function close():Bool;
	
	public function data_seek(offset:Int):Void;
	
	public function execute():Bool;
	
	public function fetch():Bool;
	
	public function free_result():Void;
	
	public function get_result():EitherType<MySQLi_Result,Bool>;
	
	public function prepare(query:String):EitherType<MySQLi_STMT,Bool>;
	
	public function reset():Bool;
	
	public function result_metadata():EitherType<MySQLi_Result,Bool>;
		
	public function store_result():Bool;
	
	
	
	
}