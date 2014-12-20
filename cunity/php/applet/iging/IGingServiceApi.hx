package me.cunity.php.applet.iging;
import me.cunity.php.applet.IServiceApi;
import me.cunity.php.applet.Types;


/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

interface IGingServiceApi implements IServiceApi 
{
	
	public function add(create:Bool = true, question:String = null):Void;
			
	public function get(param:GetParam):Map<Dynamic>;

}