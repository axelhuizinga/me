package me.cunity.php.gd;
import haxe.ds.StringMap;
import haxe.Log;
import haxe.crypto.Md5;
import hxphp.oo.gd.GDImage;
import sys.FileSystem;
import haxe.io.Path;
import php.Lib;
import php.Web;
using me.cunity.util.Crypt;

/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

class ImageText 
{

	public var text:String;
	var imgKey:String;
	var imgSet:StringMap<Dynamic>;
	var config:StringMap<Dynamic>;
	
	public function new() 
	{
		config = new StringMap();
		imgSet = new StringMap();
		//defaults
		config.set('Path', Web.getCwd()); // set's the server path to the script folder
		config.set('url','localhost/paradiseprojects/devel/oneApi/bin'); // url to the script folder
		config.set('cacheDir', 'cache/');				// directory for caching generated images should be writable 
		config.set('imgQuality', '0');						// image save Quality 0-9 (0 is best, not 9)
		config.set('fontDir', config.get('Path')+'fonts/');		// full path to font folder
		config.set('fontFile', 'DejaVuSans-Bold.ttf');						// preferred TTF font (it needs to be in the fonts folder)
		config.set('fontSize', '30');						// preferred font size
		config.set('fontColor', '666');		
	}
	
	
	
	public function imageSettings(text:String, fontSize:Int, fontFile:String = null, fontColor:String = null)
	{
		trace('fontSize:' + fontSize + 'fontColor:' + fontColor);
		imgSet.set('text', text);
		imgSet.set('fontColor', fontColor);
		imgSet.set('fontSize', Std.string(fontSize));
		imgSet.set('fontFile', fontFile == null ? config.get('fontFile') :fontFile);
		imgKey = imgSet.hash2md5();
	}
	
	public function makeImage(?outputMethod:OutputMethod):Dynamic
	{
		for (key in ['fontColor', 'fontFile', 'fontSize'])
		{
			imgSet.set(key, imgSet.get(key) != null ? imgSet.get(key) :config.get(key));
		}
		
		//imgSet.set('fontSize', imgSet.get('fontSize') != null ? imgSet.get('fontSize') :config.get('fontSize'));
		if (outputMethod != show)
		{
			imgKey = imgSet.hash2md5();
			trace('outputMethod:' + Std.string(outputMethod) + ' imgKey:' + imgKey);
		}
		
		var cacheImage = loadCache(outputMethod);
		if (Std.is(cacheImage, GDImage) || outputMethod == html)
		{
			trace('cacheImage:' + cacheImage);
			//untyped __call__('error_log', 'cacheImage:' + cacheImage);
			return cacheImage;
		}
		var fontAddress = config.get('fontDir') + imgSet.get('fontFile');
		var txtArray:Array<String> = imgSet.get('text').split('|');
		var longStr:String = '';
		var offx:Int = 3;
		var offy:Int = 3;
		var lines:Array<String> = [];
		
		for (line in txtArray)
		{
			lines.push(line);
			longStr = line.length > longStr.length ? line :longStr;
		}
		
		var n:Int = lines.length;
		//untyped __call__('error_log', 'fontAddress:' + fontAddress);
		var bbox:Array<Int> = imagettfbbox_t(imgSet.get('fontSize'), 0, fontAddress,
			longStr);
		//var bbox:Array<Int> = untyped __call__(
			//"imagettfbbox", imgSet.get('fontSize'), 0, fontAddress,longStr);
		
		//Calculate the height of the text box by adding the absolute value of the Upper Left "Y" position with the Lower Left "Y" position.	
		var tww:Int = Math.round(Math.abs(bbox[2] - bbox[0]) * 1.01);
		var thh:Int = Math.round(Math.abs(bbox[7] - bbox[1]));
		
		var th:Int = -bbox[7] - 1;
		var sp:Int = Math.round(n > 1 ? th + (((thh * n) - (n * th)) / n):0);
		
		var width:Int = Math.round(tww + offx * 2);
		var height:Int = Math.round(thh * n + offy * 2);
		var image:GDImage = transparentImage(width, height);
		
		var fontColor:Array<Int> = html2rgb(imgSet.get('fontColor'));
		var tColor:Int = image.colorAllocate(fontColor[0], fontColor[1], fontColor[2]);
		var ynew:Int = Vert(height, thh * n, th);
		
		var tw:Int =  0;
		var xnew:Int = 0;
		
		for (line in lines)
		{
			bbox = imagettfbbox_t(imgSet.get('fontSize'), 0, fontAddress, line);
			//bbox = untyped __call__('imagettfbbox', imgSet.get('fontSize'), 0, fontAddress, line);
			tw = bbox[2] - bbox[0];
			xnew = Horiz(width, tww, tw);
			image.text.TrueTypeText(imgSet.get('fontSize'), 0, xnew, ynew, tColor, fontAddress,
				line);
			ynew += sp;
		}
		
		//untyped __call__('error_log', 'image.outputPng(cacheImage):' + cacheImage + 'resource:'
			//+ image.resource);
		image.outputPng(cacheImage);
		
		if (outputMethod == resource)
			return image;
		else if (outputMethod == html)
			return '<img src="' + config.get('url') + config.get('cacheDir') + '.png />';
		else
		{			
			browserCache(Date.now().getTime());
			Web.setHeader('Content-type', 'image/png');
			image.outputPng();
		}
		image.destroy();
		return true;
	}
		
/*	function hash2md5(h:Map<Dynamic>):String
	{
		var key:String = '';
		var hKeys:Iterator<String> = h.keys();
		while (hKeys.hasNext())
		{
			key += Std.string(h.get(hKeys.next()));
		}
		trace('hash2md5 Map:' + Std.string(h));
		trace('hash2md5 key:' + key);
		return Md5.encode(key);		
	}*/
	
	function html2rgb(cval:String):Array<Int> {
		
		var color:Array<String> = cval.split('');
		var red:Int;
		var green:Int;
		var blue:Int;
		red = green = blue = 0;
		if (color[0] == '#')
			color.shift();
		if (color.length == 6) {
			red =  Std.parseInt('0x' + color[0] + color[1]);
			green = Std.parseInt('0x' + color[2] + color[3]);
			blue = Std.parseInt('0x' + color[4] + color[5]);
		} else if (color.length == 3) {
			red =  Std.parseInt('0x' + color[0] + color[0]);
			green = Std.parseInt('0x' + color[1] + color[1]);
			blue = Std.parseInt('0x' + color[2] + color[2]);	
		} 
		trace(Std.string(color) + ' color length:' + color.length +':'+ Std.string([red, green, blue]));
		return [red, green, blue];
	}
	
	function imagettfbbox_t(size:Int, angle:Int, fontfile:String, text:String){
		// compute size with a zero angle
		//trace(fontfile + ':' + size + ':' + text);
		var coords:Array<Dynamic> = Lib.toHaxeArray(
			untyped __call__('imagettfbbox', size, 0, fontfile, text)
			//hxphp.GD.imageTTFBBox(size, 0, fontfile, text)
		);
		trace('coords:' + Std.string(coords));
		var ret:Array<Int> = new Array();
		if (angle == 0)
		{
			for (c in coords)
			{
				ret.push(Std.int(c));
			}
			return ret;
		}

		// convert angle to radians
		var a = Math.PI/180 * angle;
		// compute some usefull values
		var ca:Float = Math.cos(a);
		var sa:Float = Math.sin(a);
		
		// perform transformations
		var i = 0;
		while ( i < 7)
		{
			ret[i] = Math.round(coords[i] * ca + coords[i+1] * sa);
			ret[i+1] = Math.round(coords[i+1] * ca - coords[i] * sa);
			i += 2;
		}
		return ret;
	}
		
	function loadCache(outputMethod:OutputMethod):Dynamic
	{
		var cacheFile:String = config.get('Path') + config.get('cacheDir') + imgKey + '.png';
		trace('cacheFile:' + cacheFile + ' exists:' + Std.string(FileSystem.exists(cacheFile)));
		if (!FileSystem.exists(cacheFile))
			return cacheFile;
		switch (outputMethod)
		{
			case resource:
				return GDImage.createFromString(cacheFile);
			case html:
				return '<img src="' + config.get('url') + config.get('cacheDir') + imgKey + '.png" />';
			default:
				if (untyped __php__("isset($_SERVER['HTTP_IF_MODIFIED_SINCE'])"))
				{
					var modifiedSince:Date = Date.fromString(~/;.*$/.replace(
						untyped __php__("$_SERVER['HTTP_IF_MODIFIED_SINCE']"), ''));
					if (modifiedSince.getTime() >= FileSystem.stat(cacheFile).mtime.getTime())
					{
						untyped __php__("header($_SERVER['SERVER_PROTOCOL'].' 304 Not Modified')");
						Sys.exit(0);
					}
				}
		}
		Web.setHeader('Content-type', 'image/' + Path.extension(cacheFile) == 'jpg' ? 'jpeg' :
			Path.extension(cacheFile));
		Lib.printFile(cacheFile);
		Sys.exit(0);
		return true;
		
	}
	
	function browserCache(time:Float){
		Web.setHeader('Last-Modified', DateTools.format(Date.fromTime(time), '%a, %d %b %Y %H:%M:%S GMT'));
		Web.setHeader('Expires', 
			DateTools.format(Date.fromTime(time + 86400*365), '%a, %d %b %Y %H:%M:%S GMT'));
		Web.setHeader("Pragma", "public");
		Web.setHeader("Cache-Control", "maxage=" + Std.string(86400 * 14));
	}

/*
	 * Sets the horizontal position of the first character of a line of text.
	 *
	 * $width -> width of the image
	 * $twidth -> width of the longest line of this group of lines of text
	 * $lwidth -> width of this line of text.
	 */
	function Horiz(width:Int, twidth:Int, lwidth:Int)
	{
		var xnew:Int = 0;
		var just='left';
		var horz='center';
		if(just=="right")xnew=twidth-lwidth-2;
		if(just=="center")xnew= Math.round((twidth-lwidth)/2);
		if(just=="left")xnew=1;
		if(horz=="right")xnew=xnew+(width-twidth);
		if(horz=="center")xnew=xnew+Math.round((width-twidth)/2);
		return xnew;
	}


/*
	 * Sets the vertical position of the first character of a line of text.
	 *
	 * height -> height of the image
	 * theight -> height of this group of lines of text
	 * lheight -> height of one line of text.
	 */
	function Vert(height:Int, theight:Int, lheight:Int)
	{
		var vert = 'center';
		var ynew:Int = 0;
		if(vert=="center")ynew=Math.round((height/2)-(theight/2))+lheight;
		if(vert=="top")ynew=lheight;
		if(vert=="bottom")ynew=height-theight+lheight;
		return ynew;
	}
	
	
	function transparentImage(width:Int, height:Int):GDImage
	{
		var im:GDImage = GDImage.createTrueColor(width, height);
		im.alphaBlending(true);
		var color:Int = im.colorAllocateAlpha(0, 0, 0, 127);
		im.drawing.fill(0, 0, color);
		im.imageSaveAlpha(true);
		im.alphaBlending(true);
		return im;	
	}
}
	/*
	 * 
 function transparentImage($width,$height){
		$im = imagecreatetruecolor($width, $height);
		imagealphablending($im, false);
		$color = imagecolorallocatealpha($im, 0, 0, 0, 127);
		imagefill($im, 0, 0, $color);
		imagesavealpha($im, true);
		imagealphablending($im, true);
		return $im;
	}*/

enum OutputMethod
{
	html;
	show;
	resource;
}