/**
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package me.cunity.tools;



class ColorTools 
{

     /* Convert a uint (0x000000) to a color object.
     *
     * @param hex  Color.
     * @return Converted object {r:, g:, b:}
     */
	public static inline function rgb2int(r:Int, g:Int, b:Int):UInt
	{
		trace(StringTools.hex( ((r * 256) + g) * 256 + b));
		return ((r * 256) + g) * 256 + b;
	}
	 
    public static function hexToRGB(hex:UInt):Dynamic
    {
        var c:Dynamic = {};

      // c.a = hex >> 24 & 0xFF;
        c.r = hex >> 16 & 0xFF;
        c.g = hex >> 8 & 0xFF;
        c.b = hex & 0xFF;

        return c;
    }
	
	public static function complement(org:UInt):UInt
	{
		var rgb = hexToRGB(org);
		var r = 255 - rgb.r;
		var g = 255 - rgb.g;
		var b = 255 - rgb.b;
		return rgb2int(r, g, b);
	}
	
	public static function hue_2_rgb(v1:Float ,v2:Float ,vh:Float )
	{
		if (vh < 0)
		{
			vh += 1;
		};

		if (vh > 1)
		{
			vh -= 1;
		};

		if ((6 * vh) < 1)
		{
			return (v1 + (v2 - v1) * 6 * vh);
		};

		if ((2 * vh) < 1)
		{
			return (v2);
		};

		if ((3 * vh) < 2)
		{
			return (v1 + (v2 - v1) * ((2 / 3 - vh) * 6));
		};

		return (v1);
	}
	
	public static function rgb2hsl(rgb:Dynamic):Array<Float>{
		var r = rgb.r/255;
		var g = rgb.g/255;
		var b = rgb.b/255;
		trace(Std.string(rgb));
		var min:Float = MathTools.min([r,g,b]);
		var max:Float = MathTools.max([r,g,b]);
		var delta:Float = max-min;
		var l:Float = (min+max)/2;
		var s:Float = l > 0 && l < 1 ? delta/(l < 0.5 ? (2*l):(2-2*l)):0;
		var h:Float = 0;
		if(delta > 0){
		if(max == r && max != g){
		 h += (g-b)/delta;
		}
		if(max == g && max != b){
		 h += (2+(b-r)/delta);
		}
		if(max == b && max != r){
		 h += (4+(r-g)/delta);
		}
		h /= 6;
		}
		return [h,s,l];
	}
	
	//@param HSL values from 0..1
	public static function complementary(hsl:Array<Float>):UInt
	{
		var h:Float = hsl.shift();
		var s:Float = hsl.shift();
		var l:Float = hsl.shift();
		var var_1:Float=0;
		var var_2:Float=0;
		var r:UInt;
		var g:UInt;
		var b:UInt;
		if (s == 0)
        {
			r = Std.int(l * 255);
			g = Std.int(l * 255);
			b = Std.int(l * 255);
        }
        else
        {
			h = h + 0.5;
			if (h > 1)
				h -= 1;
			if (l < 0.5)
			{
					var_2 = l * (1 + s);
			}
			else
			{
					var_2 = (l + s) - (s * l);
			};

			var_1 = 2 * l - var_2;
			r = Std.int(255 * hue_2_rgb(var_1,var_2,h + (1 / 3)));
			g = Std.int(255 * hue_2_rgb(var_1,var_2,h));
			b = Std.int(255 * hue_2_rgb(var_1,var_2,h - (1 / 3)));
        }
		return rgb2int(r, g, b);
	}

     /*  // Function to convert hue to RGB, called from above

        function hue_2_rgb(v1,v2,vh)
        {
                if (vh < 0)
                {
                        vh += 1;
                };

                if (vh > 1)
                {
                        vh -= 1;
                };

                if ((6 * vh) < 1)
                {
                        return (v1 + (v2 - v1) * 6 * vh);
                };

                if ((2 * vh) < 1)
                {
                        return (v2);
                };

                if ((3 * vh) < 2)
                {
                        return (v1 + (v2 - v1) * ((2 / 3 - vh) * 6));
                };

                return (v1);
        };*/
}