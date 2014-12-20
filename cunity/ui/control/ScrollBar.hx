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

package me.cunity.ui.control;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import me.cunity.debug.Out;
import me.cunity.effects.easing.Linear;
import me.cunity.effects.STween;
//import org.libspark.ui.SWFWheel;

class ScrollBar extends Sprite
{
		var _content:DisplayObject;
		var _view:Rectangle;
		var _trackColor:UInt;
		var _grabberColor:UInt;
		var _grabberPressColor:UInt;
		var _gripColor:UInt;
		var _trackThickness:Int;
		var _grabberThickness:Int;
		var _easeAmount:Int;
		var _hasShine:Bool;
		
		var _track:Sprite;
		var _grabber:Sprite;
		var _grabberGrip:Sprite;
		var _grabberArrow1:Sprite;
		var _grabberArrow2:Sprite;
		var _gH:Float;// Grabber height
		var _cH:Float; // Content height
		var _lineHeight:UInt;
		var _lineStep:Float;
		var _scrollValue:Float;
		var _scrollStep:Float;
		var _contentTop:Float;
		var _defaultPosition:Float;
		var _viewW:Float; // view & track height
		var _viewH:Float;
		var _pressed:Bool ;
		
		public function destroy()
		{
			try 
			{
			Lib.current.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener, false); 
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, doScroll, false); 			
			deleteChildren(this);				
			}
			catch(ex:Dynamic)
			{
				trace(ex);
			}

		}
		
		function deleteChildren(c:DisplayObjectContainer)
		{
			while (c.numChildren > 0)
			{
				var child:Dynamic = c.removeChildAt(0);
				if (child != null)
				{
					var cName:String = child.name;
					//trace(child + ':' + cName);
					if (Std.is(child, DisplayObjectContainer))
						deleteChildren(child);
					child = null;					
					//trace( ' Successfully deleted:' + cName);
				}
			}			
		}
		//####################
		public function new(
			c:DisplayObject, v:Rectangle, tc:UInt, gc:UInt, gpc:UInt, 
			grip:UInt, tt:Int, gt:Int, ea:Int, hs:Bool = true, lh:UInt = 0
		)
		//####################
		{
			super();
			_pressed = false;
			_content = c;
			_view = v;
			_trackColor = tc;
			_grabberColor = gc;
			_grabberPressColor = gpc;
			_gripColor = grip;
			_trackThickness = tt;
			_grabberThickness = gt;
			_easeAmount = ea;
			//trace('_easeAmount:' + _easeAmount);
			//trace(_content.name + ' _content.y:' + _content.y + ' _content.height:' + _content.height);
			_lineHeight = lh;
			_hasShine = hs;
			if(ExternalInterface.available)
				ExternalInterface.addCallback('jsKey', doScroll);
			y = _content.y;		
			x = _content.x + _content.width + 8;
			createTrack();
			createGrabber();
			createGrips();
			_content.parent.addChild(this);
			_contentTop = _content.getBounds(stage).top;
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			//_defaultPosition =  Math.round(_content.y);			
			_defaultPosition = _content.y;			
			//trace('_defaultPosition:' + _defaultPosition + ' _contentTop:' + _contentTop);
			_grabber.y = 0;
			stage.addEventListener(Event.MOUSE_LEAVE, stopScroll,false,0,true);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener,true,0,true);
			//stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpListener, false, 0, true);
			_grabber.addEventListener(MouseEvent.MOUSE_DOWN, onDownListener, false, 0, true);
			_grabber.buttonMode = true;
			_track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
			_viewH = _view.height;				
			adjustSize();		
			//trace('_viewH:' + _viewH + ' _gH:' + _gH + ' _scrollStep:' + _scrollStep + ' _scrollValue:' + _scrollValue);
		}
		
		function doScroll(sC:Dynamic)
		{
			//TODO:IMPLEMENT HSCROLL	
			var kC:UInt = (Math.isNaN(sC) ? sC.keyCode :Std.int(sC));
			//trace(sC +':' + kC + ' grabberY:' + _grabber.y);
			//trace(tF.y + ':' + (-1*tF.height + _viewBox.height + marginY));
			//trace(tF.y + ':' + (marginY +_viewBox.height - tF.height));
			switch(kC){
				case 34:// PAGE DOWN
				//trace(_grabber.y + '==' + ( _viewH - _gH));
				//_content.y -= _scrollStep;
				//return;
				if (_grabber.y == _viewH - _gH)
					return;				
				//trace(_grabber.y + '+' + _scrollStep);
				startScroll(_grabber.y + _scrollStep);
				//startScroll(_grabber.y + _scrollValue);
				case 33:// PAGE UP								
				if (_grabber.y == 0)
					return;
				//trace(_grabber.y + '-' + _scrollStep);	
				startScroll(_grabber.y - _scrollStep);

				case 40:// DOWN ARROW
				if (_lineHeight == 0 || _grabber.y == _viewH - _gH)
					return;		
				startScroll(_grabber.y + _lineStep);
				case 37:// LEFT ARROW
				case 38:// UP ARROW
				if (_lineHeight == 0 || _grabber.y == 0)
					return;
				startScroll(_grabber.y - _lineStep);
				case 39:// RIGHT ARROW
			}
			//trace(tF.y);
		}		
		
		function startScroll(tY:Float) 
		{
			trace(_content.name + ' tY:' + tY + ' _grabber.y:' + _grabber.y + ' _scrollValue:' + _scrollValue + ' _cH:' + _cH + ' _viewH:' + _viewH);
			if (_cH <= _viewH)
				return;// no need to scroll
			if (tY < 0)
				tY = 0;
			else if (tY > (_viewH - _gH))
				tY = _viewH - _gH;
				//tY = Std.int(_viewH - _gH);
			trace('tY:' + tY + '_viewH :'  + _viewH );
			//Out.dumpLayout(_grabber);
			//trace('tY:' + tY + '_viewH :'  + _viewH + 'bg:'  + _gH + ' _content2y:' + (_defaultPosition - (_cH - _viewH) * (tY / _scrollValue)));
			//trace((_cH - _viewH)+ ' * ' + '(' + _grabber.y +' / ' + _scrollValue +')') ;
			STween.removeAllTweens();
			STween.add(_grabber, 0.5, { y:tY } );
			STween.add(_content, 0.5, { 
					y:_scrollValue == 0 ? _defaultPosition :_defaultPosition -  (_cH - _viewH) * (tY / _scrollValue), onComplete:reset
					//y:_defaultPosition - Math.ceil( (_cH - _viewH) * (tY / _scrollValue)), onComplete:reset
			});
		}
		
		//####################
		function stopScroll(e:Event):Void
		//####################
		{
			onUpListener();
		}
		
		//####################
		function scrollContent(e:Event):Void
		//####################
		{
			var ty:Float;
			var dist:Float;
			var moveAmount:Float;
			
			ty = -((_cH - _viewH) * (_grabber.y / _scrollValue));

			//dist = ty - _content.y + _defaultPosition;
			dist = ty - _content.y;
			moveAmount = dist / _easeAmount;
			//_content.y += Math.round(moveAmount);
			_content.y += moveAmount;
			//trace(Math.abs(_content.y - ty - _defaultPosition) + ' ty:' + ty + ' y:' + _content.y + ' dist:' + dist +' moveAmount:' + moveAmount);
			if (Math.abs(_content.y - ty - _defaultPosition) < 1.5)
			{
				_grabber.removeEventListener(Event.ENTER_FRAME, scrollContent, false);
				//trace('_content.y:' + _content.y + ' ty:' + ty);
				//_content.y = Math.round(ty) + _defaultPosition;
				_content.y =  ty  + _defaultPosition;
				//trace('removed ENTER_FRAME');
			}						
			
			//positionGrips();
		}
		
		//####################
		public function adjustSize():Void
		//####################
		{
			//this.x = _viewW - _trackThickness;
			_track.height = _viewH;
			//_track.y = 0;
			//_viewH = _track.height;
			_cH = _content.height;// + _defaultPosition;
			//trace(_cH);
			// Set height of grabber relative to how much content
			//_gH = _gH = Math.ceil((_viewH / _cH) * _viewH);
			//_gH = _viewH < _cH ? _grabber.getChildByName("bg").height = Math.floor((_viewH / _cH) * _viewH) :_viewH;
			_gH = _viewH < _cH ? _grabber.getChildByName("bg").height = (_viewH / _cH) * _viewH :_viewH;
			
			// Set minimum size for grabber
			if(_gH < 35) _gH = 35;
			if(_hasShine) _grabber.getChildByName("shine").height = _gH;
			
			// If scroller is taller than stage height, set its y position to the very bottom
			if ((_grabber.y + _gH) > _viewH) _grabber.y = _viewH - _gH;
			
			// If content height is less than stage height, set the scroller y position to 0, otherwise keep it the same
			_grabber.y = (_cH < _viewH) ? 0 :_grabber.y;
			
			// If content height is greater than the stage height, show it, otherwise hide it
			//this.visible = (_cH + 8 > _viewH);
			this.visible = (_cH > _viewH);
			//trace('visible:' + this.visible + '_cH :' + _cH + ' _viewH:' + _viewH);
			//TODO ADJUST TEXTFIELD WIDTH DYNAMICALLY
			// Distance left to scroll
			_scrollValue = _viewH - _gH;
			// SCROLLHEIGHT	
			_scrollStep = _gH;
			//_scrollStep = _viewH - _lineHeight;
			trace(_content.height + '_viewH :' + _viewH + ' _scrollValue:' + _scrollValue + ' _scrollStep:' + _scrollStep);
			//trace(_content.y );
			//_content.y = Math.round(-((_cH - _viewH) * (_grabber.y / _scrollValue)) + _defaultPosition);
			_content.y = _scrollValue == 0 ? _defaultPosition :-((_cH - _viewH) * (_grabber.y / _scrollValue)) + _defaultPosition;
			//trace(_content.y +' _defaultPosition:' + _defaultPosition);
			//trace((_cH - _viewH)+ ' * ' + '(' + _grabber.y +' / ' + _scrollValue +')') ;
			_lineStep = (_lineHeight == 0 ? 0:_gH / _lineHeight);
			positionGrips();
			if (_content.height < _viewH) 
			{ 
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener, false); 
				stage.removeEventListener(KeyboardEvent.KEY_UP, doScroll, false); 
			} 
			else 
			{ 
				stage.addEventListener(KeyboardEvent.KEY_UP, doScroll,false,0,true); 
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener,false,0,true); 
				//SWFWheel.initialize(Lib.current.stage);
			}
			//trace(stage.hasEventListener(MouseEvent.MOUSE_WHEEL));
		}
		
		//####################
		function positionGrips():Void
		//####################
		{
			_grabberGrip.y = Math.ceil(
				_grabber.getChildByName("bg").y + 
				(_gH / 2) - (_grabberGrip.height / 2));
			_grabberArrow1.y = _grabber.getChildByName("bg").y + 8;
			_grabberArrow2.y = _gH - 8;
		}
			
		//####################
				
		// CREATORS		
		
		//####################
		
		//####################
		function createTrack():Void
		//####################
		{
			_track = new Sprite();
			///var t:Sprite = new Sprite();
			drawTrack();
			//_track.addChild(t);
			addChild(_track);
		}
		
		function drawTrack()
		{
			//trace(_trackColor + ':' + _trackThickness);
			var t:Sprite = _track;
			t.graphics.clear();
			t.graphics.beginFill(_trackColor); 
			t.graphics.drawRect(0, 0, _trackThickness, _trackThickness);
			//t.graphics.drawRect(0, 0, _trackThickness, _track.height);
			t.graphics.endFill();
		}
		
		//####################
		function createGrabber():Void
		//####################
		{
			_grabber = new Sprite();
			var t:Sprite = new Sprite();
			t.name = "bg";			
			_grabber.addChild(t);
			
			if(_hasShine)
			{
				var shine:Sprite = new Sprite();
				shine.name = "shine";
				_grabber.addChild(shine);
			}
			
			addChild(_grabber);
			drawGrabber();
		}
		
		function drawGrabber()
		{
			var t:Sprite = cast _grabber.getChildAt(0);
			t.graphics.clear();
			t.graphics.beginFill(_grabberColor); 
			t.graphics.drawRect(0, 0, _grabberThickness, _grabberThickness);
			t.graphics.endFill();
			if(_hasShine)
			{
				var sg:Graphics = cast(_grabber.getChildAt(1)).graphics;
				sg.clear();
				sg.beginFill(0xffffff, 0.15);
				var mat:Matrix = new Matrix();
				mat.createGradientBox(_trackThickness, _trackThickness, 0);
				sg.beginGradientFill(
					//GradientType.LINEAR, [0xffffff, 0xffffff, 0xffffff], [0, 0.15, 0.5], [0, 150, 255],
					GradientType.LINEAR, [0xffffff, 0xffffff, 0, 0], [0.5, 0.1, 0, 0.5], [0, 57, 190, 255],
					mat);
				sg.drawRect(0, 0, Math.ceil(_trackThickness), _trackThickness);
				sg.endFill();
			}
		}
		
		public function tint(cs:Array<String>)
		{
			_trackColor = Std.parseInt(cs[0]);
			_grabberColor = Std.parseInt(cs[1]);
			trace(_trackColor + ':' + _grabberColor);
			drawGrabber();
			drawTrack();
		}
		
		//####################
		function createGrips():Void
		//####################
		{
			_grabberGrip = createGrabberGrip();
			_grabber.addChild(_grabberGrip);
			
			_grabberArrow1 = createPixelArrow();
			_grabber.addChild(_grabberArrow1);
			
			_grabberArrow2 = createPixelArrow();
			_grabber.addChild(_grabberArrow2);
			
			_grabberArrow1.rotation = -90;
			_grabberArrow1.x = ((_grabberThickness - 7) / 2) + 1;
			_grabberArrow2.rotation = 90;
			_grabberArrow2.x = ((_grabberThickness - 7) / 2) + 6;
		}
		
		//####################
		function createGrabberGrip():Sprite
		//####################
		{
			var w:Int = 7;
			var xp:Float = (_grabberThickness - w) / 2;
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_gripColor, 1);
			t.graphics.drawRect(xp, 0, w, 1);
			t.graphics.drawRect(xp, 0 + 2, w, 1);
			t.graphics.drawRect(xp, 0 + 4, w, 1);
			t.graphics.drawRect(xp, 0 + 6, w, 1);
			t.graphics.drawRect(xp, 0 + 8, w, 1);
			t.graphics.endFill();
			return t;
		}
		
		//####################
		function createPixelArrow():Sprite
		//####################
		{
			var t:Sprite = new Sprite();			
			t.graphics.beginFill(_gripColor, 1);
			t.graphics.drawRect(0, 0, 1, 1);
			t.graphics.drawRect(1, 1, 1, 1);
			t.graphics.drawRect(2, 2, 1, 1);
			t.graphics.drawRect(1, 3, 1, 1);
			t.graphics.drawRect(0, 4, 1, 1);
			t.graphics.endFill();
			return t;
		}
		
		//####################
		
		
		// LISTENERS
		
		
		//####################
		//public static var wheelScrollStep:Int = 8;
		//####################
		function mouseWheelListener(mE:MouseEvent):Void
		//####################
		{
			trace('hmm...');
			mE.preventDefault();
			mE.stopImmediatePropagation();

			var d:Float = mE.delta * .25;
			//var d:Float = mE.delta * 1;
			trace(d +':' + mE.delta + ':' );
			//return;
			if (d > 0)//up
			{
				if ((_grabber.y - (d * _scrollStep)) >= 0)
				{//_scrollStep
					startScroll(_grabber.y - d * _scrollStep);
				}
				else
				{
					startScroll(0);
				}
				//trace('_grabber.willTrigger(Event.ENTER_FRAME):'+_grabber.willTrigger(Event.ENTER_FRAME));
			//	if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
			else
			{//down
				//trace(_content.name);
				if (((_grabber.y + _grabber.height) + (Math.abs(d) * _scrollStep)) <= _viewH)
				{
					startScroll(_grabber.y + Math.abs(d) * _scrollStep);
				}
				else
				{
					trace('ok' + (_grabber.y + _grabber.height) + (Math.abs(d) * _scrollStep) + ' > ' + _viewH );
					startScroll(_viewH - _grabber.height);
				}
				//if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
		}
		
		//####################
		function onDownListener(e:MouseEvent):Void
		//####################
		{
			_pressed = true;
			_grabber.startDrag(false, new Rectangle(0, 0, 0, _viewH - _gH));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener, false, 0, true);
			//TweenLite.to(_grabber.getChildByName("bg"), 0.5, { tint:_grabberPressColor } );
			//STween.add (this, 1.0, {alpha:0.0, onComplete:cB, onCompleteParams:[this]});
			//STween.add(_grabber.getChildByName("bg"), 0.5
		}
		
		//####################
		function onUpListener(?e:MouseEvent = null):Void
		//####################
		{
			if (_pressed)
			{
				_pressed = false;
				_grabber.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener, false);
				//TweenLite.to(_grabber.getChildByName("bg"), 0.5, { tint:null } );
			}
		}
		
		//####################
		function onMouseMoveListener(e:MouseEvent):Void
		//####################
		{
			e.updateAfterEvent();
			if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
		}
		
		//####################
		public function onTrackClick(e:MouseEvent):Void
		//####################
		{			
			//trace(parent.getBounds(stage).toString());
			//trace(e.stageY + '_grabber.height :' + _grabber.height  + ' == ' + _gH);
			//trace('e.stageY :' + e.stageY + ' e.localY :' + e.localY + ' _defaultPosition:' +_defaultPosition+ ' _contentTop:' +_contentTop);
			var p:Int = (e.stageY == 0 ? Math.ceil(e.localY) :Math.ceil(e.stageY - _defaultPosition - _contentTop));
			//focusContent();
			//p = Math.ceil(e.localY);
			trace('clickedY:' + p + ' grabberY:' + _grabber.y + ' grabberBottom:' + (_grabber.y + _grabber.height)+ ' stageY:' + e.stageY);
			if(p < _grabber.y)//UP
			{
				if(_grabber.y < _grabber.height)
				{
					startScroll(0);
					trace('up2zero');
				}
				else
				{
					//TweenLite.to(_grabber, 0.5, {y:"-150", onComplete:reset});
					//STween.add(_grabber, 0.5, { y:"-150", onComplete:reset});
					//STween.add(_grabber, 0.5, { y:"-" + _scrollStep, onComplete:reset } );
					//trace(_grabber.y - _scrollStep);
					startScroll(_grabber.y - _scrollStep);
					//trace(_grabber.y - _scrollStep);
					//trace('-'+_scrollStep);
				}
				
				//if(_grabber.y < 0) _grabber.y = 0;
			}
			else if(p>(_grabber.y + _grabber.height))//DOWN
			{
				if((_grabber.y + _grabber.height) > (_viewH - _grabber.height))
				{
					//startScroll(_viewH - _grabber.height);
					//startScroll(_grabber.y + _scrollStep);
					trace(_scrollValue);
					startScroll(_scrollValue);
					//STween.add(_grabber, 0.5, {y:_viewH - _grabber.height, onComplete:reset});
					//trace('abs:'+(_viewH - _grabber.height));
				}
				else
				{
					startScroll(_grabber.y + _scrollStep);
					//startScroll(_scrollStep);
					trace('+'+_scrollStep);
				}				
				//if (_grabber.y + _gH > _track.height)
					//_grabber.y = _content.parent.height - _gH;
			}			
			//_grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
		}
		
		function focusContent():Void
		{
			var cY = _content.y;
			stage.focus = cast _content;
			_content.y = cY;
		}
		
		function reset():Void
		{
			//trace(_content.y + ':' + _grabber.y + ':' + _content.parent);
			if(_grabber.y < 0) _grabber.y = 0;
			else
			if(_grabber.y + _gH > _viewH) _grabber.y = _viewH - _gH;
			//trace(_content.y + ':' + _grabber.y);
		}
		
		//####################
		public function resize(v:Rectangle):Void
		//####################
		{
			//_viewW = _view.width;
			_view = v;
			_viewH = _view.height;		
			y = _content.y;		
			x = _content.x + _content.width + 8;
			adjustSize();			
		}
	
}