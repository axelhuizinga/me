/**
 *
 * @author Axel Huizinga
 */

package me.cunity.tools;


class MathTools 
{

	public function new() 
	{
		
	}
	
	public static function round2( number :Float, precision :Int = 2):Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	
	public static function min(values:Array < Float> ):Null<Float>{
		if (values.length < 1) return null;
		var result:Float= values.shift();
		while (values.length > 0) {
			result = cast Math.min(result, values.shift());
		}
		return result;
	}
	
	public static function max(values:Array < Float> ):Null<Float>{
		if (values.length < 1) return null;
		var result:Float= values.shift();
		while (values.length > 0) {
			result = cast Math.max(result, values.shift());
		}
		return result;
	}	

	
}