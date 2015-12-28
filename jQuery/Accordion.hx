package jQuery;
import jQuery.haxe.Plugin;
import js.html.HtmlElement;

/**
 * ...
 * @author axel@cunity.me
 */
extern class Accordion implements Plugin
{
	public var panels:Array<js.html.HtmlElement>;
	
	@:overload
	public function accordion( op:String, ?field:String, ?val:Dynamic):Dynamic
	{
		return untyped this.accordion(op, field, val);
	};
	
	@:overload
	public  function accordion(?options:Dynamic):JQuery
	{
		return untyped this.accordion(options);
	}
	
	@:overload
	public  function instance(?options:Dynamic):JQuery
	{
		return untyped this.accordion("instance");
	}	
	
}