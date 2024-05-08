package com.company.assembleegameclient.tutorial
{
   import com.company.util.ConversionUtil;
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class UIDrawBox
   {
       
      
      public var rect_:Rectangle;
      
      public var color_:uint;
      
      public const ANIMATION_MS:int = 500;
      
      public const ORIGIN:Point = new Point(250,200);
      
      public function UIDrawBox(uiDrawBoxXML:XML)
      {
         super();
         this.rect_ = ConversionUtil.toRectangle(uiDrawBoxXML);
         this.color_ = uint(uiDrawBoxXML.@color);
      }
      
      public function draw(thickness:int, g:Graphics, timeDiff:int) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var width:Number = this.rect_.width - thickness;
         var height:Number = this.rect_.height - thickness;
         if(timeDiff < this.ANIMATION_MS)
         {
            x = this.ORIGIN.x + (this.rect_.x - this.ORIGIN.x) * timeDiff / this.ANIMATION_MS;
            y = this.ORIGIN.y + (this.rect_.y - this.ORIGIN.y) * timeDiff / this.ANIMATION_MS;
            width = width * (timeDiff / this.ANIMATION_MS);
            height = height * (timeDiff / this.ANIMATION_MS);
         }
         else
         {
            x = this.rect_.x + thickness / 2;
            y = this.rect_.y + thickness / 2;
         }
         g.lineStyle(thickness,this.color_);
         g.drawRect(x,y,width,height);
      }
   }
}
