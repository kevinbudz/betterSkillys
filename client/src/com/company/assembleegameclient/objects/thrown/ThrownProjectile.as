package com.company.assembleegameclient.objects.thrown
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class ThrownProjectile extends ThrownObject
   {
       
      
      public var lifetime_:int;
      
      public var timeLeft_:int;
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var dx_:Number;
      
      public var dy_:Number;
      
      public var pathX_:Number;
      
      public var pathY_:Number;
      
      private var bitmapData:BitmapData;
      
      public function ThrownProjectile(id:uint, lifetime:int, start:Point, end:Point)
      {
         this.bitmapData = TextureRedrawer.redraw(ObjectLibrary.getTextureFromType(id),80,true,0,true);
         _rotationDelta = 0.2;
         super(0,this.bitmapData);
         this.lifetime_ = this.timeLeft_ = lifetime;
         this.start_ = start;
         this.end_ = end;
         this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
         this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
         var speed:Number = Point.distance(start,end) / this.timeLeft_;
         this.pathX_ = x_ = this.start_.x;
         this.pathY_ = y_ = this.start_.y;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         this.timeLeft_ = this.timeLeft_ - dt;
         if(this.timeLeft_ <= 0)
         {
            return false;
         }
         z_ = Math.sin(this.timeLeft_ / this.lifetime_ * Math.PI) * 2;
         setSize(z_);
         this.pathX_ = this.pathX_ + this.dx_ * dt;
         this.pathY_ = this.pathY_ + this.dy_ * dt;
         moveTo(this.pathX_,this.pathY_);
         return true;
      }
   }
}
