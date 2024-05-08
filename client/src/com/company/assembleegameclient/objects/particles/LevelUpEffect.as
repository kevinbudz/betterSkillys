package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class LevelUpEffect extends ParticleEffect
   {
      
      private static const LIFETIME:int = 2000;
       
      
      public var go_:GameObject;
      
      public var parts1_:Vector.<LevelUpParticle>;
      
      public var parts2_:Vector.<LevelUpParticle>;
      
      public var startTime_:int = -1;
      
      public function LevelUpEffect(go:GameObject, color:uint, num:int)
      {
         var part:LevelUpParticle = null;
         this.parts1_ = new Vector.<LevelUpParticle>();
         this.parts2_ = new Vector.<LevelUpParticle>();
         super();
         this.go_ = go;
         for(var i:int = 0; i < num; i++)
         {
            part = new LevelUpParticle(color,100);
            this.parts1_.push(part);
            part = new LevelUpParticle(color,100);
            this.parts2_.push(part);
         }
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         if(this.go_.map_ == null)
         {
            this.endEffect();
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         if(this.startTime_ < 0)
         {
            this.startTime_ = time;
         }
         var t:Number = (time - this.startTime_) / LIFETIME;
         if(t >= 1)
         {
            this.endEffect();
            return false;
         }
         this.updateSwirl(this.parts1_,1,0,t);
         this.updateSwirl(this.parts2_,1,Math.PI,t);
         return true;
      }
      
      private function endEffect() : void
      {
         var part:LevelUpParticle = null;
         for each(part in this.parts1_)
         {
            part.alive_ = false;
         }
         for each(part in this.parts2_)
         {
            part.alive_ = false;
         }
      }
      
      public function updateSwirl(parts:Vector.<LevelUpParticle>, mult:Number, offset:Number, t:Number) : void
      {
         var i:int = 0;
         var part:LevelUpParticle = null;
         var angle:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         for(i = 0; i < parts.length; i++)
         {
            part = parts[i];
            part.z_ = t * 2 - 1 + i / parts.length;
            if(part.z_ >= 0)
            {
               if(part.z_ > 1)
               {
                  part.alive_ = false;
               }
               else
               {
                  angle = mult * (2 * Math.PI * (i / parts.length) + 2 * Math.PI * t + offset);
                  x = this.go_.x_ + 0.5 * Math.cos(angle);
                  y = this.go_.y_ + 0.5 * Math.sin(angle);
                  if(part.map_ == null)
                  {
                     map_.addObj(part,x,y);
                  }
                  else
                  {
                     part.moveTo(x,y);
                  }
               }
            }
         }
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;

class LevelUpParticle extends Particle
{
    
   
   public var alive_:Boolean = true;
   
   function LevelUpParticle(color:uint, size:int)
   {
      super(color,0,size);
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      return this.alive_;
   }
}
