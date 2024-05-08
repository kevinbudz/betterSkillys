package com.company.assembleegameclient.objects.particles
{
   public class EffectProperties
   {
       
      
      public var id:String;
      
      public var particle:String;
      
      public var cooldown:Number;
      
      public var color:uint;
      
      public var rate:Number;
      
      public var speed:Number;
      
      public var speedVariance:Number;
      
      public var spread:Number;
      
      public var life:Number;
      
      public var lifeVariance:Number;
      
      public var size:int;
      
      public var friction:Number;
      
      public var rise:Number;
      
      public var riseVariance:Number;
      
      public var riseAcc:Number;
      
      public var rangeX:int;
      
      public var rangeY:int;
      
      public var zOffset:Number;
      
      public var bitmapFile:String;
      
      public var bitmapIndex:uint;
      
      public function EffectProperties(effectXML:XML)
      {
         super();
         this.id = effectXML.toString();
         this.particle = effectXML.@particle;
         this.cooldown = effectXML.@cooldown;
         this.color = effectXML.@color;
         this.rate = Number(effectXML.@rate) || Number(5);
         this.speed = Number(effectXML.@speed) || Number(0);
         this.speedVariance = Number(effectXML.@speedVariance) || Number(0.5);
         this.spread = Number(effectXML.@spread) || Number(0);
         this.life = Number(effectXML.@life) || Number(1);
         this.lifeVariance = Number(effectXML.@lifeVariance) || Number(0);
         this.size = int(effectXML.@size) || int(3);
         this.rise = Number(effectXML.@rise) || Number(3);
         this.riseVariance = Number(effectXML.@riseVariance) || Number(0);
         this.riseAcc = Number(effectXML.@riseAcc) || Number(0);
         this.rangeX = int(effectXML.@rangeX) || int(0);
         this.rangeY = int(effectXML.@rangeY) || int(0);
         this.zOffset = Number(effectXML.@zOffset) || Number(0);
         this.bitmapFile = effectXML.@bitmapFile;
         this.bitmapIndex = effectXML.@bitmapIndex;
      }
   }
}
