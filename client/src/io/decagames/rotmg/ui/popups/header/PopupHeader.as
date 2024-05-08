package io.decagames.rotmg.ui.popups.header
{
import flash.display.Sprite;
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

public class PopupHeader extends Sprite
{

   public static const LEFT_BUTTON:String = "left_button";

   public static const RIGHT_BUTTON:String = "right_button";

   public static var TYPE_FULL:String = "full";

   public static var TYPE_MODAL:String = "modal";


   private var backgroundBitmap:SliceScalingBitmap;

   private var titleBackgroundBitmap:SliceScalingBitmap;

   private var _titleLabel:UILabel;

   private var buttonsContainers:Vector.<Sprite>;

   private var buttons:Vector.<SliceScalingButton>;

   private var _coinsField:CoinsField;

   private var _fameField:FameField;

   private var headerWidth:int;

   private var headerType:String;

   public function PopupHeader(param1:int, param2:String)
   {
      super();
      this.headerWidth = param1;
      this.headerType = param2;
      if(param2 == TYPE_FULL)
      {
         this.backgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI","popup_header",param1);
         addChild(this.backgroundBitmap);
      }
      this.buttonsContainers = new Vector.<Sprite>();
      this.buttons = new Vector.<SliceScalingButton>();
   }

   public function setTitle(param1:String, param2:int, param3:Function = null) : void
   {
      if(!this.titleBackgroundBitmap)
      {
         if(this.headerType == TYPE_FULL)
         {
            this.titleBackgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI","popup_header_title",param2);
            addChild(this.titleBackgroundBitmap);
            this.titleBackgroundBitmap.x = Math.round((this.headerWidth - param2) / 2);
            this.titleBackgroundBitmap.y = 29;
         }
         else
         {
            this.titleBackgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI","modal_header_title",param2);
            addChild(this.titleBackgroundBitmap);
            this.titleBackgroundBitmap.x = Math.round((this.headerWidth - param2) / 2);
         }
         this._titleLabel = new UILabel();
         if(param3 != null)
         {
            param3(this._titleLabel);
         }
         this._titleLabel.text = param1;
         addChild(this._titleLabel);
         this._titleLabel.x = this.titleBackgroundBitmap.x + (this.titleBackgroundBitmap.width - this._titleLabel.textWidth) / 2;
         if(this.headerType == TYPE_FULL)
         {
            this._titleLabel.y = this.titleBackgroundBitmap.height - this._titleLabel.height / 2 - 3;
         }
         else
         {
            this._titleLabel.y = this.titleBackgroundBitmap.y + (this.titleBackgroundBitmap.height - this._titleLabel.height) / 2;
         }
      }
   }

   public function addButton(param1:SliceScalingButton, param2:String, param3:int = 0) : void
   {
      var _loc4_:SliceScalingBitmap = null;
      var _loc3_:Sprite = new Sprite();
      if(this.headerType == TYPE_FULL)
      {
         _loc4_ = TextureParser.instance.getSliceScalingBitmap("UI","popup_header_button_decor");
         _loc3_.addChild(_loc4_);
      }
      _loc3_.addChild(param1);
      addChild(_loc3_);
      this.buttonsContainers.push(_loc3_);
      this.buttons.push(param1);
      if(this.headerType == TYPE_FULL)
      {
         _loc4_.y = (this.backgroundBitmap.height - _loc4_.height) / 2;
         param1.y = _loc4_.y + 8;
         if(param3 != 0){
            param1.y += param3;
         }
      }
      else
      {
         param1.y = 5;
      }
      if(param2 == "right_button")
      {
         if(this.headerType == TYPE_FULL)
         {
            _loc4_.x = this.headerWidth - _loc4_.width;
            param1.x = _loc4_.x + 6;
            if(param3 != 0){
               _loc4_.y += param3;
            }

         }
         else
         {
            param1.x = this.titleBackgroundBitmap.x + this.titleBackgroundBitmap.width - param1.width - 3;
         }
      }
      else if(this.headerType == TYPE_FULL)
      {
         _loc4_.x = _loc4_.width;
         _loc4_.scaleX = -1;
         param1.x = 16;
         if(param3 != 0){
            _loc4_.y += param3;
         }
      }
      else
      {
         param1.x = this.titleBackgroundBitmap.x + 3;
      }
   }

   public function showCoins(param1:int) : CoinsField
   {
      var _loc2_:Sprite = null;
      this._coinsField = new CoinsField(param1);
      this._coinsField.x = 44;
      addChild(this._coinsField);
      this.alignCurrency();
      var _loc4_:int = 0;
      var _loc3_:* = this.buttonsContainers;
      for each(_loc2_ in this.buttonsContainers)
      {
         addChild(_loc2_);
      }
      return this._coinsField;
   }

   public function showFame(param1:int) : FameField
   {
      this._fameField = new FameField(param1);
      this._fameField.x = 44;
      addChild(this._fameField);
      this.alignCurrency();
      return this._fameField;
   }

   private function alignCurrency() : void
   {
      if(this._coinsField && this._fameField)
      {
         this._coinsField.y = 39;
         this._fameField.y = 63;
      }
      else if(this._coinsField)
      {
         this._coinsField.y = 51;
      }
      else if(this._fameField)
      {
         this._fameField.y = 51;
      }
   }

   public function dispose() : void
   {
      var _loc1_:* = null;
      if(this.backgroundBitmap)
      {
         this.backgroundBitmap.dispose();
      }
      this.titleBackgroundBitmap.dispose();
      if(this._coinsField)
      {
         this._coinsField.dispose();
      }
      if(this._fameField)
      {
         this._fameField.dispose();
      }
      var _loc3_:int = 0;
      var _loc2_:* = this.buttons;
      for each(_loc1_ in this.buttons)
      {
         _loc1_.dispose();
      }
      this.buttonsContainers = null;
      this.buttons = null;
   }

   public function get titleLabel() : UILabel
   {
      return this._titleLabel;
   }

   public function get coinsField() : CoinsField
   {
      return this._coinsField;
   }

   public function get fameField() : FameField
   {
      return this._fameField;
   }
}
}