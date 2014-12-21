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

package me.cunity.effects;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.ActivityEvent;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import me.cunity.effects.phx.CircleSprite;
import me.cunity.effects.phx.Dumper;
import me.cunity.ui.Image;
import haxe.Timer;
import phx.col.BruteForce;
import phx.col.Quantize;
import phx.Collision;
import phx.Const;
import phx.Polygon;

import haxe.ds.GenericStack;

import phx.Body;
import phx.Circle;
import phx.col.AABB;
import phx.col.SortedList;
import phx.FlashDraw;
import phx.Material;
import phx.Shape;
import phx.Vector;

import phx.World;

class Physics 
{	
	public static var world:phx.World;
	var wBox:Rectangle;
	public static var clip:Sprite;
	var dOb:DisplayObject;
	var xmin:Float;
	var xmax:Float;
	var ymin:Float;
	var ymax:Float;
	var fd:FlashDraw;
	static var maxLoop = 0;
	
	public function new(box:Rectangle, c:Sprite, d:DisplayObject) 
	//public function new(left:Float, top:Float, right:Float, bottom:Float) 
	{
		wBox = box;
		clip = c;
		dOb = d;
		fd = new FlashDraw(c.graphics);
		//world = new World(new AABB(wBox.left, wBox.top, wBox.right, wBox.bottom), new SortedList());
		world = new World(new AABB(wBox.left, wBox.top, wBox.right, wBox.bottom), new BruteForce());
		//this.xmin = this.ymin = -1000000000;
		this.xmin = this.ymin = -1000;
		this.xmax = this.ymax = 1000;
		world.boundsCheck = 0;
		/*var r:Body = new Body(100, 10);
		r.addShape(Shape.makeBox(50, 50, 25, 25));
		r.setAngle(Math.PI / 3);
		world.addBody(r);*/
		//world.sleepEpsilon = 0.09;
		var b1:Body = new Body(0, 0);
		//b1.addShape(new CircleSprite(24, new Vector(0, 0), d));
		b1.addShape(new Polygon([new Vector(0, 0), new Vector(0, -24)], new Vector(0,0)));
		b1.addShape(new Circle(24, new Vector(0, 0), new Material(.25, 2.5, 5)));
		//b1.addShape(new Circle(24, new Vector(0, 0)));
		//b1.preventRotation();
		//b1.setAngle(Math.PI / 3);
		trace(Type.getClass(b1.shapes.first()) );
		clip.x = wBox.left;
		clip.y = wBox.top;
		b1.x = b1.y = 50;
		//b1.motion = 
		world.addBody(b1);
		//b1.setSpeed(15, 0, 0.25);
		trace(Dumper.properties(world.staticBody, true));
		//trace(Dumper.properties(b1, true));
		//b1.properties.biasCoef = 0.9;
	/*	b1.properties.angularFriction = 1;
		b1.properties.linearFriction = 1;
		b1.properties.biasCoef = 1.0;*/
		b1.properties.maxDist = 0.0;
		//world.staticBody.properties.maxDist = 0.0;
		//world.staticBody.properties.biasCoef = 0.01;
		//world.staticBody.properties.angularFriction = 0.95;
		//world.staticBody.properties.linearFriction = 0.5;
		
		//trace('added 2body ' + world.bodies.first().id + ' shape ' + world.bodies.first().shapes.first().id);
		//world.useIslands=false;
		//trace('useIslands:' + world.useIslands);
		//var floor = Shape.makeBox(wBox.width, 1, 0, wBox.height + box.top-1, new Material(0,0,1.0));
		//var poly:Polygon
		//world.addStaticShape(Shape.makeBox(wBox.width, wBox.height, 0, 0, 
		//new Material(0,0,1.0)));
		var walls:Map<Shape> = addStaticBox(wBox);
		//walls.get('right').material.restitution = 0.00001;
		//walls.get('right').material = new Material(0.0, 0.0, 1);
		var shp:FastCell<Shape> = world.staticBody.shapes.head;
		if(false)while (shp != null) {
			var wall:Shape = shp.elt;
			trace(wall.id + ' restitution:' + wall.material.restitution + ' friction:' + wall.material.friction);
			shp = shp.next;
		}
		//world.gravity = new Vector(10, 38);
		world.gravity = new Vector(0, 0.50);
		//trace(world.bodies.first().shapes.first().calculateInertia());
		var b:Body = null;
		/*for (b in world.bodies) {
			b.v_bias = new phx.Vector(0.0, 0.0);
			b.w_bias = 0.0;
		}*/
		Lib.current.addEventListener(Event.ENTER_FRAME, loop,false,0,true);
		//Timer.delay(addCopy, 1000);
	}
	
	public function addCircle() {
		var b1:Body = new Body(0, 0);
		//b1.addShape(new CircleSprite(24, new Vector(0, 0), d));
		b1.addShape(new Circle(24, new Vector(0, 0)));
		b1.preventRotation();
		//trace(Type.getClass(b1.shapes.first()) );
		clip.x = wBox.left;
		clip.y = wBox.top;
		b1.x = b1.y = 50;
		//b1.motion = 
		world.addBody(b1);
		b1.setSpeed(15, 0);
	}
	
	function addCopy() {
		var img:Image = cast dOb;
		var copy:Image = img.copy();
		var b1:Body = new Body(0, 0);
		b1.addShape(new CircleSprite(24, new Vector(0, 0), copy));
		b1.preventRotation();
		b1.x = b1.y = 50;
		world.addBody(b1);
		b1.setSpeed(15, 0);
		var cs:CircleSprite = cast b1.shapes.first();
		trace(cs.display);
	}
	
	function addStaticBox(box:Rectangle):Map<Shape> {
		var walls:Map<Shape> = new Map();
		//floor
		world.addStaticShape(Shape.makeBox(wBox.width, 0.5, 0.5, wBox.height));
		trace(world.staticBody.id);
		walls.set('floor', world.staticBody.shapes.head.elt);
		trace(world.staticBody.shapes.head.elt.id +':' + walls.get('floor').material.restitution);
		//right wall
		world.addStaticShape(Shape.makeBox(0.5, wBox.height, wBox.width, 0.5));
		walls.set('right', world.staticBody.shapes.head.elt);
		trace(world.staticBody.shapes.head.elt.body.properties.linearFriction);
		trace(world.staticBody.shapes.head.elt.id);
		//sky
		world.addStaticShape(Shape.makeBox(wBox.width, 0.5, 0.5, 0.5));
		walls.set('sky', world.staticBody.shapes.head.elt);
		//left wall
		world.addStaticShape(Shape.makeBox(0.5, wBox.height, 0.5, 0.5));
		walls.set('left', world.staticBody.shapes.head.elt);
		return walls;
	}
	
	static var doOnce = true;
	function loop(_) {
		Lib.current.traceNow =  (maxLoop++ < 3); 
		//world.step(1, 20);
		//trace(world.bodies.first().x);
		if (world.bodies.head == null) {
			Lib.current.removeEventListener(Event.ENTER_FRAME, loop, false);
			return;
		}
		if (false && maxLoop++ < 22) {
			if (world.bodies.first().x > 150) {				
				//world.bodies.first().setSpeed(0,0,0);
				world.bodies.first().motion = 0;
				world.sleepEpsilon = 1;
				trace(world.bodies.first().x + ' > ' + (wBox.right - 400) +' motion:' + world.bodies.first().motion);
				if (doOnce) {
					Lib.current.traceNow = true;
					doOnce = false;
				}
			}
		}
		//else		Lib.current.removeEventListener(Event.ENTER_FRAME, loop);
		if (false && world.bodies.first().x > wBox.right-100){
			//world.bodies.first().x = wBox.left;
			trace(world.bodies.first().motion);
			world.bodies.first().motion = 0;
			trace(world.bodies.first().motion);
			Lib.current.removeEventListener(Event.ENTER_FRAME, loop, false);
		}
		var last:String = world.bodies.first().a +':' + world.bodies.first().shapes.first().circle.tC.x + ' x ' +
			world.bodies.first().shapes.first().circle.tC.y;
		world.step(1, 100);
		//world.step(0.1, 2);
		if (! Collision.doOnce && doOnce) {
			doOnce = false;
			trace(World.last + last + '\n' + world.bodies.first().a +':' + world.bodies.first().shapes.first().circle.tC.x + ' x ' +
			world.bodies.first().shapes.first().circle.tC.y);
			world.sleepEpsilon = 1;
		}
		var g = clip.graphics;
		g.clear();
		//var fd = new FlashDraw(g);
		//fd.drawCircleRotation = true;
		drawWorld(world);
	}
	
	public function drawWorld( w :World ) {
		fd.drawBody(w.staticBody);
		for ( b in w.bodies ) {			
			if(Type.getClass(b.shapes.first()) == CircleSprite)
				drawBody(b);
			else
				fd.drawBody(b);
		}
		//for( j in w.joints )
			//drawJoint(j);
		for( a in w.arbiters ) {
			//trace(a.contacts);
		}
	}

	public function drawBody( b :Body ) {
		for( s in b.shapes ) {
			var b = s.aabb;
			if( b.r < xmin || b.b < ymin || b.l > xmax || b.t > ymax )
				continue;
			if (s.type == Shape.CIRCLE)
				drawShape(cast s);
		}
	}
	
	public function drawShape( s :CircleSprite ) {
		//var c = selectColor(s);
		/*switch( s.type ) {
			case Shape.CIRCLE:drawCircle(s.circle);
			case Shape.POLYGON:drawPoly(s.polygon);
			case Shape.SEGMENT:drawSegment(s.segment);
			}*/
		//trace(s +' display:' + s.display);
		if( s.display != null ) {//We have a display object
			s.sprite.x = s.circle.tC.x ;
			s.sprite.y = s.circle.tC.y;
			//trace(s.sprite.x);
		}
	}
}