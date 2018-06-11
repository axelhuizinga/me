package me.cunity.js;
import js.html.Window;
import js.html.Element;
import js.html.Node;
/*import haxe.extern.Rest;*/
import js.jquery.JQuery;

/**
 * @author axel@cunity.me
 */

class JHelper {
	/*@:selfCall
	@:overload(function(element:js.html.Element):Void { })
	@:overload(function(elementArray:haxe.extern.EitherType<js.html.NodeList, Array<js.html.Element>>):Void { })
	@:overload(function(selection:js.jquery.JQuery):Void { })
	@:overload(function(callback:haxe.Constraints.Function):Void { })
	@:overload(function(object:Dynamic):Void { })
	@:overload(function(html:String, attributes:Dynamic):Void { })
	@:overload(function(selector:String, ?context:haxe.extern.EitherType<js.html.Element, js.jquery.JQuery>):Void { })
	public function J(html:String, ?ownerDocument:js.html.Document):JQuery
	
	@:overload(function(j:JQuery):JQuery{})
	@:overload(function(j:Window):JQuery{})
	@:overload(function(j:Element):JQuery{})
	@:overload(function(j:Node):JQuery{})
	@:overload(function(html:String, context:JQuery):JQuery{})
	public static inline function J( html : String ) : JQuery {
		return new JQuery(html);
	}
	*/
	//public static function J(expr:Rest<Dynamic>) return new JQuery(expr);
	
	public static inline function vsprintf(format:String, args:Array<Dynamic>):String
	{
		//trace(format);
		//trace(args);
		return (untyped __js__("vsprintf"))(format, args);
	};

}