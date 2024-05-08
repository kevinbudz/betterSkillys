package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.HoverTooltipDelegate;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.ui.tooltip.controller.TooltipAble;
import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.ui.SimpleText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.HideTooltipsSignal;

import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class SellableObjectPanel extends Panel implements TooltipAble
   {

      public var buyItem:Signal;
      
      private var owner:SellableObject;
      
      private var nameText:SimpleText;

      private var buyButton:LegacyBuyButton;
      
      private var rankReqText:Sprite = null;
      
      private var guildRankReqText:SimpleText = null;
      
      private var coinIcon:Sprite;

      private var toolTip:ToolTip;
      
      private var bitmap:Bitmap;
      
      private const BUTTON_OFFSET:int = 17;

      public var hoverTooltipDelegate:HoverTooltipDelegate;
      
      public function SellableObjectPanel(gs:GameSprite, owner:SellableObject)
      {
         this.hoverTooltipDelegate = new HoverTooltipDelegate();
         this.buyItem = new Signal(SellableObject);
         this.coinIcon = new Sprite();
         this.bitmap = new Bitmap();
         super(gs);
         this.createNameText();
         this.createBuyButton();
         this.setOwner(owner);
         this.createIcon();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.hoverTooltipDelegate.setDisplayObject(this);
         this.hoverTooltipDelegate.tooltip = owner.getTooltip();
      }

      private static function createRankReqText(rankReq:int) : Sprite
      {
         var requiredText:SimpleText = null;
         var rankText:Sprite = null;
         var rankReqText:Sprite = new Sprite();
         requiredText = new SimpleText(16,16777215,false,0,0);
         rankText = new RankText(rankReq,false,false);
         requiredText.setBold(true);
         requiredText.text = "Rank Required:";
         requiredText.updateMetrics();
         requiredText.filters = [new DropShadowFilter(0,0,0)];
         rankText.x = requiredText.width + 4;
         rankText.y = (requiredText.height - rankText.height) * 0.5;
         rankReqText.addChild(requiredText);
         rankReqText.addChild(rankText);
         return rankReqText;
      }
      
      private static function createGuildRankReqText(guildRankReq:int) : SimpleText
      {
         var requiredText:SimpleText = null;
         requiredText = new SimpleText(16,16711680,false,0,0);
         requiredText.setBold(true);
         requiredText.text = GuildUtil.rankToString(guildRankReq) + " Rank Required";
         requiredText.useTextDimensions();
         requiredText.filters = [new DropShadowFilter(0,0,0)];
         return requiredText;
      }
      
      private function createBuyButton() : void
      {
         this.buyButton = new LegacyBuyButton("",16,0,0);
         this.buyButton.addEventListener(MouseEvent.CLICK,this.onBuyButtonClick);
         addChild(this.buyButton);
      }
      
      private function createIcon() : void
      {
         this.bitmap.x = -4;
         this.bitmap.y = -8;
         this.bitmap.bitmapData = this.owner.getIcon();
         addChild(this.bitmap);
      }

      private function createNameText() : void
      {
         this.nameText = new SimpleText(16,16777215,false,WIDTH - 44,0);
         this.nameText.setBold(true);
         this.nameText.htmlText = "<p align=\"center\">Thing For Sale</p>";
         this.nameText.wordWrap = true;
         this.nameText.multiline = true;
         this.nameText.autoSize = TextFieldAutoSize.CENTER;
         this.nameText.filters = [new DropShadowFilter(0,0,0)];
         this.nameText.x = 44;
         addChild(this.nameText);
      }
      
      public function setOwner(_owner:SellableObject) : void
      {
         if(this.owner == _owner)
         {
            return;
         }
         this.owner = _owner;
         var title:String = this.owner.soldObjectName();
         if(this.owner.soldObjectName() == "Vault Chest")
         {
            this.owner.price_ = calculatePrice(this.gs_.map.player_);
         }
         this.buyButton.setPrice(this.owner.price_,_owner.currency_);
         this.nameText.htmlText = "<p align=\"center\">" + title + "</p>";
      }

      public function calculatePrice(player:Player):int
      {
         var price:int;
         switch(player.rank)
         {
            case 10:
                    price = 150;
                 break;
            case 20:
                    price = 125;
                 break;
            case 30:
                    price = 100;
                 break;
            case 40:
                    price = 75;
                 break;
            case 50:
                    price = 25;
                 break;
            case 60:
                    price = 0;
                 break;
            default:
                    price = this.owner.price_;
                 break;
         }
         return price;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onBuyKeyDown);
         this.coinIcon.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.coinIcon.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onBuyKeyDown);
         this.coinIcon.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.coinIcon.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.resetTooltip();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.resetTooltip();
         stage.addChild(this.toolTip = this.owner.getTooltip());
      }
      
      private function resetTooltip() : void
      {
         if(this.toolTip)
         {
            if(this.toolTip.parent)
            {
               this.toolTip.parent.removeChild(this.toolTip);
            }
            this.toolTip = null;
         }
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.resetTooltip();
      }

      private function onBuyKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText){
            this.buyItem.dispatch(this.owner,this.owner.currency_);
         }
      }
      
      private function onBuyButtonClick(event:MouseEvent) : void
      {
         this.buyItem.dispatch(this.owner,this.owner.currency_);
      }
      
      override public function draw() : void
      {
         var player:Player = gs_.map.player_;
         this.nameText.y = this.nameText.height > 30?Number(0):Number(12);
         var rankReq:int = this.owner.rankReq_;
         if(player.numStars_ < rankReq)
         {
            this.removeButtons();
            if(this.rankReqText == null || !contains(this.rankReqText))
            {
               this.updateRankRequiredText(rankReq);
            }
         }
         else if(player.guildRank_ < this.owner.guildRankReq_)
         {
            this.removeButtons();
            if(this.guildRankReqText == null || !contains(this.guildRankReqText))
            {
               this.updateGuildRankRequiredText();
            }
         }
         else
         {
            this.buyButton.setPrice(this.owner.price_,owner.currency_);
            this.buyButton.setEnabled(!gs_.gsc_.outstandingBuy_);
            this.buyButton.x = WIDTH / 2 - this.buyButton.width / 2;
            this.buyButton.y = HEIGHT - this.buyButton.height / 2 - this.BUTTON_OFFSET;
            this.addButtons();
            if(this.rankReqText != null && contains(this.rankReqText))
            {
               removeChild(this.rankReqText);
            }
         }
      }
      
      private function updateRankRequiredText(rankReq:int) : void
      {
         this.rankReqText = createRankReqText(rankReq);
         this.rankReqText.x = WIDTH / 2 - this.rankReqText.width / 2;
         this.rankReqText.y = HEIGHT - this.rankReqText.height / 2 - 20;
         addChild(this.rankReqText);
      }
      
      private function updateGuildRankRequiredText() : void
      {
         this.guildRankReqText = createGuildRankReqText(this.owner.guildRankReq_);
         this.guildRankReqText.x = (WIDTH - this.guildRankReqText.width) * 0.5;
         this.guildRankReqText.y = HEIGHT - this.guildRankReqText.height / 2 - 20;
         addChild(this.guildRankReqText);
      }
      
      private function addButtons() : void
      {
         if(!contains(this.buyButton))
         {
            addChild(this.buyButton);
         }
      }
      
      private function removeButtons() : void
      {
         if(contains(this.buyButton))
         {
            removeChild(this.buyButton);
         }
      }

      public function setShowToolTipSignal(_arg1:ShowTooltipSignal):void {
         this.hoverTooltipDelegate.setShowToolTipSignal(_arg1);
      }

      public function getShowToolTip():ShowTooltipSignal {
         return (this.hoverTooltipDelegate.getShowToolTip());
      }

      public function setHideToolTipsSignal(_arg1:HideTooltipsSignal):void {
         this.hoverTooltipDelegate.setHideToolTipsSignal(_arg1);
      }

      public function getHideToolTips():HideTooltipsSignal {
         return (this.hoverTooltipDelegate.getHideToolTips());
      }
   }
}
