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
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.text;

import flash.display.DisplayObject;
import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.Rectangle;
import flash.geom.Matrix;

class Metrics 
{

	public static function getFilterRect(dOb:DisplayObject, dF:BitmapFilter):Rectangle {
		var bData:BitmapData = new BitmapData(Std.int(dOb.width), Std.int(dOb.height));
		var mat:Matrix = new Matrix();
		//bData.draw(dOb, mat);
		bData.draw(dOb);
		var dBounds = dOb.getBounds(dOb.parent);
		trace(Std.string(dBounds));
		if(false){
		dBounds.x += 2;
		dBounds.y += 2;
		dBounds.width -= 4;
		dBounds.height -= 4;
		}
		trace(Std.string(dBounds));
		return	bData.generateFilterRect(dBounds, dF);
	}
	
}