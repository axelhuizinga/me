package me.cunity.app;
/**
 * ...
 * @author axel@cunity.me
 */


//import haxe.CallStack;
//import haxe.CallStack;
import me.cunity.debug.Out;
#if !js
import erazor.Template;
import sys.io.File;
#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end
#end

class Ui 
{
	public function new(app:App, prop:Dynamic = null) 
	{
		#if !js
		trace('hmmm');
		App.errLog(app.path + '=>' + Std.string(prop));
		//Out.dumpStack(CallStack.callStack());
		var tplContent:String = File.getContent('templates/' + app.path + '.html');
		var er:EReg = ~/@([a-zA-Z0-9]+)/;
		er.match(tplContent);
		var vars:Array<String> = [];
		var nextPart:String = tplContent;
		var mi:Int = 0;
		//trace(mi + ':' + tplContent.charAt(er.matchedLeft().length));
		var keywords:Array<String> = ['if', 'for'];
		while (er.matchSub(tplContent, mi))
		{
			//trace(mi + ':' + tplContent.charAt(er.matchedLeft().length) + ':' + er.matched(0) + ':' + er.matched(1));
			mi = tplContent.length - er.matchedRight().length;
			if (Lambda.has(vars, er.matched(1)) || Lambda.has(keywords, er.matched(1)))
				continue;
			vars.push(er.matched(1));
		}
		//trace(vars.toString());
		for (v in vars)
		{
			if (Reflect.field(prop, v) == null)
			{
				Reflect.setField(prop, v, Reflect.isFunction(Reflect.field(app, v)) ? Reflect.callMethod(app, Reflect.field(app, v),[]) :'');
			}
		}
		
		var tpl:Template = new Template(tplContent);
		//App.errLog(prop);
		//App.errLog(tplContent);
		//Lib.print(tpl.execute(prop));
		try
		{
			Lib.print(tpl.execute(prop));
		}
		catch (ex:Dynamic)
		{
			trace(ex);
		}
		#end
		//trace('hmmm');
	}
	
	public static function print(template:String, prop:Dynamic = null):String
	{
		var tpl:Template = new Template(File.getContent('templates/' +template + '.html'));
		try
		{
			return tpl.execute(prop);
		}
		catch (ex:Dynamic)
		{
			trace(ex);
		}
		return null;
	}
}