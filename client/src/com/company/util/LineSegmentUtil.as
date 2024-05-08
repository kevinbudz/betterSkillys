package com.company.util
{
   import flash.geom.Point;
   
   public class LineSegmentUtil
   {
       
      
      public function LineSegmentUtil()
      {
         super();
      }
      
      public static function intersection(l1x1:Number, l1y1:Number, l1x2:Number, l1y2:Number, l2x1:Number, l2y1:Number, l2x2:Number, l2y2:Number) : Point
      {
         var d:Number = (l2y2 - l2y1) * (l1x2 - l1x1) - (l2x2 - l2x1) * (l1y2 - l1y1);
         if(d == 0)
         {
            return null;
         }
         var ua:Number = ((l2x2 - l2x1) * (l1y1 - l2y1) - (l2y2 - l2y1) * (l1x1 - l2x1)) / d;
         var ub:Number = ((l1x2 - l1x1) * (l1y1 - l2y1) - (l1y2 - l1y1) * (l1x1 - l2x1)) / d;
         if(ua > 1 || ua < 0 || ub > 1 || ub < 0)
         {
            return null;
         }
         var p:Point = new Point(l1x1 + ua * (l1x2 - l1x1),l1y1 + ua * (l1y2 - l1y1));
         return p;
      }
      
      public static function pointDistance(x:Number, y:Number, x0:Number, y0:Number, x1:Number, y1:Number) : Number
      {
         var nx:Number = NaN;
         var ny:Number = NaN;
         var t:Number = NaN;
         var dx:Number = x1 - x0;
         var dy:Number = y1 - y0;
         var dd:Number = dx * dx + dy * dy;
         if(dd < 0.001)
         {
            nx = x0;
            ny = y0;
         }
         else
         {
            t = ((x - x0) * dx + (y - y0) * dy) / dd;
            if(t < 0)
            {
               nx = x0;
               ny = y0;
            }
            else if(t > 1)
            {
               nx = x1;
               ny = y1;
            }
            else
            {
               nx = x0 + t * dx;
               ny = y0 + t * dy;
            }
         }
         dx = x - nx;
         dy = y - ny;
         return Math.sqrt(dx * dx + dy * dy);
      }
   }
}
