package kabam.rotmg.account.web.view
{
   import com.company.ui.SimpleText;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   
   public class FormField extends Sprite
   {
      
      protected static const BACKGROUND_COLOR:uint = 3355443;
      
      protected static const ERROR_BORDER_COLOR:uint = 16549442;
      
      protected static const NORMAL_BORDER_COLOR:uint = 4539717;
      
      protected static const TEXT_COLOR:uint = 11776947;
       
      
      public function FormField()
      {
         super();
      }
      
      public function getHeight() : Number
      {
         return 0;
      }
      
      protected function drawSimpleTextBackground(simpleText:SimpleText, hPadding:int, vPadding:int, hasError:Boolean) : void
      {
         var borderColor:uint = !!hasError?uint(ERROR_BORDER_COLOR):uint(NORMAL_BORDER_COLOR);
         graphics.lineStyle(2,borderColor,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         graphics.beginFill(BACKGROUND_COLOR,1);
         graphics.drawRect(simpleText.x - hPadding - 5,simpleText.y - vPadding,simpleText.width + hPadding * 2,simpleText.height + vPadding * 2);
         graphics.endFill();
         graphics.lineStyle();
      }
   }
}
