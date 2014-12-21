package me.cunity.app.data;
import me.cunity.app.data.OracleTypes;
import me.cunity.debug.Out;

import sys.db.Mysql;
import sys.db.Object;
import sys.db.Types;
//import sys.db.SpodInfos;

import me.cunity.app.Types;



class OracleData extends Object
{

	public var date:Date;
	public var signIndex:Int;
	public var changeIndex:Int;
	public var changeLines:SSmallFlags<Lines>;
	@:id public var oID:SId;
	public var question:String;
	public var uID:Int;
	

	
	public static function getOracleData(hct:HistoryConstraint):List<OracleData>
	{
		/*var od:OracleData = 
		{
			date:this.date,
			signIndex:this.signIndex,
			changeIndex:this.changeIndex,
			changeLines:this.changeLines,
			question:this.question,
			uID:this.uID
		};*/
		
		return OracleData.manager.search($date >= hct.start && $date <= (if( hct.end == null) $now() else hct.end) && {uID:hct.uID });
	}
	
	public static function saveOracleData(oracle:Oracle):OracleData
	{
		
		var od:OracleData = new OracleData();
		
		od.date = oracle.date;
		od.signIndex = oracle.signIndex;
		od.changeIndex = oracle.changeIndex;
		od.changeLines = oracle.changeLines;
		od.question = oracle.question;
		od.uID = oracle.uID;
		od.insert();
		return od;
	}	

}
