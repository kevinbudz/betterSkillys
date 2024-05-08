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
   
   public class FameField extends Sprite
   {
       
      
      private var fameFieldBackground:SliceScalingBitmap;
      
      private var _label:UILabel;
      
      private var fameBitmap:Bitmap;
      
      public function FameField(param1:int)
      {
         super();
         this.fameFieldBackground = TextureParser.instance.getSliceScalingBitmap("UI","bordered_field",param1);
         this._label = new UILabel();
         DefaultLabelFormat.coinsFieldLabel(this._label);
         addChild(this.fameFieldBackground);
         addChild(this._label);
         var _loc2_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         _loc2_ = TextureRedrawer.resize(_loc2_,null,34,true,0,0,5);
         this.fameBitmap = new Bitmap(_loc2_);
         this.fameBitmap.y = -4;
         this.fameBitmap.x = param1 - 40;
         addChild(this.fameBitmap);
      }
      
      public function set fameAmount(param1:int) : void
      {
         this._label.text = param1.toString();
         this._label.x = (this.fameFieldBackground.width - this._label.textWidth) / 2 - 5;
         this._label.y = (this.fameFieldBackground.height - this._label.height) / 2 + 2;
      }
      
      public function get label() : UILabel
      {
         return this._label;
      }
      
      public function dispose() : void
      {
         this.fameFieldBackground.dispose();
         this.fameBitmap.bitmapData.dispose();
      }
   }
}
