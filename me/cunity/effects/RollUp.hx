/**
 *
 * @author Axel Huizinga
 */

package me.cunity.effects;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.geom.Rectangle;
import me.cunity.graphics.BitmapLoader;
import me.cunity.effects.DistortImage;
import sandy.events.Shape3DEvent;
import sandy.materials.attributes.LightAttributes;
import sandy.materials.attributes.LineAttributes;
import sandy.materials.attributes.MaterialAttributes;
import sandy.materials.Material;
import sandy.materials.ColorMaterial;
import sandy.core.Scene3D;
import sandy.core.data.PrimitiveFace;
import sandy.core.data.Vertex;
import sandy.core.data.Point3D;
import sandy.core.scenegraph.Geometry3D;
import sandy.core.scenegraph.Shape3D;
import sandy.core.scenegraph.Camera3D;
import sandy.core.scenegraph.Group;
import sandy.core.scenegraph.TransformGroup;
import sandy.primitive.Plane3D;
import sandy.materials.Appearance;
import sandy.materials.BitmapMaterial;
import flash.display.Sprite;
import flash.Lib;

import com.as3dmod.ModifierStack;
import com.as3dmod.plugins.sandy3d.LibrarySandy3d;
import com.as3dmod.modifiers.Bend;
import com.as3dmod.util.ModConstant;
import com.as3dmod.util.Phase;	

class RollUp extends Sprite
{
	var bmpLoader:BitmapLoader;
	var loop:Int ;	
	var rPlane:Plane3D;
	//var rPlane:Sprite;
	var scene:Scene3D;
	var tg:TransformGroup;
	var d_tl:SandyPoint;
	var d_bl:SandyPoint ;
	var d_tr:SandyPoint;
	var d_br:SandyPoint;	
	var distort:DistortImage;
	private var m_aFaces :Array<PrimitiveFace>;
	var __dumpObject:Dynamic -> haxe.PosInfos -> Void;

	public function new(?imgList:Array<String>) 
	{
		super(); 
		bmpLoader = new BitmapLoader( 
			{ onCompleteCallback:run, href:'sandy/palm.jpg'} );		
	}
	
	function run(content:DisplayObject){
		//sphere.appearance = new Appearance(  new BitmapMaterial( new Palm() ) );
		var bmpMat:BitmapMaterial = new BitmapMaterial( bmpLoader.bData );
		bmpMat.lightingEnable = true;

		trace(content.width + ' x ' + content.height );
		scene = new Scene3D( "myScene", this, new Camera3D( Std.int(content.width), 
			Std.int(content.height)), new Group("root") );
		//var sphere:Sphere = new Sphere("mySphere");
		tg = new TransformGroup("MainTransform");
		
		//trace(Std.string(Type.getInstanceFields(Type.getClass(bmpLoader))));
		//trace(Type.getInstanceFields(Type.getClass(content)).join('\n'));
		var res:Int = 24;
		rPlane = new Plane3D("rollUpPlane", 
		content.height, //height
		content.width, //width
		res, res, 
		'xy_aligned',
		//'zx_aligned',
		'quad'		
		);
		//dumpObject(bmpLoader);
		trace(scene.camera.z);
		dumpObject(scene.camera.getLookAt());
		scene.camera.lookAt(0, 0, 0);
		var r:Float = Math.sqrt(
		Math.pow(content.width, 2) + Math.pow(content.height, 2)) / 2;
		r = content.height;
		scene.camera.z = -r / Math.tan(scene.camera.fov * Math.PI / 180);
		bmpMat.smooth = true;
		rPlane.appearance = new Appearance( bmpMat );
		///
		var materialAttr:MaterialAttributes = new MaterialAttributes([
			new LineAttributes(0.5, 0x990000, 0.5)]);
		var material:Material = new ColorMaterial(0xffcc33, 1, materialAttr);
		
		//rPlane.appearance = new Appearance( material );	
		///
		rPlane.enableEvents = true;
		rPlane.enableBackFaceCulling = false;
		//rPlane.useSingleContainer = false;
		//scene.root.addChild( sphere );
		tg.addChild( rPlane );
		scene.root.addChild( scene.camera );
		scene.root.addChild( tg);
		//
		/*tg.pan = 10;
		tg.tilt = 45;
		tg.roll = 10;*/
		Lib.current.stage.addChild(this);
		//loop = 0;
		//rPlane.addEventListener(MouseEvent.MOUSE_UP, rollUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, rollUp,false,0,true);
		Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame,false,0,true);
		for (poly in rPlane.aPolygons){
			poly.container.addEventListener(MouseEvent.MOUSE_OVER, highlight,false,0,true);
			poly.container.addEventListener(MouseEvent.MOUSE_OUT, reset,false,0,true);
		}
		
				//1. istantiate the ModifierStack 
		var m:ModifierStack = new ModifierStack(new LibrarySandy3d(), rPlane);
	   
		//2. define Bend Modifier
		var b1:Bend = new Bend( .5, 0.5, .4) ;
		//var b2:Bend = new Bend(.1, 0.5, .4 + Math.PI * .5) ;
		var b2:Bend = new Bend(.1, 0.5) ;
		b2.switchAxes = true;
		//var b2:Bend = new Bend(.1, 0.5, .4+Math.PI*.5) ;
		
		//3. definre some bedning parameters
		//b1.bendAxis = ModConstant.X;
		//b2.bendAxis = ModConstant.Y;
		
		//4. adding modifier and applying the modifications
		m.addModifier(b1);
		m.addModifier(b2);
		
		m.apply();
		scene.render();
	}
	
	function highlight(evt:MouseEvent) {
		evt.target.alpha = 0.5;		
		//trace(evt.target.name + ':' + evt.target.getChildAt(0).name);
		trace(evt.target.name + ':' + evt.target.parent.parent.name);
	}
	
	function reset(evt:MouseEvent) {
		evt.target.alpha = 1.0;
	}
	
	function rollUp(evt:MouseEvent) {
	//function rollUp(evt:Shape3DEvent) {
		/*d_bl.x += 10;
		d_bl.y -= 3;
		//distort.setTransform (d_tl, d_tr, d_br, d_bl);
		distort.rollUp();*/
		//Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		//Lib.current.nextFrame();
		
		var materialAttr01:MaterialAttributes = new MaterialAttributes( 
                                                      [new LightAttributes( true, 0.1)]);
		 var material01:Material = new sandy.materials.ColorMaterial( 0xFFCC33, 1, materialAttr01 );
      material01.lightingEnable = true;
      var app01 = new Appearance( material01 );
		trace(Std.string(rPlane.aPolygons.length));
		var poly = rPlane.aVisiblePolygons[rPlane.aVisiblePolygons.length-1];
		var poly = rPlane.aVisiblePolygons[0];
		var poly = rPlane.aPolygons[rPlane.aPolygons.length-1];
		var verts = poly.vertices;
		trace(poly.id + ' vertices.length:' + verts.length);
		for (v in verts)
			dumpObject(v);
		//trace('x:' + v.x + ' y:' + v.y + ' z:' + v.z +'\n');
		/*verts[0].x += 10;
		verts[0].z -= 10;
		verts[3].x += 10;
		verts[3].z -= 10;*/
		//poly.material.renderPolygon(scene, poly, poly.container);
		trace(rPlane.appearance);
		trace(poly.material.id);
		trace(poly.appearance == rPlane.appearance);
		//poly.visible = false;
		//poly.appearance = app01;
		//poly.material.unlink(poly);
		trace(poly.appearance == rPlane.appearance);
		trace(poly.container.name);
		/*var s:DisplayObject = getChildByName('instance8');
		s.x += s.width*.5;
		s.scaleX = .5;*/
		trace(rPlane.rotateZ );
		//tg.pan += 1;
		//trace(tg.tilt);
		//tg.pan = 10;
		tg.tilt += 15;
		//tg.roll = 10;
		trace(tg.tilt);
		//poly.container.rotation = 30;
		//rPlane.generate();info@iamaghanaian.com
		//poly.material.dispose();
		//scene.render();
	}
	
	function onEnterFrame(evt:Event) {
		//if (loop++ < 360) {
			//sphere.rotateZ=loop * 10;
			//sphere.rotateAxis(1, 0, 0, loop);
			//sphere.rotateAxis(0.1, 1, 0.1, 1);
			//scene.render();
		//}
		scene.render();
	}
	
	
	
	public static function dumpObject(ob:Dynamic, ?i:haxe.PosInfos) {
		trace('dumpObject:' + ob, i);
		ExternalInterface.call('dumpObject', ob);
	}
}