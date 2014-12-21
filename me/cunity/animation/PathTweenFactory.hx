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
import flash.display.Shape;
import flash.geom.Point;
import flash.xml.XML;
import flash.xml.XMLList;
import me.cunity.animation.geometry.BezierQ;
//import me.cunity.animation.geometry.Circle;
//import me.cunity.animation.geometry.Hermite;
import me.cunity.layout.Position;
import singularity.numeric.Consts;
//import me.cunity.animation.geometry.IPath2D;
import me.cunity.debug.Out;
import singularity.geom.Parametric;

import me.cunity.ui.BaseCell;


class PathTweenFactory 
{
	
	public static function create(xN:XML, baseCell:BaseCell):FastTween
	{
		//var baseCell = dS;
		//var duration = xN.attribute('duration').toString() == '' ? baseCell.layoutRoot.timeLine.duration:
		var duration = xN.attribute('duration').toString() == '' ? baseCell._parent.timeLine.duration:
			Std.parseInt(xN.attribute('duration').toString());	
		var segments:XMLList = xN.children();
		var path:Parametric = null;
		var paths:Array<Parametric> = new Array();
		//var debugS:Shape = new Shape();
		//baseCell.layoutRoot.addChild(debugS);
		baseCell.refPoint = getRefPoint(segments, baseCell);
		//trace(Std.string(baseCell.refPoint));
		for (s in 0...segments.length()) 
		{
			//paths.push(
				switch(segments[s].name()) {
					case 'BezierQ':
					paths.push(new BezierQ(segments[s], baseCell));
					//paths[paths.length - 1].setContainer(debugS);
					paths[paths.length - 1].parameterize = Consts.ARC_LENGTH;
					/*case 'Circle':
					paths.push(Circle.create(segments[s], baseCell));
					case 'Hermite':
					paths.push(Hermite.create(segments[s], baseCell));		*/			
				}
			//);
		}
		if (paths.length == 1){
			path = paths[0];
			path.draw(1);	
			//trace('rendered path:' + path + ' 2:' + baseCell);
			//Out.dumpLayout(baseCell);
		}
		/*else{
			path = new ComplexPath2D(paths);
			for (p in paths)
				p.render(baseCell.graphics);	
		}*/
		
		var start:UInt = 	xN.attribute('start').toString() == '' ? 0:
			Std.parseInt(xN.attribute('start').toString());
		var trans:Dynamic = xN.attribute('transition').toString() == '' ? Transition.linear :
			Reflect.field(Transition, xN.attribute('transition').toString());
		return FastTween.add(baseCell, duration, {path:path}, trans, start);
		//return FastTween.add(baseCell, path, duration, 0, new TransitionCurve(Transition.backOut));
	}
	
	static function getRefPoint(segments:XMLList, baseCell:BaseCell):Dynamic {
		for (s in 0...segments.length()) 
		{
			if (segments[s].toXMLString().indexOf('self') > -1) {
				var atts:XMLList = segments[s].attributes();
				for (a in 0...atts.length()) {
					if (atts[a].toString().indexOf('self') > -1) {
						var pT:Point = Position.get(atts[a].toString().split('_'), baseCell);
						return { x:pT.x - baseCell.x, y:pT.y - baseCell.y };
					}
				}
			}
		}
		return {x:0, y:0};
	}
	
}