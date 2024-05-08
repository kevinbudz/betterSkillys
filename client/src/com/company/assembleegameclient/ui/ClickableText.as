package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class ClickableText extends Sprite
   {
       
      
      public var text_:SimpleText;
      
      public var actualWidth_:int;
      
      public var actualHeight_:int;
      
      public var defaultColor_:uint = 16777215;
      
      public function ClickableText(textSize:int, bold:Boolean, text:String)
      {
         super();
         this.text_ = new SimpleText(textSize,16777215,false,0,0);
         this.text_.setBold(bold);
         this.text_.text = text;
         this.text_.updateMetrics();
         addChild(this.text_);
         this.text_.filters = [new DropShadowFilter(0,0,0)];
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function makeStatic(text:String) : void
      {
         this.text_.text = text;
         this.text_.updateMetrics();
         this.setDefaultColor(11776947);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setColor(color:uint) : void
      {
         this.text_.setColor(color);
      }
      
      public function setDefaultColor(color:uint) : void
      {
         this.defaultColor_ = color;
         this.setColor(this.defaultColor_);
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.setColor(16768133);
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.setColor(this.defaultColor_);
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         SoundEffectLibrary.play("button_click");
      }
   }
}
