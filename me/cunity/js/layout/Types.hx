package me.cunity.js.layout;
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

enum Alignment 
{
	BOTTOM;
	BOTTOM_LEFT;
	BOTTOM_RIGHT;
	CENTER;
	LEFT;
	MIDDLE;
	RIGHT;
	TOP;
	TOP_LEFT;
	TOP_RIGHT;
}

enum Orientation 
{
	H;//HORIZONTAL
	HSH;//HORIZONTAL SAME HIGHT
	V;//VERTICAL
	VSW;//VERTICAL SAME WIDTH
}

enum Sizing 
{
	NATIVE;
	FILL;
	HFILL;
	VFILL;
}

typedef Corners = { //CSS STYLE CLOCKWISE ORDER
	var TR:Int;
	var BR:Int;
	var BL:Int;
	var TL:Int;
	var method:String;
}

typedef Border = { //CSS STYLE CLOCKWISE ORDER
	@:optional var top:Int;
	@:optional var right:Int;
	@:optional var bottom:Int;
	@:optional var left:Int;
}

typedef Dims = 
{
	@:optional var height:Int;
	@:optional var width:Int;	
}

typedef Rect = 
{>Dims,
	@:optional var left:Int;
	@:optional var top:Int;
}

typedef DynaCell = 
{
	var cell:BaseCell;
	var dims:Dims;
}

typedef DynaCellSize = 
{
	var cells:Array<BaseCell>;
	var freeSpace:Int;
}

typedef DynaBox = 
{
	var cLen:Int;
	var freeSpace:Int;
}