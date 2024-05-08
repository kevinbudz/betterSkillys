package com.company.util
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class IntPoint
   {
       
      
      public var x_:int;
      
      public var y_:int;
      
      public function IntPoint(x:int = 0, y:int = 0)
      {
         super();
         this.x_ = x;
         this.y_ = y;
      }
      
      public static function unitTest() : void
      {
         var test:UnitTest = new UnitTest();
      }
      
      public static function fromPoint(p:Point) : IntPoint
      {
         return new IntPoint(Math.round(p.x),Math.round(p.y));
      }
      
      public function x() : int
      {
         return this.x_;
      }
      
      public function y() : int
      {
         return this.y_;
      }
      
      public function setX(x:int) : void
      {
         this.x_ = x;
      }
      
      public function setY(y:int) : void
      {
         this.y_ = y;
      }
      
      public function clone() : IntPoint
      {
         return new IntPoint(this.x_,this.y_);
      }
      
      public function same(p:IntPoint) : Boolean
      {
         return this.x_ == p.x_ && this.y_ == p.y_;
      }
      
      public function distanceAsInt(p:IntPoint) : int
      {
         var dx:int = p.x_ - this.x_;
         var dy:int = p.y_ - this.y_;
         return Math.round(Math.sqrt(dx * dx + dy * dy));
      }
      
      public function distanceAsNumber(p:IntPoint) : Number
      {
         var dx:int = p.x_ - this.x_;
         var dy:int = p.y_ - this.y_;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      public function distanceToPoint(p:Point) : Number
      {
         var dx:int = p.x - this.x_;
         var dy:int = p.y - this.y_;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      public function trunc1000() : IntPoint
      {
         return new IntPoint(int(this.x_ / 1000) * 1000,int(this.y_ / 1000) * 1000);
      }
      
      public function round1000() : IntPoint
      {
         return new IntPoint(Math.round(this.x_ / 1000) * 1000,Math.round(this.y_ / 1000) * 1000);
      }
      
      public function distanceSquared(p:IntPoint) : int
      {
         var dx:int = p.x() - this.x_;
         var dy:int = p.y() - this.y_;
         return dx * dx + dy * dy;
      }
      
      public function toPoint() : Point
      {
         return new Point(this.x_,this.y_);
      }
      
      public function transform(m:Matrix) : IntPoint
      {
         var p:Point = m.transformPoint(this.toPoint());
         return new IntPoint(Math.round(p.x),Math.round(p.y));
      }
      
      public function toString() : String
      {
         return "(" + this.x_ + ", " + this.y_ + ")";
      }
   }
}

import com.company.util.IntPoint;

class UnitTest
{
    
   
   function UnitTest()
   {
      var p:IntPoint = null;
      var rp:IntPoint = null;
      var n:Number = NaN;
      super();
      trace("STARTING UNITTEST: IntPoint");
      p = new IntPoint(999,1001);
      rp = p.round1000();
      if(rp.x() != 1000 || rp.y() != 1000)
      {
         trace("ERROR IN UNITTEST: IntPoint1");
      }
      p = new IntPoint(500,400);
      rp = p.round1000();
      if(rp.x() != 1000 || rp.y() != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint2");
      }
      p = new IntPoint(-400,-500);
      rp = p.round1000();
      if(rp.x() != 0 || rp.y() != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint3");
      }
      p = new IntPoint(-501,-999);
      rp = p.round1000();
      if(rp.x() != -1000 || rp.y() != -1000)
      {
         trace("ERROR IN UNITTEST: IntPoint4");
      }
      p = new IntPoint(-1000,-1001);
      rp = p.round1000();
      if(rp.x() != -1000 || rp.y() != -1000)
      {
         trace("ERROR IN UNITTEST: IntPoint5");
      }
      p = new IntPoint(999,1001);
      rp = p.trunc1000();
      if(rp.x() != 0 || rp.y() != 1000)
      {
         trace("ERROR IN UNITTEST: IntPoint6");
      }
      p = new IntPoint(500,400);
      rp = p.trunc1000();
      if(rp.x() != 0 || rp.y() != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint7");
      }
      p = new IntPoint(-400,-500);
      rp = p.trunc1000();
      if(rp.x() != 0 || rp.y() != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint8");
      }
      p = new IntPoint(-501,-999);
      rp = p.trunc1000();
      if(rp.x() != 0 || rp.y() != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint9");
      }
      p = new IntPoint(-1000,-1001);
      rp = p.trunc1000();
      if(rp.x() != -1000 || rp.y() != -1000)
      {
         trace("ERROR IN UNITTEST: IntPoint10");
      }
      n = 0.9999998;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint40");
      }
      n = 0.5;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint41");
      }
      n = 0.499999;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint42");
      }
      n = -0.499999;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint43");
      }
      n = -0.5;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint44");
      }
      n = -0.99999;
      if(int(n) != 0)
      {
         trace("ERROR IN UNITTEST: IntPoint45");
      }
      trace("FINISHED UNITTEST: IntPoint");
   }
}
