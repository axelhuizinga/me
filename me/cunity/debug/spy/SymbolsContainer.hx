/**
 *
 * @author Axel Huizinga
 */

package debug.spy;
import debug.Spy;
import flash.display.Sprite;
import flash.xml.XMLDocument;
import me.cunity.tools.ArrayTools;

//class SymbolsContainer extends Sprite
class SymbolsContainer 
{

	var symbols:Array<DisplaySymbol>;
	var symTree:XMLDocument;


	public function new() 
	{
		symbols = new Array();		
	}
	
	public function reset() {
		symbols = new Array();
	}
	
	public function addSymbol(dS:DisplaySymbol) {
		symbols.push(dS);
	}
	
	function createTree() {
		//var children:Map<DisplaySymbol> = Spy.rootSymbol.children;
		var currentSymbol:DisplaySymbol = Spy.rootSymbol;
		var currentPath:String = currentSymbol.labelText;
		for (key in currentSymbol.children.keys()) {
			Reflect.setField(treeBranch, key, currentSymbol.children.get(key));
		}
		
	}
		
	
}