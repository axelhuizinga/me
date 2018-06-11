package me.cunity.js.jqPlugin;

/**
 * ...
 * @author axel@cunity.me
 */
extern class Template implements js.jquery.Plugin
{

	@:overload public function tmpl(data:Dynamic):js.jquery.JQuery;
	
	public function template(name:String):js.jquery.JQuery;	
	
	public function tmplItem():js.jquery.JQuery;
	
	public function update():js.jquery.JQuery;
	
	@:overload static public function template(name:String, template: String):JQuery;
	
	@:overload  static public function tmpl(compiledName:String, data:Dynamic):JQuery;
	
}