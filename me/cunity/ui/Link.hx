/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.ui;
import flash.Lib;
import flash.net.URLRequest;

class Link 
{

	public function new() 
	{
		
	}
	
	public static function go(att:Dynamic)
	{
		//trace (att);
		if (att.url == null)
			return;
		//TODO:HANDLE SCHEMES
		var request:URLRequest = new URLRequest(att.url);
		try {
			Lib.getURL(request, att.target? att.target :'_self');
			//trace(att.url);
		}
		catch (ex:Dynamic)
		{
			trace(att.url + ':' + ex);
		}
	}
}