/**
 *
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
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.effects;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.xml.XML;
import flash.xml.XMLList;

import me.cunity.tools.ArrayTools;
import me.cunity.ui.BaseCell;
import org.cove.ape.APEngine;
import org.cove.ape.Group;



class ApeWorld extends Effect
{
	var deltaTime:Float;
	var frameRate:Int;
	var threshold:Float;
	
	var baseGroup:Group;
	
	public function new(xN:XML, p:BaseCell) 
	{
		super(xN, p);
		deltaTime = cAtts.deltaTime == null ? .25 :Std.parseFloat(cAtts.deltaTime);	
		frameRate = cAtts.frameRate == null ? 32 :Std.parseInt(cAtts.frameRate);	
		threshold = cAtts.threshold == null ? .01 :Std.parseFloat(cAtts.threshold);	
		
		APEngine.init();
		APEngine.container = this;
		baseGroup = new Group();
		baseGroup.collideInternal = true;
		
	}
	
	function addStaticBox(sX:XML) {
		var sAtts:Array<String>  = XConfig.getAttributeNames(sX);
		trace(Std.string(sAtts));
		var i:Int = ArrayTools.indexOf(sAtts, 'rel');
		if(i>-1){
			box = getRel(sX.attribute(sAtts[i]).toString()).box;
			//trace(sX.attribute(sAtts[i]).toString()+ ':' + getRel(sX.attribute(sAtts[i]).toString()).name + ':' + Std.string(box));
		}
		i = ArrayTools.indexOf(sAtts, 'rel.bottom');
		if ( i > -1) {
			box.bottom = getRel(sX.attribute(sAtts[i]).toString()).box.bottom;
			//trace(sX.attribute(sAtts[i]).toString()+ ':' + getRel(sX.attribute(sAtts[i]).toString()).name + ':' + Std.string(box));
		}
		trace(Std.string(box));
	}
	
	function run(evt:Event) {
		
	}
	
	override public function init() {
		//box = dSprite.box;
		var sBoxes:XMLList = xNode.child('StaticBox');
		for (i in 0...sBoxes.length())
			addStaticBox(sBoxes[i]);
	/*}
	
	override public function start() {*/
		addEventListener(Event.ENTER_FRAME, run,false,0,true);
	}
	
	
	
}