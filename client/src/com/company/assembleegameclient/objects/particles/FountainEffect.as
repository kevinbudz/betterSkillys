package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.FreeList;
   
   public class FountainEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public function FountainEffect(go:GameObject)
      {
         super();
         this.go_ = go;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var t:int = 0;
         var part:FountainParticle = null;
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
         for(var i:int = this.lastUpdate_ / 50; i < time / 50; i++)
         {
            t = i * 50;
            part = FreeList.newObject(FountainParticle) as FountainParticle;
            part.restart(t,time);
            map_.addObj(part,x_,y_);
         }
         this.lastUpdate_ = time;
         return true;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;
import flash.geom.Vector3D;

class FountainParticle extends Particle
{
   
   private static const G:Number = -4.9;
   
   private static const VI:Number = 6.5;
   
   private static const ZI:Number = 0.75;
    
   
   public var startTime_:int;
   
   protected var moveVec_:Vector3D;
   
   function FountainParticle()
   {
      this.moveVec_ = new Vector3D();
      super(4285909,ZI,100);
   }
   
   public function restart(startTime:int, time:int) : void
   {
      var dt:int = 0;
      var angle:Number = 2 * Math.PI * Math.random();
      this.moveVec_.x = Math.cos(angle);
      this.moveVec_.y = Math.sin(angle);
      this.startTime_ = startTime;
      dt = time - this.startTime_;
      x_ = x_ + this.moveVec_.x * dt * 0.0008;
      y_ = y_ + this.moveVec_.y * dt * 0.0008;
      var t:Number = (time - this.startTime_) / 1000;
      z_ = 0.75 + VI * t + G * (t * t);
   }
   
   override public function removeFromMap() : void
   {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      var t:Number = (time - this.startTime_) / 1000;
      moveTo(x_ + this.moveVec_.x * dt * 0.0008,y_ + this.moveVec_.y * dt * 0.0008);
      z_ = 0.75 + VI * t + G * (t * t);
      return z_ > 0;
   }
}
