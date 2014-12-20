/**
 *
 * @author Axel Huizinga
 */

package me.cunity.tools;


class StringTool
{
	public static function dirname(url:String):String { 
		var sep:String = (~/\//.match(url) ? '/' :'\\'); 
		url = new EReg(sep + "$", null).replace(url, ''); 
		var arr:Array < String > = url.split(sep); 
		arr.pop(); 
		return arr.join(sep); 
	} 
	
	public static function lcFirst(s:String):String {
		var eR = ~/^(.)/;
		eR.match(s);
		var r = eR.replace(s, eR.matched(0).toLowerCase());
		//var r = eR.replace(s, "+$1".toUpperCase());
		return r == null ? '' :r;
	}
	
	public static function ucFirst(s:String):String {
		var eR = ~/^(.)/;
		eR.match(s);
		var r = eR.replace(s, eR.matched(0).toUpperCase());
		//var r = eR.replace(s, "+$1".toUpperCase());
		return r == null ? '' :r;
	}
	
	/*public static function sprintf(vals:Dynamic, format:String):String
	{
		var iV:Array<Dynamic> = (Std.is(vals, Array)) ? vals :[vals] ;
		var formats:Array<String> = format.split('%');
		var result:String = formats.shift();
		if (formats.length != iV.length)
			return "format string not matching values !";
		while (formats.length >0 )
		{
			var form:String = formats.shift();
			var fType:String = form.substr(form.length - 1);
		}
		return result;
	}*/
	

#if (flash9||flash10)
	public static function match(s:String, eR:EReg):Array<String>{
	//public static function match(s:String, eR:Dynamic):Array<String>{
		var pat:String = Std.string(untyped eR.r);
		//var pat:String = Std.string(eR);
		//trace(pat + ' length:' +pat.length + ' 1.:' + pat.charCodeAt(0));
		var mod:String = (~/[gimosx]$/.match(pat)) ? pat.substr(pat.lastIndexOf('/') + 1, pat.length) :
			null;
		pat = pat.substr(1, pat.lastIndexOf('/') - 1);
		//trace(pat + '<- len:'+pat.length+' mod:' + mod);
		var matched:Array<String> = 
			Reflect.callMethod(
				//s, Reflect.field(s,'match'), [	untyped __new__(__global__["RegExp"],"l.{1}", mod)]);
				s, Reflect.field(s,'match'), [	untyped __new__(__global__["RegExp"], pat, mod)]);
		return matched;
	}
	
	public static function slice(s:String, a:Int = 0, e:Int = 0x7fffffff):String {
		return s.substr(a, e-a);
	}
	
	
#end	
}