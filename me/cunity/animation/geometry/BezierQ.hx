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

package me.cunity.animation.geometry;

import flash.display.Graphics;
import flash.geom.Point;
import flash.xml.XML;
import me.cunity.layout.Position;
import me.cunity.ui.BaseCell;
import singularity.geom.Bezier2;
import singularity.geom.Parametric;


class BezierQ extends Bezier2// implements IPath2D
{
	//var trans:Float->Float->Float->Float->Float;
	var refPoint:Dynamic;
	
	public function new(xN:XML, dSprite:BaseCell)
	{
		
		//trace(Position.get(xN.attribute('endPos').toString().split('_'), dSprite).toString());
		//var startPos:Point = Position.get(xN.attribute('startPos').toString().split('_'), dSprite);
		super();
		//var cPoints:Array<String> = ['startPos', 'ctrlPos', 'endPos'];
		refPoint = dSprite.refPoint;
		var pT:Point = Position.get(xN.attribute('startPos').toString().split('_'), dSprite);		
		//addControlPoint(pT.x , pT.y);
		addControlPoint(pT.x - refPoint.x, pT.y - refPoint.y);
		pT = Position.get(xN.attribute('ctrlPos').toString().split('_'), dSprite);
		//addControlPoint(pT.x, pT.y);		
		addControlPoint(pT.x - refPoint.x, pT.y - refPoint.y);
		pT = Position.get(xN.attribute('endPos').toString().split('_'), dSprite);
		//addControlPoint(pT.x, pT.y);
		addControlPoint(pT.x - refPoint.x, pT.y - refPoint.y);
		//dSprite = dSprite;
		/*var bez:QuadraticBezierPath2D = new QuadraticBezierPath2D(
			Position.get(xN.attribute('startPos').toString().split('_'), dSprite),
			Position.get(xN.attribute('ctrlPos').toString().split('_'), dSprite),
			Position.get(xN.attribute('endPos').toString().split('_'), dSprite),
			false
		);*/
		
		//return bez;
	}
	
	/*override public function getPos(t:Float, d:Int):Pos {
		var p:Pos = super.getPos(t);
		var f:Float = trans();
		return p;
	}*/
	public override function draw(_t:Float):Void
    {
      if( _t == 0 || __container == null )
        return;

      var g:Graphics = __container.graphics;
      g.lineStyle(__thickness, __color);

      if( _t >= 1 )
      {
        //g.moveTo(__p0X, __p0Y);
        //g.curveTo( __p1X, __p1Y, __p2X, __p2Y );
        g.moveTo(__p0X + refPoint.x, __p0Y + refPoint.y);
        g.curveTo( __p1X + refPoint.x, __p1Y + refPoint.y, __p2X + refPoint.x, __p2Y + refPoint.y );
      }
      else if( _t <= 0 )
        g.clear();
      else
	  {
        __subdivide(_t);
	  
	    // plot only segment from 0 to _t
	    g.moveTo(__p0X, __p0Y);
        g.curveTo( __cX, __cY, __pX, __pY );
	  }
    }
	
}