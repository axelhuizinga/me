/**
 *
 * @author ...
 */

package me.cunity.ui;
import flash.display.Sprite;
import flash.geom.Rectangle;

class EasyRect 
{

	public static function addRectClip(parent:Sprite, bounds:Rectangle, c:Int){
          var clip:Sprite = new Sprite();
          clip.graphics.beginFill(c);
         // clip.graphics.lineStyle(0, c);
          clip.graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
          var dOb = parent.addChild(clip);
          //trace('added rect:' + Std.string(bounds) + ' color:' + c + ' to:' + parent.name + ' at:' + parent.getChildIndex(dOb)) ;
          return clip;
     }
	
}