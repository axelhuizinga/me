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
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.xml.XML;
import me.cunity.debug.Out;
import me.cunity.effects.STween;
import me.cunity.geom.Rotate;
import me.cunity.core.Application;
import me.cunity.tools.FlashTools;
import me.cunity.tools.MathTools;
import me.cunity.ui.BaseCell;

class LookAtMouse extends EventDispatcher
{
	var dSprite:BaseCell;
	var cX:Float;
	var cY:Float;
	var dLeft:Float;
	var dRight:Float;
	var maxY:Float;
	var minY:Float;

	var center:Point;
	var xNode:XML;
	var deltaAngle:Float;
	var lastX:Int;
	var resetTween:STween;
	
	public function new(xN:XML, dyO:BaseCell) 
	{
		super();
		dSprite = dyO;
		xNode = xN;
		//trace(dSprite.layoutRoot);
		dSprite.layoutRoot.initObjects.push(this);
	}
	
	public function init(){
		deltaAngle = (xNode.attribute('deltaAngle').length() == 1) ? 
		Std.parseFloat(xNode.attribute('deltaAngle').toString()) :10.0;
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, lookAt,false,0,true);
		dSprite.addEventListener(Event.REMOVED_FROM_STAGE, remove,false,0,true);
		var dBox:Rectangle = dSprite.getBounds(dSprite.layoutRoot);
		var iBox:Rectangle = FlashTools.numTarget(
			//xNode.attribute('box').toString().split('_'), dSprite.layoutRoot).box;
			xNode.attribute('box').toString().split('_'), dSprite.layoutRoot.contentView).box;
		trace(dSprite.diObj.getBounds(dSprite.diObj).toString() + ':' + dBox.toString());
		cX = dBox.x + dSprite.width/2;
		cY = dBox.y + dSprite.height / 2;
		dLeft = cX - iBox.x;
		dRight = iBox.x + iBox.width - cX;
		minY = iBox.y;
		maxY = iBox.y + iBox.height;
		//center = new Point(dSprite.width/2, dSprite.height/2);
		//center = new Point(cX, cY);
		lastX = Std.int(cX);
	}
	
	function crossMark(g:Graphics, p:Point, r:Float) {
		g.lineStyle(0.5, 0x8000ff);
		g.drawCircle(p.x, p.y, r);
		g.moveTo(p.x - r, p.y);
		g.lineTo(p.x + r, p.y);
		g.moveTo(p.x, p.y - r);
		g.lineTo(p.x, p.y + r);
	}
	
	function lookAt(evt:MouseEvent) {
		//trace(evt.stageX + ' x ' + evt.localY);
		//trace((Application.instance.menu != null && 	Application.instance.menu.container2hide.head != null));
		if (Application.instance.menu != null && 
			!Application.instance.menu.container2hide.isEmpty())
			//Application.instance.menu.container2hide.keys().length > 0)
			return;
		/*if (evt.stageY > maxY || evt.stageY < minY) {
			
			return;
		}*/
		//trace(minY + '<' + evt.stageY + '>' + maxY  );
		var angle:Float = 0.0;
		if (lastX == Std.int(evt.stageX))
			return;
		lastX = Std.int(evt.stageX);
		var dist = evt.stageX - cX;
		if (dist > dRight || dist < - dLeft || evt.stageY > maxY || evt.stageY < minY) {
			if (resetTween != null)
				STween.removeTween(resetTween);
			resetTween = STween.add(dSprite.diObj, 0.5, { rotation:0.0 } );
			return;
		}
		//if (cX < evt.stageX) {
		if (dist > 0) {
			angle = 90 * dist / dRight;
			//trace(evt.stageX +' a:' +Std.int(angle) + ' d:' + dist + ':' +  MathTools.round2(dist / dRight));
		}
		else {
			angle = 90 * dist / dLeft;
			//trace(evt.stageX +' a:' +Std.int(angle) + ' d:' + dist +':' + Std.int(dist / dLeft));
		}
		//trace(angle);
		if (Math.abs( angle - dSprite.diObj.rotation) > deltaAngle) {
			if (resetTween != null)
				STween.removeTween(resetTween);
			resetTween = STween.add(dSprite.diObj, 0.5, { rotation:angle } );
			return;
		}
		dSprite.diObj.rotation = angle;
	}
	
	function remove(evt:Event) {
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, lookAt, false);
		//dSprite.layoutRoot.removeEventListener(MouseEvent.MOUSE_MOVE, lookAt);
		dSprite.removeEventListener(Event.REMOVED_FROM_STAGE, remove, false);
		trace('wow');
		
	}
}