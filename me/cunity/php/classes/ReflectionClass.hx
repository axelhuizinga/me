package me.cunity.php.classes;

extern class ReflectionClass
{
	/***CONSTANTS***/

	public static inline var IS_IMPLICIT_ABSTRACT = 16;
	public static inline var IS_EXPLICIT_ABSTRACT = 32;
	public static inline var IS_FINAL = 64;

	/***METHODS***/

	function __clone():Void;
	function export(argument:Dynamic, ?returns:Bool):Void;
	function new(argument:Dynamic):Void;
	function __toString():Void;
	function getName():Void;
	function isInternal():Void;
	function isUserDefined():Void;
	function isInstantiable():Void;
	function getFileName():Void;
	function getStartLine():Void;
	function getEndLine():Void;
	function getDocComment():Void;
	function getConstructor():Void;
	function hasMethod(name:Dynamic):Void;
	function getMethod(name:Dynamic):Void;
	function getMethods(?filter:Dynamic):Void;
	function hasProperty(name:Dynamic):Void;
	function getProperty(name:Dynamic):Void;
	function getProperties(?filter:Dynamic):Void;
	function hasConstant(name:Dynamic):Void;
	function getConstants():Void;
	function getConstant(name:Dynamic):Void;
	function getInterfaces():Void;
	function getInterfaceNames():Void;
	function isInterface():Void;
	function isAbstract():Void;
	function isFinal():Void;
	function getModifiers():Void;
	function isInstance(object:Dynamic):Void;
	function newInstance(args:Dynamic):Void;
	function newInstanceArgs(?args:Dynamic):Void;
	function getParentClass():Void;
	function isSubclassOf(cls:Dynamic):Void;
	function getStaticProperties():Void;
	function getStaticPropertyValue(name:Dynamic, ?deflt:Dynamic):Void;
	function setStaticPropertyValue(name:Dynamic, value:Dynamic):Void;
	function getDefaultProperties():Void;
	function isIterateable():Void;
	function implementsInterface(interf:Dynamic):Void;
	function getExtension():Void;
	function getExtensionName():Void;
	function inNamespace():Void;
	function getNamespaceName():Void;
	function getShortName():Void;

}
