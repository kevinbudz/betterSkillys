package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

import flash.geom.Point;
   
   public class RingEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var novaRadius_:Number;
      
      public var color_:int;
      
      public function RingEffect(go:GameObject, radius:Number, color:int)
      {
         super();
         this.start_ = new Point(go.x_,go.y_);
         this.novaRadius_ = radius;
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var angle:Number = NaN;
         var p:Point = null;
         var q:Point = null;
         var part:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var SIZE:int = 0;
         var NUMPOINTS:int = 12;
         var LIFETIME:int = 200;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               NUMPOINTS = 12;
               break;
            case 1:
               NUMPOINTS = 6;
               break;
            case 0:
               NUMPOINTS = 1;
               break;
         }
         for(var i:int = 0; i < NUMPOINTS; i++)
         {
            angle = i * 2 * Math.PI / NUMPOINTS;
            p = new Point(this.start_.x + this.novaRadius_ * Math.cos(angle),this.start_.y + this.novaRadius_ * Math.sin(angle));
            q = new Point(this.start_.x + this.novaRadius_ * 0.9 * Math.cos(angle),this.start_.y + this.novaRadius_ * 0.9 * Math.sin(angle));
            part = new SparkerParticle(SIZE,this.color_,LIFETIME,q,p);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}
