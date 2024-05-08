package com.company.assembleegameclient.objects.particles
{
   public class SparkParticle extends Particle
   {
      public var lifetime_:int;
      
      public var timeLeft_:int;
      
      public var initialSize_:int;
      
      public var dx_:Number;
      
      public var dy_:Number;
      
      public function SparkParticle(size:int, color:int, lifetime:int, z:Number, dx:Number, dy:Number)
      {
         super(color,z,size);
         this.initialSize_ = size;
         this.lifetime_ = this.timeLeft_ = lifetime;
         this.dx_ = dx;
         this.dy_ = dy;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         this.timeLeft_ = this.timeLeft_ - dt;
         if(this.timeLeft_ <= 0)
         {
            return false;
         }
         x_ = x_ + this.dx_ * dt / 1000;
         y_ = y_ + this.dy_ * dt / 1000;
         setSize(this.timeLeft_ / this.lifetime_ * this.initialSize_);
         return true;
      }
   }
}
