package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.account.ui.components.BackgroundBox;
   import com.company.assembleegameclient.account.ui.components.Selectable;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.offer.Offer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.util.components.RadioButton;
   
   public class OfferRadioButton extends Sprite implements Selectable
   {
      
      private static const SELECTED_COLOR:int = 7829367;
      
      private static const OVER_COLOR:int = 5987163;
      
      private static const DEFAULT_COLOR:int = 4539717;
       
      
      public var offer:Offer;
      
      private var config:MoneyConfig;
      
      private var background:BackgroundBox;
      
      private var container:Sprite;
      
      private var toggle:RadioButton;
      
      private var coinBitmap:BitmapData;
      
      private var goldText:SimpleText;
      
      private var costText:SimpleText;
      
      private var bonusText:SimpleText;
      
      private var taglineText:SimpleText;
      
      private var isSelected:Boolean;
      
      private var isOver:Boolean;
      
      public function OfferRadioButton(offer:Offer, config:MoneyConfig)
      {
         super();
         this.offer = offer;
         this.config = config;
         this.makeBackgroundBox();
         this.makeContainer();
         this.makeSelectToggle();
         this.makeCoinImage();
         this.makeGoldText();
         this.makeCostText();
         this.makeBonusText();
         this.makeTaglineTextIfApplicable();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function getValue() : String
      {
         return this.offer.realmGold_.toString();
      }
      
      public function setOver(value:Boolean) : void
      {
         this.isOver = value;
         this.updateBackgroundColor();
      }
      
      public function setSelected(value:Boolean) : void
      {
         this.isSelected = value;
         this.toggle.setSelected(value);
         this.updateBackgroundColor();
      }
      
      public function showBonus(showBonuses:Boolean) : void
      {
         if(this.bonusText)
         {
            this.bonusText.visible = showBonuses;
         }
      }
      
      private function makeBackgroundBox() : void
      {
         this.background = new BackgroundBox();
         this.background.setSize(520,36);
         this.updateBackgroundColor();
         addChild(this.background);
      }
      
      private function makeContainer() : void
      {
         this.container = new Sprite();
         this.container.x = this.container.y = 3;
         addChild(this.container);
      }
      
      private function makeSelectToggle() : void
      {
         this.toggle = new RadioButton();
         this.toggle.x = 3;
         this.container.addChild(this.toggle);
      }
      
      private function makeCoinImage() : void
      {
         var coin:Bitmap = null;
         this.coinBitmap = AssetLibrary.getImageFromSet("lofiObj3",225);
         this.coinBitmap = TextureRedrawer.redraw(this.coinBitmap,50,true,0);
         this.coinBitmap = BitmapUtil.cropToBitmapData(this.coinBitmap,8,8,this.coinBitmap.width - 16,this.coinBitmap.height - 16);
         coin = new Bitmap(this.coinBitmap);
         coin.x = this.toggle.x + 35;
         this.container.addChild(coin);
      }
      
      private function makeGoldText() : void
      {
         this.goldText = new SimpleText(18,16777215,false,0,0);
         this.goldText.text = this.offer.realmGold_ + " Gold";
         this.goldText.setBold(true);
         this.goldText.updateMetrics();
         this.goldText.x = this.toggle.x + 70;
         this.goldText.y = this.coinBitmap.height / 2 - this.goldText.height / 2;
         this.goldText.filters = [new DropShadowFilter(0,0,0)];
         this.container.addChild(this.goldText);
      }
      
      private function makeCostText() : void
      {
         this.costText = new SimpleText(18,16777215,false,0,0);
         this.costText.text = this.config.parseOfferPrice(this.offer);
         this.costText.setBold(true);
         this.costText.updateMetrics();
         this.costText.x = 200;
         this.costText.y = this.coinBitmap.height / 2 - this.costText.height / 2;
         this.costText.filters = [new DropShadowFilter(0,0,0)];
         this.container.addChild(this.costText);
      }
      
      private function makeBonusText() : void
      {
         if(this.offer.bonus == 0)
         {
            return;
         }
         this.bonusText = new SimpleText(18,16777215,false,0,0);
         this.bonusText.text = this.offer.bonus + "% Bonus";
         this.bonusText.setBold(true);
         this.bonusText.updateMetrics();
         this.bonusText.x = 280;
         this.bonusText.y = this.coinBitmap.height / 2 - this.bonusText.height / 2;
         this.bonusText.filters = [new DropShadowFilter(0,0,0)];
         this.container.addChild(this.bonusText);
      }
      
      private function makeTaglineTextIfApplicable() : void
      {
         if(this.offer.tagline != null)
         {
            this.makeTaglineText();
         }
      }
      
      private function makeTaglineText() : void
      {
         this.taglineText = new SimpleText(18,8891485,false,0,0);
         this.taglineText.text = this.offer.tagline;
         this.taglineText.updateMetrics();
         this.taglineText.x = 400;
         this.taglineText.y = this.coinBitmap.height / 2 - this.taglineText.height / 2;
         this.taglineText.filters = [new DropShadowFilter(0,0,0)];
         this.container.addChild(this.taglineText);
      }
      
      private function updateBackgroundColor() : void
      {
         var color:int = !!this.isSelected?int(SELECTED_COLOR):!!this.isOver?int(OVER_COLOR):int(DEFAULT_COLOR);
         this.background.setColor(color);
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.setOver(true);
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.setOver(false);
      }
   }
}
