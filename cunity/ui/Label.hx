/**
 *
 * @author ...
 */

package me.cunity.ui;

import flash.display.BlendMode;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import me.cunity.core.Application;
import me.cunity.text.Format;

class Label extends TextField
{
 
	public function new(cAtts:Dynamic) 
	{
		super();
		selectable = true;
		//blendMode = BlendMode.LAYER;
		antiAliasType = AntiAliasType.ADVANCED;
		gridFitType = GridFitType.PIXEL;
		if (cAtts.textField == null || cAtts.textField.autoSize == null ) autoSize = TextFieldAutoSize.LEFT;
		for (name in Reflect.fields(Format.textFieldTypes)) {
			var val:Dynamic = Reflect.field(cAtts.textField, name);
			if (val != null)
				Reflect.setField(this, name, Reflect.field(Format.textFieldTypes, name).apply(null, [val]));
		}
		if (cAtts.textFormat == null) {
			var tForm:TextFormat = defaultTextFormat;
			tForm.font = "Arial";
			tForm.bold = true;
			tForm.color = 0xffffff;
			embedFonts = false;
			defaultTextFormat = tForm;
		}
		else if (cAtts.styleSheet)
		{
			//embedFonts = true;
			styleSheet = cAtts.styleSheet;
			//trace(Std.string(styleSheet.getStyle('.menu')));
		}
		else
			//layoutRoot.textFormats.get(cAtts.textFormat)
			defaultTextFormat = Application.instance.textFormats.get(cAtts.textFormat);
		
		//trace(defaultTextFormat.font + ' embed:' + embedFonts);

		//trace(embedFonts + ':' + defaultTextFormat.font);
		//trace(Std.string(cAtts.textField));
		//trace(text +':' +width +' x ' + height + ' font:' + defaultTextFormat.font + ' embedFonts:' + embedFonts);
	}
	
}