package kabam.rotmg.ui
{
   import flash.display.Sprite;
   
   public class UIUtils
   {
      
      private static const NOTIFICATION_BACKGROUND_WIDTH:Number = 95;
      
      private static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;
      
      private static const NOTIFICATION_BACKGROUND_ALPHA:Number = 0.4;
      
      private static const NOTIFICATION_BACKGROUND_COLOR:Number = 0;
      
      public static const NOTIFICATION_SPACE:uint = 28;
       
      
      public function UIUtils()
      {
         super();
      }
      
      public static function returnHudNotificationBackground() : Sprite
      {
         var background:Sprite = new Sprite();
         background.graphics.beginFill(NOTIFICATION_BACKGROUND_COLOR,NOTIFICATION_BACKGROUND_ALPHA);
         background.graphics.drawRoundRect(0,0,NOTIFICATION_BACKGROUND_WIDTH,NOTIFICATION_BACKGROUND_HEIGHT,12,12);
         background.graphics.endFill();
         return background;
      }
   }
}
