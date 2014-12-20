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

package me.cunity.fonts;
import me.cunity.tools.StringTool;
#if neko
import neko.FileSystem;
import neko.Sys;
#elseif php
#

class FontInfos 
{
	var fontsDir:String;
	var fontList:Map < Array < Map < String >>> ;
	var files:Array<String>;
	var size:Int;
	var pSep:String;
	
	public function new() {}
	public function get(dir:String, onProgress:Int->Void = null, includePersonal:Bool=false):Map<Map<String>>
	{
		fontsDir = dir;
		var sysName = Sys.systemName();
		pSep = ~/windows/i.match(sysName) ? '\\' :'/';
		if (! FileSystem.isDirectory(dir)) {
			onProgress(666);
			return null;
		}
		Sys.setCwd(dir);
		files = new Array();
		var infos = new Map<Map<String>>();
		trace( "looking 4 fontDirs @ " + dir + ':' + includePersonal);
		var dirs:Array<String> = FileSystem.readDirectory(dir);
		for (d in dirs) {
			if (! FileSystem.isDirectory(fontsDir + pSep + d))
				continue;
			trace(d);
			if (d == 'personal' && includePersonal)
				files = files.concat(addPersonal(fontsDir + pSep + d));
			else
				files = files.concat(glob(fontsDir + pSep + d, new Array<String>()));
			trace(files.length);
		}
		//onProgress(files.length);
		//return null;
		//return files;
		this.size = files.length;
		var progress:Int = 0;
		var last:Int = -1;			
		var ttf:TTF = new TTF();
		for(file in files){			
			var info:Map<String> = ttf.getInfo(file);
			//trace(info.keys().hasNext);
			//Sys.exit(666);
			var h:Map<String> = new Map();
			h.set('file', file);
			//trace(file);
			infos.set(StringTool.ucFirst(file), h);
			for(key in info.keys()){
				infos.get(StringTool.ucFirst(file)).set(key, info.get(key));	
				//trace('set:' + key + '->'+info.get(key));	
			}
			//current =  sprintf('%d' , 100 * progress/this->size);
			var current =   Std.int(100 * progress/this.size);
			if(current != last)
				onProgress(current);
			last = current;
			progress++;
			//Sys.exit(666);
			//if(debug)sleep(debug);
		}
		//this->updateFontDb(infos);
		onProgress(100);		
		//return null;
		return infos;
	}
	
	function addPersonal(dir:String):Array<String>{
		//trace(dir);
		return glob(dir, new Array<String>());
	}
	
	public function glob(path:String, res:Array<String>=null):Array<String> {
		//trace(path);
		var rec:Bool = res != null;
		if (res == null)
			res = new Array();
			
		var pathInfo = StringTool.pathInfo(path);
		var cDir = pathInfo.get('dirname');
		//trace(cDir);
		if (! FileSystem.isDirectory(cDir))
			return null;
		Sys.setCwd(cDir);
		var files:Array<String> = FileSystem.readDirectory(cDir);
		//trace(files.length);
		for (f in files){
			if (rec && FileSystem.isDirectory(f))
				res.concat(glob(cDir + pSep + f, res));
			else
				res.push(cDir + pSep + f);
		}
		//trace(res.length);
		return res;				
	}
	
}