package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class ParticleGenerator extends ParticleEffect
   {
       
      
      private var particlePool:Vector.<BaseParticle>;
      
      private var liveParticles:Vector.<BaseParticle>;
      
      private var targetGO:GameObject;
      
      private var generatedParticles:Number = 0;
      
      private var totalTime:Number = 0;
      
      private var effectProps:EffectProperties;
      
      private var bitmapData:BitmapData;
      
      private var friction:Number;
      
      public function ParticleGenerator(effectProperties:EffectProperties, go:GameObject)
      {
         super();
         this.targetGO = go;
         this.particlePool = new Vector.<BaseParticle>();
         this.liveParticles = new Vector.<BaseParticle>();
         this.effectProps = effectProperties;
         if(this.effectProps.bitmapFile)
         {
            this.bitmapData = AssetLibrary.getImageFromSet(this.effectProps.bitmapFile,this.effectProps.bitmapIndex);
            this.bitmapData = TextureRedrawer.redraw(this.bitmapData,this.effectProps.size,true,0);
         }
         else
         {
            this.bitmapData = TextureRedrawer.redrawSolidSquare(this.effectProps.color,this.effectProps.size);
         }
      }
      
      public static function attachParticleGenerator(effectProperties:EffectProperties, go:GameObject) : ParticleGenerator
      {
         return new ParticleGenerator(effectProperties,go);
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var tDelta:Number = NaN;
         var newParticle:BaseParticle = null;
         var particle:BaseParticle = null;
         var t:Number = time / 1000;
         tDelta = dt / 1000;
         if(this.targetGO.map_ == null)
         {
            return false;
         }
         x_ = this.targetGO.x_;
         y_ = this.targetGO.y_;
         z_ = this.targetGO.z_ + this.effectProps.zOffset;
         this.totalTime = this.totalTime + tDelta;
         var projectedTotal:Number = this.effectProps.rate * this.totalTime;
         var particlesToGen:int = projectedTotal - this.generatedParticles;
         for(var i:int = 0; i < particlesToGen; i++)
         {
            if(this.particlePool.length)
            {
               newParticle = this.particlePool.pop();
            }
            else
            {
               newParticle = new BaseParticle(this.bitmapData);
            }
            newParticle.initialize(this.effectProps.life + this.effectProps.lifeVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.rise + this.effectProps.riseVariance * (2 * Math.random() - 1),z_);
            map_.addObj(newParticle,x_ + this.effectProps.rangeX * (2 * Math.random() - 1),y_ + this.effectProps.rangeY * (2 * Math.random() - 1));
            this.liveParticles.push(newParticle);
         }
         this.generatedParticles = this.generatedParticles + particlesToGen;
         for(var j:int = 0; j < this.liveParticles.length; j++)
         {
            particle = this.liveParticles[j];
            particle.timeLeft = particle.timeLeft - tDelta;
            if(particle.timeLeft <= 0)
            {
               this.liveParticles.splice(j,1);
               map_.removeObj(particle.objectId_);
               j--;
               this.particlePool.push(particle);
            }
            else
            {
               particle.spdZ = particle.spdZ + this.effectProps.riseAcc * tDelta;
               particle.x_ = particle.x_ + particle.spdX * tDelta;
               particle.y_ = particle.y_ + particle.spdY * tDelta;
               particle.z_ = particle.z_ + particle.spdZ * tDelta;
            }
         }
         return true;
      }
      
      override public function removeFromMap() : void
      {
         var particle:BaseParticle = null;
         for each(particle in this.liveParticles)
         {
            map_.removeObj(particle.objectId_);
         }
         this.liveParticles = null;
         this.particlePool = null;
         super.removeFromMap();
      }
   }
}
