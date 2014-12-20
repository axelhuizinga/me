package me.cunity.service;

import haxe.remoting.HttpAsyncConnection;
import haxe.CallStack;
import me.cunity.core.Application;
import me.cunity.debug.Out;


class Client{
	
	static var url:String;
	static var cnx:HttpAsyncConnection;

    function processServerSideError(error:Dynamic):Void
    {
        trace (error);
		Out.dumpStack(CallStack.callStack());
    }
	
	public function new() 
	{
	}	
	
	public function init():ServiceProxy
	{		
		var cnx = haxe.remoting.HttpAsyncConnection.urlConnect(
			'service.php'
		);		
		cnx.setErrorHandler(processServerSideError);
		return new ServiceProxy(cnx.service);
	}	

}
