package me.cunity.php.applet;
import haxe.ds.StringMap;


/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

interface IMediaServiceApi extends IServiceApi 
{
	
	public function add(
		mediaPath:String, create:Bool = false, overwrite:Bool = false, name:String = null):Void;
			
	public function getAlbum(mediaPath:String):StringMap<Dynamic>;

}