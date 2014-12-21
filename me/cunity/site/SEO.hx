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
import me.cunity.php.dom.DOMNode;
import me.cunity.php.dom.DOMNodeList;
import php.FileSystem;
import php.Lib;
import php.Web;
using me.cunity.php.dom.DOMUtils;

class SEO 
{
	var buttonList:DOMNodeList;
	var linkList:Array<DOMNode>;
	var uri:String;
	var lastMods:Array<Date>;
	
	public function new(lList:DOMNodeList) 
	{
		buttonList = lList;
		lastMods = new Array();
		linkList = new Array();
	}
	
	public function siteMap():String
	{
		uri = Web.getURI();
		var sM:String = '<div id="siteMap">\n';
		for (l in buttonList.iterator()) {			
			if (l.getAttribute('obj') != null)// 	skip internal function buttons
				continue;
			if (l.getAttribute('interactionState') == 'DISABLED')// 	SKIP INITIALLY DISABLED BUTTONS
				continue;			
			var id:String = l.getAttribute('id');
			if (id == '' || id == null)//SKIP BUTTONS WITHOUT ID
				continue;
			sM += '<a href="/#' + id + '">' + id + '</a>\n';
			//Lib.print(Site.configDir + l.nodeName +':'+l.getAttribute('id') + '.xml ' + FileSystem.stat(Site.configDir +  l.getAttribute('id') + '.xml').mtime.toString()+' <br/>');
			lastMods.push(FileSystem.stat(Site.configDir +  l.getAttribute('id') + '.xml').mtime);
			linkList.push(l);
		}
		sM += '</div>\n';
		updateSitemapXml();
		return sM;
	}
	
	function updateSitemapXml()
	{
		var needsUpdate:Bool = false;
		var lastMod:Float = 0.0;
		
		if (! FileSystem.exists('sitemap.xml'))
			needsUpdate = true;
		else
		{
			lastMod = FileSystem.stat('sitemap.xml').mtime.getTime();
			for (i in 0...lastMods.length)
			{					
				if (lastMods[i].getTime() > lastMod)// newer
				{
					needsUpdate = true;
					break;
				}
			}
		}
		
		if (needsUpdate)
		{
			var siteMapXml:DOMDocument = new DOMDocument('1.0', 'utf-8');
			var urlset:DOMElement = siteMapXml.createElement('urlset');
			var host:String = Web.getHostName();
			for (i in 0...lastMods.length)
			{
				var url:DOMNode = urlset.appendChild(siteMapXml.createElement('url'));
				url.appendChild(siteMapXml.createElement('loc', 'http://' + host + uri + '#' + linkList[i].getAttribute('id')));
				url.appendChild(siteMapXml.createElement('lastmod', lastMods[i].toString()));
			}	
			siteMapXml.appendChild(urlset);
			siteMapXml.save('sitemap.xml');
			//Lib.print('saved sitemap.xml');
		}		
	}
	
}