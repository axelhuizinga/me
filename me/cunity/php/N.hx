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

package me.cunity.php;
//import php.Dynamic;

class N
{

	public static function array(?init:Dynamic) :Dynamic
	{
		var arr:Dynamic = untyped __php__('array()');
		if (init != null) {
			if (untyped __call__('is_array', init)) {			
				untyped __php__('foreach($init as $el)array_push($arr, $el)');
			}			
			else
				untyped __call__('array_push', arr, init);
		}
		return arr;
	}
	
	public static function push(arr:Dynamic, els:Dynamic):Int {
		if (els.pop != null) {			
				for (i in 0...els.length) untyped __call__('array_push', arr, els[i]);
			}			
		else
			untyped __call__('array_push', arr, els);
		return untyped __php__('count($arr)');
	}
	
	public static function remove( arr:Dynamic, x :Dynamic ) :Bool {
		var a:Array<Dynamic> = cast arr;
		return a.remove(x);
	}
	
}