package com.company.assembleegameclient.util
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class BloodComposition
   {
      
      private static var idDict_:Dictionary = new Dictionary();
      
      private static var imageDict_:Dictionary = new Dictionary();
       
      
      public function BloodComposition()
      {
         super();
      }
      
      public static function getBloodComposition(id:int, image:BitmapData, bloodProb:Number, bloodColor:uint) : Vector.<uint>
      {
         var comp:Vector.<uint> = idDict_[id];
         if(comp != null)
         {
            return comp;
         }
         comp = new Vector.<uint>();
         var colors:Vector.<uint> = getColors(image);
         for(var i:int = 0; i < colors.length; i++)
         {
            if(Math.random() < bloodProb)
            {
               comp.push(bloodColor);
            }
            else
            {
               comp.push(colors[int(colors.length * Math.random())]);
            }
         }
         return comp;
      }
      
      public static function getColors(image:BitmapData) : Vector.<uint>
      {
         var colors:Vector.<uint> = imageDict_[image];
         if(colors == null)
         {
            colors = buildColors(image);
            imageDict_[image] = colors;
         }
         return colors;
      }
      
      private static function buildColors(image:BitmapData) : Vector.<uint>
      {
         var y:int = 0;
         var color:uint = 0;
         var colors:Vector.<uint> = new Vector.<uint>();
         for(var x:int = 0; x < image.width; x++)
         {
            for(y = 0; y < image.height; y++)
            {
               color = image.getPixel32(x,y);
               if((color & 4278190080) != 0)
               {
                  colors.push(color);
               }
            }
         }
         return colors;
      }
   }
}
