package me.cunity.js;
//import jQuery.JQuery;
import jQuery.*;
import js.html.*;
import js.Lib;
import me.cunity.debug.Out;

import me.cunity.js.layout.Types;
import me.cunity.js.layout.*;

class Layout 
{

	static var root:Container;
	static var x:Int;
	static var y:Int;
	static var height:Int;
	static var width:Int;
	static var orientation;
		
	static public function layout(j:JQuery):Container
	{
		//orientation = switch(j.attr('data-orientation'))
		switch(j.attr('data-orientation'))
		{			
			case 'H','HSH':
				root = new Row(j);
			case 'V','VSW':
				root = new Column(j);
			default:
				root = new Column(j);
			/*case 'H':
				root = new Row(j);
				H;
			case 'HSH':
				root = new Row(j);
				HSH;
			case 'V':
				root = new Column(j);
				V;
			case 'VSW':
				root = new Column(j);
				VSW;				
			default:
				root = new Column(j);
				V;*/
		}
		root.layout();
		return root;
	}
	
}