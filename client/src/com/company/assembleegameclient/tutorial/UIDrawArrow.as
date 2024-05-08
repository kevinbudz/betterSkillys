package com.company.assembleegameclient.tutorial
{
   import com.company.util.ConversionUtil;
   import com.company.util.PointUtil;
   import flash.display.Graphics;
   import flash.geom.Point;
   
   public class UIDrawArrow
   {
       
      
      public var p0_:Point;
      
      public var p1_:Point;
      
      public var color_:uint;
      
      public const ANIMATION_MS:int = 500;
      
      public function UIDrawArrow(uiDrawArrowXML:XML)
      {
         super();
         var a:Array = ConversionUtil.toPointPair(uiDrawArrowXML);
         this.p0_ = a[0];
         this.p1_ = a[1];
         this.color_ = uint(uiDrawArrowXML.@color);
      }
      
      public function draw(thickness:int, g:Graphics, timeDiff:int) : void
      {
         var q:Point = null;
         var p:Point = new Point();
         if(timeDiff < this.ANIMATION_MS)
         {
            p.x = this.p0_.x + (this.p1_.x - this.p0_.x) * timeDiff / this.ANIMATION_MS;
            p.y = this.p0_.y + (this.p1_.y - this.p0_.y) * timeDiff / this.ANIMATION_MS;
         }
         else
         {
            p.x = this.p1_.x;
            p.y = this.p1_.y;
         }
         g.lineStyle(thickness,this.color_);
         g.moveTo(this.p0_.x,this.p0_.y);
         g.lineTo(p.x,p.y);
         var a:Number = PointUtil.angleTo(p,this.p0_);
         q = PointUtil.pointAt(p,a + Math.PI / 8,30);
         g.lineTo(q.x,q.y);
         q = PointUtil.pointAt(p,a - Math.PI / 8,30);
         g.moveTo(p.x,p.y);
         g.lineTo(q.x,q.y);
      }
   }
}
