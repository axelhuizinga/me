package me.cunity.js.layout;
/*
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

import me.cunity.js.layout.Types;

//import jQuery.JQuery;
#if js
import jQuery.*;
#end

using me.cunity.js.layout.Ext;

class BaseCell
{

	public var box:Rect;
	public var dynaLayout:Bool;
	//public var dynaCells:Array<DynaCell>;

	@:isVar public var maxContentBox(default, null):Rect;
	@:isVar public var align(default, set):Alignment;
	@:isVar public var sizing(default, set):Sizing;
	//@:isVar public var jQ(default, set):JQuery;
	@:isVar public var changed(default, set):Bool;
	//@:isVar public var parent(default, set):JQuery;

	public var cells(default, null):Array<BaseCell>;
	public var left(default, never):Float;
	public var top(default, never):Float;
	public var height(default, never):Float;
	public var width(default, never):Float;
	public var fixedHeight(default, null):Bool;
	public var fixedWidth(default, null):Bool;
	public var isScreen(default, null):Bool;
	public var orientation(default, null):Orientation;
	public var parent(default, null):Container;
	public var jQ(default, null):JQuery;
	
	var aRect:Rect;
	
	
	public function layout():Void
	{		
		
	}
	
	
	public function new(j:JQuery, p:Container = null) 
	{
		cells = new Array();
		jQ = j;
		box = {};
		//align = (j.attr('data-align') == null ? LEFT :Type.createEnum(Alignment, j.attr('data-align')));
		align = createAlign( j.attr('data-align'));
		//sizing = (j.attr('data-sizing') ==  null ? NATIVE :Type.createEnum(Sizing, j.attr('data-sizing')));
		sizing = createSizing(j.attr('data-sizing'));
		orientation = getOrientation(j.attr('data-orientation'));		
		parent = p;
	}
	
	/*public function add(cell:BaseCell)
	{
		cells.add(cell);
		if (cell.jQ.attr('id') == null)
			
	}*/
	
	public function remove(c:BaseCell):Bool
	{
		return cells.remove(c);
	}
	
	public function getBox():Rect
	{
		box = 
		{ 
			left:jQ.position().left,
			top:jQ.position().top,
			height:jQ.height(),
			width:jQ.width(),
		};
		return box;
	}
	
	public function getMaxDims():Void
	{//	GET AVAILABLE PARENT DIMS
		
		if (isScreen)
			trace('jQ.innerWidth()<=0:' + (jQ.innerWidth() <= 0?'Y':'N') + ' jQ.innerHeight():' + jQ.innerHeight() + '  jQ.paddingHeight():' + jQ.paddingHeight());
		maxContentBox = { 
			//width:jQ.innerWidth()<=0 ? jQ.parent().innerWidth() - jQ.parent().paddingWidth() - jQ.paddingWidth() :
			width:jQ.innerWidth() <= 0 ? 
				jQ.parent().innerWidth() - jQ.parent().paddingWidth() - jQ.paddingWidth() - jQ.borderWidth() - jQ.marginWidth():
				jQ.innerWidth() - jQ.paddingWidth(), 
			//height:jQ.innerHeight()<=0 ? jQ.parent().innerHeight() - jQ.parent().paddingHeight() - jQ.paddingHeight() :
			height:jQ.innerHeight() <= 0 ? 
				jQ.parent().innerHeight() - jQ.parent().paddingHeight() - jQ.paddingHeight() - jQ.borderHeight() - jQ.marginHeight():
				jQ.innerHeight() - jQ.paddingHeight()
		};
	}
	
	function set_align(a:Alignment):Alignment
	{
		return align = a;
	}
	
	function set_sizing(b:Sizing):Sizing
	{
		if(jQ.parent() != null) switch(b)
		{
			default:
		}
		return sizing = b;
	}
	
	function set_changed(l:Bool):Bool
	{		
		if(jQ.parent() != null) switch(align)
		{
			default:
				trace('oops');
				return false;
				
			case BOTTOM:
				trace('ok');
			case BOTTOM_LEFT:
				trace('ok');

			case BOTTOM_RIGHT:
				trace('ok');

			case LEFT:
				trace('ok');

			case MIDDLE:
				trace('ok');

			case RIGHT:
				trace('ok');

			case TOP:
				trace('ok');

			case TOP_LEFT:
				trace('ok');

			case TOP_RIGHT:				
				trace('ok');
		}
		return true;
	}
	
	static public function create(j:JQuery, p:Container):Container
	{
		return switch(j.attr('data-orientation'))
		{			
			case 'H','HSH':
				new Row(j, p);
			case 'V','VSW':
				new Column(j, p);
			default:
				new Column(j, p);
		}		
	}
	
	static public function createAlign(a:String):Alignment
	{
		return switch(a)
		{
			case 'BOTTOM':BOTTOM;
			case 'BOTTOM_LEFT':BOTTOM_LEFT;
			case 'BOTTOM_RIGHT':BOTTOM_RIGHT;
			case 'LEFT':LEFT;
			case 'MIDDLE':MIDDLE;
			case 'RIGHT':RIGHT;
			case 'TOP':TOP;
			case 'TOP_LEFT':TOP_LEFT;
			case 'TOP_RIGHT':TOP_RIGHT;
			default:LEFT;
		}
	}
	
	public function createSizing(a:String):Sizing
	{
		var p:Float = 0;
		
		if (a != null)
		{
			var env = a.split(';');
			a = env[0];
			p = Std.parseFloat(env[1]);
		}
		
		return switch(a)
		{	
			case 'NATIVE':NATIVE;
			/*case 'FIXED':FIXED(p);
			case 'HFIXED':HFIXED(p);
			case 'VFIXED':VFIXED(p);
			case 'PERCENT':PERCENT(p);
			case 'HPERCENT':HPERCENT(p);
			case 'VPERCENT':VPERCENT(p);*/
			case 'FILL':FILL;
			case 'HFILL':HFILL;
			case 'VFILL':VFILL;
			default:NATIVE;
		}
	}
	
	public function getOrientation(a:String):Orientation
	{
		return switch(a)
		{				
			case 'H':
				H;
			case 'HSH':
				HSH;
			case 'V':
				V;
			case 'VSW':
				VSW;				
			default:
				V;
		}
	}
}