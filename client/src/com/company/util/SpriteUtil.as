package com.company.util
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class SpriteUtil
   {
       
      
      public function SpriteUtil()
      {
         super();
      }
      
      public static function safeAddChild(sprite:DisplayObjectContainer, displayObject:DisplayObject) : void
      {
         if(sprite != null && displayObject != null && !sprite.contains(displayObject))
         {
            sprite.addChild(displayObject);
         }
      }
      
      public static function safeRemoveChild(sprite:DisplayObjectContainer, displayObject:DisplayObject) : void
      {
         if(sprite != null && displayObject != null && sprite.contains(displayObject))
         {
            sprite.removeChild(displayObject);
         }
      }
   }
}
