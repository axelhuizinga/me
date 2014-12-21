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
import me.cunity.php.dom.DOMElement;
import me.cunity.php.dom.DOMNode;
using me.cunity.php.dom.DOMUtils;

import me.cunity.site.Container;

class Button extends Container
{

	public function new(xN:DOMNode, p:Container) 
	{
		super(xN, p);
		if (xNode.getAttribute('obj')!=null) {
			if (xNode.getAttribute('interactionState')!=null)//INITIALLY DISABLED'			
				interactionState = InteractionState.DISABLED;
			else
				interactionState = InteractionState.ENABLED;
		}
		
		else if (xNode.getAttribute('id')!=null){			
			var linkPath:String = Site.configDir + xNode.getAttribute('id') + '.xml';
			if (linkExists(linkPath))
				interactionState = InteractionState.ENABLED;
		}
	}
	
	function linkExists(linkPath:String):Bool
	{
		untyped {return __call__('file_exists', linkPath) == true; };
	}
	
}