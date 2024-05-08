package io.decagames.rotmg.ui.texture
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import io.decagames.rotmg.ui.assets.UIAssets;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class TextureParser
   {
      
      private static var _instance:TextureParser;
       
      
      private var textures:Dictionary;
      
      private var json:JsonParser;
      
      public function TextureParser()
      {
         super();
         this.textures = new Dictionary();
         this.json = StaticInjectorContext.getInjector().getInstance(JsonParser);
         this.registerTexture(new UIAssets.UI(),new UIAssets.UI_CONFIG(),new UIAssets.UI_SLICE_CONFIG(),"UI");
      }
      
      public static function get instance() : TextureParser
      {
         if(_instance == null)
         {
            _instance = new TextureParser();
         }
         return _instance;
      }
      
      public function registerTexture(param1:Bitmap, param2:String, param3:String, param4:String) : void
      {
         this.textures[param4] = {
            "texture":param1,
            "configuration":this.json.parse(param2),
            "sliceRectangles":this.json.parse(param3)
         };
      }
      
      private function getConfiguration(param1:String, param2:String) : Object
      {
         if(!this.textures[param1])
         {
            throw new Error("Can\'t find set name " + param1);
         }
         if(!this.textures[param1].configuration.frames[param2 + ".png"])
         {
            throw new Error("Can\'t find config for " + param2);
         }
         return this.textures[param1].configuration.frames[param2 + ".png"];
      }
      
      private function getBitmapUsingConfig(param1:String, param2:Object) : Bitmap
      {
         var _loc3_:Bitmap = this.textures[param1].texture;
         var _loc4_:ByteArray = _loc3_.bitmapData.getPixels(new Rectangle(param2.frame.x,param2.frame.y,param2.frame.w,param2.frame.h));
         _loc4_.position = 0;
         var _loc5_:BitmapData = new BitmapData(param2.frame.w,param2.frame.h);
         _loc5_.setPixels(new Rectangle(0,0,param2.frame.w,param2.frame.h),_loc4_);
         return new Bitmap(_loc5_);
      }
      
      public function getTexture(param1:String, param2:String) : Bitmap
      {
         var _loc3_:Object = this.getConfiguration(param1,param2);
         return this.getBitmapUsingConfig(param1,_loc3_);
      }
      
      public function getSliceScalingBitmap(param1:String, param2:String, param3:int = 0) : SliceScalingBitmap
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Bitmap = this.getTexture(param1,param2);
         var _loc6_:Object = this.textures[param1].sliceRectangles.slices[param2 + ".png"];
         var _loc7_:String = SliceScalingBitmap.SCALE_TYPE_NONE;
         if(_loc6_)
         {
            _loc4_ = new Rectangle(_loc6_.rectangle.x,_loc6_.rectangle.y,_loc6_.rectangle.w,_loc6_.rectangle.h);
            _loc7_ = _loc6_.type;
         }
         var _loc8_:SliceScalingBitmap = new SliceScalingBitmap(_loc5_.bitmapData,_loc7_,_loc4_);
         _loc8_.sourceBitmapName = param2;
         if(param3 != 0)
         {
            _loc8_.width = param3;
         }
         return _loc8_;
      }
   }
}
