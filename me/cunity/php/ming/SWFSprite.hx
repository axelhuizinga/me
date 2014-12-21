package me.cunity.php.ming;
import me.cunity.php.classes.ReflectionClass;

class SWFSprite extends SWFCharacter
{
	
	/***METHODS***/

	public function new()
	{
		super();
		if (_cName == 'SWFSprite')
		{
			Ming.log('instanciate Sprite');
			_instance = untyped __php__("new SWFSprite()");
		}
	}
	
	public function add(character:Dynamic):SWFDisplayItem
	{
		var di:SWFDisplayItem = new SWFDisplayItem();
		//di._instance = untyped __php__("$_instance->add($character->_instance);");
		di._instance = _instance.add(character._instance);
		Ming.log(new ReflectionClass(di._instance).getName() + ':' + new ReflectionClass(_instance).getName());
		return di;
	}
	
	public function remove(object:SWFCharacter):Void
	{
		
	}
	
	public function nextFrame():Void
	{
		//untyped __php__("$_instance->nextFrame();");
		_instance.nextFrame();
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
