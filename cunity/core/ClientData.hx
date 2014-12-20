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

package me.cunity.core;
import haxe.Log;
import me.cunity.fonts.FontInfos;

//import AppTypes;
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

class ClientData implements ServerApi {

	var api :ClientApiImpl;
	var name :String;

	public function new( scnx :haxe.remoting.SocketConnection ) {
		api = new ClientApiImpl(scnx.client);
		(cast scnx).__private = this;
		Log.trace = _trace;
	}

	public function identify( name :String ) {
		if( this.name != null )
			throw "You are already identified";
		this.name = name;
		Server.clients.add(this);
		for( c in Server.clients ) {
			if( c != this )
				c.api.userJoin(name);
			api.userJoin(c.name);
		}
	}
	
	public function getFontsInfo(fontDir :String, includePrivate:Bool) {
		trace('fontDir:' + fontDir + ' includePrivate:' + includePrivate);
		var fontsInfo:FontInfos = new FontInfos();
		//var files:Array<String> = fontsInfo.get(fontDir, api.showProgress, includePrivate);
		var files:Map<Map<String>> = fontsInfo.get(fontDir, api.showProgress, includePrivate);
		/*for (i in 0...files.length)
			this.api.userSay(Std.string(i), files[i]);*/
		var keys:Iterator<String> = files.keys();
		while (keys.hasNext()) {
			var key:String = keys.next();
			this.api.debug(key);
			//trace(k);
			//var f:Map<String>
			for (p in files.get(key).iterator())
				//trace( p);
				this.api.debug(p);
		}
			
	}

	public function broadcast( msg :ClientMessage ) {
		for( c in Server.clients )
			c.api.getMessage (msg);
	}

	public function leave() {
		if( Server.clients.remove(this) )
			for( c in Server.clients )
				c.api.userLeave(name);
	}

	public static function ofConnection( scnx :haxe.remoting.SocketConnection ) :ClientData {
		return (cast scnx).__private;
	}
	
	public function _trace(v :Dynamic, ?i :haxe.PosInfos ) :Void {
		untyped {
			if(i != null && Reflect.hasField(i ,'customParams')){
				i = i.customParams[0];
				//msg += Std.string(i.customParams);
			}
			var msg = if( i != null ) i.className+":"+i.methodName +":"+i.lineNumber+":" else "";
			api.debug(msg +Std.string(v));
			
		}
	}

}