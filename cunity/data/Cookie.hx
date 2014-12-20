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

package me.cunity.data;
#if flash
import flash.external.ExternalInterface;
#end
import Type;

class Cookie 
{
	
	//public static var cookies:Dynamic;
	public static var cookies:Array<Array<Dynamic>>;
	
	public static function isEnabled():Bool
	{
		#if flash
		return ExternalInterface.call("function(){ return EasyCookie.enabled}");
		#elseif php
		#elseif js
		return Type.typeof(untyped __js__("parent.EasyCookie")) != ValueType.TNull && EasyCookie.enabled;
		#end
	}
		
	public static function get(key:String):Dynamic
	{
		#if flash
		return ExternalInterface.call('EasyCookie.get', key );
		#elseif php
		#elseif js
		return EasyCookie.get(key);
		#end
	}
	
	public static function has(key:String):Bool 
	{
		#if flash
		return ExternalInterface.call('EasyCookie.has', key);
		#elseif php
		#elseif js
		return EasyCookie.has(key);
		#end
	}

	public static function remove(key):Dynamic 
	{
		#if flash
		return ExternalInterface.call('EasyCookie.remove', key);
		#elseif php
		#elseif js
		return EasyCookie.remove(key);
		#end
	}
	
	public static function set(cookie:Dynamic) :Void
	{
		#if flash
		ExternalInterface.call('setCookie', cookie );
		#elseif php
		#elseif js
		for(key in Reflect.fields(cookie))
			EasyCookie.set(key, Reflect.field(cookie, key));
		#end
	}
	
	public static function all():Array<Array<Dynamic>>
	{
		#if flash
		return  ExternalInterface.call('EasyCookie.all');
		#elseif php
		#elseif js
		return EasyCookie.all();
		#end
	}
	
}