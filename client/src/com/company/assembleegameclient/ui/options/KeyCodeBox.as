package com.company.assembleegameclient.ui.options
{
   import com.company.ui.SimpleText;
   import com.company.util.KeyCodes;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.getTimer;
   
   public class KeyCodeBox extends Sprite
   {
      
      public static const WIDTH:int = 80;
      
      public static const HEIGHT:int = 32;
       
      
      public var keyCode_:uint;
      
      public var selected_:Boolean;
      
      public var inputMode_:Boolean;
      
      private var char_:SimpleText = null;
      
      public function KeyCodeBox(keyCode:uint)
      {
         super();
         this.keyCode_ = keyCode;
         this.selected_ = false;
         this.inputMode_ = false;
         this.char_ = new SimpleText(16,16777215,false,0,0);
         this.char_.setBold(true);
         this.char_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.char_);
         this.drawBackground();
         this.setNormalMode();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function value() : uint
      {
         return this.keyCode_;
      }
      
      public function setKeyCode(keyCode:uint) : void
      {
         if(keyCode == this.keyCode_)
         {
            return;
         }
         this.keyCode_ = keyCode;
         this.setText(KeyCodes.CharCodeStrings[this.keyCode_]);
         dispatchEvent(new Event(Event.CHANGE,true));
      }
      
      private function drawBackground() : void
      {
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(2,this.selected_ || this.inputMode_?uint(11776947):uint(4473924));
         g.beginFill(3355443);
         g.drawRect(0,0,WIDTH,HEIGHT);
         g.endFill();
         g.lineStyle();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.selected_ = true;
         this.drawBackground();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.selected_ = false;
         this.drawBackground();
      }
      
      private function setText(text:String) : void
      {
         this.char_.text = text;
         this.char_.updateMetrics();
         this.char_.x = WIDTH / 2 - this.char_.width / 2;
         this.char_.y = HEIGHT / 2 - this.char_.height / 2 - 2;
         this.drawBackground();
      }
      
      private function setNormalMode() : void
      {
         this.inputMode_ = false;
         removeEventListener(Event.ENTER_FRAME,this.onInputEnterFrame);
         if(stage != null)
         {
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onInputMouseDown,true);
         }
         this.setText(KeyCodes.CharCodeStrings[this.keyCode_]);
         addEventListener(MouseEvent.CLICK,this.onNormalClick);
      }
      
      private function setInputMode() : void
      {
         if(stage == null)
         {
            return;
         }
         stage.stageFocusRect = false;
         stage.focus = this;
         this.inputMode_ = true;
         removeEventListener(MouseEvent.CLICK,this.onNormalClick);
         addEventListener(Event.ENTER_FRAME,this.onInputEnterFrame);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onInputMouseDown,true);
      }
      
      private function onNormalClick(event:MouseEvent) : void
      {
         this.setInputMode();
      }
      
      private function onInputEnterFrame(event:Event) : void
      {
         var t:int = getTimer() / 400;
         this.setText(t % 2 == 0?"":"[Hit Key]");
      }
      
      private function onInputKeyDown(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         this.keyCode_ = event.keyCode;
         this.setNormalMode();
         dispatchEvent(new Event(Event.CHANGE,true));
      }
      
      private function onInputMouseDown(event:MouseEvent) : void
      {
         this.setNormalMode();
      }
   }
}
