package io.decagames.rotmg.ui.popups.header
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class CoinsField extends Sprite
   {
       
      
      private var coinsFieldBackground:SliceScalingBitmap;
      
      private var _label:UILabel;
      
      private var coinBitmap:Bitmap;
      
      public function CoinsField(param1:int)
      {
         super();
         this.coinsFieldBackground = TextureParser.instance.getSliceScalingBitmap("UI","bordered_field",param1);
         this._label = new UILabel();
         DefaultLabelFormat.coinsFieldLabel(this._label);
         addChild(this.coinsFieldBackground);
         addChild(this._label);
         var _loc2_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",225);
         _loc2_ = TextureRedrawer.resize(_loc2_,null,34,true,0,0,5);
         this.coinBitmap = new Bitmap(_loc2_);
         this.coinBitmap.y = -4;
         this.coinBitmap.x = param1 - 40;
         addChild(this.coinBitmap);
      }
      
      public function set coinsAmount(param1:int) : void
      {
         this._label.text = param1.toString();
         this._label.x = (this.coinsFieldBackground.width - this._label.textWidth) / 2 - 5;
         this._label.y = (this.coinsFieldBackground.height - this._label.height) / 2 + 2;
      }
      
      public function get label() : UILabel
      {
         return this._label;
      }
      
      public function dispose() : void
      {
         this.coinsFieldBackground.dispose();
         this.coinBitmap.bitmapData.dispose();
      }
   }
}
