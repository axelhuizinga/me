package me.cunity.app;
import me.cunity.app.data.Oracle;
//import me.cunity.app.data.OracleData;
import me.cunity.app.data.OracleDataDisplay;
import me.cunity.app.data.OracleTypes;
//import me.cunity.app.IGingOracle;

interface IGingOracleIface 
{
	//public function allSigns():String;
	//public function ask(question:String = ''):String;
	public function ask(question:String = ''):OracleDataDisplay;
	public function showSign(oracle:Oracle, asked:Bool = true):String;
	public function getHistory(hC:HistoryConstraint = null):List<OracleDataDisplay>;	
}