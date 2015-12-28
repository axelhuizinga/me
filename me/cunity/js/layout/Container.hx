package me.cunity.js.layout;
//import jQuery.JQuery;
#if js
import jQuery.*;
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
import me.cunity.js.layout.Types;
import me.cunity.app.App;
using me.cunity.js.layout.Ext;
using Lambda;

class Container extends BaseCell
{

	public var dynaCells:Array<BaseCell>;
	
	var sameWidth:Bool;
	var sameHeight:Bool;
	var maxW:Float;
	var maxH:Float;
	var cW:Float;
	var cH:Float;	
	
	public function new(j:JQuery, p:Container = null) 
	{
		super(j, p);		
		isScreen = j.hasClass('screen');
		if (isScreen)
		{
			if (jQ.attr('id') == null)
				jQ.attr('id', 'screen_' +  App.ins.screens.length);
			App.ins.screens.push({id:jQ.attr('id'), container:this});
		}

		else if (jQ.attr('id') == null)
		{
			jQ.attr('id', parent.jQ.attr('id') + '_' + ~/.*\./.replace(Type.getClassName(Type.getClass(this)), '') + '_' + parent.cells.length);
		}
		
		if (jQ.hasClass('content'))
		{
			App.ins.contentBox = this;
		}
		
		//trace(j.attr('id') + ':' + Type.getClassName(Type.getClass(this)));
		//jQ.data('cell', this);
		addChildren();
	}
	
	public function addChildren()
	{
		jQ.children().each(function()
		{
			var jC:JQuery = JQuery.cur;
			if (jC.get()[0].nodeName != 'TBODY' && jC.get()[0].nodeName != 'CUFON')//SKIP TABLES FOR LAYOUT
				cells.push(BaseCell.create(jC, this));
		});		
	}
	
	public function clear()
	{
		cells = new Array();
		box = {};		
	}
	
	public function find(jq:JQuery):Container
	{
		var bc:Container = null;
		for (c in cells)
		{
			if (c.jQ == jq)
				return cast c;
		}
		
		for (c in cells)
		{
			if (Std.is(c, Container))
				bc = cast (c).find(jq);
			if (bc != null)
				return bc;
		}
		return bc;
	}
	
	public function setChildrenDims()
	{
		dynaCells = new Array();
		maxW = maxH  = cW = cH = 0;
		getMaxDims();
		//trace(jQ.attr('id') + ' cells.length:' + cells.length + ' maxContentBox.height:' + maxContentBox.height);
		//applyMargin(); TODO?
		
		var fixedSum:Int = 0;
		var c:BaseCell;
		for (c in cells) 
		{
			//c.layout();
			switch(c.sizing)
			{
				case FILL, VFILL:
					dynaCells.push(c);
				default:
					fixedSum += c.jQ.outerHeight(true);
					c.fixedHeight = true;
			}
			if(isScreen) trace('class:' + c.jQ.attr('class') + ' fixedSum:' + fixedSum);
		}
		if (isScreen) trace('cells:' + cells.length );
		
		var freeSpace:Int = Math.floor((fixedHeight ? jQ.innerHeight() - jQ.paddingHeight():maxContentBox.height)) - fixedSum;
		if (isScreen) trace('freeSpace:' + freeSpace + ' fixedSum:' + fixedSum + ' box:' + jQ.height());
		dynaCells.sort(bigFirst);
		var dcs:DynaCellSize = { cells:dynaCells, freeSpace:freeSpace };
		calcfillSize(dcs);
		var marginBorderPaddingSum = Lambda.fold(dcs.cells, function(a, b) {
			return a.jQ.marginHeight() + a.jQ.borderHeight() + a.jQ.paddingHeight()+ b;
		},0);
		freeSpace = Math.floor((dcs.freeSpace - marginBorderPaddingSum)  / Lambda.count(dcs.cells));		
		if(isScreen) trace('freeSpace:' + freeSpace + ' fixedSum:' + fixedSum + ' box:' + jQ.height());

		if(freeSpace>0) for (c in dcs.cells)
		{
			switch(c.sizing)
			{
				case FILL,VFILL:
					c.jQ.height(freeSpace);
					//if(isScreen) trace('c.jQ.height():' + c.jQ.height());
					if(c.jQ.attr('id') != null) trace(c.jQ.attr('id') +':' + 'c.jQ.height():' + c.jQ.height());
				default:
			}
		}
		//trace ('align:' + align);
		cH = Math.round(Lambda.fold(cells, function(a, b) {
			return a.jQ.outerHeight(true) + b;
		}, 0));
		if (align == MIDDLE)
		{
			cells[0].jQ.css( { marginTop:(maxContentBox.height - cH) / 2 + 'px'} );
		}		
		
		for (c in cells)
		{
			c.layout();
		}
	}	
	
	function calcfillSize(dcs:DynaCellSize):Void
	{
		var marginBorderPaddingSum = Math.ceil(Lambda.fold(dcs.cells, function(a, b) {
			return a.jQ.marginHeight() + a.jQ.borderHeight() + a.jQ.paddingHeight()+ b;
		},0));
		var freeSpace:Int = Math.floor((dcs.freeSpace - marginBorderPaddingSum)  / Lambda.count(dcs.cells));
		for (c in dcs.cells)
		{
			if (c.jQ.height() >= freeSpace )
			{
				dcs.cells.remove(c);
				dcs.freeSpace -= c.jQ.outerHeight(true);
				calcfillSize(dcs);
				break;
			}
		}		
	}
	
	public function bigFirst(a:BaseCell, b:BaseCell):Int
	{
		if (a.jQ.outerHeight(true) == b.jQ.outerHeight(true))
			return 0;
		return 
			a.jQ.outerHeight(true) > b.jQ.outerHeight(true) ? 1 :-1;
	}
	
	/*override public function getBox():Rect
	{
		super.getBox();
		switch(sizing)
		{
			case FILL, VFILL:
				//GET AVAILABLE SPACE
				var usedSpace:Int = Math.ceil(Lambda.fold(parent.cells, function(a, b) {
					return (a.fixedHeight ? a.jQ.outerHeight(true) + b:b);
				},0));
				var freeSpace:Int = Math.floor(parent.jQ.height() - usedSpace - (parent.jQ.paddingHeight() * (parent.cells.length + 1)));
				box.height = freeSpace;
			default:				
		}
		return box;
	}*/

	override public function getMaxDims():Void
	{//	GET AVAILABLE PARENT DIMS
		super.getMaxDims();
		//trace(jQ.attr('id') + ':' + maxContentBox);
		if(!isScreen) switch(sizing)
		{
			case FILL, VFILL:
				//GET AVAILABLE SPACE
				var usedSpace:Int = Math.ceil(Lambda.fold(parent.cells, function(a, b) {
					return (a.fixedHeight ? a.jQ.outerHeight(true) + b:b);
				},0));
				var freeSpace:Int = Math.floor(parent.jQ.height() - usedSpace - (parent.jQ.paddingHeight() * (parent.cells.length + 1)));
				maxContentBox.height = freeSpace;
			default:
				//ALL FINE
		}
		
		//trace(jQ.attr('id') + ':' + maxContentBox);
	}	
	
	override public function layout():Void
	{		
		setChildrenDims();
	}
}