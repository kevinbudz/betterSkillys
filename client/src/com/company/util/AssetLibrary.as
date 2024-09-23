package com.company.util
{
   import flash.display.BitmapData;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   
   public class AssetLibrary
   {
      
      public static var images_:Dictionary = new Dictionary();
      
      public static var imageSets_:Dictionary = new Dictionary();
      
      public static var sounds_:Dictionary = new Dictionary();
      
      public static var imageLookup_:Dictionary = new Dictionary();
       
      
      public function AssetLibrary(se:StaticEnforcer)
      {
         super();
      }
      
      public static function addImage(name:String, data:BitmapData) : void
      {
         images_[name] = data;
         imageLookup_[data] = name;
      }
      
      public static function addImageSet(name:String, data:BitmapData, width:int, height:int) : void
      {
         images_[name] = data;
         var imageSet:ImageSet = new ImageSet();
         imageSet.addFromBitmapData(data,width,height);
         imageSets_[name] = imageSet;
         for(var i:int = 0; i < imageSet.images_.length; i++)
         {
            imageLookup_[imageSet.images_[i]] = [name,i];
         }
      }
      
      public static function addToImageSet(name:String, data:BitmapData) : void
      {
         var imageSet:ImageSet = imageSets_[name];
         if(imageSet == null)
         {
            imageSet = new ImageSet();
            imageSets_[name] = imageSet;
         }
         imageSet.add(data);
         var i:int = imageSet.images_.length - 1;
         imageLookup_[imageSet.images_[i]] = [name,i];
      }
      
      public static function addSound(name:String, soundClass:Class) : void
      {
         var a:Array = sounds_[name];
         if(a == null)
         {
            sounds_[name] = new Array();
         }
         sounds_[name].push(soundClass);
      }
      
      public static function lookupImage(data:BitmapData) : Object
      {
         return imageLookup_[data];
      }
      
      public static function getImage(name:String) : BitmapData
      {
         return images_[name];
      }
      
      public static function getImageSet(name:String) : ImageSet
      {
         return imageSets_[name];
      }
      
      public static function getImageFromSet(name:String, id:int) : BitmapData
      {
         var imageSet:ImageSet = imageSets_[name];
         return imageSet.images_[id];
      }
      
      public static function getSound(name:String) : Sound
      {
         var a:Array = sounds_[name];
         var i:int = Math.random() * a.length;
         return new sounds_[name][i]();
      }
      
      public static function playSound(name:String, volume:Number = 1.0) : void
      {
         var a:Array = sounds_[name];
         var i:int = Math.random() * a.length;
         var sound:Sound = new sounds_[name][i]();
         var trans:SoundTransform = null;
         if(volume != 1)
         {
            trans = new SoundTransform(volume);
         }
         sound.play(0,0,trans);
      }
   }
}

class StaticEnforcer
{
    
   
   function StaticEnforcer()
   {
      super();
   }
}
