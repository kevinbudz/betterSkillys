package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.IGraphicsData;
   
   public class ParticleEffect extends GameObject
   {
       
      
      public function ParticleEffect()
      {
         super(null);
         objectId_ = getNextFakeObjectId();
         hasShadow_ = false;
      }
      
      public static function fromProps(effectProps:EffectProperties, go:GameObject) : ParticleEffect
      {
         if(Parameters.data_.disableAllParticles) return null;
         switch(effectProps.id)
         {
            case "Healing":
               return new HealingEffect(go);
            case "Fountain":
               return new FountainEffect(go);
            case "Gas":
               return new GasEffect(go,effectProps);
            case "Vent":
               return new VentEffect(go);
            case "Bubbles":
               return new BubbleEffect(go,effectProps);
            case "XMLEffect":
               return new XMLEffect(go,effectProps);
            case "CustomParticles":
               return ParticleGenerator.attachParticleGenerator(effectProps,go);
            default:
               trace("ERROR: unable to create effect: " + effectProps.id);
               return null;
         }
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         return false;
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
      }
   }
}
