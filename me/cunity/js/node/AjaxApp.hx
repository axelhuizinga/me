package me.cunity.js.node;
/**
 * ...
 * @author axel@cunity.me
 */

import js.html.Attr;
import js.Node;
import js.node.http.ClientRequest;
import promhx.Deferred;
import js.npm.Express;
import js.npm.express.Application;
import js.npm.express.CookieParser;
import js.npm.express.Request;
import js.npm.express.Response;
import js.npm.express.Router;
import js.npm.express.Session;
import js.npm.connect.support.Middleware;
import js.npm.express.Static;
import js.npm.mongoose.macro.Manager;
import js.npm.mongoose.macro.Model;
import js.npm.mongoose.Mongoose;
import js.npm.Mongoose.mongoose;
import js.npm.mongoose.Query;
import js.support.Error;
import me.cunity.debug.Out;

using js.npm.express.Session;

typedef ServerOptions =
{
	@:optional var dbPath:String;
	@:optional var dbConn:Mongoose;
	@:optional var port:Int;
	@:optional var host:String;
}

typedef Menu =
{
	?name:String,
	?label:String
}

typedef Entry =
{
	?title:String,
	?content:String,
	?att:Attr,
	?tag:String,
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
	
	public var dbConn:Mongoose;
	public var router:Router;
	
	var app:Express;
	var sOpts:ServerOptions;
	var sheets:Null<Array<Sheet>>;
	
	var topMenu:Array<Menu>;
	var footerMenu:Array<Menu>;
	var dTopMenu:Deferred<Array<Menu>>;
	
	public function new(options:ServerOptions) 
	{
		app = new Express();
		app.locals.pretty = true;
		app.set('view engine', 'jade');
		sOpts = options;
		var compress = Node.require('compression');
		app.use(compress());  
		var secret = 'something!NEW666';
		app.use( new CookieParser(secret));
		app.use( new Session( { secret:secret } ));
		//router = new Router();
		var express = Node.require('express');
		topMenu = new Array();
		footerMenu = new Array();
		
		dbConn = mongoose.connect(options.dbPath);
		//Out.dumpObject(dbConn);
		var sheetMan:SheetManager = SheetManager.build(dbConn, 'Sheet');
		Out.dumpObject(sheetMan);
		app.use(new Static('public'));
		app.all('/',function(req:Request ,res: Response, next:MiddlewareNext)
		{
			var session = req.session();
			if( session.n == null ){
				session.n = 1;
			}
			res.locals.isAjax = req.xhr;
			var se:Array<Dynamic> = untyped app._router.stack;

			trace( req.originalUrl + '<br>req.xhr:' + req.xhr + '<br>');
			
			if (req.param('init') || (!req.xhr && (req.originalUrl == '/' || req.originalUrl == '/index')))
			{
				trace('home');
				res.render('home', { title: 'Der Gesunde Hund', topMenu:topMenu, footerMenu:footerMenu });
				res.end();												
				return;
			}
			next();
			//
		});
		var resultSet:Query<Array<Sheet>> = sheetMan.find( { }, loadSheets);		

	}
	
	function loadSheets(err:Null<Error>, sheets:Null<Array<Sheet>>):Void
	{
		this.sheets = sheets;
		footerMenu = new Array();
		
		trace(sheets.length);
		for (sheet in sheets)
		{
			trace(sheet.name + ':');
			if (sheet.name == 'index')
				sheet.name = 'home';
				//continue;
			footerMenu.push({name:sheet.name, label:sheet.name.substr(0, 1).toUpperCase() + sheet.name.substr(1)});
			app.all('/' + sheet.name, function(req:Request , res:Response, next:MiddlewareNext)
			{
				trace(req.route.path);
				res.locals.isAjax = req.xhr;
				if (req.param('init') || !req.xhr)
				{
					trace('first load');
					res.render(req.route.path.substr(1), { title: 'Der Gesunde Hund', topMenu:topMenu, footerMenu:footerMenu });
					res.end();
					return;
				}
				res.render(req.route.path.substr(1), 
					{ title:  req.route.path.substr(1) , topMenu:[], footerMenu:[] } );
				res.end();
			});
			
			for (e in sheet.entries)
				trace(e.title + ':' + e.content);
		}	
		//trace('topMenu:' + topMenu);
		var port:Int = sOpts.port == null ? 4040 : sOpts.port;
		var host:String = sOpts.host == null ? Node.require('os').hostname() : sOpts.host;
		trace('$host is listening on $port :)');
		app.listen(port);
	}
	
	/*function renderRoot(res:Response):Void
	{	
		res.render('index', { title: 'DerGesundeHund.de', topMenu:topMenu, 
			content:jade.renderFile('views/home.jade', {})});
		res.end();			
	}*/
	
}