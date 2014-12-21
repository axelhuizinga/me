package me.cunity.animation;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

import flash.xml.XML;
import me.cunity.ui.BaseCell;


typedef BCTween = {
	var bC:BaseCell;
	var xNode:XML;
}

typedef DynaTween = { 
	> BCTween,
	var starter:Dynamic;
}	

typedef CompositeTween =
{
	> BCTween,
	var begin:Dynamic;
	var end:Dynamic;
	var initial:Dynamic;
}

