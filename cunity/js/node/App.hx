package me.cunity.js.node;
import js.Node;
import js.node.http.ClientRequest;
import js.node.http.ServerResponse;
import js.npm.Express;
import js.npm.express.Request;
import js.npm.express.Session;
import js.npm.connect.support.Middleware;
import js.npm.express.Static;
import me.cunity.debug.Out;

typedef ServerOptions =
{
	@:optional var port:Int;
	@:optional var host:String;
}
/**
 * ...
 * @author axel@cunity.me
 */
class App extends Express
{

	public function new(options:ServerOptions) 
	{
		super();
		var secret = 'something!NEW666';
		use( new js.npm.express.CookieParser(secret));
		use( new Session( { secret:secret } ));
		all('/', function(req:Request ,res:ServerResponse, next:MiddlewareNext)
		{
			var session = untyped req.session();
			Out.dumpObject(session);
		});
		use(new Static('.'));
		var port:Int = options.port == null ? 4040 : options.port;
		var host:String = options.host == null ? Node.require('os').hostname() : options.host;
		trace('$host is listening to $port :)');
	}
	
}