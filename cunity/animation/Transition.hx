/**
 *
 * @author Axel Huizinga - axel@cunity.me
 * All rights reserved
 * 
 * ported from Transitions.as
 * Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com
 * 
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

package me.cunity.animation;

class Transition 
{
	/**
	 * Configures the amount of overshoot to use for 'back' transitions.
	 * 
	 * @see	#backIn
	 * @see	#backOut
	 * @see	#backInAndOut
	 */
	static var BACK_OVERSHOOT:Float      = 1.70158;
	
	/**
	 * Configures the amplitude of an elastic wave.
	 * 
	 * @see #elasticIn
	 * @see #elasticOut
	 * @see #elasticInAndOut
	 */
	private static var ELASTIC_AMPLITUDE:Float;
	
	/**
	 * Configures the period of an elastic wave.
	 * 
	 * @see #elasticIn
	 * @see #elasticOut
	 * @see #elasticInAndOut
	 */
	static var ELASTIC_PERIOD:Float      = 400;
	
	// *********************************************************************************
	// API
	// *********************************************************************************
	
	/**
	 * Linear easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function linear(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * t / d + b;
	}
	
	/**
	 * Sine in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function sineIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return -c * Math.cos((t / d) * (Math.PI / 2)) + b + c;
	}
	
	/**
	 * Sine out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function sineOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * Math.sin((t / d) * (Math.PI / 2)) + b;
	}
	
	/**
	 * Sine in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function sineInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return -c / 2 * (Math.cos((t / d) * Math.PI) - 1) + b;
	}
	
	/**
	 * Quad in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quadIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * (t /= d) * t + b;
	}
	
	/**
	 * Quad out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quadOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return -c * (t /= d) * (t - 2) + b;
	}
	
	/**
	 * Quad in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quadInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t + b;
		}
		else
		{
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}
	}
	
	/**
	 * Cubic in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function cubicIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * (t /= d) * t * t + b;
	}
	
	/**
	 * Cubic out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function cubicOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * ((t = t / d - 1) * t * t + 1) + b;
	}
	
	/**
	 * Cubic in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function cubicInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		if(( t /= d / 2) < 1)
		{
			return c / 2 * t * t * t + b;
		}
		else
		{
			return c / 2 * (( t -= 2) * t * t + 2) + b;
		}
	}
	
	/**
	 * Quart in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quartIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * (t /= d) * t * t * t + b;
	}
	
	/**
	 * Quart out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quartOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return -c * ((t = t / d - 1) * t * t * t - 1) + b;
	}
	
	/**
	 * Quart in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quartInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t * t * t + b;
		}
		else
		{
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
	}
	
	/**
	 * QuFloat in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quFloatIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * (t /= d) * t * t * t * t + b;
	}
	
	/**
	 * QuFloat out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quFloatOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
	}
	
	/**
	 * QuFloat in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function quFloatInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t * t * t * t + b;
		}
		else
		{
			return c / 2 * (( t -= 2) * t * t * t * t + 2) + b;
		}
	}
	
	/**
	 * Expo in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function expoIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		return (t == 0) ? b :c * Math.pow(2, 10 * (t / d - 1)) + b;
	}
	
	/**
	 * Expo out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function expoOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		return (t == d) ? b + c :c * (-Math.pow(2, -10 * t / d) + 1) + b;
	}
	
	/**
	 * Expo in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function expoInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		if(t == 0) 
		{
			return b;
		}
		
		if(t == d) 
		{
			return b + c;
		}
		
		if((t /= d / 2) < 1)
		{
			return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
		}
		
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
	}
	
	/**
	 * Back in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function backIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		var s:Float = BACK_OVERSHOOT;
		
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
	}
	
	/**
	 * Back out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function backOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		var s:Float = BACK_OVERSHOOT;
		
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
	}
	
	/**
	 * Back in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function backInAndOut (t:Float, b:Float, c:Float, d:Float):Float
	{
		var s:Float = BACK_OVERSHOOT;
		
		if((t /= d / 2) < 1)
		{
			return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		}
		
		return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
	}
	
	/**
	 * Bounce easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function bounce(t:Float, b:Float, c:Float, d:Float):Float
	{
		if((t /= d) < (1 / 2.75))
		{
			return c * (7.5625 * t * t) + b;
		}
		else if(t < (2 / 2.75))
		{
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
		}
		else if(t < (2.5 / 2.75))
		{
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
		}
		else
		{
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
		}
	}
	
	/**
	 * Elastic in easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function elasticIn(t:Float, b:Float, c:Float, d:Float):Float
	{
		var a:Null<Float> = ELASTIC_AMPLITUDE;
		var p:Null<Float> = ELASTIC_PERIOD;
		var s:Float;
		
		if(t == 0)
		{
			return b;
		}
		
		if((t /= d) == 1)
		{
			return b + c; 
		}
		
		if(null==p)
		{
			p = d * 0.3;
		}
		
		if(null==a || a < Math.abs(c))
		{
			a = c; 
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin (c / a);
		}
		
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
	}
	
	/**
	 * Elastic out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function elasticOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		var a:Null<Float> = ELASTIC_AMPLITUDE;
		var p:Null<Float> = ELASTIC_PERIOD;
		var s:Float;
		
		if(t == 0)
		{
			return b;
		}
		
		if((t /= d) == 1)
		{
			return b + c;
		}
		
		if(null==p)
		{
			p = d * 0.3;
		}
		
		if(null==a || a < Math.abs(c))
		{
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin (c / a);
		}
		
		return (a * Math.pow(2, -10 * t) * Math.sin( (t * d - s)*(2 * Math.PI) / p) + c + b);
	}
	
	/**
	 * Elastic in and out easing equation.
	 * 
	 * @param	t	TIME:		Current time during the tween. 0 to duration.
	 * @param	b	BEGINING:	Starting value of the property being tweened.
	 * @param	c	CHANGE:		Change in the properties value from start to target.
	 * @param	d	DURATION:	Duration of the tween.
	 * 
	 * @return	The resulting tweened value.
	 */
	inline public static function elasticInAndOut(t:Float, b:Float, c:Float, d:Float):Float
	{
		var a:Null<Float> = ELASTIC_AMPLITUDE;
		var p:Null<Float> = ELASTIC_PERIOD;
		var s:Float;
		
		if(t == 0)
		{
			return b; 
		} 
		
		if((t /= d / 2) == 2)
		{
			return b + c;
		}
		
		if(null==p)
		{
			p = d * (0.3 * 1.5);
		}
		
		if(null==a || a < Math.abs(c))
		{ 
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		
		if(t < 1)
		{
			return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t * d - s)*(2 * Math.PI) / p )) + b;
		}
		else
		{
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
		}
	}
	
}