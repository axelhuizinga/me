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

package me.cunity.php.application;
import me.cunity.php.application.res.Fonts;
import me.cunity.net.XmlSocket;
import me.cunity.php.NArray;
import sys.io.File;
import php.Lib;
import php.Sys;
//import php.net.Host;
import php.Web;

class Service extends App
{
	
	static var connections:Int = 1;
	var live:Bool;
	var hostIP:String;
	var fonts:Fonts;
	var xmlSock:XmlSocket;
	//var read:Array<Int>;
	//var write:Array<Int>;
	var read:Dynamic;
	var write:Dynamic;
	var port:Int;
	var pid:Int;

	
	public function new(host:String , ?port:Int = 5555) 
	{
		super();
		this.port = init(port);
		this.hostIP = ~/^(\d{1,3}\.){3}\d{1,3}$/.match(host) ? host :untyped __call__('gethostbyname', host);
		trace('host.net:' + host + ' IP:' +this.hostIP);

		//Lib.println('starting Service on ip:' + this.hostIP);
		untyped __php__("ob_flush()");
		run(this.port);
	}
	
	function init(port:Int) {
		untyped __php__("ob_implicit_flush()");
		fonts = new Fonts();		
		xmlSock = new XmlSocket();
		trace('Checking 4 free port:' + port);
		var isRunning:Bool = untyped __call__('file_exists', 'data/'  + port);
		//var isRunning:Bool = untyped __php__("file_exists('data/'.$port)");
		if (isRunning ) {//	KILL RUNNIG PROCESS
			var pid:Int = Std.parseInt(File.getContent('data/'  + port));
			trace( 'trying to kill pid:' + pid);
			if (! untyped __call__('posix_kill', pid, 9)) {
				trace('Could not terminate PID:' + pid);
				//Sys.exit(666);
			}
		}
		pid = untyped __call__('posix_getpid');
		File.putContent('data/'  + port, Std.string(pid));
		trace(File.getContent('data/'  + port));
		return port;
	}
	
	override function out(data:String):Bool {
	//function out(data:String):Bool {
		return true;
	}
	
	function run(port:Int) {
		xmlSock.bind(this.hostIP, this.port);
		/*read = new Array();
		write = new Array();
		var master:Array<Int> = [xmlSock.xS];*/
		read = NArray.array();
		write = NArray.array();
		var master:Dynamic = NArray.array(xmlSock.xS);
		var selected:Dynamic;
		/*var opts:Array < Dynamic > = untyped __call__('stream_context_get_options', sock.__s);
		untyped __call__('print_r', opts);*/

		Lib.print(xmlSock.xS + " LISTEN\n");
		untyped __php__("ob_flush()");
		//Web.flush();
		var xData:Xml = null;
		live = true;
		while (live) {
			read = master;
			write = master;			
			selected = xmlSock.select(read, write);
			if (selected == false){
				trace('selected = false');
				break;
			}
			trace('selected:' + selected);
			trace('read:'+ NArray.toString(read));
			trace('write:' + NArray.toString(write));
			untyped __php__("ob_flush()");
			for (i in 0...selected) {
				if (this.read[i] == this.xmlSock.xS) {//NEW CONNECTION
					var conn:XmlSocket = xmlSock.accept(900);
					NArray.push(master, conn.xS);
					trace('new connection:' + conn.xS);
					untyped __php__("ob_flush()");
					//$key_num = array_search($conn, $master, TRUE);
					
				} else { 
					var data:Dynamic = untyped __call__('fread', this.read[i], 32768); 
					trace('got:' + data);
					untyped __php__("ob_flush()");
					if (data.length == 0 || data == false) {//CONNECTION GONE | CONNECTION BROKEN
						var delIndex = untyped __call__('array_search', this.read[i], master, true);
						untyped __call__('fclose', this.read[i]);
						NArray.remove(master, this.read[delIndex]);
					}
					else {
						xData = Xml.parse(data);		
						trace('parsed ' + xData);
						untyped __php__("ob_flush()");
						if (xData.nodeName == 'exit')
							exitService(master);
						dispatch(xData, this.write[i]);
						trace('accept ' + this.read[i] + '==' + (write[i] == this.read[i]? 'true' :'false') );
						untyped __php__("ob_flush()");						
					}					
				}
			}
		}	
		//untyped __call__('fclose', sock.__s);
		exitService(master);
	}
	
	function exitService(m:Dynamic) {
		trace(m.length);
		untyped __php__("ob_flush()");
		for (i in 0...m.length)
			untyped __call__('fclose', m[i]);
		untyped __call__('fclose', xmlSock.xS);
		untyped __call__('unlink', 'data/'  + port);
	}
	
	function dispatch(xComm:Xml, client:Int){
		trace(xComm.nodeName);
		switch(xComm.nodeName) {
			case 'updateFonts':
			if (xComm.get('personal') != null) {
				//fonts.updateFontList(client);
				fonts.updateFontList(out);
			}
			untyped __call__('fwrite', client, "<exit/>" + String.fromCharCode(0));
		}
	}
	

	
}