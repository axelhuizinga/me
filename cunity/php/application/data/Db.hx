/**
 *
 * @author Axel Huizinga
 * based on code from poko.Db
 * Copyright (c) 2008, TouchMyPixel & contributors
 * Original author :Tony Polinelli <tonyp@touchmypixel.com> 
 * Contributers:Tarwin Stroh-Spijer 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

package me.cunity.application.data;

import php.db.Connection;
import php.db.Mysql;
import php.db.Object;
import php.db.ResultSet;
import php.Exception;
import php.HException;
import php.Lib;
import php.Web;

class Db 
{

	public var cnx:Connection;
	public var lastError:String;
	public var lastQuery:String;
	public var lastAffectedRows:Int;
	
	
	public function new() 
	{
		
	}
	
	public function connect(database:String, user:String, password:String, host:String='localhost', ?port:Int=null, ?socket:String=null)
	{
		cnx = Mysql.connect( {
			
			host :host,
			port :port,
			user :user,
			pass :password,
			socket :socket,
			database :database
		});
	}
	
	public function query(sql:String):ResultSet
	{
		lastQuery = sql;
		return cnx.request(sql);
		//return untyped __call__("mysql_query", sql);
	}
	
	public function request(sql:String):List<Dynamic>
	{
		lastQuery = sql;
		
		var result:ResultSet  = cnx.request(sql);
		return result.results();
	}
	
	public function requestSingle(sql:String):Dynamic
	{
		lastQuery = sql;
		var result:ResultSet = cnx.request(sql);
		
		return result.next();
	}
	
	public function insert(table:String, data:Dynamic):Bool
	{
		var fields:ResultSet = cnx.request("SHOW FIELDS from `" + table + "`");
		if (fields.length == 0) {
			lastError = "DB UPDATE ERROR";
			return false;
		}
		
		var sql = "INSERT INTO `" + table + "` "; 
		var fieldNames:Array<String> = new Array();
		var fieldData:Array<String> = new Array();
		
		for (field in fields) 
		{
			var fieldName:String = field.Field;
			var variable:Dynamic = (Std.is(data, Map))  ? data.get(fieldName) :Reflect.field(data, fieldName);
			
			if (variable != null) 
			{
				fieldNames.push(fieldName);
				fieldData.push(variable);
			}
		}
		
		sql += "(";
		
		var c:Int = 0;
		for (f in fieldNames) {
			if (c > 0) sql += " , ";
			sql += "`" + f + "`";
			c++;
		}
		
		sql += ") VALUES (";
		
		var c = 0;
		for (d in fieldData) {
			if (c > 0) sql += " , ";
			sql += cnx.quote(d);
			c++;
		}
		
		sql += ")";
		
		lastQuery = sql;
		var request = cnx.request(sql);
		lastAffectedRows = request.length;
		
		return true;
	}
	
	public function update(table:String, data:Dynamic, where:String):Bool
	{
		var sql = "SHOW FIELDS from `" + table + "`";
		var fields:ResultSet = null;
		try {
			
			fields = cnx.request(sql);
		} catch (e:Dynamic)
		{
			trace(sql);
			throw(e);
		}
		
		
		if (fields.length == 0) {
			lastError = "DB UPDATE ERROR";
			return false;
		}
		
		var sql = "UPDATE `" + table + "` SET "; 
		var c:Int = 0;
		for (field in fields) 
		{
			var fieldName:String = field.Field;
			var variable:Dynamic = (Std.is(data, Map))  ? data.get(fieldName) :Reflect.field(data, fieldName);
			
			if (variable != null) 
			{
				if (c > 0) sql += " , ";
				sql += " `"+fieldName+"`=" + cnx.quote(variable);
				c++;
			}
		}
		
		sql += " WHERE " + where;
		
		lastQuery = sql;
		
		lastAffectedRows = cnx.request(sql).length; 		
		
		return true;
	}
	
	
	
	public function delete(table:String, where:String):Bool
	{
		var sql = "DELETE FROM `"+table+"` WHERE " + where;
		
		lastQuery = sql;
		
		lastAffectedRows = cnx.request(sql).length; 
		
		return true;
	}
	
	
	public function count(table:String, ?where:String = ""):Int
	{
		var sql = "SELECT COUNT(*) as count FROM `" + table + "` WHERE " + where;
		
		lastQuery = sql;
		
		var result:ResultSet = cnx.request(sql); 
		
		return result.next().count;
	}
	
	public function exists(table:String, ?where:String = ""):Bool
	{
		return count(table, where) > 0;
	}
	
}