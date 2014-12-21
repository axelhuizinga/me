/**
 *
 * @author Axel Huizinga
 */

package debug.spy;
import debug.spy.DisplaySymbol;
import flash.display.Shape;
import flash.geom.Point;

class RelationSet extends Shape
{
	
	var parentSymbol:DisplaySymbol;
	var childSymbols:Array<DisplaySymbol>;
	public static var relationColor:UInt = 0x008000;
	
	public function new(pSym:DisplaySymbol) 
	{
		super();
		childSymbols = new Array();
		this.parentSymbol = pSym;
	}
	
	public function addChildSymbols(child:DisplaySymbol) {
		childSymbols.push(child);
	}
	
	public function draw() {
		this.graphics.clear();
		this.graphics.lineStyle(0, relationColor);
		var parentAnchor:Point = parentSymbol.parentAnchorPoint;
		//trace(parentSymbol.parentSpyObject.name + ':' + Std.string(parentAnchor));
		for (symbol in childSymbols){
			this.graphics.moveTo(parentAnchor.x, parentAnchor.y);
			this.graphics.lineTo(symbol.childAnchorPoint.x, symbol.childAnchorPoint.y);
			//trace(Std.string(symbol.childAnchorPoint));
		}
		
	}
}