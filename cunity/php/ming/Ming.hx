package me.cunity.php.ming;
import haxe.PosInfos;
import me.cunity.debug.Out;
import php.Web;

class Ming
{
	/***CONSTANTS***/

	public static inline var MING_NEW = 1;
	public static inline var MING_ZLIB = 1;
	public static inline var SWFBUTTON_HIT = 8;
	public static inline var SWFBUTTON_DOWN = 4;
	public static inline var SWFBUTTON_OVER = 2;
	public static inline var SWFBUTTON_UP = 1;
	public static inline var SWFBUTTON_MOUSEUPOUTSIDE = 64;
	public static inline var SWFBUTTON_DRAGOVER = 160;
	public static inline var SWFBUTTON_DRAGOUT = 272;
	public static inline var SWFBUTTON_MOUSEUP = 8;
	public static inline var SWFBUTTON_MOUSEDOWN = 4;
	public static inline var SWFBUTTON_MOUSEOUT = 2;
	public static inline var SWFBUTTON_MOUSEOVER = 1;
	public static inline var SWFFILL_RADIAL_GRADIENT = 18;
	public static inline var SWFFILL_LINEAR_GRADIENT = 16;
	public static inline var SWFFILL_TILED_BITMAP = 64;
	public static inline var SWFFILL_CLIPPED_BITMAP = 65;
	public static inline var SWFTEXTFIELD_NOEDIT = 8;
	public static inline var SWFTEXTFIELD_PASSWORD = 16;
	public static inline var SWFTEXTFIELD_MULTILINE = 32;
	public static inline var SWFTEXTFIELD_WORDWRAP = 64;
	public static inline var SWFTEXTFIELD_DRAWBOX = 2048;
	public static inline var SWFTEXTFIELD_NOSELECT = 4096;
	public static inline var SWFTEXTFIELD_HTML = 512;
	public static inline var SWFTEXTFIELD_AUTOSIZE = 16384;
	public static inline var SWFTEXTFIELD_ALIGN_LEFT = 0;
	public static inline var SWFTEXTFIELD_ALIGN_RIGHT = 1;
	public static inline var SWFTEXTFIELD_ALIGN_CENTER = 2;
	public static inline var SWFTEXTFIELD_ALIGN_JUSTIFY = 3;
	public static inline var SWFACTION_ONLOAD = 1;
	public static inline var SWFACTION_ENTERFRAME = 2;
	public static inline var SWFACTION_UNLOAD = 4;
	public static inline var SWFACTION_MOUSEMOVE = 8;
	public static inline var SWFACTION_MOUSEDOWN = 16;
	public static inline var SWFACTION_MOUSEUP = 32;
	public static inline var SWFACTION_KEYDOWN = 64;
	public static inline var SWFACTION_KEYUP = 128;
	public static inline var SWFACTION_DATA = 256;
	public static inline var SWFACTION_INIT = 512;
	public static inline var SWFACTION_PRESS = 1024;
	public static inline var SWFACTION_RELEASE = 2048;
	public static inline var SWFACTION_RELEASEOUTSIDE = 4096;
	public static inline var SWFACTION_ROLLOVER = 8192;
	public static inline var SWFACTION_DRAGOVER = 32768;
	public static inline var SWFACTION_DRAGOUT = 65536;
	public static inline var SWFACTION_KEYPRESS = 131072;
	public static inline var SWFACTION_CONSTRUCT = 262144;
	public static inline var SWF_SOUND_NOT_COMPRESSED = 0;
	public static inline var SWF_SOUND_ADPCM_COMPRESSED = 16;
	public static inline var SWF_SOUND_MP3_COMPRESSED = 32;
	public static inline var SWF_SOUND_NOT_COMPRESSED_LE = 48;
	public static inline var SWF_SOUND_NELLY_COMPRESSED = 96;
	public static inline var SWF_SOUND_5KHZ = 0;
	public static inline var SWF_SOUND_11KHZ = 4;
	public static inline var SWF_SOUND_22KHZ = 8;
	public static inline var SWF_SOUND_44KHZ = 12;
	public static inline var SWF_SOUND_8BITS = 0;
	public static inline var SWF_SOUND_16BITS = 2;
	public static inline var SWF_SOUND_MONO = 0;
	public static inline var SWF_SOUND_STEREO = 1;
	public static inline var SWFBLEND_MODE_NORMAL = 1;
	public static inline var SWFBLEND_MODE_LAYER = 2;
	public static inline var SWFBLEND_MODE_MULT = 3;
	public static inline var SWFBLEND_MODE_SCREEN = 4;
	public static inline var SWFBLEND_MODE_DARKEN = 6;
	public static inline var SWFBLEND_MODE_LIGHTEN = 5;
	public static inline var SWFBLEND_MODE_ADD = 8;
	public static inline var SWFBLEND_MODE_SUB = 9;
	public static inline var SWFBLEND_MODE_DIFF = 7;
	public static inline var SWFBLEND_MODE_INV = 10;
	public static inline var SWFBLEND_MODE_ALPHA = 11;
	public static inline var SWFBLEND_MODE_ERASE = 12;
	public static inline var SWFBLEND_MODE_OVERLAY = 13;
	public static inline var SWFBLEND_MODE_HARDLIGHT = 14;
	public static inline var SWFFILTER_TYPE_DROPSHADOW = 0;
	public static inline var SWFFILTER_TYPE_BLUR = 1;
	public static inline var SWFFILTER_TYPE_GLOW = 2;
	public static inline var SWFFILTER_TYPE_BEVEL = 3;
	public static inline var SWFFILTER_TYPE_GRADIENTGLOW = 4;
	public static inline var SWFFILTER_TYPE_CONVOLUTION = 5;
	public static inline var SWFFILTER_TYPE_COLORMATRIX = 6;
	public static inline var SWFFILTER_TYPE_GRADIENTBEVEL = 7;
	public static inline var SWFFILTER_FLAG_CLAMP = 2;
	public static inline var SWFFILTER_FLAG_PRESERVE_ALPHA = 1;
	public static inline var SWFFILTER_MODE_INNER = 128;
	public static inline var SWFFILTER_MODE_KO = 64;
	public static inline var SWFFILTER_MODE_COMPOSITE = 32;
	public static inline var SWFFILTER_MODE_ONTOP = 16;
	public static inline var SWF_GRADIENT_PAD = 0;
	public static inline var SWF_GRADIENT_REFLECT = 1;
	public static inline var SWF_GRADIENT_REPEAT = 2;
	public static inline var SWF_GRADIENT_NORMAL = 0;
	public static inline var SWF_GRADIENT_LINEAR = 1;
	public static inline var SWF_SHAPE3 = 3;
	public static inline var SWF_SHAPE4 = 4;
	public static inline var SWF_SHAPE_USESCALINGSTROKES = 1;
	public static inline var SWF_SHAPE_USENONSCALINGSTROKES = 2;
	public static inline var SWF_LINESTYLE_CAP_ROUND = 0;
	public static inline var SWF_LINESTYLE_CAP_NONE = 16384;
	public static inline var SWF_LINESTYLE_CAP_SQUARE = 32768;
	public static inline var SWF_LINESTYLE_JOIN_ROUND = 0;
	public static inline var SWF_LINESTYLE_JOIN_BEVEL = 4096;
	public static inline var SWF_LINESTYLE_JOIN_MITER = 8192;
	public static inline var SWF_LINESTYLE_FLAG_NOHSCALE = 1024;
	public static inline var SWF_LINESTYLE_FLAG_NOVSCALE = 512;
	public static inline var SWF_LINESTYLE_FLAG_HINTING = 256;
	public static inline var SWF_LINESTYLE_FLAG_NOCLOSE = 4;
	public static inline var SWF_LINESTYLE_FLAG_ENDCAP_ROUND = 0;
	public static inline var SWF_LINESTYLE_FLAG_ENDCAP_NONE = 1;
	public static inline var SWF_LINESTYLE_FLAG_ENDCAP_SQUARE = 2;
	public static inline var SWF_VIDEOSTREAM_MODE_MANUAL = 1;
	public static inline var SWF_VIDEOSTREAM_MODE_AUTO = 0;

	
	public static var cffi:String;//PATH 2 MINGLIB NDLL
	public static var debug:Bool;
	
	/***public functionS***/

	public static  function setcubicthreshold(threshold:Int):Void
	{
		untyped __call__("ming_setcubicthreshold", threshold);
	}
	
	public static  function setscale(scale:Float):Void
	{
		untyped __call__("ming_setscale", scale);
	}
	
	public static  function useswfversion(version:Int):Void
	{
		untyped __call__("ming_useswfversion", version);
	}
	
	//static  public function ming_keypress();
	//static  public function ming_useconstants();
	
	public static  function setswfcompression(compression:Int):Void
	{
		untyped __call__("ming_setswfcompression", compression);
	}
	
	public static function log(m:Dynamic, ?i:PosInfos)
	{
		var msg = if ( i != null ) i.fileName + ':' + i.lineNumber + ":"  + i.methodName  else "";
		if (debug)
		Out._trace( m, i);	
		else
		untyped __call__("error_log",   msg +':' + m);		
	}	
}
