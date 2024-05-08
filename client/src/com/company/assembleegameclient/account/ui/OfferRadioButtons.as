package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.account.ui.components.Selectable;
   import com.company.assembleegameclient.account.ui.components.SelectionGroup;
   import com.company.assembleegameclient.util.offer.Offer;
   import com.company.assembleegameclient.util.offer.Offers;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.lib.ui.api.Layout;
   import kabam.lib.ui.impl.VerticalLayout;
   import kabam.rotmg.account.core.model.MoneyConfig;
   
   public class OfferRadioButtons extends Sprite
   {
       
      
      private var offers:Offers;
      
      private var config:MoneyConfig;
      
      private var choices:Vector.<OfferRadioButton>;
      
      private var group:SelectionGroup;
      
      public function OfferRadioButtons(offers:Offers, config:MoneyConfig)
      {
         super();
         this.offers = offers;
         this.config = config;
         this.makeGoldChoices();
         this.alignGoldChoices();
         this.makeSelectionGroup();
      }
      
      public function getChoice() : OfferRadioButton
      {
         return this.group.getSelected() as OfferRadioButton;
      }
      
      private function makeGoldChoices() : void
      {
         var count:int = this.offers.offerList.length;
         this.choices = new Vector.<OfferRadioButton>(count,true);
         for(var i:int = 0; i < count; i++)
         {
            this.choices[i] = this.makeGoldChoice(this.offers.offerList[i]);
         }
      }
      
      private function makeGoldChoice(offer:Offer) : OfferRadioButton
      {
         var choice:OfferRadioButton = new OfferRadioButton(offer,this.config);
         choice.addEventListener(MouseEvent.CLICK,this.onSelected);
         addChild(choice);
         return choice;
      }
      
      private function onSelected(event:MouseEvent) : void
      {
         var selectable:Selectable = event.currentTarget as Selectable;
         this.group.setSelected(selectable.getValue());
      }
      
      private function alignGoldChoices() : void
      {
         var elements:Vector.<DisplayObject> = this.castChoicesToDisplayList();
         var layout:Layout = new VerticalLayout();
         layout.setPadding(5);
         layout.layout(elements);
      }
      
      private function castChoicesToDisplayList() : Vector.<DisplayObject>
      {
         var count:int = this.choices.length;
         var elements:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
         for(var i:int = 0; i < count; i++)
         {
            elements[i] = this.choices[i];
         }
         return elements;
      }
      
      private function makeSelectionGroup() : void
      {
         var selectables:Vector.<Selectable> = this.castBoxesToSelectables();
         this.group = new SelectionGroup(selectables);
         this.group.setSelected(this.choices[0].getValue());
      }
      
      private function castBoxesToSelectables() : Vector.<Selectable>
      {
         var count:int = this.choices.length;
         var selectables:Vector.<Selectable> = new Vector.<Selectable>(0);
         for(var i:int = 0; i < count; i++)
         {
            selectables[i] = this.choices[i];
         }
         return selectables;
      }
      
      public function showBonuses(showBonuses:Boolean) : void
      {
         var i:int = this.choices.length;
         while(i--)
         {
            this.choices[i].showBonus(showBonuses);
         }
      }
   }
}
