package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.RandomUtil;
   
   public class GasEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var props:EffectProperties;
      
      public var color_:int;
      
      public var rate:Number;
      
      public var type:String;
      
      public function GasEffect(go:GameObject, props:EffectProperties)
      {
         super();
         this.go_ = go;
         this.color_ = props.color;
         this.rate = props.rate;
         this.props = props;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var size:Number = NaN;
         var r:Number = NaN;
         var speedX:Number = NaN;
         var speedY:Number = NaN;
         var life:Number = NaN;
         var p:GasParticle = null;
         if(this.go_.map_ == null)
         {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var num:int = 20;
         for(var i:int = 0; i < this.rate; i++)
         {
            size = (Math.random() + 0.3) * 200;
            r = Math.random();
            speedX = RandomUtil.plusMinus(this.props.speed - this.props.speed * (r * (1 - this.props.speedVariance)));
            speedY = RandomUtil.plusMinus(this.props.speed - this.props.speed * (r * (1 - this.props.speedVariance)));
            life = this.props.life * 1000 - this.props.life * 1000 * (r * this.props.lifeVariance);
            p = new GasParticle(size,this.color_,life,this.props.spread,0.75,speedX,speedY);
            map_.addObj(p,x_,y_);
         }
         return true;
      }
   }
}
