package me.cunity.neko.ming;

class SWFMovieClip
{
	/***METHODS***/

	public function new():Void;
	public function add(object:SWFCharacter):Void;
	public function remove(object:SWFCharacter):Void;
	public function nextFrame():Void;
	public function labelFrame(label:String):Void;
	public function setFrames(number:Int):Void;
	public function startSound(startSound):Void;
	public function stopSound(startSound):Void;
	public function setScalingGrid(x:Int, y:Int, width:Int, height:Int):Void;
	public function removeScalingGrid():Void;
	public function setSoundStream(stream:SWFSoundStream):Void;
	public function addInitAction(action:SWFAction):Void;
}
