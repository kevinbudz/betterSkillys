package com.company.assembleegameclient.screens.charrects
{
   import com.company.ui.SimpleText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.filters.DropShadowFilter;

import kabam.rotmg.assets.services.IconFactory;
import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class BuyCharacterRect extends CharacterRect
   {
      private var classNameText_:SimpleText;
      private var priceText_:SimpleText;
      private var currency_:Bitmap;
      
      public function BuyCharacterRect(model:PlayerModel)
      {
         super(2039583,4342338);
         var icon:Shape = this.buildIcon();
         icon.x = 7;
         icon.y = 9;
         addChild(icon);
         makeContainer();
         this.classNameText_ = new SimpleText(18,16777215,false,0,0);
         this.classNameText_.setBold(true);
         this.classNameText_.text = "Buy " + this.getOrdinalString(model.getMaxCharacters() + 1) + " Character Slot";
         this.classNameText_.updateMetrics();
         this.classNameText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.classNameText_.x = 58;
         this.classNameText_.y = 13;
         selectContainer.addChild(this.classNameText_);
         this.priceText_ = new SimpleText(18,16777215,false,0,0);
         this.priceText_.text = model.getNextCharSlotPrice().toString();
         this.priceText_.updateMetrics();
         this.priceText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.priceText_.x = this.width - 45 - this.priceText_.width;
         this.priceText_.y = 16;
         selectContainer.addChild(this.priceText_);
         var bd:BitmapData =
                 model.isNextCharSlotCurrencyFame() ?
                         IconFactory.makeFame() :
                         IconFactory.makeCoin();
         this.currency_ = new Bitmap(bd);
         this.currency_.x = this.width - 43;
         this.currency_.y = 18;
         selectContainer.addChild(this.currency_);
      }
      
      private function buildIcon() : Shape
      {
         var shape:Shape = new Shape();
         var g:Graphics = shape.graphics;
         g.beginFill(3880246);
         g.lineStyle(1,4603457);
         g.drawCircle(19,19,19);
         g.lineStyle();
         g.endFill();
         g.beginFill(2039583);
         g.drawRect(11,17,16,4);
         g.endFill();
         g.beginFill(2039583);
         g.drawRect(17,11,4,16);
         g.endFill();
         return shape;
      }
      
      private function getOrdinalString(num:int) : String
      {
         var str:String = num.toString();
         var ones:int = num % 10;
         var tens:int = int(num / 10) % 10;
         if(tens == 1)
         {
            str = str + "th";
         }
         else if(ones == 1)
         {
            str = str + "st";
         }
         else if(ones == 2)
         {
            str = str + "nd";
         }
         else if(ones == 3)
         {
            str = str + "rd";
         }
         else
         {
            str = str + "th";
         }
         return str;
      }
   }
}
