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

package me.cunity.data.xml;
import me.cunity.php.dom.DOMDocument;
import me.cunity.php.dom.DOMElement;
import me.cunity.php.dom.DOMNode;

class Document extends DOMDocument
{

	public function new(version:String = "1.0", encode:String = "UTF-8") 
	{
		super(version, encode);
	}
	
	public function addElement(node:DOMNode, elemName:String, elemVal:String=""):DOMNode
	{
		var el:DOMElement = createElement(elemName, elemVal);
		if (el == null)//TODO - CREATE EXCEPTION API
			throw('Could not create a new element');
		var newNode:DOMNode =  node-> appendChild(el);
		if(node == null)
			throw('Could not append a new node');
	}
	
}