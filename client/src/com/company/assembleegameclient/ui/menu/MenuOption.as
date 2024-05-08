package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.CachingColorTransformer;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   
   public class MenuOption extends Sprite
   {
      
      protected static const mouseOverCT:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
       
      
      protected var origIconBitmapData_:BitmapData;
      
      protected var iconBitmapData_:BitmapData;
      
      protected var icon_:Bitmap;
      
      protected var text_:SimpleText;
      
      protected var ct_:ColorTransform = null;
      
      public function MenuOption(origIconBitmapData:BitmapData, color:uint, textStr:String)
      {
         super();
         this.origIconBitmapData_ = origIconBitmapData;
         this.iconBitmapData_ = TextureRedrawer.redraw(origIconBitmapData,this.redrawSize(),true,0);
         this.icon_ = new Bitmap(this.iconBitmapData_);
         this.icon_.filters = [new DropShadowFilter(0,0,0)];
         this.icon_.x = -12;
         this.icon_.y = -12;
         addChild(this.icon_);
         this.text_ = new SimpleText(18,color,false,0,0);
         this.text_.setBold(true);
         this.text_.text = textStr;
         this.text_.updateMetrics();
         this.text_.filters = [new DropShadowFilter(0,0,0)];
         this.text_.x = 20;
         this.text_.y = -6;
         addChild(this.text_);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function setColorTransform(ct:ColorTransform) : void
      {
         var transformedBitmapData:BitmapData = null;
         if(ct == this.ct_)
         {
            return;
         }
         this.ct_ = ct;
         if(this.ct_ == null)
         {
            this.icon_.bitmapData = this.iconBitmapData_;
            this.text_.transform.colorTransform = MoreColorUtil.identity;
         }
         else
         {
            transformedBitmapData = CachingColorTransformer.transformBitmapData(this.origIconBitmapData_,this.ct_);
            transformedBitmapData = TextureRedrawer.redraw(transformedBitmapData,this.redrawSize(),true,0);
            this.icon_.bitmapData = transformedBitmapData;
            this.text_.transform.colorTransform = this.ct_;
         }
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
         this.setColorTransform(mouseOverCT);
      }
      
      protected function onMouseOut(event:MouseEvent) : void
      {
         this.setColorTransform(null);
      }
      
      protected function redrawSize() : int
      {
         return 40 / (this.origIconBitmapData_.width / 8);
      }
   }
}
