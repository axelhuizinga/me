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

extern class DOMElement extends DOMNode
{


	public var schemaTypeInfo(default,null):Bool;
	public var tagName(default,null):String;

	public function new(name:String, ?namespaceURI:String):Void;
	public function getAttribute(name:String):String;
	public function hasAttributeNS(namespaceURI:String, localName:String):Bool;
	public function getElementsByTagNameNS(namespaceURI:String, localName:String):DOMNodeList;
	public function getAttributeNS(namespaceURI:String, localName:String):String;
	public function getAttributeNodeNS(namespaceURI:String, localName:String):DOMAttr;
	public function setAttributeNodeNS(newAttr:DOMAttr):DOMAttr;
	public function getElementsByClassName(classes:String):DOMNodeList;
	public function hasAttribute(name:String):Bool;
	public function removeAttribute(name:String):Void;
	public function setAttributeNS(namespaceURI:String, qualifiedName:String, value:String):Void;
	public function getAttributeNode(name:String):DOMAttr;
	public function getElementsByTagName(name:String):DOMNodeList;
	public function setAttributeNode(newAttr:DOMAttr):DOMAttr;
	public function setIdAttributeNode(newAttr:DOMAttr, isId:Bool):Void;
	public function removeAttributeNode(oldAttr:DOMAttr):DOMAttr;
	public function setAttribute(name:String, value:String):Void;
	public function setIdAttribute(name:String, value:String):Void;
	public function removeAttributeNS(namespaceURI:String, localName:String):Void;
	public function setIdAttributeNodeNS(newAttr:DOMAttr, isId:Bool):Void;
	
}