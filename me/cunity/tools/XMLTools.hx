/**
 * @author Axel Huizinga - axel@cunity.me
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.tools;
import flash.xml.XML;
import flash.xml.XMLList;
import haxe.ds.StringMap.StringMap;
import me.cunity.data.Parse;
import me.cunity.ui.BaseCell;
using me.cunity.tools.ArrayTools;

class XMLTools 
{
	public static function init() 
	{
		//XML.ignoreProcessingInstructions = true;
		#if flash
		XML.ignoreWhitespace = true;
		XML.prettyIndent = 3;
		XML.prettyPrinting = true;
		#end
	}
	
	public static function getElementById(xml:XML, id:String, deep:Bool = true):XML 
	{
		var nodes:XMLList = deep ? xml.descendants() :xml.elements();
		for (i in 0...nodes.length()) {
			if (untyped nodes[i]['@id'] == id)
				return nodes[i];
		}
		return null;
	}
	
	public static function getElementByTagName(xml:XML, tag:String, id:String, deep:Bool = true):XML 
	{
		var nodes:XMLList = deep ? xml.descendants(tag) :xml.elements(tag);
		for (i in 0...nodes.length()) {
			if (untyped nodes[i]['@id'] == id)
				return nodes[i];
		}
		return null;		
	}
	
	public static function getElementsHash(xml:XML, name = '*', from:XMLList = null, key:String = 'id'):StringMap < XML > {
		var res:StringMap<XML> = new StringMap();
		var els:XMLList =  from == null ? xml.elements() :from;
		trace(els.length() + ':' + from.length());
		for (i in 0...els.length())
		{
			if (name != '*' && els[i].name() != name)
				continue;
			res.set(els[i].name() +'.'+ els[i].attribute(key).toString(), els[i]);
		}
		return res;
	}
	
	/*public static function inherit(xml:XML, ob:BaseCell, node:XML) {
		if(xml.elements('Classes').length() == 0)
			return;
		var cName = Type.getClassName(Type.getClass(ob));
		trace(cName);
		cName = ~/\w*\./g.replace(cName, '');
		var cNode = xml.elements('Classes')[0].elements(cName);
		if (cNode.length() != 1)
			return;
		var names:Array<String>  = XConfig.getAttributeNames(cNode.attributes());
		if (names.length == 0)
			return;
		var familyTree:Array<XML> = new Array();
		//var aNode:XML = node;
		var aNode:XML = node.copy();
		//var att:XMLList = new XMLList();
		while (aNode != null){
			familyTree.unshift(aNode);
			aNode = aNode.parent();
		}
		for (aNode in familyTree) {
			for (name in names)
				untyped node['@' + name] =  aNode.attribute(name);
		}
	}*/
	 
	public static function getInnerHTML(node:XML):String 
	{
		var res:String = node.children().toXMLString();
		~/<.?>/.replace(res, '');
		~/<\/.?>$/.replace(res, '');
		return res;
	}
	
	public static function getClassPath(node:XML):String 
	{
		//trace(node.name() + ':' + node.parent().name());
		if(node.parent() == null)
			return node.name();	
		var familyTree:Array<XML> = new Array();
		var res:String = '';
		var classPath:XMLList = node.attribute('classPath');
		if (classPath.length() == 1)
			res = classPath[0].toString() + '.';
		var  nodeName = node.name();
		/*node = node.parent();
		while (node != null){
			familyTree.unshift(node);
			node = node.parent();
		}
		//trace(Std.string(familyTree.length));
		for (node in familyTree) {
			var prefix:XMLList = node.attribute('prefix');
			//trace(node.name() + ':' + (prefix==null? '' :prefix.toString()));
			if (prefix.length() ==1 && Parse.att2Bool(prefix[0].toString() ))
				res +=  StringTool.lcFirst(node.name() +'.');
		}	*/
		return res + nodeName;
	}
	
	public static function getXPath(xml:XML):String {
		//trace(node.name() );
		if(xml.parent() == null)
			return xml.name();	
		var res:String = xml.name();
		xml = xml.parent();
		while (xml != null){
			res = xml.name() +'.' + res;
			xml = xml.parent();
		}
		//trace(res);
		return res;		
	}
	
	public static function getAttribute(xml:XML, name:Dynamic, object:Dynamic, def:Dynamic) 
	{
		var att:XMLList = xml.attribute(name);
		if (att.length() == 0)
			Reflect.setField(object, name, def);
		else
			switch(Type.typeof(def) ){
				case TBool:
				Reflect.setField(object, name, Parse.att2Bool(att.toString()));
				case TInt:
				Reflect.setField(object, name, Std.parseInt(att.toString()));
				case TClass(c):
				Reflect.setField(object, name, att.toString());
				default:
				//nothing				
			}
		//Reflect.field(object, att.length() == 1 ? att[0] :default);
	}
	
	public static function getAttributeNames(xml:XML):Array < String > {
		var res:Array<String> = new Array();
		var atts:XMLList = xml.attributes();
		for (i in 0...atts.length())
			res.push(atts[i].name());
		return res;
	}
	
	public static function getAttributes(xml:XML):Dynamic {
		var atts:XMLList = xml.attributes();
		var res:Dynamic = {};
		for (i in 0...atts.length()) {
			Reflect.setField(res, Std.string(atts[i].name()), atts[i].toString());
		}
		return res;
	}
	
	public static function copyAttributes(to:XML, from:XML, overwrite:Bool = false):Void
	{
		var atts:XMLList = from.attributes();
		for (i in 0...atts.length())
		{
			if (!overwrite && to.attribute(atts[i].name()).toString() != '')
				continue;
			Reflect.setField(to, "@" + atts[i].name(),  atts[i].toString());
		}
	}
   
	public static function removeChildren(xml:XML, childrenName:String):XMLList
	{
		var removed = xml.elements(childrenName);
		Reflect.deleteField(xml, childrenName);
		return removed;
	}
   
   
	public static function setAttribute(xml:XML, att:String) 
	{
		var keyVal:Array < String > = att.split('=').map(StringTools.trim);
		keyVal[1] = StringTools.replace(keyVal[1], '$', '$$');
		var er:EReg = new EReg((keyVal[0] + '="[@a-zA-Z0-9_$%§?!+*]+'), '');
		if (er.match(xml.toXMLString().split('\n')[0])) {
			//trace( keyVal[0] +'="' + keyVal[1] + '" :' + er.matched(0));
			//trace(er.replace(xml.toXMLString(),  keyVal[0] +'="' + keyVal[1] +'"'));
			return new XML(er.replace(xml.toXMLString(),  keyVal[0] +'="' + keyVal[1] ));	
			//xml =  new XML(er.replace(xml.toXMLString(),  keyVal[0] +'="' + keyVal[1] ));	
		}
		else{
		//trace(xml.toXMLString() +':' + keyVal[0] +'=>' + keyVal[1]);	
		//trace(new EReg(xml.name(), null).replace(xml.toXMLString(), xml.name() + ' ' +keyVal[0] +'="' + keyVal[1]+'"'));
		return new XML(new EReg(xml.name(), null).replace(xml.toXMLString(), xml.name() + ' ' +keyVal[0] +'="' + keyVal[1] + '"'));
			//xml = new XML(new EReg(xml.name(), null).replace(xml.toXMLString(), xml.name() + ' ' +keyVal[0] +'="' + keyVal[1] + '"'));
		}
	}
	
	public static function getAttributeNS(xml:XML, att:String):String
	{
		var atts:XMLList = xml.attributes();
		for (i in 0...atts.length())
		{
			if (atts[i].localName() == att)
				return atts[i].toXMLString();
		}
		return null;
	}	
	
	public static function xmlWithAttribute(xml:XML, att:String, value:String = null):XML
	{
		var els:XMLList = xml.descendants();
		//trace('checking for ' + att +   (value == null ? '' :' = ' + value) + ' in ' + els.length() + ' elements');
		//trace('descendants:' +  xml.descendants().length());
		for (i in 0...els.length())
		{
			if (els[i].nodeKind() != 'element')
				continue;
			//trace(els[i].localName() +':' + els[i].attribute(att).length() +':' +els[i].attribute(att).toString() );
			if (els[i].attribute(att).length() == 1)
			{
				if (value == null)
					return els[i];
				if (value == els[i].attribute(att).toString())
					return els[i];				
			}			
		}
		return null;
	}
	
	public static function elementsNS(xml:XML, name:String):XMLList
	{
		//TODO CHECK4NAMESPACE
		var els:XMLList = xml.elements();
		var res:String = '';
		for (i in 0...els.length())
		{
			//trace( els[i].name() + '<-' + els[i].localName());
			//if (els[i].localName() == (':' + name))
			if (els[i].localName() ==  name)
			{
				res += els[i].toXMLString();
			}
		}
		return new XMLList(res);
	}
	
	//	XMLLIST FUNCTIONS
	public static function getElementWithAttVal(nodes:XMLList, att:String, val:String):XML
	{
		for (i in 0...nodes.length()) {
			if (untyped nodes[i]['@'+att] == val)
				return nodes[i];
		}
		return null;
	}
}