/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.animation.sandy;

class TimeLine 
{
	var actions:Array<Dynamic>;
	var current:Int;
	
	public function new() 
	{
		actions = new Array();
		current = -1;
	}
	
	public function add(act:Dynamic)
	{
		actions.push(act);
		trace(actions.length);
	}
	
	public function next():Void
	{
		trace(current +' ==' + ( actions.length - 1));
		if (current == actions.length - 1)
			return;
		actions[++current](this);
	}
	
}