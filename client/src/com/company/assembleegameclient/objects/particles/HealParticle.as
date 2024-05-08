package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Vector3D;
   
   public class HealParticle extends Particle
   {
       
      
      public var timeLeft_:int;
      
      public var go_:GameObject;
      
      public var angle_:Number;
      
      public var dist_:Number;
      
      protected var moveVec_:Vector3D;
      
      public function HealParticle(color:uint, z:Number, size:int, lifetime:int, moveVecZ:Number, go:GameObject, angle:Number, dist:Number)
      {
         this.moveVec_ = new Vector3D();
         super(color,z,size);
         this.moveVec_.z = moveVecZ;
         this.timeLeft_ = lifetime;
         this.go_ = go;
         this.angle_ = angle;
         this.dist_ = dist;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         this.timeLeft_ = this.timeLeft_ - dt;
         if(this.timeLeft_ <= 0)
         {
            return false;
         }
         x_ = this.go_.x_ + this.dist_ * Math.cos(this.angle_);
         y_ = this.go_.y_ + this.dist_ * Math.sin(this.angle_);
         z_ = z_ + this.moveVec_.z * dt * 0.008;
         return true;
      }
   }
}
