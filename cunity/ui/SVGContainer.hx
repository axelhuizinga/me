package me.cunity.ui;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib; 
import flash.xml.XML;
import haxe.CallStack;
import me.cunity.core.Application;
import me.cunity.debug.Out;
import org.svgweb.core.SVGNode;
import org.svgweb.SVGLayout;
import me.cunity.graphics.DrawTools;
using me.cunity.graphics.DrawTools;

/**
 * ...
 * @author Axel Huizinga axel@cunity.me
 */

class SVGContainer extends Container
{
	var svgLayout:SVGLayout;
	//var initialMat;
	public var layoutNodes:Map<Dynamic>;

	public function new(xNode:XML, p:Container)  
	{
		super(xNode, p);
		//contentView.mouseEnabled = false;
		//trace(name + ' parent.layoutRoot:' + _parent.layoutRoot + ' layoutRoot:' + layoutRoot + ' mouseEnabled:' + mouseEnabled
		//+	 ' contentView:' + contentView.mouseEnabled);
		layoutNodes = new Map();
		svgLayout = new SVGLayout(layoutSVG);
		svgLayout.mouseEnabled = false;
		if (layoutRoot != null)
			layoutRoot.resourceList.add(this);
		//contentView.addChild(svgLayout.svgRoot.topSprite);
		svgLayout.setSize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		contentView.addChild(svgLayout);
		svgLayout.loadURL(cAtts.href);
	}
	
	function layoutSVG()
	{
		//TODO:LOAD MULTIPLE LAYOUT NODES AND MOUSEENABLED FROM CONFIG
		var layoutNode:SVGNode = svgLayout.svgRoot.getNode(cAtts.g);
		if (layoutNode == null)
		{
			Out.dumpStack(CallStack.callStack());
			trace('oops');
			return;
		}
		//Out.dumpLayout(layoutNode.topSprite);
		if (layoutNode.clipSprite.mask != null)
		{
			//Out.dumpLayout(layoutNode.topSprite);
			//Out.dumpLayout(layoutNode.clipSprite);
			//Out.dumpLayout(layoutNode.clipSprite.mask);
			//trace(layoutNode.clipSprite.mask.parent.name);
			box = layoutNode.clipSprite.mask.getBounds(svgLayout.svgRoot.topSprite);
			/*trace(layoutNode.topSprite.getBounds(Lib.current));
			trace(layoutNode.clipSprite.getBounds(Lib.current));
			trace(layoutNode.clipSprite.mask.getBounds(Lib.current));*/
		}
		else
			box = layoutNode.topSprite.getBounds(svgLayout.svgRoot.topSprite);
		
		layoutNodes.set(cAtts.g, { box:box, node:layoutNode } );
		//setMouseEnabled(layoutNode.viewBoxSprite, true);
		//layoutNode.topSprite.mouseEnabled = layoutNode.clipSprite.mouseEnabled = layoutNode.viewBoxSprite.mouseEnabled = layoutNode.drawSprite.mouseEnabled = false;
		//trace(layoutNode.topSprite.mouseEnabled + ':' + layoutNode.clipSprite.mouseEnabled + ':' + 
			//layoutNode.viewBoxSprite.mouseEnabled + ':' + layoutNode.drawSprite.mouseEnabled);
		trace(box.toString());			
		//layoutNode.topSprite.x = -box.x; 
		//layoutNode.topSprite.y = -box.y;
contentBox = box.clone();
		box.offset( -box.x, -box.y);//MAKE SURE THAT BOX STARTS AT 0,0
		//contentBox.left = margin.left;
		//contentBox.top = margin.top;
		//box.width += margin.left + margin.right;
		//box.height += margin.top + margin.bottom;
		trace(Std.string(margin) + ' clipBox:' +  box.toString() +'->' + contentBox);
		//trace('clipBox:' +  rootBox.toString() +'->' + box + ' selfBox:' +
			//layoutNode.topSprite.getBounds(svgLayout.svgRoot.topSprite) + ' visibleBounds:' + layoutNode.topSprite.getVisibleBounds());
		contentView.removeChild(svgLayout);
		layoutNode.topSprite.name = cAtts.g;
		content = contentView.addChild(layoutNode.topSprite);
		trace(contentView.getChildAt(0).name + ':' + contentView.numChildren);
		//Out.dumpLayout(contentView.getChildAt(0));
		layoutRoot.resourceReady(this);
	}
	
	override public function getBox()
	{
		getMaxDims();
		super.getBox();
		applyMargin();

	}
	
	override function getChildrenDims()
	{
		maxW = maxH  = cW = cH = 0;
		trace('');
		for (layoutNode in layoutNodes.iterator())
		{
			if (layoutNode.box.width > maxW) 
				maxW = layoutNode.box.width;
			if (layoutNode.box.height > maxH) 
				maxH = layoutNode.box.height;
			//if (c.cAtts.expand != null)
				//dynamicBlocks.set(c, c.cAtts.expand.split(',').map2(Std.parseInt));			
		}
		cW = maxW;
		cH = maxH;
	}
	
	override public function layout()
	{			
		trace(name + ':' + layoutNodes.keys().hasNext() + ' yeah box:' + box + ' maxContentDims:' + maxContentDims);

		var aY:Float = 0;// margin.left;
		var aX:Float = 0;//margin.top;	

		for (key in layoutNodes.keys())
		{
			var layoutNode:SVGNode = svgLayout.svgRoot.getNode(key);
			//trace(layoutNode + ':' + key);
			var layoutInfo:Dynamic = layoutNodes.get(key);
			var nodeBox:Rectangle = layoutInfo.box;
			//trace(box + '->' + nodeBox);
			if (cAtts.preserveAspectRatio )//&& (box.width > maxContentDims.width || box.height > maxContentDims.height))
			{
				//scaleToFit();
			//layoutNode.topSprite.parent.removeChildAt(0);
				continue;
			}
			var wScale:Float = 1;
			var hScale:Float = 1;
			//trace(key +':' + fixedWidth + ':'  +fixedHeight);
			if (fixedWidth)
			{
				if (nodeBox.width > box.width)
					wScale = box.width / nodeBox.width;				
			}
			if (fixedHeight)
			{
				if (nodeBox.height > box.height)
					hScale = box.height / nodeBox.height;
			}
			var scale:Float = Math.min(wScale, hScale);
			var mat:Matrix = layoutNode.topSprite.transform.matrix;
			//trace(mat.toString());
			//trace(box + ' nodeBox:' + nodeBox + ' scale :'  + scale);
			//move back 2 origin first;
			//mat.translate( -nodeBox.x, -nodeBox.y);
			//layoutNode.topSprite.x = -nodeBox.x;
			//layoutNode.topSprite.y = -nodeBox.y;
			if (scale != 1)
			{				
				if(wScale > hScale)
					box.width = box.width * scale;
				else
					box.height = box.height * scale;
				mat.scale(scale, scale);				
			}

			//trace(name +' cH:' + cH + ' aY:' + aY + ' scale:' + scale + ' align:' + cAtts.align);
			//PLACE LAYOUT NODES
			aY = -scale * margin.top;
			switch(cAtts.align) 
			{
				case 'C'://'Center Top'
				mat.translate( (box.width - nodeBox.width * scale) / 2, aY);	
				//mat.translate( (box.width - nodeBox.width) / 2, aY);	
				case 'CM'://'Center Middle'
				mat.translate( (box.width - nodeBox.width * scale) / 2, 
					(box.height - margin.top - margin.bottom - nodeBox.height * scale) / 2);	
				//trace(name + ':' + Std.string(box) + ' -> ' + c.name + ':' + Std.string(c.box));	
				case 'LM'://'Left | Center Middle'
				//if (cells.length != 1)
					//throw('Horizontal center align works only for one child');
				mat.translate(aX, (box.height - margin.top - margin.bottom - nodeBox.height * scale) / 2);
				case 'CB'://CenterBottom
				//mat.translate( nodeBox.x + (box.width - nodeBox.width * scale) / 2, nodeBox.y + maxContentDims.height - nodeBox.height * scale - margin.bottom);
				mat.translate( (box.width - nodeBox.width * scale) / 2,
					box.height - nodeBox.height * scale - margin.bottom);
				default://'TL'
				//mat.translate(aX, aY);								
			}
			//Out.dumpLayout(this);
			//Out.dumpLayout(layoutNode.topSprite);
			layoutNode.topSprite.transform.matrix = mat;
			//layoutNode.topSprite.parent.removeChildAt(0);
			//trace(layoutNode.topSprite.parent.name + ' index:' + layoutNode.topSprite.parent.getChildIndex(layoutNode.topSprite) );
			//Out.dumpLayout(this);
			//Out.dumpLayout(layoutNode.topSprite);
			//trace(mat.toString());
			//trace(layoutNode.clipSprite.mask.localToGlobal(new Point(0,0)));
			//trace(layoutNode.topSprite.localToGlobal(new Point(0,0)));
			//trace (c.label.text + ':' + aY + ':' + c.box.height);
			//Out.dumpLayout(c, true);		
			//trace(aY + ' c.name:' + c.name + ' c.margin.top:' + c.margin.top +' c.height:' +  c.height);
		}
	}
		
	override public function destroy() {
		while(contentView.numChildren>0)
		{
			var child:Dynamic = contentView.removeChildAt(0);
			//if (Reflect.isFunction(Reflect.field(child, 'destroy')))
				//child.destroy();
			child = null;
		}
	}
	
}