package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.RandomUtil;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class LightningEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var color_:int;
      
      public var particleSize_:int;
      
      public function LightningEffect(go:GameObject, end:WorldPosData, color:int, particleSize:int)
      {
         super();
         this.start_ = new Point(go.x_,go.y_);
         this.end_ = new Point(end.x_,end.y_);
         this.color_ = color;
         this.particleSize_ = particleSize;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var p:Point = null;
         var part:Particle = null;
         var factor:Number = NaN;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var distance:Number = Point.distance(this.start_,this.end_);
         var num:int = distance * 3;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               num = distance * 3;
               break;
            case 1:
               num = distance * 2;
               break;
            case 0:
               num = 3 + distance;
               break;
         }
         for(var i:int = 0; i < num; i++)
         {
            p = Point.interpolate(this.start_,this.end_,i / num);
            part = new SparkParticle(this.particleSize_,this.color_,1000 - i / num * 900,0.5,0,0);
            factor = Math.min(i,num - i);
            map_.addObj(part,p.x + RandomUtil.plusMinus(distance / 200 * factor),p.y + RandomUtil.plusMinus(distance / 200 * factor));
         }
         return false;
      }
   }
}
