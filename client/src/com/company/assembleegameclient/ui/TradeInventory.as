package com.company.assembleegameclient.ui
{
import com.company.assembleegameclient.constants.InventoryOwnerTypes;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.messaging.impl.data.TradeItem;

public class TradeInventory extends Sprite
{

   private static const NO_CUT:Array = [0,0,0,0];

   private static const cuts:Array = [[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0],[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]];

   public static const CLICKITEMS_MESSAGE:int = 0;

   public static const NOTENOUGHSPACE_MESSAGE:int = 1;

   public static const TRADEACCEPTED_MESSAGE:int = 2;

   public static const TRADEWAITING_MESSAGE:int = 3;

   private static var tooltip_:ToolTip = null;


   public var gs_:GameSprite;

   public var playerName_:String;

   private var message_:int;

   private var nameText_:SimpleText;

   private var taglineText_:SimpleText;

   public var slots_:Vector.<TradeSlot>;

   public function TradeInventory(gs:GameSprite, playerName:String, items:Vector.<TradeItem>, canSelect:Boolean)
   {
      var item:TradeItem = null;
      var slot:TradeSlot = null;
      this.slots_ = new Vector.<TradeSlot>();
      super();
      this.gs_ = gs;
      this.playerName_ = playerName;
      this.nameText_ = new SimpleText(20,11776947,false,0,0);
      this.nameText_.setBold(true);
      this.nameText_.x = 0;
      this.nameText_.y = 0;
      this.nameText_.text = this.playerName_;
      this.nameText_.updateMetrics();
      this.nameText_.filters = [new DropShadowFilter(0,0,0)];
      addChild(this.nameText_);
      this.taglineText_ = new SimpleText(12,11776947,false,0,0);
      this.taglineText_.x = 0;
      this.taglineText_.y = 22;
      this.taglineText_.text = "";
      this.taglineText_.updateMetrics();
      this.taglineText_.filters = [new DropShadowFilter(0,0,0)];
      addChild(this.taglineText_);
      for(var i:int = 0; i < GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS; i++)
      {
         item = items[i];
         slot = new TradeSlot(item.item_,item.tradeable_,item.included_,item.slotType_,i - 3,cuts[i],i, item.itemData_);
         slot.x = int(i % 4) * (Slot.WIDTH + 4);
         slot.y = int(i / 4) * (Slot.HEIGHT + 4) + 46;
         if(item.item_ != -1)
         {
            slot.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            slot.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         }
         if(canSelect && item.tradeable_)
         {
            slot.addEventListener(MouseEvent.MOUSE_DOWN,this.onSlotClick);
         }
         this.slots_.push(slot);
         addChild(slot);
      }
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
   }

   public function getOffer() : Vector.<Boolean>
   {
      var offer:Vector.<Boolean> = new Vector.<Boolean>();
      for(var i:int = 0; i < this.slots_.length; i++)
      {
         offer.push(this.slots_[i].included_);
      }
      return offer;
   }

   public function setOffer(offer:Vector.<Boolean>) : void
   {
      for(var i:int = 0; i < this.slots_.length; i++)
      {
         this.slots_[i].setIncluded(offer[i]);
      }
   }

   public function isOffer(offer:Vector.<Boolean>) : Boolean
   {
      for(var i:int = 0; i < this.slots_.length; i++)
      {
         if(offer[i] != this.slots_[i].included_)
         {
            return false;
         }
      }
      return true;
   }

   public function numIncluded() : int
   {
      var num:int = 0;
      for(var i:int = 0; i < this.slots_.length; i++)
      {
         if(this.slots_[i].included_)
         {
            num++;
         }
      }
      return num;
   }

   public function numEmpty() : int
   {
      var num:int = 0;
      for(var i:int = 4; i < this.slots_.length; i++)
      {
         if(this.slots_[i].item_ == -1)
         {
            num++;
         }
      }
      return num;
   }

   public function setMessage(message:int) : void
   {
      switch(message)
      {
         case CLICKITEMS_MESSAGE:
            this.nameText_.setColor(11776947);
            this.taglineText_.setColor(11776947);
            this.taglineText_.text = "Click items you want to trade";
            this.taglineText_.updateMetrics();
            break;
         case NOTENOUGHSPACE_MESSAGE:
            this.nameText_.setColor(16711680);
            this.taglineText_.setColor(16711680);
            this.taglineText_.text = "Not enough space for trade!";
            this.taglineText_.updateMetrics();
            break;
         case TRADEACCEPTED_MESSAGE:
            this.nameText_.setColor(9022300);
            this.taglineText_.setColor(9022300);
            this.taglineText_.text = "Trade accepted!";
            this.taglineText_.updateMetrics();
            break;
         case TRADEWAITING_MESSAGE:
            this.nameText_.setColor(11776947);
            this.taglineText_.setColor(11776947);
            this.taglineText_.text = "Player is selecting items";
            this.taglineText_.updateMetrics();
      }
   }

   private function onRemovedFromStage(event:Event) : void
   {
      this.removeTooltip();
   }

   private function onMouseOver(event:Event) : void
   {
      var tradeSlot:TradeSlot = event.currentTarget as TradeSlot;
      this.setToolTip(new EquipmentToolTip(tradeSlot.item_,this.gs_.map.player_,-1,InventoryOwnerTypes.OTHER_PLAYER,tradeSlot.id));
   }

   private function onRollOut(event:Event) : void
   {
      this.removeTooltip();
   }

   private function setToolTip(toolTip:ToolTip) : void
   {
      this.removeTooltip();
      tooltip_ = toolTip;
      if(tooltip_ != null)
      {
         stage.addChild(tooltip_);
      }
   }

   private function removeTooltip() : void
   {
      if(tooltip_ != null)
      {
         if(tooltip_.parent != null)
         {
            tooltip_.parent.removeChild(tooltip_);
         }
         tooltip_ = null;
      }
   }

   private function onSlotClick(event:MouseEvent) : void
   {
      var slot:TradeSlot = event.currentTarget as TradeSlot;
      slot.setIncluded(!slot.included_);
      dispatchEvent(new Event(Event.CHANGE));
   }
}
}
