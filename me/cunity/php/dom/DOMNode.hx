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

package me.cunity.php.dom;

extern class DOMNode 
{

	inline public static var XML_ELEMENT_NODE:Int =  1 ;
	inline public static var XML_ATTRIBUTE_NODE:Int =  2 ;
	inline public static var XML_TEXT_NODE:Int =  3 ;
	inline public static var XML_CDATA_SECTION_NODE:Int =  4 ;
	inline public static var XML_ENTITY_REFERENCE_NODE:Int =  5 ;
	inline public static var XML_ENTITY_NODE:Int =  6 ;
	inline public static var XML_PROCESSING_INSTRUCTION_NODE:Int =  7 ;
	inline public static var XML_COMMENT_NODE:Int =  8 ;
	inline public static var XML_DOCUMENT_NODE:Int =  9 ;
	inline public static var XML_DOCUMENT_TYPE_NODE:Int =  10 ;
	inline public static var XML_DOCUMENT_FRAGMENT_NODE:Int =  11 ;
	inline public static var XML_NOTATION_NODE:Int =  12 ;
	
	public var attributes(default,null):DOMNamedNodeMap;
	public var childNodes(default,null):DOMNodeList;
	public var firstChild(default,null):DOMNode;
	public var lastChild(default,null):DOMNode;
	public var localName(default,null):String;
	public var namespaceURI(default,null):String;
	public var nextSibling(default,null):DOMNode;
	public var nodeName(default,null):String;
	public var nodeType(default,null):Int;
	public var nodeValue:String;
	public var ownerDocument(default,null):DOMDocument;
	public var parentNode(default,null):DOMNode;
	public var prefix:String;
	public var previousSibling(default,null):DOMNode;
	public var textContent:String;

	public function appendChild(newChild:DOMNode):DOMNode;
	public function cloneNode(deep:Bool):DOMNode;
	public function hasAttributes():Bool;
	public function hasChildNodes():Bool;
	public function insertBefore(newChild:DOMNode, refChild:DOMNode):DOMNode;
	public function isSupported(feature:String, version:String):Bool;
	public function lookupNamespaceURI(prefix:String):Void;
	public function lookupPrefix(namespaceURI:String):Void;
	public function normalize():Void;
	public function removeChild(oldChild:DOMNode):DOMNode;
	public function replaceChild(newChild:DOMNode, oldChild:DOMNode):DOMNode;
	public function getUserData(key:String):Dynamic;
	public function setUserData(key:String, userData:Dynamic, callBack:Dynamic):Dynamic;
	
}