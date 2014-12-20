package me.cunity.neko.ming;
import neko.Sys;

class SWFSprite extends SWFCharacter
{
	
	private static var _new;
	private static var _add;
	private static var _nextFrame;
	private static var loaded:Bool = false;
	
	function init()
	{
		_new = Ming.load( "newSprite",0);
		_add = Ming.load( "spriteAdd", 2);
		_nextFrame = Ming.load( "spriteNextFrame", 1);		
		loaded = true;
	}
	
	/***METHODS***/

	public function new()
	{
		super();
		if (!loaded)
			init();
		if (_cName == 'SWFSprite')
		{
			//Ming.log('instanciate Sprite');
			_instance = _new();
		}
	}
	
	public function add(character:SWFCharacter):SWFDisplayItem
	{
		var di:SWFDisplayItem = new SWFDisplayItem();
		di._instance = _add(_instance, character._instance);
		return di;
	}
	
	public function remove(object:SWFCharacter):Void
	{
		
	}
	
	public function nextFrame():Void
	{
		_nextFrame(_instance);
	}
	
	/*
	public function labelFrame(label:String):Void;
	public function setFrames(number:Int):Void;
	public function startSound(sound:SWFSound ):Void;
	public function stopSound(sound:SWFSound):Void;
	public function setScalingGrid(x:Int, y:Int, width:Int, height:Int):Void;
	public function removeScalingGrid():Void;
	public function setSoundStream(stream:SWFSoundStream):Void;
	public function addInitAction(action:SWFAction):Void;
	*/
}
