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

package me.cunity.effects;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.xml.XML;
import me.cunity.ui.BaseCell;

class Effect extends BaseCell
{
	public var dSprite:BaseCell;

	public function new(xN:XML, p:BaseCell) 
	{
		dSprite = p;
		super(xN, p._parent);
	}
	
	public function init() {
		
	}
	
	public function start() {
		
	}
	
	function getRel(ref:String):BaseCell {
		var rel:Array < String > = ref.split('.');
		var relCount:Int = Std.parseInt(rel[1]);
		var dS:BaseCell = dSprite;
		//trace(relCount + ':' + dS.name);
		while (relCount-- > 0) {
			dS = dS._parent;	
			//trace(dS.name);
		}
		return dS;
	}
	
	public static function target(ref:Array<String>, root:BaseCell):BaseCell {
		try{
			var res:DisplayObjectContainer = cast(
				root.getChildAt(Std.parseInt(ref.shift())), DisplayObjectContainer);
			while (ref.length > 0)
				res = cast( res.getChildAt(Std.parseInt(ref.shift())), DisplayObjectContainer);
			return cast(res, BaseCell);
		}
		catch (ex:Dynamic) { return null;}
	}
	
}