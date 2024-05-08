package io.decagames.rotmg.ui.tabs
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class TabContentBackground extends SliceScalingBitmap
   {
       
      
      private var decorBitmapData:BitmapData;
      
      private var decorSliceRectangle:Rectangle;
      
      public function TabContentBackground()
      {
         super(TextureParser.instance.getTexture("UI","tab_cointainer_background").bitmapData,SliceScalingBitmap.SCALE_TYPE_9,new Rectangle(15,15,1,1));
      }
      
      override public function dispose() : void
      {
         this.decorBitmapData.dispose();
         super.dispose();
      }
      
      public function addDecor(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.render();
         if(param3 == 0)
         {
            this.decorBitmapData = TextureParser.instance.getTexture("UI","tab_open_decor_left").bitmapData;
            this.decorSliceRectangle = new Rectangle(21,0,1,14);
            param1 = param1 - 7;
            param2 = param2 - 4;
         }
         else if(param3 == param4 - 1)
         {
            this.decorBitmapData = TextureParser.instance.getTexture("UI","tab_open_decor_right").bitmapData;
            this.decorSliceRectangle = new Rectangle(18,0,1,14);
         }
         else
         {
            this.decorBitmapData = TextureParser.instance.getTexture("UI","tab_open_decor_center").bitmapData;
            this.decorSliceRectangle = new Rectangle(18,0,1,14);
         }
         this.bitmapData.copyPixels(this.decorBitmapData,new Rectangle(0,0,this.decorSliceRectangle.x,this.decorBitmapData.height),new Point(param1,0));
         var _loc5_:int = param1;
         while(_loc5_ < param2)
         {
            this.bitmapData.copyPixels(this.decorBitmapData,new Rectangle(this.decorSliceRectangle.x,0,this.decorSliceRectangle.width,this.decorBitmapData.height),new Point(this.decorSliceRectangle.x + _loc5_,0));
            _loc5_++;
         }
         this.bitmapData.copyPixels(this.decorBitmapData,new Rectangle(this.decorSliceRectangle.x + this.decorSliceRectangle.width,0,this.decorBitmapData.width - (this.decorSliceRectangle.x + this.decorSliceRectangle.width),this.decorBitmapData.height),new Point(param2,0));
      }
   }
}
