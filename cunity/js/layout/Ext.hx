package me.cunity.js.layout;
#if js
//import jQuery.JQuery;
import js.JQuery;
#end
/*
 *
 * @author axel@cunity.me
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

class Ext 
{

	static public function borderWidth(j:JQuery):Int 
	{
		//var bW:Int = 0;
		//trace('border-left-width' + j.css("border-left-width"));
		//if(j.css("border-left-width") != '')
		return 0 + Std.parseInt(j.css("border-left-width")) + Std.parseInt(j.css("border-right-width"));
	}
	
	static public function borderHeight(j:JQuery):Int 
	{
		return 0 + Std.parseInt(j.css("border-top-width")) + Std.parseInt(j.css("border-bottom-width"));
	}
	
	static public function marginWidth(j:JQuery):Int 
	{
		return 0 + Std.parseInt(j.css("margin-left")) + Std.parseInt(j.css("margin-right"));
	}
	
	static public function marginHeight(j:JQuery):Int 
	{
		return 0 + Std.parseInt(j.css("margin-top")) + Std.parseInt(j.css("margin-bottom"));
	}
	
	static public function paddingWidth(j:JQuery):Int 
	{
		return 0 + Std.parseInt(j.css("padding-left")) + Std.parseInt(j.css("padding-right"));
	}
	
	static public function paddingHeight(j:JQuery):Int 
	{
		return 0 + Std.parseInt(j.css("padding-top")) + Std.parseInt(j.css("padding-bottom"));
	}		
}
