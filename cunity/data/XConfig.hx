/**
 *
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

package me.cunity.data;
import flash.xml.XML;
import flash.xml.XMLDocument;
import flash.xml.XMLList;
import me.cunity.tools.StringTool;
import me.cunity.ui.BaseCell;
import Type.ValueType;

class XConfig
{

	public var xml(default, null):XML;
	
	public function new(xmlString:String) 
	{
		//XML.ignoreProcessingInstructions = true;
		XML.ignoreWhitespace = true;
		XML.prettyIndent = 3;
		XML.prettyPrinting = true;
		xml = new XML(xmlString);
		//trace(xml.toXMLString());
	}
	
	public function getElements(name:String, root:XML = null):XMLList {
		if (root == null)
			root = xml;
		var els:XMLList = root.elements(name);
		//trace(els.length());
		//var els:XMLList = root.descendants(name);
		//trace(Std.string(els));
		return els;
	}
	
	public function getElementById(id:String, deep:Bool = true, root:XML = null):XML {
		if (root == null)
			root = xml;
		var nodes:XMLList = deep ? root.descendants() :root.elements();
		for (i in 0...nodes.length()) {
			if (untyped nodes[i]['@id'] == id)
				return nodes[i];
		}
		return null;
	}
	
	public function getElementByTagName(tag:String, id:String, deep:Bool = true, root:XML = null):XML {
		if (root == null)
			root = xml;
		var nodes:XMLList = deep ? root.descendants(tag) :root.elements(tag);
		for (i in 0...nodes.length()) {
			if (untyped nodes[i]['@id'] == id)
				return nodes[i];
		}
		return null;		
	}
	
	public function getElementsHash(name = '*', from:XMLList = null, key:String = 'id'):Map < XML > {
		var res:Map<XML> = new Map();
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
	
	public function inherit(ob:BaseCell, node:XML) {
		if(xml.elements('Classes').length() == 0)
			return;
		var cName = Type.getClassName(Type.getClass(ob));
		trace(cName);
		cName = ~/\w*\./g.replace(cName, '');
		var cNode = xml.elements('Classes')[0].elements(cName);
		if (cNode.length() != 1)
			return;
		var names:Array<String>  = XConfig.getAttributeNames(cNode);
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
	}
	 
	public static function getInnerHTML(node:XML):String {
		var res:String = node.children().toXMLString();
		~/<.?>/.replace(res, '');
		~/<\/.?>$/.replace(res, '');
		return res;
	}
	
	public static function getClassPath(node:XML):String {
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
	
	public static function getXPath(node:XML):String {
		//trace(node.name() );
		if(node.parent() == null)
			return node.name();	
		var res:String = node.name();
		node = node.parent();
		while (node != null){
			res = node.name() +'.' + res;
			node = node.parent();
		}
		//trace(res);
		return res;		
	}
	
	public static function getAttribute(node:XML, name:Dynamic, object:Dynamic, def:Dynamic) {
		var att:XMLList = node.attribute(name);
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
	
	public static function getAttributeNames(atts:XMLList):Array < String > {
		var res:Array<String> = new Array();
		//trace(atts.length());
		for (i in 0...atts.length())
			res.push(atts[i].name());
		return res;
	}
	
	public static function getAttributes(node:XML):Dynamic {
		var atts:XMLList = node.attributes();
		var res:Dynamic = {};
		for (i in 0...atts.length()) {
			//trace(i +':' + atts[i].name());
			//trace(i +':' + atts[i]);
			Reflect.setField(res, Std.string(atts[i].name()), atts[i].toString());
			//Reflect.setField(res,  atts[i].name(), atts[i].toString());
		}
		return res;
	}
	
	public static function deleteNode(xmlToDelete:XML):XMLList
   {
		var cn:XMLList = new XMLList(xmlToDelete.parent()).children();
		var atts:XMLList = xmlToDelete.parent().attributes();
		var res:String = '<' + xmlToDelete.parent().name() + ' ';
		for (i in 0...atts.length())
			res += atts[i].name() + '="' + atts[i].toString() + '" ';
		res += '>';
		//trace(cn.length()+':'+xmlToDelete.parent().name());
		for ( i in 0...cn.length() )
		{
			if ( cn[i] != xmlToDelete && cn[i].childIndex() != xmlToDelete.childIndex()) 
			{
				//untyped __global__["delete"](cn[i]);       
				//untyped __delete__(cn, cn[i]);    
				//trace(i+' kept:'+cn[i].name() + Std.string(cn[i].toString() == cn[i].toXMLString()));
				res += cn[i].valueOf().toXMLString();
			}
		}    
		res += '</' + xmlToDelete.parent().name() + '>';
		//trace(res);
		return new XMLList(new XML(res));
   }
	
}