package me.cunity.php.applet;
import erazor.Template;
import haxe.CallStack;
import me.cunity.debug.Out;
import sys.io.File;
import php.Lib;

/**
 * ...
 * @author axel@cunity.me
 */

class Ui 
{
	public function new(template:String, prop:Dynamic = null) 
	{
		App.errLog(template + '=>' + Std.string(prop));
		//Out.dumpStack(CallStack.callStack());
		var tpl:Template = new Template(File.getContent('templates/' +template + '.html'));
		try
		{
			Lib.print(tpl.execute(prop));
		}
		catch (ex:Dynamic)
		{
			trace(ex);
		}
		Sys.exit(0);
	}	
}