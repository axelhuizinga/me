/**
 *
 * @author Axel Huizinga
 */

package me.cunity.ui;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import me.cunity.ui.Label;
import me.cunity.tools.StringOp;

class UiGroup extends BaseCell
{
	public var type:String;
	public var inputs:Array<TextField>;
	public var cboxes:Array<TextField>;
	public var marginX(default, setMarginX):Float;
	public var marginY(default, setMarginY):Float;
	public var paddingX :Float;
	public var paddingY :Float;
	var aX:Float;
	var aY:Float;
	var iW:Float;
	var iH:Float;
	public var aHeight:Float;
	
	public function new(?title:String, ?names:Array<String>, ?defaults:Array<String>) 
	{
		super();
		inputs = new Array();
		cboxes = new Array();
		trace(title + ':' + Std.string(names));
		marginX = 5;
		marginY = 5;
		paddingX = 5;
		paddingY = 5;
		iW = 40; 
		if (title != null)
			setTitle(title);
		else
			iH = 20;
		if (names != null)
			addInputFields(names, defaults);
		trace(width + ' x ' + height);
	}
	
	public function addCheckBox(name:String, ?label:String ) {
		var checkBox = new CheckBox(name, label);
		cboxes.push(checkBox.checkBox);
		checkBox.x = aX;
		checkBox.y = aY;
		aY += checkBox.height + paddingY;
		addChild(checkBox);
	}
	
	public function addRadioGroup(name:String, title:String, labels:Array<String> ) {
		var checkBox = new RadioGroup(name, title, labels);
		cboxes.push(checkBox.checkBox);
		checkBox.x = aX;
		checkBox.y = aY;
		aY += checkBox.height + paddingY;
		addChild(checkBox);
	}
	
	public function addInputFields(names:Array < String >, defaults:Array<String> ) {
		var labels:Array<TextField> = new Array();
		var labelWidth:Float = 0;
		//this.names.concat(names);
		for (name in names) {
			//trace(StringOp.ucFirst(name));
			labels.push(new Label( {textField:{ text:StringOp.ucFirst(name) ,autoSize:TextFieldAutoSize.LEFT }}));			
			labels[labels.length - 1].x = aX;
			if (labels[labels.length - 1].width > labelWidth)
				labelWidth = labels[labels.length - 1].width;
		}
		var nI:Int = 0;
		for (name in names) {
			var aText:String = defaults != null ? defaults[nI] :'';
			var input:Label = new Label( {textField:{ 
				type:TextFieldType.INPUT,
				name:name,
				background:true,
				backgroundColor:0xffffff,
				autoSize:TextFieldAutoSize.NONE,
				width:iW,
				height:iH,
				text:aText
			} });
			addChild(labels[nI]);
			addChild(input);
			inputs.push(input);
			//trace(width + ' x ' + height);
			labels[nI].y = aY;
			labels[nI++].width = labelWidth;
			input.x = aX + paddingX + labelWidth;
			input.y = aY;
			aY += iH + paddingY;
			aHeight += iH + paddingY;
			//trace(aY);
		}
		aHeight += paddingY;
	}
	
	function setMarginX(mx:Float) {
		marginX = mx;
		aX = marginX * 2;
		return marginX;
	}
	
	function setMarginY(my:Float) {
		marginY = my;
		aHeight = aY = marginY * 2;
		return marginY;
	}
	
	public function setTitle(title:String) {
		var tForm:TextFormat = new TextFormat();
		tForm.bold = true;
		tForm.font = '_sans';
		if (type == null)
			type = title;
		var t:Label = new Label( {
			textField:{ text:StringOp.ucFirst(title), autoSize:TextFieldAutoSize.LEFT },
			textFormat:tForm} );
		addChild(t);
		t.x = aX;
		t.y = aY;
		t.defaultTextFormat.bold = true;
		aY += t.height + paddingY;
		iH = t.height; 
		aHeight += iH + paddingY;
		trace(width + ' x ' + height);
	}
	
	public function drawFrame(w:Float) {
		trace(aHeight);
		trace(width + ' x ' + height);
		/*graphics.beginFill(0xff0000, 0.1);
		graphics.drawRect(0, 0, w, aY + marginY);*/
		graphics.lineStyle(1, 0x888888);
		graphics.drawRoundRect(
			marginX, marginY, w - margin.left + margin.right, aY - 1 * marginY, marginX * 2);
		trace(width + ' x ' + height);
	}
	
}