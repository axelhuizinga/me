package me.cunity.js.node;
/**
 * ...
 * @author axel@cunity.me
 */

import js.Node;
import js.node.http.ClientRequest;
import js.node.http.ServerResponse;
import js.npm.Express;
import js.npm.express.Application;
import js.npm.express.CookieParser;
import js.npm.express.Request;
import js.npm.express.Session;
import js.npm.connect.support.Middleware;
import js.npm.express.Static;
import js.npm.mongoose.Mongoose;
import me.cunity.debug.Out;
//using js.npm.express.Session;

typedef ServerOptions =
{
	@:optional var db:Mongoose;
	@:optional var port:Int;
	@:optional var host:String;
}

import js.npm.mongoose.macro.Model;
import js.npm.mongoose.Mongoose;
import js.npm.Mongoose.mongoose;

typedef Entry =
{
	?title:String,
	?content:String
}

typedef SheetData = 
{
	name:String,
	owner:String,
	creationDate:Date,
	lastModified:Date,
	?entries:Array<Entry>
}

 @:schemaOptions({
    autoIndex: true
})

class Sheet extends Model<SheetData> { }
class SheetManager extends Manager<SheetData,Sheet> { }

class AjaxApp 
{

	public function new(options:ServerOptions) 
	{
		var app:Express = new Express();
		//super();
		var secret = 'something!NEW666';
		app.use( new CookieParser(secret));
		app.use( new Session( { secret:secret } ));
		app.all('/', function(req:Request ,res:ServerResponse, next:MiddlewareNext)
		//all('/', function(req ,res, next)
		{
			/*var session = req.session();
			if( session.n == null ){
				session.n = 1;
			}*/
			res.write("<!DOCTYPE html><html><head></head><body>HELLO " );
			//+ session.n++ + '<br>' + Reflect.fields(res).join('<br>'));
			//Out.dumpObject(res);
			Out.dumpObject(untyped req.session);
			res.write("<br>request:" + Reflect.fields(req).join('<br>'));
			res.write("<br>session:" + Type.typeof(untyped req.session) + '<br>');
			res.end();
		});
		app.use(new Static('.'));
		var port:Int = options.port == null ? 4040 : options.port;
		var host:String = options.host == null ? Node.require('os').hostname() : options.host;
		trace('$host is listening on $port :)');
		app.listen(port);
	}
	
	public function initRoutes(err:Null<js.support.>,sheets:Null<Array<Sheet>>):Void
	{
		trace(sheets.length);
		for (sheet in sheets)
		{
			trace(sheet.name + ':');
			for (e in sheet.entries)
				trace(e.title + ':' + e.content);
		}		
	}
	
}