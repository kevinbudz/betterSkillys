package com.company.assembleegameclient.engine3d
{
   import flash.geom.Vector3D;
   
   public class Line3D
   {
       
      
      public var v0_:Vector3D;
      
      public var v1_:Vector3D;
      
      public function Line3D(v0:Vector3D, v1:Vector3D)
      {
         super();
         this.v0_ = v0;
         this.v1_ = v1;
      }
      
      public static function unitTest() : Boolean
      {
         return UnitTest.run();
      }
      
      public function crossZ(l:Line3D) : int
      {
         var d:Number = (l.v1_.y - l.v0_.y) * (this.v1_.x - this.v0_.x) - (l.v1_.x - l.v0_.x) * (this.v1_.y - this.v0_.y);
         if(d < 0.001 && d > -0.001)
         {
            return Order.NEITHER;
         }
         var uan:Number = (l.v1_.x - l.v0_.x) * (this.v0_.y - l.v0_.y) - (l.v1_.y - l.v0_.y) * (this.v0_.x - l.v0_.x);
         var ubn:Number = (this.v1_.x - this.v0_.x) * (this.v0_.y - l.v0_.y) - (this.v1_.y - this.v0_.y) * (this.v0_.x - l.v0_.x);
         if(uan < 0.001 && uan > -0.001 && ubn < 0.001 && ubn > -0.001)
         {
            return Order.NEITHER;
         }
         var ua:Number = uan / d;
         var ub:Number = ubn / d;
         if(ua > 1 || ua < 0 || ub > 1 || ub < 0)
         {
            return Order.NEITHER;
         }
         var zdiff:Number = this.v0_.z + ua * (this.v1_.z - this.v0_.z) - (l.v0_.z + ub * (l.v1_.z - l.v0_.z));
         if(zdiff < 0.001 && zdiff > -0.001)
         {
            return Order.NEITHER;
         }
         if(zdiff > 0)
         {
            return Order.IN_FRONT;
         }
         return Order.BEHIND;
      }
      
      public function lerp(p:Number) : Vector3D
      {
         return new Vector3D(this.v0_.x + (this.v1_.x - this.v0_.x) * p,this.v0_.y + (this.v1_.y - this.v0_.y) * p,this.v0_.z + (this.v1_.z - this.v0_.z) * p);
      }
      
      public function toString() : String
      {
         return "(" + this.v0_ + ", " + this.v1_ + ")";
      }
   }
}

import com.company.assembleegameclient.engine3d.Line3D;
import com.company.assembleegameclient.engine3d.Order;
import flash.geom.Vector3D;

class UnitTest
{
    
   
   function UnitTest()
   {
      super();
   }
   
   private static function testCrossZ() : Boolean
   {
      var l0:Line3D = new Line3D(new Vector3D(0,0,0),new Vector3D(0,100,0));
      var l1:Line3D = new Line3D(new Vector3D(10,0,10),new Vector3D(-10,100,-100));
      if(l0.crossZ(l1) != Order.IN_FRONT)
      {
         return false;
      }
      if(l1.crossZ(l0) != Order.BEHIND)
      {
         return false;
      }
      l0 = new Line3D(new Vector3D(1,1,200),new Vector3D(6,6,200));
      l1 = new Line3D(new Vector3D(3,1,-100),new Vector3D(1,3,-100));
      if(l0.crossZ(l1) != Order.IN_FRONT)
      {
         return false;
      }
      if(l1.crossZ(l0) != Order.BEHIND)
      {
         return false;
      }
      return true;
   }
   
   public static function run() : Boolean
   {
      trace("STARTING UNITTEST: Line3D");
      if(!testCrossZ())
      {
         trace("CrossZ test FAILED!");
         return false;
      }
      trace("FINISHED UNITTEST: Line3D");
      return true;
   }
}
