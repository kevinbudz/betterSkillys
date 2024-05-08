package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class HealingEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var lastPart_:int;
      
      public function HealingEffect(go:GameObject)
      {
         super();
         this.go_ = go;
         this.lastPart_ = 0;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
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
         var sinceLast:int = time - this.lastPart_;
         if(sinceLast > 500)
         {
            angle = 2 * Math.PI * Math.random();
            size = (3 + int(Math.random() * 5)) * 20;
            dist = 0.3 + 0.4 * Math.random();
            part = new HealParticle(16777215,Math.random() * 0.3,size,1000,0.1 + Math.random() * 0.1,this.go_,angle,dist);
            map_.addObj(part,x_ + dist * Math.cos(angle),y_ + dist * Math.sin(angle));
            this.lastPart_ = time;
         }
         return true;
      }
   }
}
