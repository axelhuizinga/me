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

extern class DOMDocument extends DOMNode
{
	public var doctype(default,null):DOMDocumentType;
	public var documentElement(default,null):DOMElement;
	public var implementation(default, null):DOMImplementation;
	public var documentURI:String;
	public var encoding:String;
	public var version:String;
	public var xmlVersion:String;
	public var formatOutput:Bool;
	public var recover:Bool;
	public var resolveExternals:Bool;
	public var standalone:Bool;
	public var strictErrorChecking:Bool;
	public var substituteEntities:Bool;
	public var validateOnParse:Bool;
	public var xmlStandalone:Bool;
	public var preserveWhiteSpace:Bool;
	public var actualEncoding(default, null):String;
	public var xmlEncoding(default, null):String;

	public function createAttribute(name:String):DOMAttr;
	public function createAttributeNS(namespaceURI:String, qualifiedName:String):DOMAttr;
	public function createCDATASection(data:String):DOMCDATASection;
	public function createComment(data:String):DOMComment;
	public function createDocumentFragment():DOMDocumentFragment;
	public function createElement(tagName:String, ?value:String):DOMElement;
	public function createElementNS(namespaceURI:String, qualifiedName:String, ?value:String):DOMElement;
	public function createEntityReference(name:String):DOMEntityReference;
	public function createProcessingInstruction(target:String, data:String):DOMProcessingInstruction;
	public function createTextNode(data:String):DOMText;
	public function getElementById(elementId:String):DOMElement;
	public function getElementsByTagName(tagname:String):DOMNodeList;
	public function getElementsByTagNameNS(namespaceURI:String, localName:String):DOMNodeList;
	public function importNode(importedNode:DOMNode, deep:Bool):DOMNode;
	public function new(?ver:String, ?enc:String):Void;
	public function load(fileName:String, ?options:Int):Dynamic;
	public function loadHTML(source:String):Bool;
	public function loadHTMLFile(fileName:String):Bool;
	public function loadXML(source:String, ?options:Int):Dynamic;
	public function normalizeDocument():Void;
	public function registerNodeClass(baseClass:String, extendedClass:String):Bool;
	public function relaxNGValidate(fileName:String):Bool;
	public function relaxNGValidateSource(source:String):Bool;
	public function save(fileName:String, ?options:Int):Int;
	public function saveHTML():String;
	public function saveHTMLFile(fileName:String):Int;
	public function saveXML(?node:DOMNode, ?options:Int):String;
	public function schemaValidate(fileName:String):Bool;
	public function schemaValidateSource(source:String):Bool;	
	public function validate():Bool;	
	public function xinclude(?options:Int):Int;
}