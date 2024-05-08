package com.company.assembleegameclient.objects.particles
{
   public class GasParticle extends SparkParticle
   {
       
      
      private var noise:Number;
      
      public function GasParticle(size:int, color:int, lifetime:int, noise:Number, z:Number, dx:Number, dy:Number)
      {
         this.noise = noise;
         super(size,color,lifetime,z,dx,dy);
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var varY:Number = NaN;
         timeLeft_ = timeLeft_ - dt;
         if(timeLeft_ <= 0)
         {
            return false;
         }
         if(square_.obj_ && square_.obj_.props_.static_)
         {
            return false;
         }
         var varX:Number = Math.random() * this.noise;
         varY = Math.random() * this.noise;
         x_ = x_ + dx_ * varX * dt / 1000;
         y_ = y_ + dy_ * varY * dt / 1000;
         setSize(timeLeft_ / lifetime_ * initialSize_);
         return true;
      }
   }
}
