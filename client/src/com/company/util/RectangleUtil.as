package com.company.util
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RectangleUtil
   {
       
      
      public function RectangleUtil()
      {
         super();
      }
      
      public static function pointDist(rect:Rectangle, x:Number, y:Number) : Number
      {
         var cX:Number = x;
         var cY:Number = y;
         if(cX < rect.x)
         {
            cX = rect.x;
         }
         else if(cX > rect.right)
         {
            cX = rect.right;
         }
         if(cY < rect.y)
         {
            cY = rect.y;
         }
         else if(cY > rect.bottom)
         {
            cY = rect.bottom;
         }
         if(cX == x && cY == y)
         {
            return 0;
         }
         return PointUtil.distanceXY(cX,cY,x,y);
      }
      
      public static function closestPoint(rect:Rectangle, x:Number, y:Number) : Point
      {
         var cX:Number = x;
         var cY:Number = y;
         if(cX < rect.x)
         {
            cX = rect.x;
         }
         else if(cX > rect.right)
         {
            cX = rect.right;
         }
         if(cY < rect.y)
         {
            cY = rect.y;
         }
         else if(cY > rect.bottom)
         {
            cY = rect.bottom;
         }
         return new Point(cX,cY);
      }
      
      public static function lineSegmentIntersectsXY(rect:Rectangle, x0:Number, y0:Number, x1:Number, y1:Number) : Boolean
      {
         var tint:Number = NaN;
         var bint:Number = NaN;
         var maxY:Number = NaN;
         var minY:Number = NaN;
         if(rect.left > x0 && rect.left > x1 || rect.right < x0 && rect.right < x1 || rect.top > y0 && rect.top > y1 || rect.bottom < y0 && rect.bottom < y1)
         {
            return false;
         }
         if(rect.left < x0 && x0 < rect.right && rect.top < y0 && y0 < rect.bottom || rect.left < x1 && x1 < rect.right && rect.top < y1 && y1 < rect.bottom)
         {
            return true;
         }
         var m:Number = (y1 - y0) / (x1 - x0);
         var c:Number = y0 - m * x0;
         if(m > 0)
         {
            tint = m * rect.left + c;
            bint = m * rect.right + c;
         }
         else
         {
            tint = m * rect.right + c;
            bint = m * rect.left + c;
         }
         if(y0 < y1)
         {
            minY = y0;
            maxY = y1;
         }
         else
         {
            minY = y1;
            maxY = y0;
         }
         var topoverlap:Number = tint > minY?Number(tint):Number(minY);
         var botoverlap:Number = bint < maxY?Number(bint):Number(maxY);
         return topoverlap < botoverlap && !(botoverlap < rect.top || topoverlap > rect.bottom);
      }
      
      public static function lineSegmentIntersectXY(rect:Rectangle, p1x:Number, p1y:Number, p2x:Number, p2y:Number, result:Point) : Boolean
      {
         var slope:Number = NaN;
         var c:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         if(p2x <= rect.x)
         {
            slope = (p2y - p1y) / (p2x - p1x);
            c = p1y - p1x * slope;
            y = slope * rect.x + c;
            if(y >= rect.y && y <= rect.y + rect.height)
            {
               result.x = rect.x;
               result.y = y;
               return true;
            }
         }
         else if(p2x >= rect.x + rect.width)
         {
            slope = (p2y - p1y) / (p2x - p1x);
            c = p1y - p1x * slope;
            y = slope * (rect.x + rect.width) + c;
            if(y >= rect.y && y <= rect.y + rect.height)
            {
               result.x = rect.x + rect.width;
               result.y = y;
               return true;
            }
         }
         if(p2y <= rect.y)
         {
            slope = (p2x - p1x) / (p2y - p1y);
            c = p1x - p1y * slope;
            x = slope * rect.y + c;
            if(x >= rect.x && x <= rect.x + rect.width)
            {
               result.x = x;
               result.y = rect.y;
               return true;
            }
         }
         else if(p2y >= rect.y + rect.height)
         {
            slope = (p2x - p1x) / (p2y - p1y);
            c = p1x - p1y * slope;
            x = slope * (rect.y + rect.height) + c;
            if(x >= rect.x && x <= rect.x + rect.width)
            {
               result.x = x;
               result.y = rect.y + rect.height;
               return true;
            }
         }
         return false;
      }
      
      public static function lineSegmentIntersect(rect:Rectangle, p1:IntPoint, p2:IntPoint) : Point
      {
         var slope:Number = NaN;
         var c:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         if(p2.x() <= rect.x)
         {
            slope = (p2.y() - p1.y()) / (p2.x() - p1.x());
            c = p1.y() - p1.x() * slope;
            y = slope * rect.x + c;
            if(y >= rect.y && y <= rect.y + rect.height)
            {
               return new Point(rect.x,y);
            }
         }
         else if(p2.x() >= rect.x + rect.width)
         {
            slope = (p2.y() - p1.y()) / (p2.x() - p1.x());
            c = p1.y() - p1.x() * slope;
            y = slope * (rect.x + rect.width) + c;
            if(y >= rect.y && y <= rect.y + rect.height)
            {
               return new Point(rect.x + rect.width,y);
            }
         }
         if(p2.y() <= rect.y)
         {
            slope = (p2.x() - p1.x()) / (p2.y() - p1.y());
            c = p1.x() - p1.y() * slope;
            x = slope * rect.y + c;
            if(x >= rect.x && x <= rect.x + rect.width)
            {
               return new Point(x,rect.y);
            }
         }
         else if(p2.y() >= rect.y + rect.height)
         {
            slope = (p2.x() - p1.x()) / (p2.y() - p1.y());
            c = p1.x() - p1.y() * slope;
            x = slope * (rect.y + rect.height) + c;
            if(x >= rect.x && x <= rect.x + rect.width)
            {
               return new Point(x,rect.y + rect.height);
            }
         }
         return null;
      }
      
      public static function getRotatedRectExtents2D(centerX:Number, centerY:Number, angle:Number, w:Number, h:Number) : Extents2D
      {
         var pout:Point = null;
         var y:int = 0;
         var m:Matrix = new Matrix();
         m.translate(-w / 2,-h / 2);
         m.rotate(angle);
         m.translate(centerX,centerY);
         var extents:Extents2D = new Extents2D();
         var pin:Point = new Point();
         for(var x:int = 0; x <= 1; x++)
         {
            for(y = 0; y <= 1; y++)
            {
               pin.x = x * w;
               pin.y = y * h;
               pout = m.transformPoint(pin);
               extents.add(pout.x,pout.y);
            }
         }
         return extents;
      }
   }
}
