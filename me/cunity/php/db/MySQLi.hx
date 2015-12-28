package me.cunity.php.db;
import haxe.extern.EitherType;
import me.cunity.php.db.MySQLi_Result;
/**
 * ...
 * @author axel@cunity.me
 */
extern class MySQLi
{

	public static inline var MYSQLI_STORE_RESULT:Int   = 0;
	
	public static inline var MYSQLI_USE_RESULT:Int   = 1;
	
	public static inline var 	MYSQLI_ASSOC:Int   =   1;
 
	public static inline var 	MYSQLI_NUM:Int   =   2;
 
	public static inline var 	MYSQLI_BOTH:Int   =   3;
	
	public var affected_rows:Int;
	
	public var autocommit:Bool;
	
	public var connect_error:String;
	
	public var error:String;
	
	public var field_count:Int;
	
	public var insert_id:EitherType<Int,String>;
	
	public var more_results:Bool;
	
	
	public function new(?host:String, ?username:String, ?passwd:String, ?dbname:String, ?port:Int, ?socket:String ):Void;
	
	public function real_escape_string(escapestr:String):String;
	
	public function multi_query(query:String):Bool;
	
	public function next_result():Bool;
	
	public function prepare(query:String):EitherType<MySQLi_STMT, Bool>;
	
	public function query(query:String, ?resultmode:Int):EitherType<MySQLi_Result, Bool>;
	
	public function select_db(dbname:String):Bool;
	
	public function store_result():EitherType<MySQLi_Result, Bool>;
	
	public function stmt_init():MySQLi_STMT;
	
	
	
	
}