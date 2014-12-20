/**
 * ...
 * @author Axel Huizinga - axel@cunity.me
 */

package me.cunity.ui.mask;
import flash.display.Shape;
import flash.display.Sprite;
import me.cunity.animation.FastTween;

enum SlideDirection
{
	TOP;
	BOTTOM;
	LEFT;
	RIGHT;
	HORIZONTAL;
	VERTICAL;
}

enum SlideDistribution
{
	SPREAD;
	SHRINK;
	SPREAD_SHRINK_SPREAD;
	SHRINK_SPREAD_SHRINK;
	UNIFORM;
}

class Stripes extends Sprite
{
	
	var properties:Dynamic;
	
	var numStripes:UInt;
	var pitch:UInt;
	var direction:SlideDirection;
	var distribution:SlideDistribution;
	var outerDims:Array<Float>;
	var slideSizes:Array<Float>;
	var stripes:Array<Shape>;
	var h:Float;
	var w:Float;
	
	public function new(p:Dynamic) 
	{
		super();
		numStripes = p.numStripes == null ? 15 :p.numStripes;
		pitch = p.pitch == null ? 0 :p.pitch;
		direction = p.direction == null ? SlideDirection.HORIZONTAL :p.direction;
		distribution = p.distribution == null ? SlideDistribution.UNIFORM :p.distribution;
		h = p.height;
		w = p.width;
		outerDims = getSlideDims();
		slideSizes = new Array();
		stripes = new Array();
		buildSlides();
		addStripes();
	}
	
	function buildSlides()
	{
		switch(distribution)
		{
			case SPREAD:
			case SHRINK:
			case SPREAD_SHRINK_SPREAD:
			case SHRINK_SPREAD_SHRINK:
			case UNIFORM:
			var size = outerDims[0] / numStripes;
			for (i in 0...numStripes)
				slideSizes.push(size);
			
		}

	}
	
	function addStripes()
	{
		var stripeSize:Float = w / numStripes;
		var aX:Float = stripeSize/2, aY:Float = 0;
		trace(w + ':' + stripeSize);
		var stripHalf:Int = Math.ceil(stripeSize/2);		
		
		for (s in slideSizes)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0, 0.5);
			addChild(shape);
			stripes.push(shape);
			switch(direction)
			{
				case TOP, BOTTOM, VERTICAL:
			
				case LEFT:
				case RIGHT:
				case HORIZONTAL:
				shape.graphics.drawRect(-stripHalf, 0, Math.ceil(stripeSize), h);
				shape.x = aX;
				//trace(aX);
				aX += stripeSize;
													
			}
		}
		
	}
	
	public function show(param:Dynamic = null)
	{
		if (param == null)
			param = { };
			trace(param);
		var d:Int = param.duration == null ? 1000 :param.duration;	
			
		for (s in 0...stripes.length)
		{
			if(s== 0 && param.onComplete != null)
			FastTween.add(stripes[s], d, { scaleX:1,  onComplete:param.onComplete } );
			else
			FastTween.add(stripes[s], d, { scaleX:1 } );
			trace('added:' + s + ' d:' + d);
		}
	}
	
	public function hide(param:Dynamic = null)
	{
		if (param == null)
			param = { };		
			trace(param);
		var d:Int = param.duration == null ? 1000 :param.duration;	
		
		for (s in 0...stripes.length)
		{
			if(s== 0 && param.onComplete != null)
			FastTween.add(stripes[s], d, { scaleX:0,  onComplete:param.onComplete } );
			else
			FastTween.add(stripes[s], d, { scaleX:0 } );
		}		
	}
	
	/*	function run()
	{
		//addEventListener(Event.ENTER_FRAME, slide);
		for(s in stripes)
			FastTween.add(s, 1000, { scaleX:-1 } );
	}*/
	
	function getSlideDims():Array<Float>
	{
		switch(direction)
		{
			case TOP, BOTTOM, VERTICAL:
			return [h, w];
			case LEFT, RIGHT, HORIZONTAL:
			return [w, h];		
		}
	}
	
}