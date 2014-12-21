/**
 *
 * @author ...
 */

package me.cunity.graphics;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;

class Mask extends Sprite
{
	var slide:Sprite;
	var _parent:Sprite;
	
	public function new(p:Sprite) 
	{
		super();
		_parent = p;
		_parent.addChild(this);
	}
	
	public function addSlide() {
		slide = new Sprite();
		addChild(slide);		
	}
	
	public function paint(gr:Graphics, bounds:Rectangle, form:String) {
		gr.clear();
		gr.beginFill(0);
		//alpha = 0.5;
		switch(form) {
		/*	case 'openCircle':
			var cX:Float = bounds.left + bounds.width / 2;
			var cY:Float = bounds.top + bounds.height / 2;
			var cR:Float = bounds.width > bounds.height ? 
			gr.drawCircle(cX, cY, cR);*/
			case 'wipeRect':
			gr.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);

		}
	}
	
}