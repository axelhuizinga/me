/**
 *
 * @author Axel Huizinga
 */

package me.cunity.tools;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import me.cunity.debug.Out;
import me.cunity.ui.Container;
import me.cunity.ui.BaseCell;
import me.cunity.core.Application;
import haxe.Timer;

using StringTools;

class FlashTools
{
	var param:Array<Dynamic>;
	var callBack:Dynamic;
	
	public function new(){}
	
	public function setTimeout(cBwithArgs:Dynamic, d:Int) 
	{		
		if (Std.is(cBwithArgs, Array)) {
			param = cBwithArgs;
			callBack = param.shift();
		}
		else {
			callBack = cBwithArgs;
			param = [];
		}
		Timer.delay(doIt, d);
	}
	
	function doIt() {
		//callBack(param);
		Reflect.makeVarArgs(dispatch(param));
	}
	
	function dispatch(args:Array < Dynamic > ):Dynamic {
		//trace(args.length);
		var l:Int = args.length;
		return switch(l) {
			case 0:
			callBack();
			case 1:
			callBack(args[0]);
			case 2:
			callBack(args[0], args[1]);
			case 3:
			callBack(args[0], args[1], args[2]);
			case 4:
			callBack(args[0], args[1], args[2], args[3]);
			case 5:
			callBack(args[0], args[1], args[2], args[3], args[4]);
			default:
			throw(args.length + " parameters are not supported :-(");
			null;
		}
	}

	public static function findPath(root:DisplayObjectContainer, name:String, path:String = ''):String {	
		path = (path == '') ? root.name:path + '.' + root.name;
		//trace(path);
		if (name == root.name)
			return path;
		var children = root.numChildren;
		for (child in 0...children) {
			var childOb = root.getChildAt(child);
			var container:DisplayObjectContainer = null;
			try {
				container = cast(childOb, DisplayObjectContainer);
			}
			catch (ex:Dynamic) { continue;}
			var res:String = findPath(container, name, path);
			if (res != null)
				return res;
		}
		return null;
	}
	
	public static function getPath(dOb:DisplayObject, r:DisplayObject, path:String = ''):String {
		//trace(dOb.name);
		//trace(dOb.parent.name);
		//trace(r);
		return (dOb.parent != r) ?
			getPath(dOb.parent, r, dOb.parent.name + '.' + path):
			path;
	}
	
	public static function numTarget(ref:Array<String> , ?root:BaseCell):BaseCell 
	{		
		if (root == null)
			root = Application.instance;
		var res:BaseCell = null;
		//trace(ref.length + ' bG:' + root.bG);
		while (ref.length > 0) 
		{
			var num:Int = Std.parseInt(ref.shift()) + (root.bG == null ? 0 :1);
			//trace(num +':' + root.numChildren);
			try{
				res = cast(root.getChildAt(num), BaseCell);
				//trace(res + ' num:' + num + ' bG:' + root.bG);
			}
			catch (ex:Dynamic) { }
			root = res;
		}
		return res;
	}

}