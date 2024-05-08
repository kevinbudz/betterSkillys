package com.company.assembleegameclient.objects.particles
{
import avmplus.parameterXml;

import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

public class HealEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var color_:uint;
      
      public function HealEffect(go:GameObject, color:uint)
      {
         super();
         this.go_ = go;
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         if(Parameters.data_.disableAllParticles) return false;
         var angle:Number = NaN;
         var size:int = 0;
         var dist:Number = NaN;
         var part:HealParticle = null;
         if(this.go_.map_ == null)
         {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var num:int = 10;
         switch(Parameters.data_.reduceParticles) {
            case 2:
               num = 10;
                 break;
            case 1:
               num = 5;
                 break;
            case 0:
               num = 1;
                 break;
         }
         for(var i:int = 0; i < num; i++)
         {
            angle = 2 * Math.PI * (i / num);
            size = (3 + int(Math.random() * 5)) * 20;
            dist = 0.3 + 0.4 * Math.random();
            part = new HealParticle(this.color_,Math.random() * 0.3,size,1000,0.1 + Math.random() * 0.1,this.go_,angle,dist);
            map_.addObj(part,x_ + dist * Math.cos(angle),y_ + dist * Math.sin(angle));
         }
         return false;
      }
   }
}
