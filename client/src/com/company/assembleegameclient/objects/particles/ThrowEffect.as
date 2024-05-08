package com.company.assembleegameclient.objects.particles
{
import flash.geom.Point;

public class ThrowEffect extends ParticleEffect
{


   public var start_:Point;
   public var end_:Point;
   public var color_:int;
   public var duration_:int;

   public function ThrowEffect(start:Point, end:Point, color:int, duration:int = 1000)
   {
      super();
      this.start_ = start;
      this.end_ = end;
      this.color_ = color;
      this.duration_ = duration;
   }

   override public function update(time:int, dt:int) : Boolean
   {
      x_ = this.start_.x;
      y_ = this.start_.y;
      var size:int = 200;
      var part:ThrowParticle = new ThrowParticle(size,this.color_, this.duration_,this.start_,this.end_);
      if(this.duration_ == 0){
         part = new ThrowParticle(200, this.color_, 1500, this.start_, this.end_);
      }
      map_.addObj(part,x_,y_);
      return false;
   }
}
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.objects.particles.SparkParticle;
import com.company.assembleegameclient.util.RandomUtil;
import flash.geom.Point;

class ThrowParticle extends Particle
{


   public var lifetime_:int;

   public var timeLeft_:int;

   public var initialSize_:int;

   public var start_:Point;

   public var end_:Point;

   public var dx_:Number;

   public var dy_:Number;

   public var pathX_:Number;

   public var pathY_:Number;

   function ThrowParticle(size:int, color:int, lifetime:int, start:Point, end:Point)
   {
      super(color,0,size);
      this.lifetime_ = this.timeLeft_ = lifetime;
      this.initialSize_ = size;
      this.start_ = start;
      this.end_ = end;
      this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
      this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
      var speed:Number = Point.distance(start,end) / this.timeLeft_;
      this.pathX_ = x_ = this.start_.x;
      this.pathY_ = y_ = this.start_.y;
   }

   override public function update(time:int, dt:int) : Boolean
   {
      this.timeLeft_ = this.timeLeft_ - dt;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      z_ = Math.sin(this.timeLeft_ / this.lifetime_ * Math.PI) * 2;
      setSize(0);
      this.pathX_ = this.pathX_ + this.dx_ * dt;
      this.pathY_ = this.pathY_ + this.dy_ * dt;
      moveTo(this.pathX_,this.pathY_);
      map_.addObj(new SparkParticle(100 * (z_ + 1),color_,400,z_,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1)),this.pathX_,this.pathY_);
      return true;
   }
}
