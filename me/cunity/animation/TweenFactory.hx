/**
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.animation;
//import flash.display.Shape;
//import flash.geom.Point;
import flash.xml.XML;
import flash.xml.XMLList;
//import me.cunity.animation.geometry.BezierQ;
//import me.cunity.animation.geometry.Circle;
//import me.cunity.animation.geometry.Hermite;
//import me.cunity.layout.Position;
//import me.cunity.animation.geometry.IPath2D;
import me.cunity.debug.Out;
//import singularity.geom.Parametric;

import me.cunity.ui.BaseCell;


class TweenFactory 
{
	
	//static public function create(xN:XML, baseCell:BaseCell, tL:TimeLine):FastTween
	static public function create(xN:XML, baseCell:BaseCell):FastTween
	{
		var duration = xN.attribute('duration').toString() == '' ? baseCell._parent.timeLine.duration:
			Std.parseInt(xN.attribute('duration').toString());	
		var start:UInt = 	xN.attribute('start').toString() == '' ? 0:
			Std.parseInt(xN.attribute('start').toString());	
		var segments:XMLList = xN.children();
		var properties:Dynamic = { };
		for (s in 0...segments.length()) 
		{
			Reflect.setField(properties, segments[s].name(), segments[s].attribute('targetValue'));
			if (xN.attribute('onComplete').toString() != '' )
				Reflect.setField(
					properties, 'onComplete', Reflect.field(baseCell._parent.timeLine, xN.attribute('onComplete').toString())
					//properties, 'onComplete', Reflect.field(tL, xN.attribute('onComplete').toString())
				);
			if (xN.attribute('onUpdate').toString() != '' )
				Reflect.setField(
					properties, 'onUpdate', Reflect.field(baseCell._parent.timeLine, xN.attribute('onUpdate').toString())
					//properties, 'onComplete', Reflect.field(tL, xN.attribute('onComplete').toString())
				);
		}
		//trace(Std.string(properties));
	var trans:Dynamic = xN.attribute('transition').toString() == '' ? Transition.linear :
			Reflect.field(Transition, xN.attribute('transition').toString());		
		return FastTween.add(baseCell, duration, properties, trans, start);
	}
	
}