package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.FreeList;
   
   public class VentEffect extends ParticleEffect
   {
      
      private static const BUBBLE_PERIOD:int = 50;
       
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public function VentEffect(go:GameObject)
      {
         super();
         this.go_ = go;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var t:int = 0;
         var part:VentParticle = null;
         var angle:Number = NaN;
         var d:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         if(this.go_.map_ == null)
         {
            return false;
         }
         if(this.lastUpdate_ < 0)
         {
            this.lastUpdate_ = Math.max(0,time - 400);
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         for(var i:int = int(this.lastUpdate_ / BUBBLE_PERIOD); i < int(time / BUBBLE_PERIOD); i++)
         {
            t = i * BUBBLE_PERIOD;
            part = FreeList.newObject(VentParticle) as VentParticle;
            part.restart(t,time);
            angle = Math.random() * Math.PI;
            d = Math.random() * 0.4;
            x = this.go_.x_ + d * Math.cos(angle);
            y = this.go_.y_ + d * Math.sin(angle);
            map_.addObj(part,x,y);
         }
         this.lastUpdate_ = time;
         return true;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class VentParticle extends Particle
{
    
   
   public var startTime_:int;
   
   public var speed_:int;
   
   function VentParticle()
   {
      var r:Number = Math.random();
      super(2542335,0,75 + r * 50);
      this.speed_ = 2.5 - r * 1.5;
   }
   
   public function restart(startTime:int, time:int) : void
   {
      this.startTime_ = startTime;
      var t:Number = (time - this.startTime_) / 1000;
      z_ = 0 + this.speed_ * t;
   }
   
   override public function removeFromMap() : void
   {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      var t:Number = (time - this.startTime_) / 1000;
      z_ = 0 + this.speed_ * t;
      return z_ < 1;
   }
}
