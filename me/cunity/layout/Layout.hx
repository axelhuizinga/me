package me.cunity.layout;

/**
 * ...
 * @author axel@cunity.me
 */


typedef Corners = { //CSS STYLE CLOCKWISE ORDER
	var TR:Int;
	var BR:Int;
	var BL:Int;
	var TL:Int;
	var method:String;
}

typedef Border = { //CSS STYLE CLOCKWISE ORDER
	@:optional var top:Int;
	@:optional var right:Int;
	@:optional var bottom:Int;
	@:optional var left:Int;
}

typedef Dims = 
{
	@:optional var height:Float;
	@:optional var width:Float;	
}

typedef Rect = 
{>Dims,
	@:optional var left:Float;
	@:optional var top:Float;
}

typedef DynaCell = 
{
	var cell:BaseCell;
	var dims:Dims;
}

typedef DynaCellSize = 
{
	var cells:Array<BaseCell>;
	var freeSpace:Float;
}

typedef DynaBox = 
{
	var cLen:Int;
	var freeSpace:Float;
}