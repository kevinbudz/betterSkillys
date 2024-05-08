package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.util.FreeList;
   
   public class BubbleParticle extends Particle
   {
       
      
      private const SPREAD_DAMPER:Number = 0.0025;
      
      public var startTime:int;
      
      public var speed:Number;
      
      public var spread:Number;
      
      public var dZ:Number;
      
      public var life:Number;
      
      public var lifeVariance:Number;
      
      public var speedVariance:Number;
      
      public var timeLeft:Number;
      
      public var frequencyX:Number;
      
      public var frequencyY:Number;
      
      public function BubbleParticle(color:uint, zSpeed:Number, life:Number, lifeVariance:Number, speedVariance:Number, spread:Number)
      {
         super(color,0,75 + Math.random() * 50);
         this.dZ = zSpeed;
         this.life = life * 1000;
         this.lifeVariance = lifeVariance;
         this.speedVariance = speedVariance;
         this.spread = spread;
         this.frequencyX = 0;
         this.frequencyY = 0;
      }
      
      public static function create(poolID:*, color:uint, zSpeed:Number, life:Number, lifeVariance:Number, speedVariance:Number, spread:Number) : BubbleParticle
      {
         var bubble:BubbleParticle = FreeList.getObject(poolID) as BubbleParticle;
         if(!bubble)
         {
            bubble = new BubbleParticle(color,zSpeed,life,lifeVariance,speedVariance,spread);
         }
         return bubble;
      }
      
      public function restart(startTime:int, time:int) : void
      {
         this.startTime = startTime;
         var r:Number = Math.random();
         this.speed = (this.dZ - this.dZ * (r * (1 - this.speedVariance))) * 10;
         if(this.spread > 0)
         {
            this.frequencyX = Math.random() * this.spread - 0.1;
            this.frequencyY = Math.random() * this.spread - 0.1;
         }
         var t:Number = (time - startTime) / 1000;
         this.timeLeft = this.life - this.life * (r * (1 - this.lifeVariance));
         z_ = this.speed * t;
      }
      
      override public function removeFromMap() : void
      {
         super.removeFromMap();
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var t:Number = (time - this.startTime) / 1000;
         this.timeLeft = this.timeLeft - dt;
         if(this.timeLeft <= 0)
         {
            return false;
         }
         z_ = this.speed * t;
         if(this.spread > 0)
         {
            moveTo(x_ + this.frequencyX * dt * this.SPREAD_DAMPER,y_ + this.frequencyY * dt * this.SPREAD_DAMPER);
         }
         return true;
      }
   }
}
