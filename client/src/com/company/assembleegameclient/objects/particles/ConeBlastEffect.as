package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ConeBlastEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var target_:WorldPosData;
      
      public var blastRadius_:Number;
      
      public var color_:int;
      
      public function ConeBlastEffect(go:GameObject, target:WorldPosData, radius:Number, color:int)
      {
         super();
         this.start_ = new Point(go.x_,go.y_);
         this.target_ = target;
         this.blastRadius_ = radius;
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var angle:Number = NaN;
         var p:Point = null;
         var part:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var SIZE:int = 200;
         var LIFETIME:int = 100;
         var ARC:Number = Math.PI / 3;
         var NUMPOINTS:int = 7;
         var aimAngle:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
         switch(Parameters.data_.reduceParticles) {
            case 2:
               NUMPOINTS = 7;
               break;
            case 1:
               NUMPOINTS = 4;
               break;
            case 0:
               NUMPOINTS = 1;
               break;
         }
         for(var i:int = 0; i < NUMPOINTS; i++)
         {
            angle = aimAngle - ARC / 2 + i * ARC / NUMPOINTS;
            p = new Point(this.start_.x + this.blastRadius_ * Math.cos(angle),this.start_.y + this.blastRadius_ * Math.sin(angle));
            part = new SparkerParticle(SIZE,this.color_,LIFETIME,this.start_,p);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}
