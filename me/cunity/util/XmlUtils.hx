/**
 *
 * @author Axel Huizinga
 */

package me.cunity.util;

class XmlUtils
{

	public static function getElement(xml:Xml, att:String, val:Dynamic):Xml
	{
		var els:Iterator<Xml> = xml.elements();
		var _val =  Std.string(val);
		trace(att + ':' + _val);
		for (el in els) {
			//if(el.exists(att) && 
			trace(el.nodeName + ' ' +att + ' >' + el.get(att) + '<' + _val +'<');
			if (el.get(att) == _val)
				return el;
			trace( el.toString());
			var childs:Iterator<Xml> = el.elements();
			while (childs.hasNext()) {
				var child:Xml =  getElement(childs.next(), att, val);
				if (child != null)
					return child;
			}
		}
		return null;
	}
	
	public static function getChildByAtt(childs:Iterator<Xml>, att:String, val:Dynamic):Xml
	{
		var _val =  Std.string(val);
		trace(att + ':' + _val);
		for (el in childs) {
			//if(el.exists(att) && 
			trace(el.nodeName + ' ' +att + ' >' + el.get(att) + '<' + _val +'<');
			if (el.get(att) == _val)
				return el;
			trace( el.toString());
		}
		return null;
	}
	
	public static function innerHTML(element:Xml):String {
		var iHTML :String = '';
		var children:Iterator<Xml> = element.iterator();
		for (child in children)
			iHTML += child.toString();
		return iHTML;
	}
	
	public static function att2Bool(v:String):Bool {
		return  (v == 'true' || v == '1');
	}
	
	public static function att2Int(v:String):Int {
		if (v == null) return 0;
		var i:Int =  Std.parseInt(v);
		return Math.isNaN(i) ? 0 :i;
	}
	
	public static function att2Float(v:String):Float {
		if (v == null) return 0.0;
		var f:Float = Std.parseFloat(v);
		return Math.isNaN(f) ? 0.0 :f;
	}
	
	public static function att2Array< T > (arr:Array < T >, v:String):Void{
		var vals:Array < String >  = v.split(',');		
		for (i in 0...vals.length)
			arr.push(cast vals[i]);
	}
}