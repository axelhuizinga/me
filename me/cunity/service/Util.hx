package me.cunity.service;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class Util 
{
	public static function isValidEmail( email :String ) :Bool
	{
		var emailExpression :EReg = ~/^[\w-\.]{2,}@[ÅÄÖåäö\w-\.]{2,}\.[a-z]{2,6}$/i;
		return emailExpression.match( email );
	}		
	
	public static function isValidName( name :String ) :Bool
	{
		return ~/^([\w\.]*)$/.match(name);
	}
	
}