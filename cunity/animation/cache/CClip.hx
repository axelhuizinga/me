/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.animation.cache;
import flash.display.DisplayObject;
import flash.utils.ByteArray;

class CClip 
{
	public var numFrames(default, null):UInt;
	public var object2cache:DisplayObject;
	var cache:Array<ByteArray>;
	
	public function new(obj2cache:DisplayObject) 
	{
		numFrames = 0;
		object2cache = obj2cache;
	}
	
	public function addFrame(obj:DisplayObject = null)
	{
		
	}
	
}