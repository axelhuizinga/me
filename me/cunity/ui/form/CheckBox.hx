/**
 *
 * @author Axel Huizinga
 */

package me.cunity.ui;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
using me.cunity.tools.StringTool;

class CheckBox extends Sprite
{
	
	public var paddingX:Float;
	public var checkBox:Label;
	
	public function new(name:String, ?label:String) 
	{
		super();
		paddingX = 5;
		this.name = name;
		if (label == null)
			label = name.ucFirst();
		var labelT:Label =  new Label( { textField:{ text:label }} );
		//labelT.x = 5;
		addChild(labelT);
		var tForm:TextFormat = new TextFormat();
		tForm.bold = true;
		tForm.font = '_sans';
		tForm.leftMargin = tForm.rightMargin = 5;
		checkBox = new Label( { textField:{ 
			text:'x',	background:false,	textColor:0xffffff },
			textFormat:tForm } );
		//checkBox.addEventListener(FocusEvent.FOCUS_IN, switchState);
		checkBox.addEventListener(MouseEvent.CLICK, switchState,false,0,true);
		checkBox.name = name;
		checkBox.width = checkBox.width;
		checkBox.height = checkBox.height;
		checkBox.autoSize = TextFieldAutoSize.NONE;
		checkBox.x = paddingX + labelT.width;
		addChild(checkBox);
		var cRect:Rectangle = checkBox.getRect(this);
		graphics.beginFill(0x888888);
		graphics.drawRoundRect(cRect.x, cRect.y, cRect.width, cRect.height, 5);
		//checkBox.text = '';
	}
	
	function switchState(evt:MouseEvent) {
		if (evt.target.text == 'x')
		evt.target.text = ' ';
		else evt.target.text = 'x';
	}
	
	
}