package me.cunity.neko.ming;

class SWFButton extends SWFCharacter
{
	/***METHODS***/

	public function new():Void;
	public function setHit(object:SWFCharacter):Void;
	public function setOver(object:SWFCharacter):Void;
	public function setUp(object:SWFCharacter):Void;
	public function setDown(object:SWFCharacter):Void;
	public function setAction(object:SWFAction):Void;
	public function addShape(object:SWFCharacter, flags:Int):Void;
	public function setMenu(flag:Int):Void;
	public function setScalingGrid(x:Int, y:Int, width:Int, height:Int):Void;
	public function removeScalingGrid():Void;
	public function addAction(object:SWFAction, flags:Int):Void;
	public function addSound(sound:SWFSound, flags:Int):Void;
	public function addCharacter(object SWFCharacter, flags int):Void;
}
