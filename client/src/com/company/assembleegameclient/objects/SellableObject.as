package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.BitmapData;
   import kabam.rotmg.game.view.SellableObjectPanel;
   
   public class SellableObject extends GameObject implements IInteractiveObject
   {
       
      
      public var price_:int = 0;
      
      public var currency_:int = -1;
      
      public var rankReq_:int = 0;
      
      public var guildRankReq_:int = -1;
      
      public function SellableObject(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function setPrice(price:int) : void
      {
         this.price_ = price;
      }
      
      public function setCurrency(currency:int) : void
      {
         this.currency_ = currency;
      }
      
      public function setRankReq(rankReq:int) : void
      {
         this.rankReq_ = rankReq;
      }
      
      public function soldObjectName() : String
      {
         return null;
      }
      
      public function soldObjectInternalName() : String
      {
         return null;
      }
      
      public function getTooltip() : ToolTip
      {
         return null;
      }
      
      public function getIcon() : BitmapData
      {
         return null;
      }

      public function getSellableType():int {
         return (-1);
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new SellableObjectPanel(gs,this);
      }
   }
}
