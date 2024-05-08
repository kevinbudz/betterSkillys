package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.FreeList;
   
   public class BubbleEffect extends ParticleEffect
   {
      
      private static const PERIOD_MAX:Number = 400;
       
      
      private var poolID:String;
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public var rate_:Number;
      
      private var fxProps:EffectProperties;
      
      public function BubbleEffect(go:GameObject, props:EffectProperties)
      {
         super();
         this.go_ = go;
         this.fxProps = props;
         this.rate_ = (1 - props.rate) * PERIOD_MAX + 1;
         this.poolID = "BubbleEffect_" + Math.random();
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var start:int = 0;
         var t:int = 0;
         var angle:Number = NaN;
         var d:Number = NaN;
         var part:BubbleParticle = null;
         var x:Number = NaN;
         var y:Number = NaN;
         if(this.go_.map_ == null)
         {
            return false;
         }
         if(!this.lastUpdate_)
         {
            this.lastUpdate_ = time;
            return true;
         }
         start = int(this.lastUpdate_ / this.rate_);
         var end:int = int(time / this.rate_);
         var posX:Number = this.go_.x_;
         var posY:Number = this.go_.y_;
         if(this.lastUpdate_ < 0)
         {
            this.lastUpdate_ = Math.max(0,time - PERIOD_MAX);
         }
         x_ = posX;
         y_ = posY;
         for(var i:int = start; i < end; i++)
         {
            t = i * this.rate_;
            part = BubbleParticle.create(this.poolID,this.fxProps.color,this.fxProps.speed,this.fxProps.life,this.fxProps.lifeVariance,this.fxProps.speedVariance,this.fxProps.spread);
            part.restart(t,time);
            angle = Math.random() * Math.PI;
            d = Math.random() * 0.4;
            x = posX + d * Math.cos(angle);
            y = posY + d * Math.sin(angle);
            map_.addObj(part,x,y);
         }
         this.lastUpdate_ = time;
         return true;
      }
      
      override public function removeFromMap() : void
      {
         super.removeFromMap();
         FreeList.dump(this.poolID);
      }
   }
}
