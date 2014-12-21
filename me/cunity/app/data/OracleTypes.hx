package me.cunity.app.data;

enum Lines
{
	ONE;
	TWO;
	THREE;
	FOUR;
	FIVE;
	SIX;
}


typedef HistoryConstraint = 
{
	var uID:Int;
	@:optional var start:Date;
	@:optional var end:Date;
	@:optional var question:String;
}

/*
class OracleTypes 
{

	public function new() 
	{
		
	}
	
}*/