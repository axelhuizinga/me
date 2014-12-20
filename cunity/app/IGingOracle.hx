package me.cunity.app;

/**
 * ...
 * @author axel@cunity.me
 */

import haxe.CallStack;
import haxe.io.Path;
import haxe.CallStack;
import me.cunity.app.App;
import me.cunity.app.Types;
import me.cunity.app.data.OracleDataDisplay;
import me.cunity.app.data.OracleTypes;
import me.cunity.debug.Out;

#if (php||neko)
import sys.FileSystem;
import sys.io.File;
import me.cunity.app.data.OracleData;
#if php
import php.Web;
import php.Lib;
#elseif neko
import neko.Web;
import neko.Lib;
#end
#elseif js
import js.Lib;
#end
import me.cunity.app.data.Oracle;


@:keep class IGingOracle extends App implements IGingOracleIface
{
	static var sInst :IGingOracle; 
	
	public function allSigns():String
	{
		var res:String = new Oracle().getAllSigns();
		//Lib.print(res);
		return res;
	}
	
	public function ask(question:String = ''):OracleDataDisplay
	{
		//trace(CallStack.toString(CallStack.callStack()));

		trace(question);
		var oe:Oracle = new Oracle();//{ sign:1, change:0 };
		oe.ask();
		//return null;
		var res:OracleDataDisplay = new OracleDataDisplay({
			date:oe.date,
			signIndex:oe.signIndex,
			changeIndex:oe.changeIndex,
			changeLines:oe.changeLines,
			question:question,
			uID:user.uID
		});	
		//var res = OracleData.saveOracleData(or);
		Lib.print(Std.string(res));
		//#end 
		return res;
	}
	
	public function getHistory(hC:HistoryConstraint = null):List<OracleDataDisplay>
	{
		var data:List<OracleDataDisplay> = new List();
		#if php
		#end
		return data;
	}
	
	public function introText():String
	{
		return File.getContent('templates/de/introText.html');
	}
	
	public function showSign(oracle:Oracle, asked:Bool = true):String
	{
		var res:String = '';
		trace(res);
		return res;
	}

}