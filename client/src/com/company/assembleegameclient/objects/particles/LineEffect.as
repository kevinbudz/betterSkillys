package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.RandomUtil;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class LineEffect extends ParticleEffect
   {
       
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var color_:int;
      
      public function LineEffect(go:GameObject, end:WorldPosData, color:int)
      {
         super();
         this.start_ = new Point(go.x_,go.y_);
         this.end_ = new Point(end.x_,end.y_);
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var p:Point = null;
         var part:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var NUM:int = 30;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               NUM = 30;
               break;
            case 1:
               NUM = 15;
               break;
            case 0:
               NUM = 4;
               break;
         }
         for(var i:int = 0; i < NUM; i++)
         {
            p = Point.interpolate(this.start_,this.end_,i / NUM);
            part = new SparkParticle(100,this.color_,700,0.5,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1));
            map_.addObj(part,p.x,p.y);
         }
         return false;
      }
   }
}
