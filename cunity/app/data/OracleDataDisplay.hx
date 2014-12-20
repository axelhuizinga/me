package me.cunity.app.data;

import me.cunity.app.data.OracleTypes;

typedef OracleDisplayData =
{
	var date:Date;
	var signIndex:Int;
	var changeIndex:Int;
	var changeLines:haxe.EnumFlags<Lines>;
	var question:String;
	var uID:String;	
}

class OracleDataDisplay 
{
	public var date:Date;
	public var signIndex:Int;
	public var changeIndex:Int;
	public var changeLines:haxe.EnumFlags<Lines>;
	public var oID:Int;
	public var question:String;
	public var uID:String;

	public function new(data:OracleDisplayData) 
	{
		date = data.date;
		signIndex = data.signIndex;
		changeIndex = data.changeIndex;
		changeLines = data.changeLines;
		question = data.question;
		uID = data.uID;
	}
	
	public function show():OracleDataDisplay
	{
		return this;
	}
	
}