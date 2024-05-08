package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.KeyCodes;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class IconButton extends Sprite
   {
      
      protected static const mouseOverCT:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
       
      
      protected var origIconBitmapData_:BitmapData;
      
      protected var iconBitmapData_:BitmapData;
      
      protected var icon_:Bitmap;
      
      protected var hotkeyName_:String;
      
      protected var ct_:ColorTransform = null;
      
      protected var toolTip_:TextToolTip = null;
      
      public function IconButton(bitmapData:BitmapData, toolTipTitle:String, hotkeyName:String)
      {
         super();
         this.origIconBitmapData_ = bitmapData;
         this.iconBitmapData_ = TextureRedrawer.redraw(this.origIconBitmapData_,320 / this.origIconBitmapData_.width,true,0);
         this.icon_ = new Bitmap(this.iconBitmapData_);
         this.icon_.x = -12;
         this.icon_.y = -12;
         addChild(this.icon_);
         this.hotkeyName_ = hotkeyName;
         if(toolTipTitle != "")
         {
            this.toolTip_ = new TextToolTip(3552822,10197915,toolTipTitle,"",200);
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function setColorTransform(ct:ColorTransform) : void
      {
         if(ct == this.ct_)
         {
            return;
         }
         this.ct_ = ct;
         if(this.ct_ == null)
         {
            transform.colorTransform = MoreColorUtil.identity;
         }
         else
         {
            transform.colorTransform = this.ct_;
         }
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         if(this.toolTip_ != null && this.toolTip_.parent != null)
         {
            this.toolTip_.parent.removeChild(this.toolTip_);
         }
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
         this.setColorTransform(mouseOverCT);
         if(this.toolTip_ != null && !stage.contains(this.toolTip_))
         {
            this.toolTip_.setText("Hotkey: " + KeyCodes.CharCodeStrings[Parameters.data_[this.hotkeyName_]]);
            stage.addChild(this.toolTip_);
         }
      }
      
      protected function onMouseOut(event:MouseEvent) : void
      {
         this.setColorTransform(null);
         if(this.toolTip_ != null && this.toolTip_.parent != null)
         {
            this.toolTip_.parent.removeChild(this.toolTip_);
         }
      }
   }
}
