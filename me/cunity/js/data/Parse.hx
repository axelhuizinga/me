package me.cunity.js.data;
import haxe.ds.StringMap;
import js.Browser;
import js.Lib;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Parse 
{
	public static function att2Bool(v:String):Bool {
		return  (v == 'true' || v == '1');
	}
	
	public static function unitString(s:String):Dynamic
	{
		var e:EReg = ~/(\d*\.?\d*)/;
		if (e.match(s))
		{
			//trace(e.matched(0) + ':' + e.matchedRight());
			return [e.matchedRight(), e.matched(0)];
		}
		return null;
	}
	
	public static function getParam(key):String
	{
		var keyValuePairs:StringMap<String> = getParams();
		return keyValuePairs == null || !keyValuePairs.exists(key) ? null :keyValuePairs.get(key);
	}	
	
	public static function getParams():StringMap<String>
	{
		var s:String = Browser.window.location.search; 
		if (s.length > 1)
			s = s.substr(1);
		else
			return null;
		var keyValuePairs:StringMap<String> = new StringMap();		
		for (pair in s.split( '&' ))
		{
			var kV:Array<String> = pair.split('=');
			keyValuePairs.set(kV[0], kV.length == 2 ? StringTools.urlDecode(kV[1]) :'');
		}
		return keyValuePairs;
	}
}