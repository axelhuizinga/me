/**
 *
 * @author ...
 */

package me.cunity.text;
import flash.system.Capabilities;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.xml.XML;
import me.cunity.data.Parse;


class Format 
{
	
	public static var ref:Dynamic;
	public static var tField:TextField;
	
	public static function applyTextFieldTypes(tF:TextField, p:Dynamic, keys:Array<String> = null)
	{
		var fieldNames = keys == null ? Reflect.fields(textFieldTypes) :keys;
		//trace(fieldNames);
		try
		{
			for (f in fieldNames)
				Reflect.setField(tF, f, Reflect.field(textFieldTypes, f)(Reflect.field(p, f)));		
		}
		catch (ex:Dynamic)
		{
			trace(ex);
		}

	}

	public static function createFormat(fArgs:Dynamic, p:Dynamic )
	{
		trace(Std.string(fArgs) + Std.string(p));
		fArgs.textFormat = new TextFormat();
		for (name in Reflect.fields(textFormatTypes))
		{
			var val:Dynamic = Reflect.field(textFormatTypes, name).apply(null, [Reflect.field(p, name)]);
			if(val != null)
				Reflect.setField(fArgs.textFormat, name, val);
			//trace(name + ':' + Reflect.field(fArgs.textFormat, name));
		}
	}

	public static function setFormat(fArgs:Dynamic, p:Dynamic )
	{
		//trace(Std.string(fArgs));
		//trace(Std.string(p));
		tField = fArgs.textField;
		var aForm:TextFormat = new TextFormat();
		for (name in Reflect.fields(textFormatTypes))
		{
			var val:Dynamic = Reflect.field(textFormatTypes, name).apply(null, [Reflect.field(p, name)]);
			//trace(val +':' + Reflect.field(p, name));
			if(val != null)
				Reflect.setField(aForm, name, val);
				//Reflect.setField(fArgs.textField.defaultTextFormat, name, val);
			//trace(Reflect.field(aForm, name));
		}
		fArgs.textField.defaultTextFormat = aForm;
		//fArgs.textF
	}
	
	public static function initTextFormat(tF:TextFormat, p:Dynamic) :TextFormat
	{
		for (name in Reflect.fields(textFormatTypes))
		{
			var val:Dynamic = Reflect.field(textFormatTypes, name).apply(null, [Reflect.field(p, name)]);
			if(val != null)
				Reflect.setField(tF, name, val);
			//trace(name + ':' + Reflect.field(fArgs.textFormat, name));
		}
		return tF;
	}
	
	public static function getTextFieldArgs(p:XML ):Dynamic
	{
		var res:Dynamic = { };
		for (name in Reflect.fields(textFieldTypes))
		{
			if (p.attribute(name).length() == 0)
				continue;
			var val:Dynamic = Reflect.field(textFieldTypes, name).apply(null, [p.attribute(name).toString()]);
			//trace(name + ':' + val);
			if(val != null)
				Reflect.setField(res, name, val);
			//trace(Reflect.field(fArgs.textFormat, name));
		}
		return res;
	}
	
	public static function setTextFieldArgs(tF:TextField, p:XML )
	{
		tField = tF;
		//trace(Reflect.fields(textFieldTypes).join("\n"));
		for (name in Reflect.fields(textFieldTypes))
		{
			//trace(name);
			if (p.attribute(name).length() == 0)
				continue;
			//var val:Dynamic = Reflect.field(textFieldTypes, name).apply(null, [p.attribute(name).toString()]);
			var val:Dynamic = Reflect.field(textFieldTypes, name)(p.attribute(name).toString());
			//if(name=='backgroundColor')trace(name + ':' + val);
			if(val != null)
				Reflect.setField(tF, name, val);
			//trace(Reflect.field(fArgs.textFormat, name));
		}
	}
	
	public static function applyArgsToTextField(tF:TextField, args:Dynamic) 
	{
		for (name in Reflect.fields(args))
		{
			Reflect.setField(tF, name, Reflect.field(args, name));
		}
	}
	
	public static var textFieldTypes:Dynamic = {
		alpha:function(v)
		{
			return (v == '' ? 1.0 :Parse.att2Float(v));
		},
		antiAliasType:function(v) {
			return switch(v) {
				case 'ADVANCED':
				AntiAliasType.ADVANCED;
				case 'NORMAL':
				AntiAliasType.NORMAL;
				default:
				//AntiAliasType.NORMAL;
				AntiAliasType.ADVANCED;
			}
		},
		autoSize:function(v) {
			return switch(v) {
				case 'NONE':
				TextFieldAutoSize.NONE;
				case 'RIGHT':
				TextFieldAutoSize.RIGHT;
				case 'CENTER':
				TextFieldAutoSize.CENTER;
				case 'LEFT':
				TextFieldAutoSize.LEFT;				
				default:
				TextFieldAutoSize.LEFT;				
			}
		},
		background:Parse.att2Bool,
		backgroundColor:Parse.att2UInt,
		border:Parse.att2Bool,
		borderColor:Parse.att2UInt,
		displayAsPassword:Parse.att2Bool,
		embedFonts :Parse.att2Bool,
		//filters:function() { return []; } ,
		gridFitType:function(v) {
			return switch(v) {
				case 'PIXEL':
				GridFitType.PIXEL;
				case 'NONE':
				GridFitType.NONE;
				case 'SUBPIXEL':
				GridFitType.SUBPIXEL;
				default:
				GridFitType.PIXEL;
			}
		},
		/*height:function(v) { 
			var tW = tField.width;
			tField.autoSize = TextFieldAutoSize.NONE;
			tField.width = tW;
			if (~/%$/.match(v)) {// we want a size relative to the parent box
				return Std.parseFloat(v) / 100 * ref.height;
			}
			else
				return Parse.att2UInt(v);
		},*/
		mouseEnabled:Parse.att2Bool,
		multiline:function(v) {  return (v == '' || v == null) ? true :Parse.att2Bool(v); } ,
		name:function (v) { return (v == '') ? 'text_' + tField.parent.numChildren :v;},
		selectable:Parse.att2Bool,
		sharpness :function(v) { return (v == null) ? 0 :Std.parseFloat(v); } ,
		tabEnabled:function(v) { return (v == null) ? true :Parse.att2Bool(v); },
		//styleSheet:function (v) { return (v == '' ? null :v); },
		text :function (v) { return (v == null) ? '' :v; },
		//htmlText :function (v) { return (v == '') ? '' :v; },
		//textColor :Parse.att2UInt,
		//type:function(v) { return (v == null) ? TextFieldType.DYNAMIC :v;},
		type:function(v) { 
			return 	switch(v) {
				default:
				TextFieldType.DYNAMIC;
				case 'DYNAMIC':
				TextFieldType.DYNAMIC;
				case 'INPUT':
				TextFieldType.INPUT;
			}				
		},
		thickness :function(v) { return (v == null) ? 0 :Std.parseFloat(v); },	
		/*width:function(v) { 
			var tH = tField.height;
			//trace(tField + ':' + tH);
			tField.autoSize = TextFieldAutoSize.NONE;
			tField.height = tH;
			if (~/%$/.match(v)) {// we want a size relative to the parent box
				return Std.parseFloat(v) / 100 * ref.width;
			}
			else
				return Parse.att2UInt(v);
		},*/
		wordWrap:Parse.att2Bool,
		rotation:Parse.att2Float
	}
	
	public static var textFormatTypes:Dynamic = {
		align:function(v) {
			return switch(v) {
				case 'center':
				TextFormatAlign.CENTER;
				default:
				TextFormatAlign.LEFT;
			}
		},
		color:Parse.att2UInt,
		font:function (v) { return (v==null) ? 'Arial' :v; },
		leftMargin:function(v) { return (v == null) ? 3 :Std.parseInt(v);},
		rightMargin:function(v) { return (v == null) ? 3 :Std.parseInt(v);},
		size:Parse.att2UInt,
		bold:Parse.att2Bool
	}
	
}