package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class XMLEffect extends ParticleEffect
   {
       
      
      private var go_:GameObject;
      
      private var partProps_:ParticleProperties;
      
      private var cooldown_:Number;
      
      private var cooldownLeft_:Number;
      
      public function XMLEffect(go:GameObject, effectProps:EffectProperties)
      {
         super();
         this.go_ = go;
         this.partProps_ = ParticleLibrary.propsLibrary_[effectProps.particle];
         this.cooldown_ = effectProps.cooldown;
         this.cooldownLeft_ = 0;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         if(this.go_.map_ == null)
         {
            return false;
         }
         var fdt:Number = dt / 1000;
         this.cooldownLeft_ = this.cooldownLeft_ - fdt;
         if(this.cooldownLeft_ >= 0)
         {
            return true;
         }
         this.cooldownLeft_ = this.cooldown_;
         map_.addObj(new XMLParticle(this.partProps_),this.go_.x_,this.go_.y_);
         return true;
      }
   }
}
