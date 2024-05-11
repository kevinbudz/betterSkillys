package com.company.assembleegameclient.objects
{
import com.company.assembleegameclient.sound.SoundEffectLibrary;

public class Character extends GameObject
{


   public var hurtSound_:String;

   public var deathSound_:String;

   public function Character(objectXML:XML)
   {
      super(objectXML);
      this.hurtSound_ = Boolean(objectXML.hasOwnProperty("HitSound"))?String(objectXML.HitSound):"monster/default_hit";
      SoundEffectLibrary.load(this.hurtSound_);
      this.deathSound_ = Boolean(objectXML.hasOwnProperty("DeathSound"))?String(objectXML.DeathSound):"monster/default_death";
      SoundEffectLibrary.load(this.deathSound_);
   }

   public static function green2redu(param1:uint) : uint
   {
      if(param1 > 50)
      {
         return 0xFF00 + 0x50000 * (100 - param1);
      }
      return 0xFFFF00 - 0x500 * (50 - param1);
   }
   override public function damage(damageAmount:int, effects:Vector.<uint>, kill:Boolean, proj:Projectile, armorPierce:Boolean = false):void
   {
      super.damage(damageAmount, effects, kill, proj, armorPierce);
      if(dead_)
      {
         SoundEffectLibrary.play(this.deathSound_);
      }
      else
      {
         SoundEffectLibrary.play(this.hurtSound_);
      }
   }
}
}
