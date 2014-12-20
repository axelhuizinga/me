/**
 * 
 * @author axel@cunity.me
 * 
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

package me.cunity.service;
#if php

import me.cunity.php.utils.BackTrace;
#end
import haxe.ds.StringMap;
import me.cunity.service.Auth;


class Response 
{
	public var method:String;
	//public var action:Array<Dynamic>;
	public var content:String;
	public var errorContent:String;
	public var redirectPath:String;
	public var hasError:Bool;
	public var intVals:StringMap<Int>;
	public var floatVals:StringMap<Float>;
	public var authStatus:AuthStatus;
	
	public function new() 
	{		
		authStatus = AuthStatus.Guest;
		#if php 
		method = BackTrace.caller();
		#end
		//action = new Array();
		//content = new Map();
		content = '';
		errorContent = redirectPath = '';
		//contentObj = { };
		hasError = false;
		intVals = new StringMap ();
		floatVals = new StringMap();		
	}	
}