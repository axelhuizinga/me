/**
 *
 * @author ...
 */

package me.cunity.data;

import me.cunity.debug.Out;

import me.cunity.tools.ArrayTools;
//#if flash
import me.cunity.ui.BaseCell;
import me.cunity.geom.Points;
import me.cunity.geom.Rotate;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.xml.XMLNode;
//#end

using me.cunity.tools.ArrayTools;

class Parse 
{

	public static var  graphicsTypes:Dynamic = {
		fill:function(v) {
			if (v == null) return null;
			var a:Array < String > = ArrayTools.map(v.split(','), StringTools.trim);
			if (a.length == 1)
				return [att2UInt(a[0]), 1.0];
			//trace(a.toString() + ':' + [att2UInt(a[0]) , att2Float(a[1])].toString());
			return [att2UInt(a[0]) , att2Float(a[1])];
		},
		lineStyle:function(v) {
			if (v == null) return null;
			var a:Array < String > = ArrayTools.map(v.split(','), StringTools.trim);
			return [att2Float(a[0]), att2UInt(a[1]), att2Float(a[2])];
		}
	};
	
	public static var  displayObjectTypes:Dynamic = {
		alpha:function(v) { return (v == null) ? 1.0 :att2Float(v); } ,
		//name:function (v) { return (v==null) ? 'mc'+Std.string(flash.Lib.getTimer()) :v; },
		rotation:att2Float ,
		//visible:function(v) { return (v == null) ? true :att2Bool(v);} ,
		x:att2Float,
		y:att2Float
	};
	
	public static var  baseCellTypes:Dynamic = {
		alpha:function(v) { return (v == null) ? 1.0 :att2Float(v); } ,
		borderWidth:function(v)
		{
			if (v == null)
			return 
			{
				top:.0,
				right:.0,
				bottom:.0,
				left:.0
			};			
			return parseBorder(v);
		},
		buttonMode:att2Bool,
		cornerRadius:function(v) {
			if (v == null)
				return null;
			var values:Array<Float> = ArrayTools.map2(~/\s|,/g.split(v), Std.parseFloat);

			return switch(values.length)
			{
				case 1:
				{
					TR:values[0],// *R => height
					BR:values[0], 
					BL:values[0],// *L => width
					TL:values[0],
					method:'drawRoundRect'
				}
				case 2:
				{
					TR:values[1],// *R => height
					BR:values[1], 
					BL:values[0],// *L => width
					TL:values[0],
					method:'drawRoundRect'
				}
				case 4:
				{
					TR:values[0],
					BR:values[1],
					BL:values[2],
					TL:values[3],
					method:'drawRoundRectComplex'
				}
				default:
					null;
			}
		},
		margin:function(v)
		{
			if (v == null)
			return 
			{
				top:.0,
				right:.0,
				bottom:.0,
				left:.0
			};
			return parseBorder(v);
		},
		padding:function(v)
		{
			if (v == null)
			return 
			{
				top:.0,
				right:.0,
				bottom:.0,
				left:.0
			};
			return parseBorder(v);
		},
		preserveAspectRatio:function(v)
		{
			if (v == null)
				return null;
			var values:Array<String> = ArrayTools.map( v.split(' '), StringTools.trim);
			if (values.length == 1)
				return { align:values[0], meet:true }
			return { align:values[0], meet:(values[1] != 'slice')}
		},
		rotation:att2Float ,
		visible:function(v) { att2Bool(v); } 
	};
	
	public static var  formTypes:Dynamic = {
		alpha:function(v) { return (v == null) ? 1.0 :Std.parseFloat(v); } ,
		//containerForm:function(v) { return (v == null) ? 'rect' :v;},
		//name:function (v) { return (v==null) ? 'mc'+Std.string(flash.Lib.getTimer()) :v; },
		rotation:att2Float,
		visible:function(v) { return (v == null) ? true :att2Bool(v);} 
	};
//#if flash	
	public static var gradientTypes:Dynamic = {
		type:function(v) {
			return switch(v) {
				case 'radial':
				GradientType.RADIAL;
				default:
				GradientType.LINEAR;
			}
		},
		spreadMethod:function(v) {
			return switch(v) {
				default:
				SpreadMethod.PAD;
				case 'reflect':
				SpreadMethod.REFLECT;
				case 'repeat':
				SpreadMethod.REPEAT;
			}
		},
		colors:function(v) {
			return ArrayTools.map2(ArrayTools.map(v.split(','), StringTools.trim), att2UInt);
		},
		ratios:function(v) {
			return ArrayTools.map2(ArrayTools.map(v.split(','), StringTools.trim), att2UInt);
		},
		alphas:function(v) {
			return ArrayTools.map2(ArrayTools.map(v.split(','), StringTools.trim), att2Float);
		},
		focalPointRatio:att2Float,
		interpolationMethod:function(v) {
			return (v == 'linearRGB') ? InterpolationMethod.LINEAR_RGB :InterpolationMethod.RGB;
		}		
	};
//#end
	
	public static function inheritAtts(atts:Dynamic, atts2add:Dynamic, important:Bool = false) {
		var names = Reflect.fields(atts2add);
		for (name in names) {
			try {
			if(Reflect.field(atts, name) == null || important)
				Reflect.setField(atts, name, Reflect.field(atts2add, name));				
			}
			catch (ex:Dynamic) { trace(name);}

		}
	}
	
	public static function changeAtts(atts:Dynamic, atts2add:Dynamic, ?atts2change:Array<String>) 
	{
		trace(Std.string(atts2add));
		var names:Array < String > = (atts2change == null ? Reflect.fields(atts2add) :atts2change);
		for (name in  names) 
		{
			try {
				Reflect.setField(atts, name, Reflect.field(atts2add, name));
			}
			catch(ex:Dynamic) { trace(name);}
		}
	}
	

	public static function applyToObject(ob:Dynamic, type:Dynamic, atts:Dynamic)
	{
		//trace(ob.name + ':' + Std.string(type) + ':' + Std.string(atts));
		//trace(ob.name + '.alpha:' + ob.alpha + ' ' + Reflect.fields(type).toString() );
		//trace(ob +':'+Reflect.fields(type));
		var fName:String = '';
		for (fName in Reflect.fields(type))
		{
			//trace(fName);
			var val:Dynamic = Reflect.field(atts, fName);
			//if (val == null) continue;
			switch(fName) {
				case 'preserveAspectRatio':
				Reflect.setField(ob.cAtts, fName, Reflect.field(type, fName).apply(null, [val]));
				case 'rotation':
				//trace('rotation:' + val);
				if (Math.isNaN(val )) continue;

				//Rotate.rotateDOb(ob, 'up');
				Rotate.rotateWithNewOrigin(ob, att2Float(val), Points.getPoint(ob, 'topRight'));
				//trace(ob + ':' + att2Float(val));
				//Out.dumpLayout(ob);
				default:
				//trace(fName +':' + val);
				Reflect.setField(ob, fName, Reflect.field(type, fName).apply(null, [val]));
			}			
			//trace(fName + ':' + ob.name);
		}
	}
	
	public static function att2Bool(v:String):Bool {
		return  (v == 'true' || v == '1');
	}
#if (flash||openfl)
	public static function att2UInt(v:String):UInt {
		if (v == null) return 0;
		var u:UInt = Std.parseInt(v);
		//trace(v + ':' + u);
		return (u < 0) ? 0 :u;
	}
#end	
	public static function att2Int(v:String):Int {
		//trace(v );
		if (v == null) return 0;
		var i:Int =  Std.parseInt(v);
		
		return Math.isNaN(i) ? 0 :i;
	}
	
	public static function att2IntNull(v:String):Null<Int>
	{
		return (v == null ? null :att2Int(v));
	}
	
	public static function att2Float(v:String):Float {
		if (v == null) return 0.0;
		var f:Float = Std.parseFloat(v);
		return Math.isNaN(f) ? 0.0 :f;
	}
	
	public static function att2FloatNull(v:String):Null<Float> {
		return  (v == null ? null :att2Float(v));
	}
	  
	public static function att2Array< T > (arr:Array < T >, v:String):Void{
		var vals:Array < String >  = v.split(',');		
		for (i in 0...vals.length)
			arr.push(cast vals[i]);
	}
	
	public static function att2Method(ob:Dynamic, method:String):Dynamic
	{
		return Type.getInstanceFields(Type.getClass(ob)).contains(method) ? Reflect.field(ob, method) :null;
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
	
	public static function unitString2Float(s:String, rel:Float=0.0):Float
	{
		if (s == null || s == '')
			return 0.0;
		var hUnit:Dynamic = Parse.unitString(s);
			//trace( Std.string(hUnit) );
		if (hUnit)
		return switch(hUnit[0])
		{
			case '%':// relative to parent box
			Std.parseFloat(hUnit[1]) / 100 * rel;
			case '*'://take what you still can get - the value 0.0...1.0 denotes percentage of available space defaults to 1.0 = 100%
			var val = Std.parseFloat(hUnit[1]);
			//trace( hUnit.toString() + ':' + val);
			(val==0) ? -1.0 :-val;
			default://px
			Std.parseFloat(hUnit[1]);				
		};
		return 0.0;
	}
	
	static function parseBorder(v:String):Border
	{
		var values:Array<Float> = ArrayTools.map2(~/\s|,/g.split(v), Std.parseFloat);
		var l:Int = values.length;
		return switch(l)
		{// css margin parsing
			case 1:
			{
				top:values[0],
				right:values[0],
				bottom:values[0],
				left:values[0]
			}
			case 2:
			{
				top:values[0],
				right:values[1],
				bottom:values[0],
				left:values[1]
			}
			case 3:
			{
				top:values[0],
				right:values[1],
				bottom:values[2],
				left:values[1]
			}
			case 4:
			{
				top:values[0],
				right:values[1],
				bottom:values[2],
				left:values[3]
			}
			default:
				null;			
		}
	}
}