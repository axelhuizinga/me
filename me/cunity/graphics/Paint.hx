/**
 *
 * @author ...
 */

package me.cunity.graphics;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.SpreadMethod;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Matrix;
import flash.net.URLRequest;

import me.cunity.ui.Container;
import me.cunity.data.Parse;

enum FillType {
	verticalGradient(p:Dynamic);
}

class Paint 
{
	public static function beginFill(g:Graphics, par:Dynamic)
	{
		var mat:Matrix = new Matrix();
		var fType:FillType = cast(par.fillType, FillType );
		switch(fType) {
			case verticalGradient(p):
			mat.createGradientBox(
				p.width,
				p.height,
				Math.PI/2,//TODO:change2linearGradient with default p.rotation == null ? 0 :p.rotation,
				0,
				0//p.top == null ? 0 :0
			);
			//trace(mat.toString());
		}
		g.beginGradientFill(par.type, par.colors, par.alphas, par.ratios, mat, 
			par.spreadMethod, par.interpolationMethod, par.focalPointRatio);		
	}
	
	public static  function drawRect(g:Graphics, par:Dynamic) {// required rect:Retangle, fillType:FillType, 
		beginFill(g, par);
		g.drawRect(par.left, par.top, par.width, par.height);
		//g.endFill();	
	}
}