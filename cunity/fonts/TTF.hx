/**
 *
 * @author Axel Huizinga - axel@cunity.me
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

package me.cunity.fonts;
import me.cunity.tools.StringTool;
#if neko 
import neko.io.File;
#elseif php 
import php.io.File
#end;

class TTF
{

	public function new() 
	{
		
	}
	
	private function dec2hex(dec:Int):String {
		return StringTools.hex(dec, 2).toUpperCase();
	}
	
	public function getInfo(ttf:String) :Map<String>{
		//trace(ttf);
		//var font:String = #if neko neko.io.File.getContent(ttf) #elseif php php.io.File.getContent(ttf) #end;
		var font:String = File.getContent(ttf);
		//trace(ttf + ':' + font.length);
		if (font == '') throw ('ooops - font file ' + ttf + ' no data');
		var number_of_tabs:String = dec2hex(font.charCodeAt(4)) + dec2hex(font.charCodeAt(5));
		var offset_name_table_dec:Int = null;
		var offset_storage_dec:Int = null;
		var number_name_records_dec:Int = null;
		var copyright:String = null;
		var fontfamily:String = null;
		var fontsubfamily:String = null;
		var fullfontname:String = null;		
		try {
			//trace(number_of_tabs + ':' + Std.parseInt('0x'+number_of_tabs));
		for (i in 0...Std.parseInt('0x'+number_of_tabs)){
			var tag = font.charAt(12 + i * 16) + font.charAt(12 + i * 16 + 1) +font.charAt(12 + i * 16 + 2) +
				font.charAt(12 + i * 16 + 3);
			//trace(tag);
			if (tag == 'name') {
				var offset_name_table_hex:String = dec2hex(font.charCodeAt(12+i*16+8))
					+ dec2hex(font.charCodeAt(12+i*16+8+1))
					+ dec2hex(font.charCodeAt(12+i*16+8+2))
					+ dec2hex(font.charCodeAt(12+i*16+8+3));
				//trace(offset_name_table_hex);
				offset_name_table_dec = Std.parseInt('0x'+offset_name_table_hex);
				var offset_storage_hex = dec2hex(font.charCodeAt(offset_name_table_dec+4))
					+ dec2hex(font.charCodeAt(offset_name_table_dec+5));
				//trace(offset_storage_hex);
				offset_storage_dec = Std.parseInt('0x'+offset_storage_hex);
				var number_name_records_hex:String = dec2hex(font.charCodeAt(offset_name_table_dec+2))
					+ dec2hex(font.charCodeAt(offset_name_table_dec+3));
				number_name_records_dec = Std.parseInt('0x'+number_name_records_hex);
				break;
			}
		}
		//trace(offset_storage_dec +' - ' + offset_name_table_dec);
		var storage_dec = offset_storage_dec + offset_name_table_dec;
		var storage_hex = StringTools.hex(storage_dec);	
	

		for (j in 0... number_name_records_dec) {
			var platform_id_hex = dec2hex(font.charCodeAt(offset_name_table_dec + 6 + j * 12 + 0)) + 
				dec2hex(font.charCodeAt(offset_name_table_dec+6+j*12+1));
			var platform_id_dec = Std.parseInt('0x'+platform_id_hex);
			var name_id_hex = dec2hex(font.charCodeAt(offset_name_table_dec + 6 + j * 12 + 6)) +
				dec2hex(font.charCodeAt(offset_name_table_dec+6+j*12+7));
			var name_id_dec = Std.parseInt('0x'+name_id_hex);
			var string_length_hex = dec2hex(font.charCodeAt(offset_name_table_dec + 6 + j * 12 + 8)) +
				dec2hex(font.charCodeAt(offset_name_table_dec+6+j*12+9));
			var string_length_dec = Std.parseInt('0x'+string_length_hex);
			var string_offset_hex = dec2hex(font.charCodeAt(offset_name_table_dec + 6 + j * 12 + 10)) +
				dec2hex(font.charCodeAt(offset_name_table_dec+6+j*12+11));
			var string_offset_dec = Std.parseInt('0x'+string_offset_hex);
			if (name_id_dec==0 && null ==copyright){
				copyright='';
				for(l in 0...string_length_dec){
					if (font.charCodeAt(storage_dec+string_offset_dec+l)!=0){
						// skip null bytes
						copyright+=font.charAt(storage_dec+string_offset_dec+l);
					}
				}
			}
			if (name_id_dec==1 && null ==fontfamily){
				fontfamily='';
				for(l in 0...string_length_dec){
					if (font.charCodeAt(storage_dec+string_offset_dec+l)!=0){
						// skip null bytes
						fontfamily+=font.charAt(storage_dec+string_offset_dec+l);
					}
				}
			}
			if (name_id_dec==2 && null ==fontsubfamily){
				fontsubfamily='';
				for(l in 0...string_length_dec){
					if (font.charCodeAt(storage_dec+string_offset_dec+l)!=0){
						// skip null bytes
						fontsubfamily+=font.charAt(storage_dec+string_offset_dec+l);
					}
				}
			}
			if (name_id_dec==4 && null ==fullfontname){
				fullfontname ='';
				for(l in 0...string_length_dec){
					if (font.charCodeAt(storage_dec+string_offset_dec+l)!=0){
						// skip null bytes
						fullfontname+=font.charAt(storage_dec+string_offset_dec+l);
					}
				}
			}
			if (null ==fontfamily && null ==fontsubfamily && null ==fullfontname && null ==copyright){
				break;
			}
		}
		if(null ==fullfontname || null ==fontfamily ||null ==fontsubfamily ||null ==copyright){
				var info = StringTool.pathInfo(ttf);
				if(null ==fontfamily)
					fontfamily = StringTool.ucFirst(info.get('filename'));
				if(null ==fullfontname)
					fullfontname = fontfamily;
				if(null ==fontsubfamily)
					fontsubfamily = 'Regular';
				if(null ==copyright)
					copyright = '';
			}
		}
		catch (ex:Dynamic) { trace (ex);}										
			var res = new Map<String>();
			res.set('fontfamily', fontfamily);
			res.set('fullfontname', fullfontname);
			res.set('fontsubfamily', fontsubfamily);
			res.set('copyright', copyright);
			return res;
	}
	
}