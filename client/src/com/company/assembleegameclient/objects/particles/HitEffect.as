package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.parameters.Parameters;

public class HitEffect extends ParticleEffect
   {
       
      
      public var colors_:Vector.<uint>;
      
      public var numParts_:int;
      
      public var angle_:Number;
      
      public var speed_:Number;
      
      public function HitEffect(colors:Vector.<uint>, size:int, numParts:int, angle:Number, speed:Number)
      {
         super();
         this.colors_ = colors;
         size_ = size;
         this.numParts_ = numParts;
         this.angle_ = angle;
         this.speed_ = speed;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         if(Parameters.data_.disableAllParticles) return false;
         var color:uint = 0;
         var part:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         var moveVecX:Number = this.speed_ / 600 * Math.cos(this.angle_ + Math.PI);
         var moveVecY:Number = this.speed_ / 600 * Math.sin(this.angle_ + Math.PI);
         for(var i:int = 0; i < this.numParts_; i++)
         {
            color = this.colors_[int(this.colors_.length * Math.random())];
            part = new HitParticle(color,0.5,size_,200 + Math.random() * 100,moveVecX + (Math.random() - 0.5) * 0.4,moveVecY + (Math.random() - 0.5) * 0.4,0);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class HitParticle extends Particle
{
    
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   function HitParticle(color:uint, z:Number, size:int, lifetime:int, moveVecX:Number, moveVecY:Number, moveVecZ:Number)
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
