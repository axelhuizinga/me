package me.cunity.js;

import haxe.ds.StringMap;
import haxe.Log;
import haxe.remoting.Connection;
import js.Browser;
import js.html.*;
import js.JQuery;
import js.Lib;
import me.cunity.debug.Out;
import me.cunity.php.applet.IMediaServiceApi;

import haxe.remoting.HttpAsyncConnection; 
import haxe.remoting.HttpConnection; 

using me.cunity.js.Upload;
using js.JQuery;


/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

class MediaServiceImpl extends haxe.remoting.AsyncProxy<me.cunity.php.applet.IMediaServiceApi> { } 

class MediaClient //implements IMediaClient
{
	
	var topWin:DOMWindow;
	var mediaService:MediaServiceImpl;
	
	public static function main()
	{
		Out.traceTarget = DebugOutput.CONSOLE;
		untyped Browser.document.defaultView.debugging = true;
		Log.trace = Out._trace;
		trace('hello world');
		var mC:MediaClient = null;
		untyped Browser.document.defaultView.mediaClient = mC = new MediaClient();
		trace('mediaClient.initDropzone ' + Type.typeof(untyped Browser.document.defaultView.mediaClient.initDropzone) + ':' 
		+ Type.typeof(mC.initDropzone ));
	}
	
	public function initDropzone()
	{
		trace('dataRoot:'+ 'body'.J().attr('data-root') + 'upload?uID=' + 'body'.J().attr('data-uID'));
		//new JQuery('#dropzone').filedrop( { 
		'#dropzone'.J().filedrop( { 
			fallback_id:'fileupload',    // an identifier of a standard file input element
			maxfilesize:untyped topWin.maxfilesize,
			url:'body'.J().attr('data-root') + 'upload?uID=' + 'body'.J().attr('data-uID'),    
			//uID:'body'.J() .attr('data-uID'),
			//pass:'body'.J() .attr('data-pass'),
			uploadStarted:function(i, file, len){
				// a file began uploading
				// i = index => 0, 1, 2, 3, 4 etc
				// file is the actual file of the index
				// len = total files user dropped
				trace(i + ':uploadStarted' + ':' + len);
			},
			uploadFinished:function(i, file, response, time) {
				// response is the data you got back from server in JSON format.
				trace(time+':'+' file:'+file+' response:' + response );
				Out.dumpObject(file);
				Out.dumpObject(response);
			},
			progressUpdated:function(i, file, progress) {
				// this function is used for large files and updates intermittently
				// progress is the integer value of file being uploaded percentage to completion
				trace(i + ':' + file.name + ':' + progress);
			}
		} );		
		trace('urlConnect:' + 'body'.J() .attr('data-root'));
		return;

		//var dData:Map<Dynamic> = mediaService.getAlbum('fotos');
		//trace('dData:' + dData.toString);		
	}
	
	public function new()
	{
		topWin = Browser.document.defaultView;
		trace('hello world');
		var cnx = HttpAsyncConnection.urlConnect('body'.J() .attr('data-root'));
		//var cnx = HttpSessionAsyncConnection.urlConnect('body'.J() .attr('data-root'));
		//var cnx = HttpConnection.urlConnect('body'.J() .attr('data-root'));
		mediaService = new MediaServiceImpl(cnx.mediaservice);		
		//cnx.setErrorHandler(processServerSideError);
	
		//cnx.mediaservice.call(['fotos'], displayAlbum);
		//mediaService.init('fotos', function(r) trace(r));
		//mediaService.init(Lib.window.mediaPath);
		//mediaService.getAlbum(function(h:Map<String>) displayAlbum(h.toString()));
		//trace(mediaService.currentAlbum);

		//var dData:Map<String> = mediaService.getAlbum('fotos');
		//displayAlbum(dData.toString());
		//mediaService.getAlbum('fotos', function(h:Map<String>) displayAlbum(h.toString()));
		//var d:Dynamic = mediaService.getAlbum(
		//var h:Map<String> = mediaService.getAlbum();
		//displayAlbum(h.toString());
		//mediaService.init('fotos');
	}
	
	static function processServerSideError(error:Dynamic):Void
	{
	  trace (error);
	}	
	
	//public function displayAlbum(albumContent:Map<Dynamic>):Void
	static function displayAlbum(albumContent:StringMap<Dynamic>):Void
	{
		trace(albumContent.toString());
		//jQx('#albumDisplay').html('<pre>'+albumContent.toString()+'</pre>');
	}
	
}