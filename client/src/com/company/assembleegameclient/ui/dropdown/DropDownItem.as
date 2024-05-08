package com.company.assembleegameclient.ui.dropdown
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class DropDownItem extends Sprite
   {
       
      
      public var w_:int;
      
      public var h_:int;
      
      private var nameText_:SimpleText;
      
      public function DropDownItem(name:String, w:int, h:int)
      {
         super();
         this.w_ = w;
         this.h_ = h;
         this.nameText_ = new SimpleText(16,11776947,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = name;
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         this.nameText_.x = this.w_ / 2 - this.nameText_.width / 2;
         this.nameText_.y = this.h_ / 2 - this.nameText_.height / 2;
         addChild(this.nameText_);
         this.drawBackground(3552822);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function getValue() : String
      {
         return this.nameText_.text;
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.drawBackground(5658198);
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.drawBackground(3552822);
      }
      
      private function drawBackground(color:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(1,11776947);
         graphics.beginFill(color,1);
         graphics.drawRect(0,0,this.w_,this.h_);
         graphics.endFill();
         graphics.lineStyle();
      }
   }
}
