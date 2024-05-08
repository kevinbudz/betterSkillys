package com.company.util
{
   import flash.geom.Point;
   
   public class PointUtil
   {
      
      public static const ORIGIN:Point = new Point(0,0);
       
      
      public function PointUtil(se:StaticEnforcer)
      {
         super();
      }
      
      public static function roundPoint(p:Point) : Point
      {
         var newP:Point = p.clone();
         newP.x = Math.round(newP.x);
         newP.y = Math.round(newP.y);
         return newP;
      }
      
      public static function distanceSquared(p1:Point, p2:Point) : Number
      {
         return distanceSquaredXY(p1.x,p1.y,p2.x,p2.y);
      }
      
      public static function distanceSquaredXY(x1:Number, y1:Number, x2:Number, y2:Number) : Number
      {
         var xdiff:Number = x2 - x1;
         var ydiff:Number = y2 - y1;
         return (xdiff * xdiff) + (ydiff * ydiff);
      }
      
      public static function distanceXY(x1:Number, y1:Number, x2:Number, y2:Number) : Number
      {
         var xdiff:Number = x2 - x1;
         var ydiff:Number = y2 - y1;
         return Math.sqrt((xdiff * xdiff) + (ydiff * ydiff));
      }
      
      public static function lerpXY(x1:Number, y1:Number, x2:Number, y2:Number, f:Number) : Point
      {
         return new Point(x1 + (x2 - x1) * f,y1 + (y2 - y1) * f);
      }
      
      public static function angleTo(p1:Point, p2:Point) : Number
      {
         return Math.atan2(p2.y - p1.y,p2.x - p1.x);
      }
      
      public static function pointAt(p:Point, angle:Number, r:Number) : Point
      {
         var ret:Point = new Point();
         ret.x = p.x + (r * Math.cos(angle));
         ret.y = p.y + (r * Math.sin(angle));
         return ret;
      }
   }
}

class StaticEnforcer
{
    
   
   function StaticEnforcer()
   {
      super();
   }
}
