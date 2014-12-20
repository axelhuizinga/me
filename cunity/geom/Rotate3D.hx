/**
 *
 * @author Axel Huizinga
 */

package me.cunity.geom;

import com.as3dmod.core.Matrix4;
import com.as3dmod.core.Vector3;
import sandy.core.scenegraph.Shape3D;

class Rotate3D 
{
	
	var obj:Shape3D;
	var vX:Vector3;
	var vY:Vector3;
	var vZ:Vector3;
	
	var rX:Float;
	var rY:Float;
	var rZ:Float;
	
	
	public function new(obj:Shape3D) 
	{
		this.obj = obj;
		vX = new Vector3(1, 0, 0);
		vY = new Vector3(0, 1, 0);
		vZ = new Vector3(0, 0, 1);		
	}
	
	public function apply() 
	{		
		var vs:Array<Dynamic> = mod.getVertices();
		var vc:Int = vs.length;
		
		var ms:Matrix4;
		if(turn != 0) {
			var mt:Matrix4 = Matrix4.rotationMatrix(steerVector.x, steerVector.y, steerVector.z, turn);
			var rv:Vector3 = rollVector.clone();
			Matrix4.multiplyVector(mt, rv);
			ms = Matrix4.rotationMatrix(rv.x, rv.y, rv.z, roll);
		} else {
			ms = Matrix4.rotationMatrix(rollVector.x, rollVector.y, rollVector.z, roll);
		}

		for (i in 0...vc) {
			var v:VertexProxy = cast( vs[i], VertexProxy);
			var c:Vector3 = v.vector.clone();
			if(turn != 0) Matrix4.multiplyVector(mt, c);
			Matrix4.multiplyVector(ms, c);
			v.x = c.x;
			v.y = c.y;
			v.z = c.z;
		}		
	}
	
}