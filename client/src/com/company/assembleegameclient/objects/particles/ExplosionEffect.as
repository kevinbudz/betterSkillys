package com.company.assembleegameclient.objects.particles
{
   public class ExplosionEffect extends ParticleEffect
   {
       
      
      public var colors_:Vector.<uint>;
      
      public var numParts_:int;
      
      public function ExplosionEffect(colors:Vector.<uint>, size:int, numParts:int)
      {
         super();
         this.colors_ = colors;
         size_ = size;
         this.numParts_ = numParts;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var color:uint = 0;
         var part:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         for(var i:int = 0; i < this.numParts_; i++)
         {
            color = this.colors_[int(this.colors_.length * Math.random())];
            part = new ExplosionParticle(color,0.5,size_,200 + Math.random() * 100,Math.random() - 0.5,Math.random() - 0.5,0);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class ExplosionParticle extends Particle
{
    
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   function ExplosionParticle(color:uint, z:Number, size:int, lifetime:int, moveVecX:Number, moveVecY:Number, moveVecZ:Number)
   {
      this.moveVec_ = new Vector3D();
      super(color,z,size);
      this.timeLeft_ = this.lifetime_ = lifetime;
      this.moveVec_.x = moveVecX;
      this.moveVec_.y = moveVecY;
      this.moveVec_.z = moveVecZ;
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      this.timeLeft_ = this.timeLeft_ - dt;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      x_ = x_ + this.moveVec_.x * dt * 0.008;
      y_ = y_ + this.moveVec_.y * dt * 0.008;
      z_ = z_ + this.moveVec_.z * dt * 0.008;
      return true;
   }
}
