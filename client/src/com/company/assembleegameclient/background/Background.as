package com.company.assembleegameclient.background
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.Sprite;
   
   public class Background extends Sprite
   {
      
      public static const NO_BACKGROUND:int = 0;
      
      public static const STAR_BACKGROUND:int = 1;
      
      public static const NEXUS_BACKGROUND:int = 2;
      
      public static const NUM_BACKGROUND:int = 3;
       
      
      public function Background()
      {
         super();
      }
      
      public static function getBackground(type:int) : Background
      {
         switch(type)
         {
            case NO_BACKGROUND:
               return null;
            case STAR_BACKGROUND:
               return new StarBackground();
            case NEXUS_BACKGROUND:
               return new NexusBackground();
            default:
               return null;
         }
      }
      
      public function draw(camera:Camera, time:int) : void
      {
      }
   }
}
