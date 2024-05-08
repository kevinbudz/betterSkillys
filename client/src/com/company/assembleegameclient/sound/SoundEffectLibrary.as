package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class SoundEffectLibrary
   {
      
      private static var urlBase:String;
      
      private static const URL_PATTERN:String = "{URLBASE}/sfx/{NAME}.mp3";
      
      public static var nameMap_:Dictionary = new Dictionary();
      
      private static var activeSfxList_:Dictionary = new Dictionary(true);
       
      
      public function SoundEffectLibrary()
      {
         super();
      }
      
      public static function load(name:String) : Sound
      {
         return nameMap_[name] = nameMap_[name] || makeSound(name);
      }
      
      public static function makeSound(name:String) : Sound
      {
         var sound:Sound = new Sound();
         sound.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         sound.load(makeSoundRequest(name));
         return sound;
      }
      
      private static function getUrlBase() : String
      {
         var setup:ApplicationSetup = null;
         var base:String = "";
         try
         {
            setup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
            base = setup.getAppEngineUrl();
         }
         catch(error:Error)
         {
            base = "localhost";
         }
         return base;
      }
      
      private static function makeSoundRequest(name:String) : URLRequest
      {
         urlBase = urlBase || getUrlBase();
         var url:String = URL_PATTERN.replace("{URLBASE}",urlBase).replace("{NAME}",name);
         return new URLRequest(url);
      }
      
      public static function play(name:String, volume:Number = 1.0, isFX:Boolean = true) : void
      {
         var playFX:Boolean = Parameters.data_.playSFX && isFX || !isFX && Parameters.data_.playPewPew;
         if (!playFX) {
            return;
         }

         var actualVolume:Number = NaN;
         var trans:SoundTransform = null;
         var channel:SoundChannel = null;
         var sound:Sound = load(name);
         try
         {
            actualVolume = Number(volume);
            trans = new SoundTransform(actualVolume);
            channel = sound.play(0,0,trans);
            channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete,false,0,true);
            activeSfxList_[channel] = volume;
         }
         catch(error:Error)
         {
            trace("ERROR playing " + name + ": " + error.message);
         }
      }
      
      private static function onSoundComplete(e:Event) : void
      {
         var channel:SoundChannel = e.target as SoundChannel;
         delete activeSfxList_[channel];
      }
      
      public static function updateTransform() : void
      {
         var channel:SoundChannel = null;
         var transform:SoundTransform = null;
         for each(channel in activeSfxList_)
         {
            transform = channel.soundTransform;
            transform.volume = Boolean(Parameters.data_.playSFX)?Number(activeSfxList_[channel]):Number(0);
            channel.soundTransform = transform;
         }
      }
      
      public static function onIOError(event:IOErrorEvent) : void
      {
         trace("ERROR loading sound: " + event.text);
      }
   }
}
