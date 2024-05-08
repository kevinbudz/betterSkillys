package com.company.util
{
   import flash.display.BitmapData;
   
   public class ImageSet
   {
       
      
      public var images_:Vector.<BitmapData>;
      
      public function ImageSet()
      {
         super();
         this.images_ = new Vector.<BitmapData>();
      }
      
      public function add(bitmapData:BitmapData) : void
      {
         this.images_.push(bitmapData);
      }
      
      public function random() : BitmapData
      {
         return this.images_[int(Math.random() * this.images_.length)];
      }
      
      public function addFromBitmapData(bitmapData:BitmapData, width:int, height:int) : void
      {
         var x:int = 0;
         var maxX:int = bitmapData.width / width;
         var maxY:int = bitmapData.height / height;
         for(var y:int = 0; y < maxY; y++)
         {
            for(x = 0; x < maxX; x++)
            {
               this.images_.push(BitmapUtil.cropToBitmapData(bitmapData,x * width,y * height,width,height));
            }
         }
      }
   }
}
