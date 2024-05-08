package com.company.assembleegameclient.ui.options
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class OptionsTabTitle extends Sprite
   {
      
      private static const TEXT_SIZE:int = 16;
       
      
      public var text_:String;
      
      protected var textText_:SimpleText;
      
      protected var selected_:Boolean;
      
      public function OptionsTabTitle(text:String)
      {
         super();
         this.text_ = text;
         this.textText_ = new SimpleText(TEXT_SIZE,11776947,false,0,0);
         this.textText_.setBold(true);
         this.textText_.text = this.text_;
         this.textText_.updateMetrics();
         this.textText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(this.textText_);
         this.selected_ = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function setSelected(selected:Boolean) : void
      {
         this.selected_ = selected;
         this.redraw(false);
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.redraw(true);
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.redraw(false);
      }
      
      private function redraw(over:Boolean) : void
      {
         this.textText_.setSize(TEXT_SIZE).setColor(this.getColor(over));
      }
      
      private function getColor(isOver:Boolean) : uint
      {
         if(this.selected_)
         {
            return 16762880;
         }
         return !!isOver?uint(16777215):uint(11776947);
      }
   }
}
