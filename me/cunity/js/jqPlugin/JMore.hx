package me.cunity.js.jqPlugin;

/**
 * ...
 * @author axel@cunity.me
 */
extern class JMore implements js.jquery.Plugin
{
	//public function fileDownload(url:String, options:Dynamic):js.jquery.JQuery;
	
	static public function fileDownload(url:String, options:Dynamic):JQuery
	{
		return this.fileDownload(url, options);
	}

}