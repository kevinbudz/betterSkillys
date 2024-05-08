package com.company.assembleegameclient.engine3d
{
   import flash.geom.Vector3D;
   
   public class Plane3D
   {
      
      public static const NONE:int = 0;
      
      public static const POSITIVE:int = 1;
      
      public static const NEGATIVE:int = 2;
      
      public static const EQUAL:int = 3;
       
      
      public var normal_:Vector3D;
      
      public var d_:Number;
      
      public function Plane3D(v0:Vector3D = null, v1:Vector3D = null, v2:Vector3D = null)
      {
         super();
         if(v0 != null && v1 != null && v2 != null)
         {
            this.normal_ = new Vector3D();
            computeNormal(v0,v1,v2,this.normal_);
            this.d_ = -this.normal_.dotProduct(v0);
         }
      }
      
      public static function computeNormal(p0:Vector3D, p1:Vector3D, p2:Vector3D, result:Vector3D) : void
      {
         var ux:Number = p1.x - p0.x;
         var uy:Number = p1.y - p0.y;
         var uz:Number = p1.z - p0.z;
         var vx:Number = p2.x - p0.x;
         var vy:Number = p2.y - p0.y;
         var vz:Number = p2.z - p0.z;
         result.x = uy * vz - uz * vy;
         result.y = uz * vx - ux * vz;
         result.z = ux * vy - uy * vx;
         result.normalize();
      }
      
      public static function computeNormalVec(vec:Vector.<Number>, result:Vector3D) : void
      {
         var ux:Number = vec[3] - vec[0];
         var uy:Number = vec[4] - vec[1];
         var uz:Number = vec[5] - vec[2];
         var vx:Number = vec[6] - vec[0];
         var vy:Number = vec[7] - vec[1];
         var vz:Number = vec[8] - vec[2];
         result.x = uy * vz - uz * vy;
         result.y = uz * vx - ux * vz;
         result.z = ux * vy - uy * vx;
         result.normalize();
      }
      
      public function testPoint(v:Vector3D) : int
      {
         var val:Number = this.normal_.dotProduct(v) + this.d_;
         if(val > 0.001)
         {
            return POSITIVE;
         }
         if(val < -0.001)
         {
            return NEGATIVE;
         }
         return EQUAL;
      }
      
      public function lineIntersect(line:Line3D) : Number
      {
         var tn:Number = -this.d_ - this.normal_.x * line.v0_.x - this.normal_.y * line.v0_.y - this.normal_.z * line.v0_.z;
         var td:Number = this.normal_.x * (line.v1_.x - line.v0_.x) + this.normal_.y * (line.v1_.y - line.v0_.y) + this.normal_.z * (line.v1_.z - line.v0_.z);
         if(td == 0)
         {
            return NaN;
         }
         return tn / td;
      }
      
      public function zAtXY(x:Number, y:Number) : Number
      {
         return -(this.d_ + this.normal_.x * x + this.normal_.y * y) / this.normal_.z;
      }
      
      public function toString() : String
      {
         return "Plane(n = " + this.normal_ + ", d = " + this.d_ + ")";
      }
   }
}
