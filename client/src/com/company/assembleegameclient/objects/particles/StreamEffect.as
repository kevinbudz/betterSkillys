package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.parameters.Parameters;

import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class StreamEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var color_:int;
      
      public function StreamEffect(start:WorldPosData, end:WorldPosData, color:int)
      {
         super();
         this.start_ = new Point(start.x_,start.y_);
         this.end_ = new Point(end.x_,end.y_);
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var size:int = 0;
         var part:StreamParticle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var num:int = 5;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               num = 5;
               break;
            case 1:
               num = 2;
               break;
            case 0:
               num = 1;
               break;
         }
         for(var i:int = 0; i < num; i++)
         {
            size = (3 + int(Math.random() * 5)) * 20;
            part = new StreamParticle(1.85,size,this.color_,1500 + Math.random() * 3000,0.1 + Math.random() * 0.1,this.start_,this.end_);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Point;
import flash.geom.Vector3D;

class StreamParticle extends Particle
{
    
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   public var start_:Point;
   
   public var end_:Point;
   
   public var dx_:Number;
   
   public var dy_:Number;
   
   public var pathX_:Number;
   
   public var pathY_:Number;
   
   public var xDeflect_:Number;
   
   public var yDeflect_:Number;
   
   public var period_:Number;
   
   function StreamParticle(z:Number, size:int, color:int, lifetime:int, moveVecZ:Number, start:Point, end:Point)
   {
      this.moveVec_ = new Vector3D();
      super(color,z,size);
      this.moveVec_.z = moveVecZ;
      this.timeLeft_ = lifetime;
      this.start_ = start;
      this.end_ = end;
      this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
      this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
      var speed:Number = Point.distance(start,end) / this.timeLeft_;
      var deflect:Number = 0.25;
      this.xDeflect_ = this.dy_ / speed * deflect;
      this.yDeflect_ = -this.dx_ / speed * deflect;
      this.pathX_ = x_ = this.start_.x;
      this.pathY_ = y_ = this.start_.y;
      this.period_ = 0.25 + Math.random() * 0.5;
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      this.timeLeft_ = this.timeLeft_ - dt;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      this.pathX_ = this.pathX_ + this.dx_ * dt;
      this.pathY_ = this.pathY_ + this.dy_ * dt;
      var deflectFactor:Number = Math.sin(this.timeLeft_ / 1000 / this.period_);
      moveTo(this.pathX_ + this.xDeflect_ * deflectFactor,this.pathY_ + this.yDeflect_ * deflectFactor);
      return true;
   }
}
