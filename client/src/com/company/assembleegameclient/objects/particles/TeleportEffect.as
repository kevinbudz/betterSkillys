package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.parameters.Parameters;

public class TeleportEffect extends ParticleEffect
   {
       
      
      public function TeleportEffect()
      {
         super();
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var angle:Number = NaN;
         var dist:Number = NaN;
         var lifetime:int = 0;
         var part:TeleportParticle = null;
         var num:int = 20;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               num = 20;
               break;
            case 1:
               num = 10;
               break;
            case 0:
               num = 1;
               break;
         }
         for(var i:int = 0; i < num; i++)
         {
            angle = 2 * Math.PI * Math.random();
            dist = 0.7 * Math.random();
            lifetime = 500 + 1000 * Math.random();
            part = new TeleportParticle(255,50,0.1,lifetime);
            map_.addObj(part,x_ + dist * Math.cos(angle),y_ + dist * Math.sin(angle));
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class TeleportParticle extends Particle
{
    
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   function TeleportParticle(color:uint, size:int, moveVecZ:Number, lifetime:int)
   {
      this.moveVec_ = new Vector3D();
      super(color,0,size);
      this.moveVec_.z = moveVecZ;
      this.timeLeft_ = lifetime;
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      this.timeLeft_ = this.timeLeft_ - dt;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      z_ = z_ + this.moveVec_.z * dt * 0.008;
      return true;
   }
}
