package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.messaging.impl.incoming.TradeStart;
   
   public class TradePanel extends Sprite
   {
      
      public static const WIDTH:int = 200;
      
      public static const HEIGHT:int = 400;
       
      
      public var gs_:GameSprite;
      
      private var myInv_:TradeInventory;
      
      private var yourInv_:TradeInventory;
      
      private var cancelButton_:TextButton;
      
      private var tradeButton_:TradeButton;
      
      public function TradePanel(gs:GameSprite, tradeStart:TradeStart)
      {
         super();
         this.gs_ = gs;
         var playerName:String = this.gs_.map.player_.name_;
         this.myInv_ = new TradeInventory(gs,playerName,tradeStart.myItems_,true);
         this.myInv_.x = 14;
         this.myInv_.y = 0;
         this.myInv_.addEventListener(Event.CHANGE,this.onMyInvChange);
         addChild(this.myInv_);
         this.yourInv_ = new TradeInventory(gs,tradeStart.yourName_,tradeStart.yourItems_,false);
         this.yourInv_.x = 14;
         this.yourInv_.y = 174;
         addChild(this.yourInv_);
         this.cancelButton_ = new TextButton(16,"Cancel",80);
         this.cancelButton_.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.cancelButton_.x = WIDTH / 4 - this.cancelButton_.width / 2;
         this.cancelButton_.y = HEIGHT - this.cancelButton_.height - 10;
         addChild(this.cancelButton_);
         this.tradeButton_ = new TradeButton(16,80);
         this.tradeButton_.addEventListener(MouseEvent.CLICK,this.onTradeClick);
         this.tradeButton_.x = 3 * WIDTH / 4 - this.tradeButton_.width / 2;
         this.tradeButton_.y = this.cancelButton_.y;
         addChild(this.tradeButton_);
         this.checkTrade();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function setYourOffer(offer:Vector.<Boolean>) : void
      {
         this.yourInv_.setOffer(offer);
         this.checkTrade();
      }
      
      public function youAccepted(myOffer:Vector.<Boolean>, yourOffer:Vector.<Boolean>) : void
      {
         if(this.myInv_.isOffer(myOffer) && this.yourInv_.isOffer(yourOffer))
         {
            this.yourInv_.setMessage(TradeInventory.TRADEACCEPTED_MESSAGE);
         }
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(Event.ACTIVATE,this.onActivate);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(Event.ACTIVATE,this.onActivate);
      }
      
      private function onActivate(event:Event) : void
      {
         this.tradeButton_.reset();
      }
      
      private function onMyInvChange(event:Event) : void
      {
         this.gs_.gsc_.changeTrade(this.myInv_.getOffer());
         this.checkTrade();
      }
      
      private function onCancelClick(event:MouseEvent) : void
      {
         this.gs_.gsc_.cancelTrade();
         dispatchEvent(new Event(Event.CANCEL));
      }
      
      private function onTradeClick(event:MouseEvent) : void
      {
         this.gs_.gsc_.acceptTrade(this.myInv_.getOffer(),this.yourInv_.getOffer());
         this.myInv_.setMessage(TradeInventory.TRADEACCEPTED_MESSAGE);
      }
      
      public function checkTrade() : void
      {
         var myTrading:int = this.myInv_.numIncluded();
         var myEmpty:int = this.myInv_.numEmpty();
         var yourTrading:int = this.yourInv_.numIncluded();
         var yourEmpty:int = this.yourInv_.numEmpty();
         var valid:Boolean = true;
         if(yourTrading - myTrading - myEmpty > 0)
         {
            this.myInv_.setMessage(TradeInventory.NOTENOUGHSPACE_MESSAGE);
            valid = false;
         }
         else
         {
            this.myInv_.setMessage(TradeInventory.CLICKITEMS_MESSAGE);
         }
         if(myTrading - yourTrading - yourEmpty > 0)
         {
            this.yourInv_.setMessage(TradeInventory.NOTENOUGHSPACE_MESSAGE);
            valid = false;
         }
         else
         {
            this.yourInv_.setMessage(TradeInventory.TRADEWAITING_MESSAGE);
         }
         if(valid)
         {
            this.tradeButton_.reset();
         }
         else
         {
            this.tradeButton_.disable();
         }
      }
   }
}
