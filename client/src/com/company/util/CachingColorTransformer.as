package com.company.util
{
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CachingColorTransformer
   {
      
      private static var bds_:Dictionary = new Dictionary();
      private static var alphas_:Dictionary = new Dictionary();
       
      
      public function CachingColorTransformer()
      {
         super();
      }
      
      public static function transformBitmapData(bitmapData:BitmapData, ct:ColorTransform) : BitmapData
      {
         var newBitmapData:BitmapData = null;
         var object:Object = bds_[bitmapData];
         if(object != null)
         {
            newBitmapData = object[ct];
         }
         else
         {
            object = new Object();
            bds_[bitmapData] = object;
         }
         if(newBitmapData == null)
         {
            newBitmapData = bitmapData.clone();
            newBitmapData.colorTransform(newBitmapData.rect,ct);
            object[ct] = newBitmapData;
         }
         return newBitmapData;
      }
      
      public static function filterBitmapData(bitmapData:BitmapData, filter:BitmapFilter) : BitmapData
      {
         var newBitmapData:BitmapData = null;
         var object:Object = bds_[bitmapData];
         if(object != null)
         {
            newBitmapData = object[filter];
         }
         else
         {
            object = new Object();
            bds_[bitmapData] = object;
         }
         if(newBitmapData == null)
         {
            newBitmapData = bitmapData.clone();
            newBitmapData.applyFilter(newBitmapData,newBitmapData.rect,new Point(),filter);
            object[filter] = newBitmapData;
         }
         return newBitmapData;
      }
      
      public static function alphaBitmapData(bitmapData:BitmapData, alpha:int) : BitmapData
      {
         var ct:ColorTransform = alphas_[alpha];
         if (ct == null) {
            ct = new ColorTransform(1, 1, 1, alpha / 100);
            alphas_[alpha] = ct;
         }
         return transformBitmapData(bitmapData,ct);
      }
      
      public static function clear() : void
      {
         var object:Object = null;
         var bd:BitmapData = null;
         for each(object in bds_)
         {
            for each(bd in object)
            {
               bd.dispose();
            }
         }
         bds_ = new Dictionary();
         alphas_ = new Dictionary();
      }
   }
}
