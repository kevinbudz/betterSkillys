package com.company.assembleegameclient.objects.particles
{
   import flash.geom.Point;
   
   public class AOEEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var novaRadius_:Number;
      
      public var color_:int;
      
      public function AOEEffect(start:Point, radius:Number, color:int)
      {
         super();
         this.start_ = start;
         this.novaRadius_ = radius;
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
         var LIFETIME:int = 200;
         var numPoints:int = 4 + this.novaRadius_ * 2;
         for(var i:int = 0; i < numPoints; i++)
         {
            angle = i * 2 * Math.PI / numPoints;
            p = new Point(this.start_.x + this.novaRadius_ * Math.cos(angle),this.start_.y + this.novaRadius_ * Math.sin(angle));
            part = new SparkerParticle(SIZE,this.color_,LIFETIME,this.start_,p);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}
