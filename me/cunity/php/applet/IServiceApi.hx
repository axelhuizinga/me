package me.cunity.php.applet;

import haxe.ds.StringMap;
import me.cunity.php.applet.Types;

import haxe.PosInfos;
import haxe.xml.Fast;
/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */



interface IServiceApi 
{
	public var controller:App;
	public var action:String;
	public var output:String;
	public var param:StringMap<String>;
	public var root:String;
	public var server:StringMap<String>;
	public var serviceParam(default, null):ServiceParam;
	public var user:User;
	public var xconf:Fast;
	
	private function dispatch():Bool;
	public function debug(m:Dynamic, ?i:PosInfos):Void;

	public function init(sP:ServiceParam = null):Void;
	
}