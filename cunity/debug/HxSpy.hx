package debug;

import debug.Spy;

/**
 *
 * @author Axel Huizinga
 */

class HxSpy
{
	//var className:String;
	static var spyIndex:Int = -1;
	static var spy:Spy;
	static var layout:String = '<layout>
		<textformat
		color="0xffffff"
		font="Arial"
		size="10"
		leftMargin="1"
		rightMargin="1"		
	/>
	<textfield 	border="true" borderColor="0x600000" 
		background = "true"	backgroundColor = "0xccaaaa" />
	< / layout > ';
	//var swf2spy:DisplayObject;
	var obj2spy:Dynamic;
	
	
	static function spyObject(swf2spy:DisplayObject){
		if (spyIndex != -1)
			flash.Lib.current.removeChildAt(spyIndex);
		spy = new Spy(Lib.current, swf2spy, true, true, layout);
		spyIndex = flash.Lib.current.numChildren - 1;
		spy.draw();		
	}
	
}