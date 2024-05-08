package com.company.util
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Triangle
   {
       
      
      public var x0_:Number;
      
      public var y0_:Number;
      
      public var x1_:Number;
      
      public var y1_:Number;
      
      public var x2_:Number;
      
      public var y2_:Number;
      
      public var vx1_:Number;
      
      public var vy1_:Number;
      
      public var vx2_:Number;
      
      public var vy2_:Number;
      
      public function Triangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number)
      {
         super();
         this.x0_ = x0;
         this.y0_ = y0;
         this.x1_ = x1;
         this.y1_ = y1;
         this.x2_ = x2;
         this.y2_ = y2;
         this.vx1_ = this.x1_ - this.x0_;
         this.vy1_ = this.y1_ - this.y0_;
         this.vx2_ = this.x2_ - this.x0_;
         this.vy2_ = this.y2_ - this.y0_;
      }
      
      public static function containsXY(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number) : Boolean
      {
         var vx1:Number = x1 - x0;
         var vy1:Number = y1 - y0;
         var vx2:Number = x2 - x0;
         var vy2:Number = y2 - y0;
         var a:Number = (x * vy2 - y * vx2 - (x0 * vy2 - y0 * vx2)) / (vx1 * vy2 - vy1 * vx2);
         var b:Number = -(x * vy1 - y * vx1 - (x0 * vy1 - y0 * vx1)) / (vx1 * vy2 - vy1 * vx2);
         return a >= 0 && b >= 0 && a + b <= 1;
      }
      
      public static function intersectTriAABB(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, l:Number, t:Number, r:Number, b:Number) : Boolean
      {
         if(l > x0 && l > x1 && l > x2 || r < x0 && r < x1 && r < x2 || t > y0 && t > y1 && t > y2 || b < y0 && b < y1 && b < y2)
         {
            return false;
         }
         if(l < x0 && x0 < r && t < y0 && y0 < b || l < x1 && x1 < r && t < y1 && y1 < b || l < x2 && x2 < r && t < y2 && y2 < b)
         {
            return true;
         }
         return lineRectIntersect(x0,y0,x1,y1,l,t,r,b) || lineRectIntersect(x1,y1,x2,y2,l,t,r,b) || lineRectIntersect(x2,y2,x0,y0,l,t,r,b);
      }
      
      private static function lineRectIntersect(x0:Number, y0:Number, x1:Number, y1:Number, l:Number, t:Number, r:Number, b:Number) : Boolean
      {
         var top_intersection:Number = NaN;
         var bottom_intersection:Number = NaN;
         var toptrianglepoint:Number = NaN;
         var bottomtrianglepoint:Number = NaN;
         var m:Number = (y1 - y0) / (x1 - x0);
         var c:Number = y0 - m * x0;
         if(m > 0)
         {
            top_intersection = m * l + c;
            bottom_intersection = m * r + c;
         }
         else
         {
            top_intersection = m * r + c;
            bottom_intersection = m * l + c;
         }
         if(y0 < y1)
         {
            toptrianglepoint = y0;
            bottomtrianglepoint = y1;
         }
         else
         {
            toptrianglepoint = y1;
            bottomtrianglepoint = y0;
         }
         var topoverlap:Number = top_intersection > toptrianglepoint?Number(top_intersection):Number(toptrianglepoint);
         var botoverlap:Number = bottom_intersection < bottomtrianglepoint?Number(bottom_intersection):Number(bottomtrianglepoint);
         return topoverlap < botoverlap && !(botoverlap < t || topoverlap > b);
      }
      
      public function aabb() : Rectangle
      {
         var minX:Number = Math.min(this.x0_,this.x1_,this.x2_);
         var maxX:Number = Math.max(this.x0_,this.x1_,this.x2_);
         var minY:Number = Math.min(this.y0_,this.y1_,this.y2_);
         var maxY:Number = Math.max(this.y0_,this.y1_,this.y2_);
         return new Rectangle(minX,minY,maxX - minX,maxY - minY);
      }
      
      public function area() : Number
      {
         return Math.abs((this.x0_ * (this.y1_ - this.y2_) + this.x1_ * (this.y2_ - this.y0_) + this.x2_ * (this.y0_ - this.y1_)) / 2);
      }
      
      public function incenter(result:Point) : void
      {
         var a:Number = PointUtil.distanceXY(this.x1_,this.y1_,this.x2_,this.y2_);
         var b:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x2_,this.y2_);
         var c:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x1_,this.y1_);
         result.x = (a * this.x0_ + b * this.x1_ + c * this.x2_) / (a + b + c);
         result.y = (a * this.y0_ + b * this.y1_ + c * this.y2_) / (a + b + c);
      }
      
      public function contains(x:Number, y:Number) : Boolean
      {
         var a:Number = (x * this.vy2_ - y * this.vx2_ - (this.x0_ * this.vy2_ - this.y0_ * this.vx2_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
         var b:Number = -(x * this.vy1_ - y * this.vx1_ - (this.x0_ * this.vy1_ - this.y0_ * this.vx1_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
         return a >= 0 && b >= 0 && a + b <= 1;
      }
      
      public function distance(x:Number, y:Number) : Number
      {
         if(this.contains(x,y))
         {
            return 0;
         }
         return Math.min(LineSegmentUtil.pointDistance(x,y,this.x0_,this.y0_,this.x1_,this.y1_),LineSegmentUtil.pointDistance(x,y,this.x1_,this.y1_,this.x2_,this.y2_),LineSegmentUtil.pointDistance(x,y,this.x0_,this.y0_,this.x2_,this.y2_));
      }
      
      public function intersectAABB(l:Number, t:Number, r:Number, b:Number) : Boolean
      {
         return intersectTriAABB(this.x0_,this.y0_,this.x1_,this.y1_,this.x2_,this.y2_,l,t,r,b);
      }
   }
}
