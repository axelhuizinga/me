/**
 *
 * @author Axel Huizinga
 */

package me.cunity.tools;
import flash.system.ApplicationDomain;
import Type.ValueType;   

class ClassTools 
{

	
	public static function hasSuperClass(obClass:Class<Dynamic>, cls:Class<Dynamic>):Bool {
		if (obClass == cls)
			return true;
		var sup:Class<Dynamic> = Type.getSuperClass(obClass)  ;
		if (sup == null)
			return false;
		if (sup == cls)
			return true;
		return hasSuperClass(sup, cls);
	}
	
	public static function hasSuperClassPath(ob:Dynamic, path:String, loadedType:Dynamic = null):Bool {
		//trace(loadedType);
		var oC:Class < Dynamic > = if (loadedType == null) {
			switch(Type.typeof(ob)){
				default:
				//trace(Type.typeof(ob));
				ob;
				case TClass(c ):
				//trace('TClass:' +Type.getClassName(c));
				Type.getClass(ob);
			} 
		}
		else {
			//trace(loadedType.typeof(ob));
			loadedType.getClass(ob);
		};
		//trace(path + ':' +oC);
		if (oC == null) throw("Object is not a class instance");
		var sC:Class<Dynamic> = (loadedType==null) ? Type.getSuperClass(oC) :
			loadedType.getSuperClass(oC);
		if (sC == null) return false;
		if (Type.getClassName(sC) == path) return true;
		return hasSuperClassPath(sC, path);
	}
	
}