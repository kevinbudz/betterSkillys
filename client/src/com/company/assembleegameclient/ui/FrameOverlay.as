package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.account.ui.Frame;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FrameOverlay extends Sprite
   {
       
      
      private var darkBox_:Shape;
      
      private var frame_:Frame;
      
      public function FrameOverlay(frame:Frame)
      {
         super();
         this.darkBox_ = new Shape();
         var g:Graphics = this.darkBox_.graphics;
         g.clear();
         g.beginFill(0,0.8);
         g.drawRect(0,0,800,600);
         g.endFill();
         addChild(this.darkBox_);
         this.frame_ = frame;
         this.frame_.addEventListener(Event.COMPLETE,this.onFrameDone);
         addChild(this.frame_);
      }
      
      private function onFrameDone(event:Event) : void
      {
         parent.removeChild(this);
      }
   }
}
