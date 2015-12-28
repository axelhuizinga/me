package me.cunity.php;
import haxe.PosInfos;
import php.Web;


class Debug
{
	public static var logFile:String;
	
	public static function dump(message:Dynamic , stackPos:UInt=0):Void
	{
		untyped __call__('edump', message, stackPos);
	};	
	
	public static function _trace(v : Dynamic, ?i : PosInfos)
	{
		var info = if( i != null ) i.fileName+":"+i.methodName +":"+i.lineNumber+":" else "";		
		//untyped __call__('edump',  info + ':' + v);
		//untyped __call__('error_log',  info + ':' + v);
		
		untyped __call__('file_put_contents', logFile,  info + ':' + ( Std.is(v, String) || Std.is(v, Int) || Std.is(v, Float)  ? v : untyped __call__("print_r", v, 1))
			+ '\n', untyped __php__('FILE_APPEND'));
		//untyped __call__('trace', v, info);
	}
	
}