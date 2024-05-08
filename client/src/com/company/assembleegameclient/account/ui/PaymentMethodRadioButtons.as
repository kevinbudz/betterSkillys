package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.account.ui.components.Selectable;
   import com.company.assembleegameclient.account.ui.components.SelectionGroup;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.lib.ui.api.Layout;
   import kabam.lib.ui.impl.HorizontalLayout;
   
   public class PaymentMethodRadioButtons extends Sprite
   {
       
      
      private var labels:Vector.<String>;
      
      private var boxes:Vector.<PaymentMethodRadioButton>;
      
      private var group:SelectionGroup;
      
      public function PaymentMethodRadioButtons(labels:Vector.<String>)
      {
         super();
         this.labels = labels;
         this.makeRadioButtons();
         this.alignRadioButtons();
         this.makeSelectionGroup();
      }
      
      public function setSelected(label:String) : void
      {
         this.group.setSelected(label);
      }
      
      public function getSelected() : String
      {
         return this.group.getSelected().getValue();
      }
      
      private function makeRadioButtons() : void
      {
         var count:int = this.labels.length;
         this.boxes = new Vector.<PaymentMethodRadioButton>(count,true);
         for(var i:int = 0; i < count; i++)
         {
            this.boxes[i] = this.makeRadioButton(this.labels[i]);
         }
      }
      
      private function makeRadioButton(label:String) : PaymentMethodRadioButton
      {
         var method:PaymentMethodRadioButton = new PaymentMethodRadioButton(label);
         method.addEventListener(MouseEvent.CLICK,this.onSelected);
         addChild(method);
         return method;
      }
      
      private function onSelected(event:Event) : void
      {
         var selectable:Selectable = event.currentTarget as Selectable;
         this.group.setSelected(selectable.getValue());
      }
      
      private function alignRadioButtons() : void
      {
         var elements:Vector.<DisplayObject> = this.castBoxesToDisplayObjects();
         var layout:Layout = new HorizontalLayout();
         layout.setPadding(20);
         layout.layout(elements);
      }
      
      private function castBoxesToDisplayObjects() : Vector.<DisplayObject>
      {
         var count:int = this.boxes.length;
         var elements:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
         for(var i:int = 0; i < count; i++)
         {
            elements[i] = this.boxes[i];
         }
         return elements;
      }
      
      private function makeSelectionGroup() : void
      {
         var selectables:Vector.<Selectable> = this.castBoxesToSelectables();
         this.group = new SelectionGroup(selectables);
         this.group.setSelected(this.boxes[0].getValue());
      }
      
      private function castBoxesToSelectables() : Vector.<Selectable>
      {
         var count:int = this.boxes.length;
         var selectables:Vector.<Selectable> = new Vector.<Selectable>(0);
         for(var i:int = 0; i < count; i++)
         {
            selectables[i] = this.boxes[i];
         }
         return selectables;
      }
   }
}
