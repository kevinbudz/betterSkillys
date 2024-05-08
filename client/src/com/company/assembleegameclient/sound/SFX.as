package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.media.SoundTransform;
   
   public class SFX
   {
      
      private static var sfxTrans_:SoundTransform;
       
      
      public function SFX()
      {
         super();
      }
      
      public static function load() : void
      {
         sfxTrans_ = new SoundTransform(Boolean(Parameters.data_.playSFX)?Number(1):Number(0));
      }
      
      public static function setPlaySFX(playSFX:Boolean) : void
      {
         Parameters.data_.playSFX = playSFX;
         Parameters.save();
         SoundEffectLibrary.updateTransform();
      }
   }
}
