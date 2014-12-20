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

package me.cunity.site;
import me.cunity.php.dom.DOMAttr;
import me.cunity.php.dom.DOMDocument;
import me.cunity.php.dom.DOMElement;
import me.cunity.php.dom.DOMNamedNodeMap;
import me.cunity.php.dom.DOMNode;
import me.cunity.php.dom.DOMNodeList;

enum InteractionState{
	ACTIVE;
	//CONTAINER;
	HIDDEN;
	ENABLED;
	DISABLED;
}

class Container 
{
	var children:Array<Container>;
	var parent:Container;
	var xNode:DOMNode;
	var liveDoc:DOMDocument;
	
	private var _interactionState:InteractionState;
	
	//public var configDir:String;
	public var interactionState(getState, setState):InteractionState;
	
	public function new(xN:DOMNode, p:Container = null) 
	{
		parent = p;
		
		/*if(p==null) untyped{
			configDir = ( __var__('GLOBALS', 'configDir') == null ? 'site/' : __var__('GLOBALS', 'configDir'));
		}
		else
			configDir = parent.configDir;*/
		//trace(configDir);
		xNode = xN;
		_interactionState = InteractionState.HIDDEN;
		//trace(_interactionState);
		children = new Array();
		addChildren();
		
	}
	
	function getState():InteractionState {
		return _interactionState;
	}
	
	function setState(st:InteractionState):InteractionState {
		_interactionState = st;
		if(parent != null) switch(parent.interactionState) {
			case InteractionState.HIDDEN:
			parent.interactionState = st;
			default:
			//DO NOTHING			
		}
		return _interactionState;
	}
	
	function addChildren() 
	{
		var childList:DOMNodeList = xNode.childNodes;	
		for (child in 0...childList.length) {
			var childNode:DOMNode = childList.item(child);
			switch(childNode.nodeName){
				case 'Button':
				children.push(new Button(childNode, this));
				default:
				children.push(new Container(childNode, this));
			}
		}
	}
	
	function copyChildren(p:DOMNode, doc:DOMDocument) {
		trace(   p.nodeName+ ' ownerDoc:' + Std.string(p.ownerDocument == null));
		p = p.appendChild(doc.importNode(copyNode(xNode), true));
		for (child in children) {
			/*trace(p.nodeName +':' + child.xNode.nodeName +':' + 
			( child.xNode.attributes.getNamedItem('id') == null ? '' :child.xNode.attributes.getNamedItem('id').nodeValue) 
			+':' +  child.interactionState);*/
			if (child.interactionState == InteractionState.HIDDEN)
				continue;
			child.copyChildren(p, doc);
		}
	}
	
	function copyNode(n:DOMNode):DOMNode {
		var copy = n.cloneNode(true);
		while (copy.firstChild != null)
			copy.removeChild(copy.firstChild);
		return copy;
	}
	
	
}