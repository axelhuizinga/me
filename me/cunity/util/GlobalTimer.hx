package me.cunity.util;

/**
 * @author Axel Huizinga axel@cunity.me
 * originally written by Tony Polinelli 
 */

import haxe.ds.GenericStack;
import haxe.CallStack;
import haxe.Timer;
#if js
import js.Browser;
#end
import me.cunity.debug.Out;

class GTimer extends Timer
{
	public var paused:Bool;
	public function new(ms:Int) 
	{
		super(ms);		
	}
}

class GlobalTimer
{
    public static var GTimers:GenericStack<GTimer> = new GenericStack<GTimer>();
	//trace('GTimers:' + GTimers);
    //public static var GTimers:Array<GTimer> = new Array();

    public static function setInterval(func:Dynamic, milliseconds:Int, rest:Array<Dynamic> = null):GTimer
    {
        var GTimer:GTimer = new GTimer(milliseconds);
        GTimers.add(GTimer);
        GTimer.run = function()
        {
            //Reflect.callMethod(null, func, rest); MSIE chokes
            func();
        }

        return GTimer;
    }

    public static function clearInterval(t:GTimer)
    {
		if (t == null)
		{
			//trace('GTimers[' + id + '] is null');
			clearAllTimers();
			return;
		}
        t.stop();
        GTimers.remove(t);
        t = null;
    }

    public static function setTimeout(func:Dynamic, milliseconds:Int,	rest:Array<Dynamic> = null):GTimer
    {
        var GTimer:GTimer = new GTimer(milliseconds);
        GTimers.add(GTimer);
        
        GTimer.run = function()
        {
            //Reflect.callMethod(null, func, rest);
            func();
            clearTimeout(GTimer);
        }

        return GTimer;
    }

    public static function clearTimeout(t:GTimer)
    {
        t.stop();
        GTimers.remove(t);
        t = null;
    }
	
	public static function clearAllTimers(?e:Dynamic)
	{
		var t:GTimer;
		while ((t = GTimers.pop()) != null)
		{
				t.stop();
				t =  null;
		}
		//Out.dumpStack(CallStack.callStack());
		#if js
		Browser.window.onerror = null;
		#end
		//return false;
	}

}