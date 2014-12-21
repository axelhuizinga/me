package me.cunity.app.data;

import me.cunity.app.data.OracleTypes;
import me.cunity.debug.Out;


class Oracle 
{

	public var date:Date;
	public var signIndex:Int;
	public var changeIndex:Int;
	public var changeLines:haxe.EnumFlags<Lines>;
	public var question:String;
	public var uID:Int;

	static var un:Array<String> = [ "Das Schöpferische","Der Friede","Begrenzter Einfluß","Die Macht des Großen","Der Besitz von Großem","Das Warten","Der Durchbruch","Des Großen Zähmungskraft","Die Stockung","Das Empfangende","Die Betrachtung","Die Begeisterung","Der Fortschritt","Das Zusammenhalten","Die Sammlung","Die Zersplitterung","Das Entgegenkommen","Das Empordringen","Das Sanfte","Die Dauer","Der Tiegel","Der Brunnen","Des Großen Übergewicht","Die Arbeit am Verdorbenen","Die Unschuld","Die Wiederkehr","Die Mehrung","Das Erregende","Das Durchbeißen","Die Anfangsschwierigkeit","Die Nachfolge","Die Ernährung","Die Gemeinschaft mit Menschen","Die Verfinsterung des Lichts","Die Familie","Die Fülle","Das Haftende","Die Vollendung","Die Umwälzung","Die Anmut","Der Streit","Das Heer","Die Auflösung","Die Befreiung","Das Unvollendete","Das Abgründige","Die Bedrängnis","Die Jugendtorheit","Das Auftreten","Die Annäherung","Innere Wahrheit","Das Heiratende Mädchen","Der Gegensatz","Die Beschränkung","Das Heitere","Die Minderung","Der Rückzug","Die Bescheidenheit","Die Entwicklung","Des Kleinen Übergewicht","Der Wanderer","Das Hemmnis","Die Werbung","Das Stillehalten" ];
	static var nIndex:Array<Int> = [ 1, 11, 9, 34, 14, 5, 43, 26, 12, 2, 20, 16, 35, 8, 45, 23, 44, 46, 57, 32, 50, 48, 28, 18, 25, 24, 42, 51, 21, 3, 17, 27, 13, 36, 37, 55, 30, 63, 49, 22, 6, 7, 59, 40, 64, 29, 47, 4, 10, 19, 61, 54, 38, 60, 58, 41, 33, 15, 53, 62, 56, 39, 31, 52 ];
	
	static var hzeich:Array<Dynamic> = [
		[ 1,1,1,"Der Himmel" ],
		[ 0,0,0,"Die Erde" ],
		[ 0,1,1,"Der Wind" ],
		[ 1,0,0,"Der Donner" ],
		[ 1,0,1,"Das Feuer" ],
		[ 0,1,0,"Das Wasser" ],
		[ 1,1,0, "Der See" ],
		[ 0,0,1,"Der Berg" ]
	]; 
	
	var lin:Array<Int>;
	var wlin:Array<Int>;
	static var u:Array<Dynamic>;
	static var lineImg:Array<String> = ["design/6.jpg","design/7.jpg","design/8.jpg","design/9.jpg"];
	public var strichsumme:Array<Int>;// = [0, 0, 0, 0, 0, 0];
	public var zname:String;
	public var wname:String;
	public var zbild:Array<String>;
		
	function init() 
	{ 
		//trace(hzeich[0].join(' '));
		strichsumme =  [];
		u =  [];
		var zid = 0;
		for (uhz in 0...8){ 
			for (ohz in 0...8) { 
				//trace(uhz + ' ' + ohz);
				u[zid]=[];
				for (t in 0...3){ 
					u[zid][t] = hzeich[uhz][t];
				//trace(zid + ':' +hzeich[uhz][t]);					
				}
				for(t in 3...6){
					u[zid][t]=hzeich[ohz][t-3];
				//trace(zid + ':' +hzeich[ohz][t-3]);
				}		
				zid++;
			}		
		}		
	}
	
	public function ustrich(strich:Int,il:Int,?wil:Int) :Void
	{
		//trace('wil:' + (wil != null  ? 'Y':'N') + ':' +  Std.string(wil));
		if(wil != null ){
			wlin[strich-1] = wil;
		}
		//else
		lin[strich-1] = il;
	}

	public function test(w) :Void
	{
		trace(lin.length + ':' + lin.join(''));
		for (t in 0...64)
		{
			if (u[t].join('') == lin.join('')) { 
				zname = un[t];
				signIndex = nIndex[t];
				trace(zname + ':' + Std.string(t) + ':' + u[t].join(''));
				break;
			}
		}
		//trace('wlin:' + Std.string(wlin) + (w?'W':'N'));
		if(w){ 
			for (t in 0...64)
			{
				if (u[t].join('') == wlin.join('')) {
					wname = un[t];
					changeIndex = nIndex[t];		
					trace(wname + ':' + Std.string(t) + ':' + wlin.join(''));
					break;
				}
			}

		}
		else{
			wname = "";
		}
		//trace(strichsumme.toString() + ':' + strichsumme.length);
		//trace(zbild.join('') + ':' + zbild.length);
	}

	public function new() 
	{
		init();
		trace('OK');
		//#if !js
		
	}
	
	public function ask()
	{		
		lin = [ ];
		wlin = [ ];
		zbild = [ ];
		date = Date.now();
		wlin= [];
		var element = 0;
		var stengel = 49;
		var wandel = false;
		var wandlung = 0;
		var teiler = 0;
		var linkerh = 0;
		var rechterh = 0;
		var lrest = 0;
		var rrest = 0;
		var esumme = 0;
		var wert = 0;
		var il = 0;
		var li = 0;
		var wil = 0;
		//changeLines.init();
		changeLines = new haxe.EnumFlags(0);
		var strich = 7;
		
		while (strich-- > 1) 
		{
			strichsumme[strich] = 0;
			stengel = 49;
			for (element in 1...4)
			{
				wert = 0;
				var obergrenze = stengel - 1;
				teiler = untyped __call__('mt_rand', 1,obergrenze-1);
				linkerh = teiler;
				rechterh = obergrenze - teiler;
				lrest = linkerh % 4;
				if (lrest == 0)  lrest = 4;
				rrest = rechterh % 4;
				if (rrest == 0)  rrest = 4 ;
				esumme = rrest + lrest + 1;
				stengel = stengel - esumme;
				if (element == 1) esumme = esumme -1;
				if (esumme == 8) wert = 2;
				if (esumme == 4) wert = 3;
				strichsumme[strich] = strichsumme[strich] + wert;
			}
			
			if (strichsumme[strich] == 6 || strichsumme[strich] == 9 ) 
			{
				changeLines.set(Type.createEnumIndex(Lines,strich-1));
				wandel = true;
			}
		}
		for (strich in 1...7) {
			switch(strichsumme[strich])  
			{
				case 6:
				li=0;
				il=0;
				wil=1;
				wandlung = 1;
				case 7:
				wandlung = 1;
				wil=1;
				li=1;
				il=1;
				case 8:
				wandlung = 2;
				wil=0;
				li=2;
				il=0;
				case 9:
				wandlung = 2 ;
				li=3;
				il=1;
				wil = 0;
				default:
				trace('this should not happen:' + strich + ':' + strichsumme[strich]);
			}
			if (wandel){
				zbild[6 - strich] = lineImg[li];// line index 5 - 0
				zbild[12 - strich] = lineImg[wandlung];// line index 11 - 6 for the change lines
				//trace('wil:' + Std.string(wil));
				ustrich(strich,il,wil);
			}	
			else{
				zbild[6 - strich] = lineImg[li];
				ustrich(strich,il);
			}
		}
		test(wandel);
	}
	
	public function getAllSigns():String
	{
		var hSigns = 
		[
			[7,7,7],
			[7,8,8],
			[8,8,7],
			[7,7,8],
			[8,7,7],
			[7,8,7],
			[8,7,8],
			[8,8,8]
		];
		var allSigns = '
			<table  class="allSigns">';
		for (row in 0...8) 
		{
			allSigns += "<tr>\n";
			for (col in 0...8)
			{
				var lines:Array<Int> = hSigns[row].concat(hSigns[col]);
				lin = Lambda.array(Lambda.map(lines, function(v) { return v == 7 ? 1 :0; } ));
				lin.reverse();
				var signIndex:Int = 0;
				for (t in 0...64)
				{
					if (u[t].join('') == lin.join('')) { 
						//zname = un[t];
						signIndex = nIndex[t];
						//trace(zname + ':' + Std.string(t) + ':' + u[t].join(''));
						break;
					}
				}				
				allSigns += '<td><a href="iging/zeichen/' + signIndex + '.php">\n';
				for (line in lines)
					allSigns += '<img src="iging/design/' + line + '.jpg">';
				allSigns += "</a></td>\n";
			}
			allSigns += "</tr>\n";
		}
		allSigns += "</table>";
		return allSigns;
	}
	
	/*public function getOracleData():OracleData
	{
		var od:OracleData = 
		{
			date:this.date,
			signIndex:this.signIndex,
			changeIndex:this.changeIndex,
			changeLines:this.changeLines,
			question:this.question,
			uID:this.uID
		};
		
		return od;
	}*/
}