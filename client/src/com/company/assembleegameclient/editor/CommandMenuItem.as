package com.company.assembleegameclient.editor
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CommandMenuItem extends Sprite
   {
      
      private static const WIDTH:int = 80;
      
      private static const HEIGHT:int = 25;
       
      
      public var callback_:Function;
      
      public var command_:int;
      
      private var over_:Boolean = false;
      
      private var down_:Boolean = false;
      
      private var selected_:Boolean = false;
      
      private var text_:SimpleText;
      
      public function CommandMenuItem(label:String, callback:Function, command:int)
      {
         super();
         this.callback_ = callback;
         this.command_ = command;
         this.text_ = new SimpleText(16,16777215,false,0,0);
         this.text_.setBold(true);
         this.text_.text = label;
         this.text_.updateMetrics();
         this.text_.x = 2;
         addChild(this.text_);
         this.redraw();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function setSelected(selected:Boolean) : void
      {
         this.selected_ = selected;
         this.redraw();
      }
      
      public function setLabel(label:String) : void
      {
         this.text_.text = label;
         this.text_.updateMetrics();
      }
      
      private function redraw() : void
      {
         graphics.clear();
         if(this.selected_ || this.down_)
         {
            graphics.lineStyle(2,16777215);
            graphics.beginFill(8355711,1);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
         else if(this.over_)
         {
            graphics.lineStyle(2,16777215);
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
         else
         {
            graphics.lineStyle(1,16777215);
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.over_ = true;
         this.redraw();
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.over_ = false;
         this.down_ = false;
         this.redraw();
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         this.down_ = true;
         this.redraw();
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         this.down_ = false;
         this.redraw();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this.callback_(this);
      }
   }
}
