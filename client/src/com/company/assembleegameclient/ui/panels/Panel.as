package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import flash.display.Sprite;
   
   public class Panel extends Sprite
   {
      
      public static const WIDTH:int = 200 - 12;
      
      public static const HEIGHT:int = 100 - 16;
       
      
      public var gs_:GameSprite;
      
      public function Panel(gs:GameSprite)
      {
         super();
         this.gs_ = gs;
      }
      
      public function draw() : void
      {
      }
   }
}
