/**
 * 
 * @author 
 *
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

package me.cunity.service;

//import mtwin.mail.Exception;

class Mail 
{
	var from:String;
	var to:String;
	var part:mtwin.mail.Part;
	
	public function new(from:String, to:String, subject:String) 
	{
		part = new mtwin.mail.Part("multipart/alternative");
		part.setHeader("From",from);
		part.setHeader("To",to);
		part.setDate();
		part.setHeader("Subject", subject);		  
		this.from = from;
		this.to = to;
	}
	
	public function addContent(type:String, body:String)
	{
		var content = part.newPart(type);
		content.setContent(body);
	}
	
	public function send()
	{
		mtwin.mail.Smtp.send( "smtp.cunity.me", from, to, part.get() );
	}
	
}
