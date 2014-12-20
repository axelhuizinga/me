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

package me.cunity.graphics;
import me.cunity.tools.MathTools;

class Color 
{
	public static var _DEFAULT_WREF:Array<Float> = [0.95043, 1.00000, 1.08890];
	public static var _RybWheel = [
		0,  26,  52,
		83, 120, 130,
		141, 151, 162,
		177, 190, 204,
		218, 232, 246,
		261, 275, 288,
		303, 317, 330,
		338, 345, 352,
		360
	];

	public static var _RgbWheel = [
		0,   8,  17,
		26,  34,  41,
		48,  54,  60,
		81, 103, 123,
		138, 155, 171,
		187, 204, 219,
		234, 251, 267,
		282, 298, 329,
		360
	];
	var __a:Float;
	var __rgb:Array<Int>;
	var __hsl:Array<Float>;
	var __wref:Array<Float>;
	public var _uint(get__uint, null):UInt;
	
	public function new( values:Array<Dynamic> , mode:String = 'rgb', alpha:Float = 1.0, wref = null)
    /*Instantiate a new grapefruit.Color object.
    
    Parameters:
      :values:
        The values of this color, in the specified representation.
      :mode:
        The representation mode used for values.
      :alpha:
        the alpha value (transparency) of this color.
      :wref:
        The whitepoint reference, default is 2° D65.

    '*/
    {
		if (mode == 'rgb') {		
			__rgb = new Array().concat(values);
			__hsl = Color.RgbToHsl(values.shift(), values.shift(), values.shift());
		}
		else if (mode == 'hsl') {
		  __hsl = new Array().concat(values);
		  __rgb = Color.HslToRgb(values.shift(), values.shift(), values.shift());			
		}
		else {
			throw('Invalid color mode:' + mode);
		}

		__a = alpha;
		__wref = wref==null? [0.95043, 1.00000, 1.08890] :wref;
	}

	
	public function ComplementaryColor( mode = 'ryb'):Color
	{
		/*Create a new instance which is the complementary color of this one.
		
		Parameters:
		  :mode:
			Select which color wheel to use for the generation (ryb/rgb).
		
		
		Returns:
		  A grapefruit.Color instance.

		>>> Color.NewFromHsl(30, 1, 0.5).ComplementaryColor()
		(0.0, 0.5, 1.0, 1.0)
		>>> Color.NewFromHsl(30, 1, 0.5).ComplementaryColor().hsl
		(210, 1, 0.5)
		*/
		var h:Float = __hsl[0];
		var s:Float = __hsl[1];
		var l:Float = __hsl[2];

		if (mode == 'ryb')
			h = Color.RgbToRyb(h);
		h = (h + 180) % 360;
		if (mode == 'ryb')
			h = Color.RybToRgb(h);
		
		return new Color([h, s, l], 'hsl', __a, __wref);
	}
	
	function get__uint():UInt
	{
		trace(StringTools.hex( ((__rgb[0] * 256) + __rgb[1]) * 256 + __rgb[2]));
		return ((__rgb[0] * 256) + __rgb[1]) * 256 + __rgb[2];
	}
	
	public static function     newFromInt(hex:UInt):Color
    {
        return new Color([
			cast hex >> 16 & 0xFF,
			cast hex >> 8 & 0xFF,
			cast hex & 0xFF
		]);
    }
	
	public static function RgbToRyb(hue:Float):Float
	{
		/*'''Maps a hue on the RGB color wheel to Itten's RYB wheel.
		
		Parameters:
		  :hue:
			The hue on the RGB color wheel [0...360]
		
		Returns:
		  An approximation of the corresponding hue on Itten's RYB wheel.
		
		>>> Color.RgbToRyb(15)
		26*/
		var d:Float = hue % 15;
		var i:Int = Std.int(hue / 15);
		var x0:Float = _RybWheel[i];
		var x1:Float = _RybWheel[i + 1];
		return x0 + (x1 - x0) * d / 15;
	}
    
  public static function RybToRgb(hue:Float):Float
  {
	   /* '''Maps a hue on Itten's RYB color wheel to the standard RGB wheel.
		
		Parameters:
		  :hue:
			The hue on Itten's RYB color wheel [0...360]
		
		Returns:
		  An approximation of the corresponding hue on the standard RGB wheel.
		
		>>> Color.RybToRgb(15)
		8*/
		var d:Float = hue % 15;
		var i:Int = Std.int(hue / 15);
		var x0:Float = _RgbWheel[i];
		var x1:Float = _RgbWheel[i + 1];
		return x0 + (x1 - x0) * d / 15;
	}
	
	public static function HslToRgb(h:Float, s:Float, l:Float):Array<Int>
	{
		/*'''Convert the color from HSL coordinates to RGB.
		
		Parameters:
		  :h:
			The Hue component value [0...1]
		  :s:
			The Saturation component value [0...1]
		  :l:
			The Lightness component value [0...1]
		
		Returns:
		  The color as an (r, g, b) tuple in the range:
		  r[0...1],
		  g[0...1],
		  b[0...1]
		  
		>>> Color.HslToRgb(30.0, 1.0, 0.5)
		(1.0, 0.5, 0.0)
		
		'''*/
		if (s == 0) 
			return [Std.int(l), Std.int(l), Std.int(l)];//   # achromatic (gray)
		var n2:Float = 0;
		if (l < 0.5)
			n2 = l * (1.0 + s);
		else
			n2 = l + s - (l * s);

		var n1:Float = (2.0 * l) - n2;

		h /= 60.0;
		return [
			Color.hueToRgb(n1, n2, h + 2),
			Color.hueToRgb(n1, n2, h),
			Color.hueToRgb(n1, n2, h - 2)
		];
	}
	
	public static function hueToRgb(n1:Float, n2:Float, h:Float):Int
	{
		h %= 6.0;
		if (h < 1.0)
			return Std.int(n1 + ((n2 - n1) * h));
		if (h < 3.0)
			return Std.int(n2);
		if (h < 4.0)
			return Std.int(n1 + ((n2 - n1) * (4.0 - h)));
		return Std.int(n1);
	}
	
	//public static function  RgbToHsl(r:Float, g:Float, b:Float):Array<Float>
	public static function  RgbToHsl(r:Int, g:Int, b:Int):Array<Float>
	{
		/*Convert the color from RGB coordinates to HSL.
		Parameters:
		  :r:
			The Red component value [0...1]
		  :g:
			The Green component value [0...1]
		  :b:
			The Blue component value [0...1]
		
		Returns:
		  The color as an (h, s, l) tuple in the range:
		  h[0...360],
		  s[0...1],
		  l[0...1]

		>>> Color.RgbToHsl(1, 0.5, 0)
		(30.0, 1.0, 0.5)
		
		'*/
		var minVal:Float = MathTools.min(cast [r, g, b]);//       # min RGB value
		var maxVal:Float = MathTools.max(cast[r, g, b]);//       # max RGB value

		var l:Float = (maxVal + minVal) / 2.0;
		if (minVal==maxVal)
		  return [0.0, 0.0, l];//    # achromatic (gray)

		var d:Float = maxVal - minVal; //        # delta RGB value
		var s:Float = 0;
		if (l < 0.5)
			s = d / (maxVal + minVal);
		else
			s = d / (2.0 - maxVal - minVal);

		//dr, dg, db = [(maxVal-val) / d for val in (r, g, b)]
		var dr:Float = (maxVal - r) / d;
		var dg:Float = (maxVal - g) / d;
		var db:Float = (maxVal - b) / d;
		var h:Float = 0;
		if (r==maxVal)
			h = db - dg;
		else if (g==maxVal)
			h = 2.0 + dr - db;
		else
			h = 4.0 + dg - dr;
		
		h = (h * 60.0) % 360.0;
		return [h, s, l];
	}
	
	
}