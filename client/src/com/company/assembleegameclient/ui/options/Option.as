package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class Option extends Sprite
   {
      
      private static var tooltip_:ToolTip;
       
      
      public var paramName_:String;
      
      public var tooltipText_:String;
      
      private var desc_:SimpleText;
      
      public function Option(paramName:String, desc:String, tooltipText:String)
      {
         super();
         this.paramName_ = paramName;
         this.tooltipText_ = tooltipText;
         this.desc_ = new SimpleText(18,11776947,false,0,0);
         this.desc_.text = desc;
         this.desc_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.desc_.updateMetrics();
         this.desc_.x = KeyCodeBox.WIDTH + 24;
         this.desc_.y = KeyCodeBox.HEIGHT / 2 - this.desc_.height / 2 - 2;
         this.desc_.mouseEnabled = true;
         this.desc_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.desc_.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addChild(this.desc_);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function refresh() : void
      {
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         tooltip_ = new TextToolTip(2565927,8553090,null,this.tooltipText_,150);
         stage.addChild(tooltip_);
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.removeToolTip();
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         this.removeToolTip();
      }
      
      private function removeToolTip() : void
      {
         if(tooltip_ != null && stage.contains(tooltip_))
         {
            stage.removeChild(tooltip_);
            tooltip_ = null;
         }
      }
   }
}
