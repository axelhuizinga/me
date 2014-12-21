/**
 *
 * @author ...
 */

package me.cunity.ui;
import flash.xml.XML;

class DynaBlock 
{
	public static function create(x:XML, p:Container):Dynamic
	{
		var classPath = switch(x.attribute('classPath').toString())
		{
			case '':
			'me.cunity.ui';
			default:
			'me.cunity.ui.' + x.attribute('classPath').toString();
		}
		//trace(classPath + '.' + x.name() + ':' + Type.resolveClass(classPath + '.' + x.name()));
		return Type.createInstance(Type.resolveClass(classPath + '.' + x.name()), [x, p]);
	}
	
	public static function getClass(name):Dynamic
	{
		var cl = Type.resolveClass('me.cunity.ui.' + name);
		//trace(name +'->'+ cl);
		return cl;
	}
	
}