package me.cunity.js.layout;
import js.JQuery;
import js.Lib;
import me.cunity.debug.Out;
import me.cunity.js.layout.Types;

using me.cunity.js.layout.Ext;

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
class Row extends Container
{

	public function new(j:JQuery, p:Container = null) 
	{
		super(j, p);
		sameHeight = orientation == HSH;	
	}
	

	override public function setChildrenDims()
	{
		dynaCells = new Array();
		maxW = maxH  = cW = cH = 0;
		getMaxDims();
		//useFreeSpace();
		if(jQ.attr('id') != null)
		//trace(jQ.attr('id') + ' cells.length:' + cells.length + ' maxContentBox:' + maxContentBox);
		if (cells.length == 0)
			return;

		maxH = Math.ceil(Lambda.fold(cells, function(a, b)
		{
			return a.jQ.outerHeight(true) > b ? a.jQ.outerHeight(true):b;
		},0));
		
		var usedSpace:Int = 0;//hold occupied width from NATIVE, FIXED, HFIXED, PERCENT, HPERCENT Sizing
		var startX:Int = cells[0].jQ.position().left;
		var rowCells:Array<BaseCell> = new Array();
		var aX:Int = 0;
		var row:Int = 0;
		var dcs:DynaCellSize = null;
		var freeSpace:Int = 0;
		trace('fixedWidth:' + fixedWidth + ' sameHeight:' + sameHeight + ' maxH:' + maxH);
		var c:BaseCell;
		//if (sameHeight) 
		for (c in cells) 
		{
			//c.getMaxDims();
			if ( true)
				trace(c.jQ.attr('id') + 'allsigns' + c.jQ.height() + ' maxH:' + maxH  );	
			//if(c.jQ.height()<=maxH)
			//c.jQ.height(maxH - c.jQ.marginHeight() - c.jQ.borderHeight() - c.jQ.paddingHeight());
			//trace (c.jQ.attr('id') + ' ci:' + Lambda.indexOf(cells, c) + ' aX:' + aX +' > 0 && c.jQ.position().left:' + c.jQ.position().left + ' == ' + startX + ' c.jQ.outerWidth:' + c.jQ.outerWidth(true) + ' c.jQ.height():' + c.jQ.height());
			if (aX > 0 && c.jQ.position().left == startX)
			{
				//omg - row is wrapped
				layoutRow(dcs = { cells:rowCells, freeSpace:Math.floor((fixedWidth? jQ.innerWidth() - jQ.paddingWidth() :maxContentBox.width )) - usedSpace } );
				aX = 0;
				rowCells = new Array();
				usedSpace = 0;
			}
			rowCells.push(c);
			aX++;
			
			switch(c.sizing)
			{
				case FILL, HFILL:
					//DO NOTHING;
				default:
					usedSpace += c.jQ.outerWidth(true);
					c.fixedWidth = true;
			}			
			//c.jQ.height(maxH - c.jQ.marginHeight() - c.jQ.borderHeight() - c.jQ.paddingHeight());
			//Out.dumpLayout(c.jQ.get()[0]);
		}
		
		var dcs:DynaCellSize = { cells:rowCells, freeSpace:(fixedWidth? jQ.innerWidth() - jQ.paddingWidth()  :maxContentBox.width ) - usedSpace };
		trace('freeSpace:' + dcs.freeSpace + ':' + dcs.cells.length + ' maxContentBox.width:' + maxContentBox.width + ' align:' + align);
		layoutRow(dcs);
		//trace('freeSpace:' + dcs.freeSpace + ':' + dcs.cells.length);
		
		//trace('jQ.outerHeight:' + jQ.outerHeight());
		
		for (c in cells)
		{
			if (rowCells.length == cells.length && c.sizing == FILL)
			{
				c.jQ.height(maxContentBox.height - c.jQ.marginHeight() - c.jQ.borderHeight() - c.jQ.paddingHeight());
			}
			c.layout();
		}
	}
	
	function layoutRow(dcs:DynaCellSize):Void
	{
		//Lambda.iter(dcs.cells, function(c) { c.jQ.removeAttr('style'); } );//RESET HEIGHT
		var maxH:Int = Math.ceil(Lambda.fold(dcs.cells, function(a, b) {
			return a.jQ.outerHeight(true) > b ? a.jQ.outerHeight(true) :b;
		}, 0));
		dynaCells = new Array();
		var rowCells:Array<BaseCell> = dcs.cells;
		var usedSpace:Int = 0;
		trace ('dcs.cells:' + dcs.cells.length + ' maxH:' + maxH + ' dcs.freeSpace:' + dcs.freeSpace);
		var c:BaseCell = null;
		for (c in dcs.cells)
		{
			switch(c.sizing)
			{
				case FILL, HFILL:
					dynaCells.push(c);
					c.dynaLayout = true;
				default:
					usedSpace += c.jQ.outerWidth(true);						
			}	
			if(sameHeight)
				c.jQ.height(maxH - c.jQ.marginHeight() - c.jQ.borderHeight() - c.jQ.paddingHeight());	
	
		}
		
		dynaCells.sort(bigFirst);
		dcs = { cells:dynaCells, freeSpace:(fixedWidth? jQ.innerWidth() - jQ.paddingWidth() :maxContentBox.width ) - usedSpace };
		calcfillSize(dcs);
		var marginBorderPaddingSum = Math.ceil(Lambda.fold(dcs.cells, function(a, b) {
			return a.jQ.marginWidth() + a.jQ.borderWidth() + a.jQ.paddingWidth()+ b;
		},0));
		var freeCellSpace:Int = Math.floor((dcs.freeSpace - marginBorderPaddingSum)  / Lambda.count(dcs.cells));
		trace(dcs.freeSpace + ' > 0) for (c in dcs.cells):' +  dcs.cells.length + ' marginBorderPaddingSum:' + marginBorderPaddingSum);
		
		if(dcs.freeSpace > 0) for (c in dcs.cells)
		{
			switch(c.sizing)
			{
				case FILL, HFILL:
					
					trace('ci:' + Lambda.indexOf(cells, c) + ':' + freeCellSpace +  ' => ' + c.jQ.width() + ':' + c.jQ.outerWidth() + ':' + c.jQ.outerWidth(true));
					c.jQ.width(freeCellSpace);
					trace(freeCellSpace +  ' => ' + c.jQ.width() + ':' + c.jQ.outerWidth() + ':' + c.jQ.outerWidth(true));
				default:
			}
			//c.layout();
		}	

		for (c in cells)
		{
			/*switch(align)
			{
				case MIDDLE, CENTER:
					c.jQ.css( { marginLeft:
			}
			trace(c.jQ.attr('id') + (maxContentBox.height - c.jQ.outerHeight()) / 2 );
			c.jQ.css( { marginTop:(maxContentBox.height - c.jQ.outerHeight()) / 2 + 'px'} );*/
		}
	}
	
	override public function bigFirst(a:BaseCell, b:BaseCell):Int
	{
		if (a.jQ.outerWidth(true) == b.jQ.outerWidth(true))
			return 0;
		return 
			a.jQ.outerWidth(true) > b.jQ.outerWidth(true) ? 1 :-1;
	}	
	
	override function calcfillSize(dcs:DynaCellSize):Void
	{
		var marginBorderPaddingSum = Math.round(Lambda.fold(dcs.cells, function(a, b) {
			return a.jQ.marginWidth() + a.jQ.borderWidth() + a.jQ.paddingWidth() + b;
		},0));
		//var freeCellSpace:Int = Math.round((dcs.freeSpace - marginBorderPaddingSum)  / Lambda.count(dcs.cells));
		var freeCellSpace:Int = Math.round(dcs.freeSpace / Lambda.count(dcs.cells));
		trace ('dcs.cells.length:' + dcs.cells.length + ' freeCellSpace:' + freeCellSpace + ' marginBorderPaddingSum:' + marginBorderPaddingSum);
		var c:BaseCell;
		for (c in dcs.cells)
		{
			//if (c.jQ.width() >= freeCellSpace )
			if (c.jQ.outerWidth(true) >= freeCellSpace )
			{
				trace(c.jQ.attr('id') + ' removing:' + c.jQ.width() + '/' + c.jQ.outerWidth(true) +  ' >= ' + freeCellSpace );
				//throw('oops');
				dcs.cells.remove(c);
				if(cells.length>0)//TODO - UNDERSTAND THIS
				c.dynaLayout = false;
				dcs.freeSpace -= c.jQ.outerWidth(true);
				calcfillSize(dcs);
				//break;
			}
		}		
	}
	
	override public function getMaxDims():Void
	{
		super.getMaxDims();
		trace(jQ.attr('id') + ':' + maxContentBox);

	}
	
}