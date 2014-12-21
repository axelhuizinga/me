/**
 *
 * @author Axel Huizinga
 */

package me.cunity.ui;
import flash.display.Sprite;
import flash.text.TextFieldAutoSize;
import flash.text.TextField;
import flash.text.TextFormat;

class HeadLabel extends Sprite
{

	public var label:TextField;
	
	public function new() 
	{
		super();
	}
	
	public function init(tF:TextFormat, style:Dynamic){
		label = new TextField();
		label.defaultTextFormat = tF;
		//label.background = true;
		label.autoSize = TextFieldAutoSize.LEFT;
		label.text = "Äg§";
		label.x = style.marginX;
		label.y = style.marginY;
		graphics.beginFill(style.backGroundColor);	
		//graphics.lineStyle(0, style.backGroundColor);*/
		//trace(Std.string(style));
		graphics.drawRoundRectComplex(0.5, 0.5, style.width - 1 , label.height + 2 * style.marginY,
			style.cornerRadius, style.cornerRadius, 0,0
		);
		label.text = "";
		addChild(label);
	}
	
}