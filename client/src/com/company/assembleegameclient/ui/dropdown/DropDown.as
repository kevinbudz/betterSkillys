package com.company.assembleegameclient.ui.dropdown
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DropDown extends Sprite
   {
       
      
      protected var strings_:Vector.<String>;
      
      protected var w_:int;
      
      protected var h_:int;
      
      protected var labelText_:SimpleText;
      
      protected var xOffset_:int = 0;
      
      protected var selected_:DropDownItem;
      
      protected var all_:Sprite;
      
      public function DropDown(strings:Vector.<String>, w:int, h:int, label:String = null)
      {
         this.all_ = new Sprite();
         super();
         this.strings_ = strings;
         this.w_ = w;
         this.h_ = h;
         if(label != null)
         {
            this.labelText_ = new SimpleText(16,16777215,false,0,0);
            this.labelText_.setBold(true);
            this.labelText_.text = label + ":";
            this.labelText_.updateMetrics();
            addChild(this.labelText_);
            this.xOffset_ = this.labelText_.width + 5;
         }
         this.setIndex(0);
      }
      
      public function getValue() : String
      {
         return this.selected_.getValue();
      }
      
      public function setValue(value:String) : void
      {
         for(var i:int = 0; i < this.strings_.length; i++)
         {
            if(value == this.strings_[i])
            {
               this.setIndex(i);
               return;
            }
         }
      }
      
      public function setIndex(index:int) : void
      {
         this.setSelected(this.strings_[index]);
      }
      
      public function getIndex() : int
      {
         for(var i:int = 0; i < this.strings_.length; i++)
         {
            if(this.selected_.getValue() == this.strings_[i])
            {
               return i;
            }
         }
         return -1;
      }
      
      private function setSelected(value:String) : void
      {
         var prevValue:String = this.selected_ != null?this.selected_.getValue():null;
         this.selected_ = new DropDownItem(value,this.w_,this.h_);
         this.selected_.x = this.xOffset_;
         this.selected_.y = 0;
         addChild(this.selected_);
         this.selected_.addEventListener(MouseEvent.CLICK,this.onClick);
         if(value != prevValue)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function onClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         this.selected_.removeEventListener(MouseEvent.CLICK,this.onClick);
         if(contains(this.selected_))
         {
            removeChild(this.selected_);
         }
         this.showAll();
      }
      
      private function showAll() : void
      {
         var global:Point = null;
         var item:DropDownItem = null;
         var yOffset:int = 0;
         global = parent.localToGlobal(new Point(x,y));
         this.all_.x = global.x;
         this.all_.y = global.y;
         for(var i:int = 0; i < this.strings_.length; i++)
         {
            item = new DropDownItem(this.strings_[i],this.w_,this.h_);
            item.addEventListener(MouseEvent.CLICK,this.onSelect);
            item.x = this.xOffset_;
            item.y = yOffset;
            this.all_.addChild(item);
            yOffset = yOffset + item.h_;
         }
         this.all_.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         stage.addChild(this.all_);
      }
      
      private function hideAll() : void
      {
         this.all_.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         stage.removeChild(this.all_);
      }
      
      private function onSelect(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         this.hideAll();
         var dropDownItem:DropDownItem = event.target as DropDownItem;
         this.setSelected(dropDownItem.getValue());
      }
      
      private function onOut(event:MouseEvent) : void
      {
         this.hideAll();
         this.setSelected(this.selected_.getValue());
      }
   }
}
