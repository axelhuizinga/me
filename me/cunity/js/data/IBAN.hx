package me.cunity.js.data;

/**
 * ...
 * @author axel@cunity.me
 */

 typedef IbanError = 
 {
	var type:String;
	var message:String;
 }
 
 typedef IbanSuccess =
 {
	var iban:String;
	var iban_print:String;
	var iban_format:Dynamic;
 }

class IBAN
{

	public static function buildIBAN(account:String, bankCode:String, onSuccess:IbanSuccess->Void, onError:IbanError->Void):Void
	{
		return (untyped __js__('buildIBAN'))(account,bankCode,onSuccess,onError);
	}
	
	public static function checkIBAN(iban:String):Bool
	{
		//trace(iban +':' + (untyped __js__('checkIBAN'))(iban));
		return (untyped __js__('checkIBAN'))(iban);
	}
	
}