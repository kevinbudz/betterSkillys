package com.company.util
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class BitmapUtil
   {
       
      
      public function BitmapUtil(se:StaticEnforcer)
      {
         super();
      }
      
      public static function mirror(bitmapData:BitmapData, width:int = 0) : BitmapData
      {
         var y:int = 0;
         if(width == 0)
         {
            width = bitmapData.width;
         }
         var mirrored:BitmapData = new BitmapData(bitmapData.width,bitmapData.height,true,0);
         for(var x:int = 0; x < width; x++)
         {
            for(y = 0; y < bitmapData.height; y++)
            {
               mirrored.setPixel32(width - x - 1,y,bitmapData.getPixel32(x,y));
            }
         }
         return mirrored;
      }
      
      public static function rotateBitmapData(bitmapData:BitmapData, clockwiseTurns:int) : BitmapData
      {
         var matrix:Matrix = new Matrix();
         matrix.translate(-bitmapData.width / 2,-bitmapData.height / 2);
         matrix.rotate(clockwiseTurns * Math.PI / 2);
         matrix.translate(bitmapData.height / 2,bitmapData.width / 2);
         var rotated:BitmapData = new BitmapData(bitmapData.height,bitmapData.width,true,0);
         rotated.draw(bitmapData,matrix);
         return rotated;
      }
      
      public static function cropToBitmapData(bitmapData:BitmapData, x:int, y:int, width:int, height:int) : BitmapData
      {
         var cropped:BitmapData = new BitmapData(width,height);
         cropped.copyPixels(bitmapData,new Rectangle(x,y,width,height),new Point(0,0));
         return cropped;
      }
      
      public static function amountTransparent(bitmapData:BitmapData) : Number
      {
         var y:int = 0;
         var alpha:int = 0;
         var trans:int = 0;
         for(var x:int = 0; x < bitmapData.width; x++)
         {
            for(y = 0; y < bitmapData.height; y++)
            {
               alpha = bitmapData.getPixel32(x,y) & 4278190080;
               if(alpha == 0)
               {
                  trans++;
               }
            }
         }
         return trans / (bitmapData.width * bitmapData.height);
      }
      
      public static function mostCommonColor(bitmapData:BitmapData) : uint
      {
         var color:uint = 0;
         var colorStr:* = null;
         var y:int = 0;
         var count:int = 0;
         var colors_:Dictionary = new Dictionary();
         for(var x:int = 0; x < bitmapData.width; x++)
         {
            for(y = 0; y < bitmapData.width; y++)
            {
               color = bitmapData.getPixel32(x,y);
               if((color & 4278190080) != 0)
               {
                  if(!colors_.hasOwnProperty(color))
                  {
                     colors_[color] = 1;
                  }
                  else
                  {
                     colors_[color]++;
                  }
               }
            }
         }
         var bestColor:uint = 0;
         var bestCount:uint = 0;
         for(colorStr in colors_)
         {
            color = uint(colorStr);
            count = colors_[colorStr];
            if(count > bestCount || count == bestCount && color > bestColor)
            {
               bestColor = color;
               bestCount = count;
            }
         }
         return bestColor;
      }
      
      public static function lineOfSight(bitmapData:BitmapData, p1:IntPoint, p2:IntPoint) : Boolean
      {
         var temp:int = 0;
         var numSteps:int = 0;
         var skipYSteps:int = 0;
         var skipXSteps:int = 0;
         var width:int = bitmapData.width;
         var height:int = bitmapData.height;
         var x0:int = p1.x();
         var y0:int = p1.y();
         var x1:int = p2.x();
         var y1:int = p2.y();
         var steep:Boolean = (y0 > y1?y0 - y1:y1 - y0) > (x0 > x1?x0 - x1:x1 - x0);
         if(steep)
         {
            temp = x0;
            x0 = y0;
            y0 = temp;
            temp = x1;
            x1 = y1;
            y1 = temp;
            temp = width;
            width = height;
            height = temp;
         }
         if(x0 > x1)
         {
            temp = x0;
            x0 = x1;
            x1 = temp;
            temp = y0;
            y0 = y1;
            y1 = temp;
         }
         var deltax:int = x1 - x0;
         var deltay:int = y0 > y1?int(y0 - y1):int(y1 - y0);
         var error:int = -(deltax + 1) / 2;
         var ystep:int = y0 > y1?int(-1):int(1);
         var xstop:int = x1 > width - 1?int(width - 1):int(x1);
         var y:int = y0;
         var x:int = x0;
         if(x < 0)
         {
            error = error + deltay * -x;
            if(error >= 0)
            {
               numSteps = error / deltax + 1;
               y = y + ystep * numSteps;
               error = error - numSteps * deltax;
            }
            x = 0;
         }
         if(ystep > 0 && y < 0 || ystep < 0 && y >= height)
         {
            skipYSteps = ystep > 0?int(-y - 1):int(y - height);
            error = error - deltax * skipYSteps;
            skipXSteps = -error / deltay;
            x = x + skipXSteps;
            error = error + skipXSteps * deltay;
            y = y + skipYSteps * ystep;
         }
         while(x <= xstop)
         {
            if(ystep > 0 && y >= height || ystep < 0 && y < 0)
            {
               break;
            }
            if(steep)
            {
               if(y >= 0 && y < height && bitmapData.getPixel(y,x) == 0)
               {
                  return false;
               }
            }
            else if(y >= 0 && y < height && bitmapData.getPixel(x,y) == 0)
            {
               return false;
            }
            error = error + deltay;
            if(error >= 0)
            {
               y = y + ystep;
               error = error - deltax;
            }
            x++;
         }
         return true;
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
