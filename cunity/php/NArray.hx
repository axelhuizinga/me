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

class NArray 
{


	public static function array(?init:Dynamic):Dynamic
	{
		var arr:Dynamic = untyped __php__('array()');
		if (init != null) {
			if (init.pop != null) {			
				for (i in 0...init.length) untyped __call__('array_push', arr, init[i]);
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
		return untyped __php__('
		function($arr, $x){
		for($i=0;$i<count($arr);$i++)
			if($arr[$i] === $x) {
				array_splice($arr, $i, 1);
				return true;
			}
		return false; }; '
		);
	}
	
	public static function toString(arr:Dynamic):String {
		var s:String = '[';
		untyped __php__("
		$s = count($arr).':[';
		for($i=0;$i<count($arr);$i++)
			$s .= $arr[$i]. ',';
		$s = substr($s, 0, strlen($s) - 1) + ']'; "
		);
		return s;
	}
/*
	function removeAt($pos) {
		if(array_key_exists($pos, $this->)) {
			unset($this->[$pos]);
			$this->length--;
			return true;
		} else
			return false;
	}

	function reverse() {
		$this-> = array_reverse($this->, false);
	}

	function shift() {
		$r = array_shift($this->);
		$this->length = count($this->);
		return $r;
	}

	function slice($pos, $end) {
		if($end == null)
			return new _hx_array(array_slice($this->, $pos));
		else
			return new _hx_array(array_slice($this->, $pos, $end-$pos));
	}

	function sort($f) {
		usort($this->, $f);
	}

	function splice($pos, $len) {
		if($len < 0) $len = 0;
		$nh = new _hx_array(array_splice($this->, $pos, $len));
		$this->length = count($this->);
		return $nh;
	}

	function toString() {
		return '['.implode($this->, ', ').']';
	}

	function __toString() {
		return $this->toString();
	}

	function unshift($x) {
		array_unshift($this->, $x);
		$this->length++;
	}

	// ArrayAccess methods:
	function offsetExists($offset) {
		return isset($this->[$offset]);
	}

	function offsetGet($offset) {
		if(isset($this->[$offset])) return $this->[$offset];
		return null;
	}

	function offsetSet($offset, $value) {
		if($this->length <= $offset) {
			$this-> = array_merge($this->, array_fill(0, $offset+1-$this->length, null));
			$this->length = $offset+1;
		}
		return $this->[$offset] = $value;
	}

	function offsetUnset($offset) {
		return $this->removeAt($offset);
	}*/

}