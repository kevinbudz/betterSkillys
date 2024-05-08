package io.decagames.rotmg.utils.colors
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GreyScale
   {
       
      
      public function GreyScale()
      {
         super();
      }
      
      public static function setGreyScale(param1:BitmapData) : BitmapData
      {
         var _loc2_:Number = 0.2225;
         var _loc3_:Number = 0.7169;
         var _loc4_:Number = 0.0606;
         var _loc5_:Array = [_loc2_,_loc3_,_loc4_,0,0,_loc2_,_loc3_,_loc4_,0,0,_loc2_,_loc3_,_loc4_,0,0,0,0,0,1,0];
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter(_loc5_);
         param1.applyFilter(param1,new Rectangle(0,0,param1.width,param1.height),new Point(0,0),_loc6_);
         return param1;
      }
      
      public static function clear(param1:BitmapData) : BitmapData
      {
         param1.applyFilter(param1,new Rectangle(0,0,param1.width,param1.height),new Point(0,0),new ColorMatrixFilter());
         return param1;
      }
      
      public static function greyScaleToDisplayObject(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:Number = 0.2225;
         var _loc4_:Number = 0.7169;
         var _loc5_:Number = 0.0606;
         var _loc6_:Array = [_loc3_,_loc4_,_loc5_,0,0,_loc3_,_loc4_,_loc5_,0,0,_loc3_,_loc4_,_loc5_,0,0,0,0,0,1,0];
         var _loc7_:ColorMatrixFilter = new ColorMatrixFilter(_loc6_);
         if(param2)
         {
            param1.filters = [_loc7_];
         }
         else
         {
            param1.filters = [];
         }
      }
   }
}
