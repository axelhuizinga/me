package me.cunity.js;
import js.JQuery;

/**
 * ...
 * @author axel@cunity.me
 */

extern class Upload 
{
	static inline function filedrop(j:JQuery, opt:Dynamic = null) :JQuery
		return untyped j.filedrop(opt);
}