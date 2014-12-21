package me.cunity.app;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class Cookie 
{

    var cookies :Map<String, String>;
	
	public function new() :Void
	{
		#if !js
		cookies = Web.getCookies();
		#else
		cookies = js.Cookie.all();
		#end
	}
	
	public function all() :Map<String, String>
    {
		return cookies;
    }
    
    public function exists(name:String) :Bool
    {
		return cookies.exists(name);
    }
    
    public function get(name:String) :Dynamic
    {
		return cookies.get(name);
    }
	
	public function set(name:String, value:Dynamic, ?expire:Date, ?path:String, ?domain:String) :Void
	{
		cookies.set(name, value);
		
		#if !js
		Web.setCookie(name, value, expire, domain, path);
		#else
		js.Cookie.set(name, value, expire != null ? Std.int((expire.getTime() - Date.now().getTime()) / 1000) :null, path, domain);
		#end
	}
    
    public function remove(name:String, ?path:String, ?domain:String) :Void
    {
        cookies.remove(name);
		
		#if !js
		if (exists(name))
		{
			set(name, null, new Date(2000,1,1,0,0,0), domain, path);
		}
        #else
		js.Cookie.remove(name, path, domain);
        #end
    }
}