/**
 *
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

package me.cunity.layout;
import flash.geom.Point;
import flash.geom.Rectangle;
import me.cunity.tools.FlashTools;
import me.cunity.ui.BaseCell;

class Position 
{

	public static function get(info:Array<String>, dS:BaseCell):Point{
		//var p:Pos = { x:.0, y:.0 };
		//trace(info.toString() + ':' + dS.name + ':'  +dS.layoutRoot.name);
		var key:String = info.pop();
		var relBox:Rectangle =  (info[0] == 'self') ? dS.getBounds(dS.layoutRoot) :
			//FlashTools.numTarget(info, dS.layoutRoot).box;
			FlashTools.numTarget(info, dS.layoutRoot.contentView).box;
		//trace(relBox.toString());
		return switch(key) {
			case 'TL':
			relBox.topLeft.add(new Point(dS.width/2, dS.height/2));
			case 'TR':
			new Point(relBox.right - dS.width/2, relBox.top + dS.height/2);
			case 'BR':
			relBox.bottomRight.subtract(new Point(dS.width/2, dS.height/2));
			case 'BL':
			new Point(relBox.left + dS.width/2, relBox.bottom - dS.height/2);
			case 'C':
			new Point(relBox.left + relBox.width / 2, relBox.top + relBox.height / 2);	
			default://Center
			new Point(relBox.left + relBox.width / 2, relBox.top + relBox.height / 2);			
		}
		
	}
	
}