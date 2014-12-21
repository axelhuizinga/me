package me.cunity.service;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */
#if php
import me.cunity.php.dom.DOMDocument;
import php.FileSystem;
#end

 enum AuthStatus
{
	AuthAdmin;
	AuthUser;
	Guest;
}

class Auth 
{
	#if (php||neko)
	public static function checkStatus(name:String, password:String, login:Bool = false):Bool
	{
		var userExists:Bool = FileSystem.exists(Service.instance.dataDir + '/users/' + name );
		if (userExists)
		{
			var userData:DOMDocument = new DOMDocument();
			//var userData:Xml = new Xml.parse(Service.instance.dataDir + '/users/' + name);
			userData.load(Service.instance.dataDir + '/users/' + name);
			if (password != userData.documentElement.getAttribute('password'))
			//if (password != userData.firstElement().get('password'))
			{
				Service.response.hasError = true;
				Service.response.errorContent += Localizer.getSystemTemplate(['errPasswordMatch']) + '<br/>';
				return true;
			}
			Service.instance.errLog(Std.string(Date.now().getTime() - Std.parseFloat(userData.documentElement.getAttribute('lastAccess'))));
			Service.instance.errLog(Date.now().getTime() +' - ' + Std.parseFloat(userData.documentElement.getAttribute('lastAccess')));
			if (
				(Date.now().getTime() - Std.parseFloat(userData.documentElement.getAttribute('lastAccess')) < Service.MAX_IDLE_TIME) 	
				//(Date.now().getTime() - Std.parseInt(userData.firstElement().get('lastAccess')) < Service.MAX_IDLE_TIME) 	
				&&
				//(Date.now().getTime() - Std.parseInt(userData.firstElement().get('lastLogin')) < Service.MAX_LIFE_TIME) 
				(Date.now().getTime() - Std.parseFloat(userData.documentElement.getAttribute('lastLogin')) < Service.MAX_LIFE_TIME) 
			) 
			{//SESSION VALID
				Service.response.authStatus = userData.documentElement.hasAttribute('admin') ? AuthAdmin :AuthUser;
				if (login)
				{
					userData.documentElement.setAttribute('lastLogin', Std.string(Date.now().getTime()));
				}
				userData.documentElement.setAttribute('lastAccess', Std.string(Date.now().getTime()));
			}
		}
		else
		{
			Service.response.hasError = true;
			Service.response.errorContent += Localizer.getSystemTemplate(['errUserNotExists']) + '<br/>';			
		}
		return userExists;
	}
	#end	
}