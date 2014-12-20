package me.cunity.app.client;
import js.Dom;
import js.Lib;

class Display 
{

	public var node:Dom;
	
	public function new(nodeName:String, parent:HtmlDom = null, attributes:Map<String> = null) 
	{
		node = Lib.document.createElement(nodeName);
		
		if (attributes != null)
		{
			for (k in attributes.keys())
				node.setAttribute(k, attributes.get(k));
		}
		
		if (parent != null)
			parent.appendChild(node);
	}
	
}