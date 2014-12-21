/**
 *
 * @author ...
 */

package me.cunity.tools;

import Type;

class ArrayTools
{
	public static var indentLevel:Null<Int>;

	public static function atts2field(aAtts):Array < Dynamic > {
		var f:Array<Dynamic> = new Array();
		for (name in Reflect.fields(aAtts)) {
			f.push( Reflect.field( aAtts, name));
		}
		return f;
	}
	
	public static function countElements<T>(a:Array<T>, el:T):Int
	{
		var count:Int = 0;
		for (e in a)
			if (e == el)
				count++;
		return count;
	}
	
	public static function map<T> (a:Array<T> , f:T->T) 
	{
		for (e in 0 ... a.length){
			//trace(a[e]);
			a[e] = f(a[e]);
			//trace(a[e]);
		}
		return a;
	}
	
	public static function map2 < S, T > (a:Array<S> , f:S -> T):Array <T> {
		var t:Array<T> = new Array();
		for (e in 0 ... a.length)
			t[e] = f(a[e]);
		return t;
	}
	
	public static function contains < T > (a:Array < T > , el:T):Bool {
		//trace(a);
		//trace(el);
		for (e in a)
			if (e == el)
				return true;
		return false;
	}
	
	//public static function sortNum(arr:Array<Int>):Array<Int>
	//public static function sortNum(arr:Array<Int>, a, b):Int
	public static function sortNum( a, b):Int
	{
		if (a < b) return -1; 
		if (a > b) return 1; 
		return 0;
		/*arr.sort(function(a, b) { if (a < b) return -1; if (a > b) return 1; return 0;});
		return arr;*/
	}
	
	
	
	public static function stringIt2Array(it:Iterator < String > , ?sort:Bool):Array<String> {
		var values:Array<String> = new Array();
		for (val in it)
			values.push(val);
		if (sort)
			values.sort(
				function(a, b) {
					var ret:Int = 0;
					if(a < b) ret = -1; 
					if (a > b) ret = 1; 
					return ret;
				}
			);
		return values;
	}
	
	public static function It2Array < T > (it:Iterator < T > ):Array < T > {
		var values:Array<T> = new Array();
		for (val in it)
			values.push(val);
		return values;
	}
	
	static function getIndent():String {
		var indent:String = '';
		for (i in 0...indentLevel)
			indent += '\t';
		return indent;
	}
	
	public static function dumpArray (arr:Array < Dynamic >,  ?propName:String ):String {
		if (arr.length == 0) return '';
		if (indentLevel == null) indentLevel = 0;
		//trace ( indentLevel + ':' + Std.string(arr.length));
		//var dump:String = '\n line 74' + Std.string(indentLevel) + getIndent()  + '[\n';
		var dump:String = '\n' + getIndent()  + '[\n';
		//indentLevel ++;	
		var i:Int = 0;
		for (el in arr) {
			//trace(el +' isArray:' + isArray(el) +' i:' + i++);
			//i++;
			if (isArray(el)) {
				//trace(el);
				indentLevel++;
				if(el == null){
					trace('el = null');
					dump += getIndent() +'[],';
				}
				else {
					var a:Array<Dynamic> = cast(el, Array<Dynamic>);	
					//trace(a);
					//var li:Int = 0;
					//indentLevel ++;	
					for (ia in a) {
						//dump += Std.string(indentLevel) + getIndent() + '[line 94';
						dump += getIndent() + '[';
						indentLevel ++;	
						dump += (ia == null) ? '\n' + getIndent() + 'null\n' :dumpArray(ia,  propName);
						indentLevel --;	
						dump += getIndent();
						//dump += (indentLevel > 1)? '],line 99\n' :']line 99\n';
						dump += (indentLevel > 0)? '],\n' :']\n';
					}
				}
				indentLevel --;
				//dump += (indentLevel > 1) ? getIndent() + '],105\n' :getIndent() + ']\n';
				dump += (indentLevel > 0) ? getIndent() + '],\n' :getIndent() + ']\n';
				return dump;
				
			}
			else {
				if (++i == 1) {
					indentLevel ++;
					dump += getIndent();
				}
				if (el == null) {
					dump += 'null';
				}
				else if (propName != null) {
					var names = propName.split('.');
					var item:Dynamic = el;
					for (name in names){
						item = Reflect.field(item, name);
					}
					dump += item;
				}
				else {
					dump +=  Std.string(el);
				}
				if (i < arr.length) dump += ', ';
				else indentLevel --;
			}
		}
		dump += '\n' + getIndent();
		//dump += (indentLevel > 1) ?  '],126\n' :'] \n';
		dump += (indentLevel > 0) ?  '],\n' :'] \n';
		//indentLevel--;
		return dump;
	}
	
	public static function dumpArrayItems(arr:Array < Dynamic>, ?propName:String):String {
		var dump:String = '';
		var indent:String = '';
		for (i in 0...indentLevel)
			indent += ' ';   
		trace (indent + indentLevel);
		for (el in arr) {
			if (propName != null) {
				var names = propName.split('.');
				var item:Dynamic = el;
				for (name in names)
					item = Reflect.field(item, name);
				dump += item;
			}
			else {
				dump +=  Std.string(el);
			}
			dump += ', ';
		}
		trace(dump);
		return dump;
	}
	
	public static function isArray(arr:Dynamic):Bool {
		return 	Type.getClassName(Type.getClass(arr)) == 'Array' ? true:false;
	}
	
	public static function indexOf<T>(arr:Array < T > , el:T):Int {
		for (i in 0...arr.length)
			if (arr[i] == el)
				return i;
		return -1;
	}
	
	public static function removeDuplicates<T>(arr:Array< T >):Array<T>
	{
		var i = 0;
		while ( i < arr.length) 
		{
			while (countElements(arr, arr[i])  > 1) { arr.splice(i, 1); } 
			i++;
		}
		return arr;
	}
	
	public static function spliceA<T>(arr:Array < T > , start:Int, 
		delCount:Int, ins:Array<T>  = null ):Array<T> {
		if (ins == null)
			return arr.splice(start, delCount);
		//if (start < 0) start = arr.length + start;	
		//trace(arr.slice(0, start + delCount).toString());
		//trace(ins.toString());
		//trace(arr.slice(start + delCount).toString());
		arr = arr.slice(0, start + delCount).concat(ins).concat(arr.slice(start + delCount));
		//trace(arr.toString());
		var ret:Array<T>= arr.splice(start, delCount);
		//trace(arr.toString());
		return ret;
		//return arr.splice(start, delCount);
	}
	
	public static function spliceEl<T>(arr:Array < T > , start:Int, 
		delCount:Int, ins:T  = null ):Array<T> {
		if (ins == null)
			return arr.splice(start, delCount);
		//if (start < 0) start = arr.length + start;	
		//trace(arr.slice(0, start + delCount).toString());
		//trace(ins.toString());
		//trace(arr.slice(start + delCount).toString());
		arr = arr.slice(0, start + delCount).concat([ins]).concat(arr.slice(start + delCount));
		//trace(arr.toString());
		var ret:Array<T>= arr.splice(start, delCount);
		//trace(arr.toString());
		return ret;
		//return arr.splice(start, delCount);
	}
	
	public static function filter < T > (arr:Array < T > , 
		cB: T->Int->Array< T > -> Bool, thisObj:Dynamic = null) {
		var ret:Array<T> = new Array();
		for (i in 0...arr.length)
			if (cB(arr[i], i, arr))
				ret.push(arr[i]);
		return ret;
	}
	
	public static function sum<T>(arr:Array<T>):T
	{
		//var s:T = null;
		var s:Dynamic = 0;
		for (e in arr)
			s += e;
		return s;
	}
}