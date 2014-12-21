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

class NodeListIter{
    var nodeList:DOMNodeList;
	var current:Int;

    public function new( list:DOMNodeList ) {
        this.nodeList = list;
		current = 0;
    }

    public function hasNext() {
        return( current < nodeList.length );
    }

    public function next() {
        return nodeList.item(current++);
    }
}

class DOMUtils 
{

	public static function iterator(list:DOMNodeList):Iterator<DOMNode>
	{
		return new NodeListIter(list);
	}
	
	public static function getAttribute(n:DOMNode, att:String):String 
	{
		var atts:DOMNamedNodeMap = n.attributes;
		for (i in 0...atts.length)
			if (atts.item(i).nodeName == att) 
				return atts.item(i).nodeValue;
		return null;
	}
}