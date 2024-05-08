package com.company.assembleegameclient.engine3d
{
   import flash.geom.Vector3D;
   
   public class Lighting3D
   {
      
      public static const LIGHT_VECTOR:Vector3D = createLightVector();
       
      
      public function Lighting3D()
      {
         super();
      }
      
      public static function shadeValue(normal:Vector3D, ambient:Number) : Number
      {
         var dot:Number = Math.max(0,normal.dotProduct(Lighting3D.LIGHT_VECTOR));
         return ambient + (1 - ambient) * dot;
      }
      
      private static function createLightVector() : Vector3D
      {
         var v:Vector3D = new Vector3D(1,3,2);
         v.normalize();
         return v;
      }
   }
}
