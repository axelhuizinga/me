/**
 * 
 * @author axel@cunity.me
 *
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

package me.cunity.debug;
import flash.events.TimerEvent;
import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.Timer;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap.StringMap;

class MemoryTracker { 
	/// This is a facility to track the lifetime of specific objects 
	static private var dict :Dictionary; 
	static private var keys :ObjectMap<Dynamic,Int>; 
	static private var uniqueKeys :StringMap<Dynamic>; 
	static private var timer :Timer; 
	static public var lastTrace :String;

	/// Call this with objects that you would like to track, and an ID to identify it 
	static public function track(obj :Dynamic, key :String) :Void 
	{ 
		initTrackerIfNecessary(); 
		if (untyped dict[obj] == key) 
		{ 
			// OK, we are already tracking it 
			return; 
		}

		// We count the number of keys with this value so we can get unique ids 
		var count = keys.get(key); 
		if (count == null) { count = 1; } 
		else { count++; } 
		keys.set(key, count);

		// Now we have a unique key 
		var uniqueKey = key + " " + count; 
		trace("Start tracking " + uniqueKey + ' mem:' + (System.totalMemory / (1024 * 1024))); 
		uniqueKeys.set(uniqueKey, key); 
		// And make the weak reference to the object 
		untyped dict[obj] = uniqueKey; 
	} 
	
	static function initTrackerIfNecessary() 
	{
		if (dict == null) 
		{ 
			// We use weak references as a trick to monitor lifetime of objects 
			dict = new Dictionary(true); 
			keys = new ObjectMap<Dynamic,Int>(); 
			uniqueKeys = new StringMap<Dynamic>(); 
			timer = new Timer(250); 
			timer.addEventListener(TimerEvent.TIMER, onTimer,false,0,true); 
			timer.start();
		} 
	} 
	
	static function onTimer(event :TimerEvent) :Void 
	{ 
		var seenKeys :ObjectMap<Dynamic, Int> = new ObjectMap<Dynamic, Int>(); 
		var t :Array<Dynamic> = untyped __keys__(dict); 
		for (k in t) { var v = untyped dict[k]; seenKeys.set(v, 0); }

		var releaseKeys :Array<String> = new Array<String>(); 
		for (k in uniqueKeys.keys()) 
		{ 
			if (!seenKeys.exists(k)) 
				releaseKeys.push(k);
		} 
		if (releaseKeys.length > 0) 
		{ 
			trace(releaseKeys.join(", ") + " has been garbage collected"); 
			for (k in releaseKeys) 
			{ 
				var key = uniqueKeys.get(k); 
				uniqueKeys.remove(k); 
				var c = keys.get(key); 
				--c; 
				if (c == 0) 
				{ 
					keys.remove(key); 
					trace("No more objects of " + key + " remain");
				} 
				else 
				{ 
					keys.set(key, c);
				}
			}
		}
	} 
	
	public function new() {}
	
}