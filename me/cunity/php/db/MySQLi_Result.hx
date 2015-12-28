package me.cunity.php.db;

import php.NativeArray;
import me.cunity.php.db.MySQLi;

/**
 * ...
 * @author axel@cunity.me
 */
extern class MySQLi_Result
{

	public var num_rows:Int;
	
	public function new():Void;
	
	public function data_seek(offset:Int):Bool;
	
	public function free():Void;
	
	public function fetch_all(resulttype:Int = 2):NativeArray;
	
	public function fetch_array(resulttype:Int = 3):NativeArray;
	
	
	
}