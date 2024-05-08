package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class FlowEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var go_:GameObject;
      
      public var color_:int;
      
      public function FlowEffect(start:WorldPosData, go:GameObject, color:int)
      {
         super();
         this.start_ = new Point(start.x_,start.y_);
         this.go_ = go;
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var size:int = 0;
         var part:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var NUM:int = 5;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               NUM = 5;
               break;
            case 1:
               NUM = 2;
               break;
            case 0:
               NUM = 1;
               break;
         }
         for(var i:int = 0; i < NUM; i++)
         {
            size = (3 + int(Math.random() * 5)) * 20;
            part = new FlowParticle(0.5,size,this.color_,this.start_,this.go_);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}

import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Point;

class FlowParticle extends Particle
{
    
   
   public var start_:Point;
   
   public var go_:GameObject;
   
   public var maxDist_:Number;
   
   public var flowSpeed_:Number;
   
   function FlowParticle(z:Number, size:int, color:int, start:Point, go:GameObject)
   {
      super(color,z,size);
      this.start_ = start;
      this.go_ = go;
      var here:Point = new Point(x_,y_);
      var target:Point = new Point(this.go_.x_,this.go_.y_);
      this.maxDist_ = Point.distance(here,target);
      this.flowSpeed_ = Math.random() * 5;
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      var ACCEL:Number = 8;
      var here:Point = new Point(x_,y_);
      var target:Point = new Point(this.go_.x_,this.go_.y_);
      var distToGo:Number = Point.distance(here,target);
      if(distToGo < 0.5)
      {
         return false;
      }
      this.flowSpeed_ = this.flowSpeed_ + ACCEL * dt / 1000;
      this.maxDist_ = this.maxDist_ - this.flowSpeed_ * dt / 1000;
      var targetDist:Number = distToGo - this.flowSpeed_ * dt / 1000;
      if(targetDist > this.maxDist_)
      {
         targetDist = this.maxDist_;
      }
      var dx:Number = this.go_.x_ - x_;
      var dy:Number = this.go_.y_ - y_;
      dx = dx * (targetDist / distToGo);
      dy = dy * (targetDist / distToGo);
      moveTo(this.go_.x_ - dx,this.go_.y_ - dy);
      return true;
   }
}

import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Point;

class FlowParticle2 extends Particle
{
    
   
   public var start_:Point;
   
   public var go_:GameObject;
   
   public var accel_:Number;
   
   public var dx_:Number;
   
   public var dy_:Number;
   
   function FlowParticle2(z:Number, size:int, color:int, accel:Number, start:Point, go:GameObject)
   {
      super(color,z,size);
      this.start_ = start;
      this.go_ = go;
      this.accel_ = accel;
      this.dx_ = Math.random() - 0.5;
      this.dy_ = Math.random() - 0.5;
   }
   
   override public function update(time:int, dt:int) : Boolean
   {
      var here:Point = new Point(x_,y_);
      var target:Point = new Point(this.go_.x_,this.go_.y_);
      var distToGo:Number = Point.distance(here,target);
      if(distToGo < 0.5)
      {
         return false;
      }
      var angle:Number = Math.atan2(this.go_.y_ - y_,this.go_.x_ - x_);
      this.dx_ = this.dx_ + this.accel_ * Math.cos(angle) * dt / 1000;
      this.dy_ = this.dy_ + this.accel_ * Math.sin(angle) * dt / 1000;
      var x:Number = x_ + this.dx_ * dt / 1000;
      var y:Number = y_ + this.dy_ * dt / 1000;
      moveTo(x,y);
      return true;
   }
}
