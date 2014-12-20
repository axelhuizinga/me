package me.cunity.js;
/**
 * ...
 * @author axel@cunity.me
 */

import haxe.ds.StringMap;
import haxe.Json;
import haxe.PosInfos;
import haxe.Timer;
import js.node.http.Server;
import js.node.MySQL;
import js.node.MysqlConnection;
import js.node.Fs;
import js.node.Http;
import js.node.Path;
import js.node.ws.WebSocket;
import js.node.ws.WebSocketServer;
import js.npm.Express;
import js.npm.connect.support.Middleware;
import js.Node;
import me.cunity.debug.Out;
import me.cunity.js.app.UserList;
import me.cunity.js.app.User;

using StringTools;

typedef MyError = Dynamic;

class App
{
	public var root:String;// APP ROOT DIR RELATIVE 2 DOCUMENTROOT
	public var dbConn:MysqlConnection;
	//public var dev:Dev;
	public var users:UserList;
	public var aConf:Dynamic;
	public var eApp:Express;
	public var wss:WebSocketServer;
	public var wssPush:Int;
		
	var debugging:Bool;

	var defaultPath:String;

	public static var ins:App;
	static var included:Map<String,String>;
	
	public static function createServerApp(cfgPath:String = 'config.json'):App
	{
		var cfgData:Dynamic = Json.parse(Fs.readFileSync(cfgPath));
		ins = new App(cfgData.sConf);
		ins.eApp.set('appInstance', ins);
		included = new Map();
		ins.require(cfgData.require);
		ins.set(cfgData.set);
		ins.all(cfgData.all);
		ins.use(cfgData.use);		
		ins.run();
		//Out.dumpObject(ins.eApp);
		return ins;
	}
	
	public function new(sConf:Dynamic) 
	{		
		eApp = new Express();
		users = new UserList();		
		aConf = sConf;
		var express = Node.require('express'); 
		eApp.use(express.urlencoded());
		var serveStatic = Node.require('serve-static');
		//trace(sConf);
		eApp.use(serveStatic(Path.join(Node.__dirname, sConf.staticPath)));				
		var logFile = Fs.createWriteStream(sConf.log, { flags:'a' } );
		eApp.use(express.logger( { stream:logFile } ));
		eApp.use(express.cookieParser(sConf.secret));
		dbConn = MySQL.createConnection( 
		{ 
			host:sConf.dbConn.host, 
			user:sConf.dbConn.user, 
			password:sConf.dbConn.password, 
			database:sConf.dbConn.database
		} );
		/*eApp.configure('development', function(){
		eApp.use(express.errorHandler());*/
		eApp.locals.pretty = true;
		//});
		if (true && 'development' == eApp.get('env')) {
			trace('development - enabling logErrors with stacktrace to console :)');
			eApp.use(function logErrors(err, req, res, next:Dynamic) {
				Node.console.error(err.stack);		
				next(err);
			});
		}
	}
	
	function require(inc:Dynamic)
	{
		var includes:Array <{ varName:String,path:String}> = inc;
		for (req in includes)
		{
			//trace(req);
			included.set(req.varName, Node.require(req.path));
		}
	}
	
	function set(set:Dynamic):Void
	{
		var sets:Array <{ varName:String,value:Dynamic}> = set;
		for (s in sets)
		{
			//trace(req);
			eApp.set(s.varName,s.value);
		}		
	}
	
	function all(all:Dynamic):Void
	{
		var alls:Array <{path:String,varName:String,method:String}> = all;
		for (a in alls)
		{
			trace(a.path +':' + included.get(a.varName) + ':' + Reflect.field(included.get(a.varName), a.method));
			eApp.all(a.path, Reflect.field(included.get(a.varName), a.method));
		}		
	}

	function use(use:Dynamic):Void
	{
		var uses:Array <{path:String,varName:String,method:String}> = use;
		for (a in uses)
		{
			//trace(req);
			eApp.use(a.path, Reflect.field(included.get(a.varName), a.method));
		}		
	}	
	
	public function run():Void
	{
		var server:Server = Http.createServer(eApp);
		wssPush = eApp.get("webSocketInterval");
		server.listen(eApp.get("port"), function() {
			if (eApp.get("webSocketInterval") > 0)
			{				
				Node.console.log('eApp server listening on port ' + eApp.get('port') + ' - realtime push interval:' 
				+ wssPush + 'ms');	
			}
			else
			{
				Node.console.log('eApp server listening on port ' + eApp.get('port'));	
			}
			
		});		
		if (wssPush > 0)
		{
			wss = new WebSocketServer( { server:server } );
			var ipPrinted:Bool = false;
			wss.on('connection', function(ws:WebSocket)
			{
				var id = new Timer(wssPush);
				if (!ipPrinted)
				{
					ipPrinted = true;
					trace(ws.upgradeReq.connection.remoteAddress);
				}
				var dbench:DBench = new DBench(aConf.dbenchInsert);
				
				wss.on('message', function(res:Dynamic)
				{
					trace(res);
					switch (res.status)
					{
						case 'InsertDone':
						id.stop();
					}
					ws.send(Json.stringify(res), null, function(err:String, final:Dynamic) {
						//if(err!='null')trace(err);
					});
					//ws.send(Json.stringify( { status:'START', start:dbench.start } ));
					id.run = function()
					{
						//var mem:Dynamic = Node.process.memoryUsage();
						ws.send(Json.stringify( { status:'UPDATE', inserted:dbench.curInsert } ), null, function(err:String, final:Dynamic) {
							//if(err!='null')trace(err);
						});
					}
					//Node.console.log('started client interval');

				});
				ws.on('close', function()
				{
					//Node.console.log('stopping client interval');
					
				});			
			});			
		}
	}
	
	public static function errLog(m:Dynamic, ?i:PosInfos)
	{
		var ms:String = Std.is(m, String) ? m :Std.string(m);
		var msg = if ( i != null ) i.fileName + ':' + i.lineNumber + ":" + i.methodName  else "";
		Node.console.log(msg);
	}
	
	
}