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
import flash.xml.XMLList;
import flash.xml.XML;

class E4XList 
{
	/**
	 * Used to replicate bracketed access in XML and XMLList classes. Will also work with the "@" operator.
	 *
	 * EXAMPLE:
	 *                                      myxml.@attribute (as3)
	 * will become ->       myxml._("@attribute") (haXe)
	 *                                      myxml["insert long string here"] (as3)
	 * will become ->       myxml._("insert long string here") (haXe)
	 *
	 * @param       field
	 * @return      A new E4XMLList wrapper
	 */
	public static inline function _(node:XMLList, field:String):XMLList
	{
			return untyped cast node[field];
	}

	/**
	 * Used to replicate the ".." operator in XML and XMLList classes.
	 * Same as calling this.node.descendants(str), but will already return a new E4XMLList wrapper.
	 *
	 * @param       descendantField (optional)
	 * @return      A new E4XMLList wrapper
	 */
	public static inline function __(node:XMLList, descendantField:String):XMLList
	{
			return untyped node.descendants(descendantField);
	}

	/**
	 * Replicates the filter behaviour. Will iterate through all elements and run a test function on each of them.
	 *
	 * @param       field                           internal xml field that we want to test for equality
	 * @param       compareTo                       external field (can be a string or another XMLList)
	 * @param       ?compareFunction        the compare function. Defaults to the equality function ( == )
	 */
	public static inline function _filter(node:XMLList, field:String, compareTo:Dynamic, compareFunction:Dynamic->Dynamic->Bool):XMLList
	{
			if (compareFunction == null)
					compareFunction = equalsTo;

			var len = untyped node.length();
			var retval = "";
			var i = -1;
			while (++i < len)
			{
					var teste :XML = cast untyped node[i];
					if (compareFunction(untyped teste[field], compareTo))
					{
							retval += untyped node[i].toXMLString();
					}
			}

			return new XMLList(retval);
	}

	public static inline function _filter_eq(node:XMLList, field:String, compareTo:Dynamic):XMLList
	{

			var len = node.length();
			var retval = "";
			var i = -1;
			while (++i < len)
			{
					var teste :XML = node[i];
					if (untyped teste[field] == compareTo)
					{
							retval += untyped node[i].toXMLString();
					}
			}

			return new XMLList(retval);
	}

	private static function equalsTo(val1:Dynamic, val2:Dynamic):Bool
	{
			return val1 == val2;
	}

	public static function iterator(node:XMLList):Iterator<XML>
	{
			return untyped {
					n :node,
					len :node.length(),
					i :0,
					hasNext:function() { return (this.i < this.len); },
					next:function() { return new XML( this.n[this.i++] ); }
			}
	}

	public static inline function toFloat(node:XMLList):Float
	{
			return Std.parseFloat(node.toString());
	}	
}