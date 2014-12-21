/**
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.service;
import haxe.Timer;
import me.cunity.php.dom.DOMDocument;
import php.FileSystem;
import php.Session;
import php.Web;
import me.cunity.service.Auth;

class User 
{
	static var userList:Array<String>;	
	static var name:String;
	static var password:String;
	
	public static function logout(name:String, password:String):Void
	{
		
		//untyped __call__('error_log', 'method:' + Service.response.method);
	}
	
	public static function login(name:String, password:String):Void
	{
		Auth.checkStatus(name, password, true);
	}
	
	public static function register(name:String, email:String, password:String):Void 
	{
		
		if(!Util.isValidName(name))
		{
			Service.response.hasError = true;
			Service.response.errorContent += Localizer.getSystemTemplate(['errUserName']) + '<br/>';
			
		}
		if (!Util.isValidEmail(email))
		{
			Service.response.hasError = true;
			Service.response.errorContent += Localizer.getSystemTemplate(['errEmailInvalid']) + '<br/>';
		}
		
		if (Service.response.hasError)
		{
			return;			
		}
		var userExists:Bool = FileSystem.exists(Service.instance.dataDir + '/users/' + name );
		Service.instance.errLog( 'userExists:' + Std.string(userExists) + ':' + Service.instance.dataDir + '/users/' + name);
		if (!userExists) {
			var admin:Bool = (FileSystem.readDirectory(Service.instance.dataDir + '/users').length == 0);
			var userData:DOMDocument = new DOMDocument();
			userData.loadXML('<?xml version="1.0" encoding="utf-8" ?><user />');
			if (admin)
			userData.documentElement.setAttribute('admin', '1');
			userData.documentElement.setAttribute('email', email);
			userData.documentElement.setAttribute('created', Date.now().toString()); 
			userData.documentElement.setAttribute('lastAccess', Std.string(Date.now().getTime())); 
			userData.documentElement.setAttribute('lastLogin', Std.string(Date.now().getTime())); 
			//var password:String = Md5.encode(Web.getClientIP());
			//userData.documentElement.setAttribute('password', Md5.encode(password));
			userData.documentElement.setAttribute('password', password);
			if ( userData.save(Service.instance.dataDir + '/users/' + name) == 0) {
				Service.response.hasError = true;
				Service.response.errorContent += Localizer.getSystemTemplate(['errUserDataSave']) + '<br/>';
				return;
			}
			Service.response.authStatus = userData.documentElement.hasAttribute('admin') ? AuthAdmin :AuthUser;
			//user created - set status to logged in and proceed ok
			//Service.response.method = 'redirect';
			//Service.response.redirectPath = 'user/welcome';
			return;
		}		
		else
		{
			
			Service.response.hasError = true;
			//Service.instance.errLog(Localizer.getSystemTemplate( ['errUserExists']));
			Service.response.errorContent += Localizer.getSystemTemplate(['errUserExists'], {name:name}) + '<br/>';
		}
	}
	
	public static function resetPassword(email:String):Void 
	{		
		var mail:Mail = new Mail('service@cunity.me', email, 'Registration');
		mail.addContent('text/html', Localizer.process('user/recoverPassword.xml', 
			{
				name:name,
				password:password
			}
		));
		mail.send();
	}
	
}