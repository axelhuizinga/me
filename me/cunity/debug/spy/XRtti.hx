/**
 *
 * @author Axel Huizinga
 */

package me.cunity.debug.spy;
import flash.net.XMLSocket;
import flash.xml.XML;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;
import haxe.rtti.CType;
import me.cunity.tools.ArrayTools;

class XRtti 
{
	
	var allClasses:Map<TypeTree>;
	var xClasses:Map<TypeTree>;
	var xDoc:XMLDocument;
	var xParser:haxe.rtti.XmlParser;
	public var xNode:XMLNode;
	var xRoot:XMLNode;
	
	public function new(xData:String) 
	{
		xDoc = new XMLDocument();
		xDoc.ignoreWhite = true;//skip textNodes
		xDoc.parseXML(xData);
		xParser = new haxe.rtti.XmlParser();
		xRoot = xDoc.firstChild;
		trace(xRoot.nodeName);
		allClasses = new Map();
		var className:String = 'me.cunity.ui.VideoClip';		
		var elements:Array<Dynamic> = xRoot.childNodes;
		for (element in elements) {
			if (element.nodeName != 'class')
				continue;
			addRtti(element, allClasses);
			if (element.attributes.path == className)
				xNode = element;
				//trace(element.attributes.path);
		}
	}
	
	public function getXClasses():Map < TypeTree > {
		xClasses = new Map();
		var elements:Array<Dynamic> = xRoot.childNodes;
		for (element in elements) {
			if (element.attributes.path == 'flash.display.DisplayObject') {
				addRtti(element, xClasses);
				continue;
			}
			//var hasSC:Bool = hasSuperClass(element, 'flash.display.DisplayObject');
			//if(hasSC){
			if(hasSuperClass(element, 'flash.display.DisplayObject')){
				//trace(hasSC + ':' + element.attributes.path);
				addRtti(element, xClasses);
			}
		}
		return xClasses;
	}
	
	public function addRtti(el:XMLNode, ttHash:Map<TypeTree>) {

		ttHash.set(el.attributes.path, 
			xParser.processElement(Xml.parse(el.toString()).firstElement()));

	}
	
	public function hasSuperClass(cN:XMLNode, sCName:String):Bool {
		//var ext:Xml = cN.firstElement();
		var ext:XMLNode = cN.firstChild;
		if ( ext != null && ext.nodeName == 'extends') {
			//trace('->' + ext.get('path') + '<- == ->' + sCName + '<-');
			if (ext.attributes.path == sCName)
				return true;
			return hasSuperClass(
				getNodeByAttVal(xRoot, 'path', ext.attributes.path),
				sCName
			);
		}
		//trace(cN.attributes.path  + '!=' + sCName);
		return false;
	}
	
	public function getNodeByAttVal(root:XMLNode, att:String, value:String):XMLNode{
		var elements:Array<Dynamic> = root.childNodes;
		for (element in elements) {
			if (element.nodeName != 'class')
				continue;
			if (Reflect.field(element.attributes, att) == value)
				return element;
		}
		/*var elements:Iterator<Xml> = xRoot.elements();
		while (elements.hasNext()) {
			var el = elements.next();
			if (el.nodeName != 'class') 
				continue;
			if (el.get(att) == value)
				return el;
		}*/
		return null;
		//return xPath.selectNode(xml);
	}
	
}