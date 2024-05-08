package kabam.rotmg.util.graphics
{
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   
   public class ButtonLayoutHelper
   {
       
      
      public function ButtonLayoutHelper()
      {
         super();
      }
      
      public function layout(width:int, ... buttons) : void
      {
         var count:int = buttons.length;
         switch(count)
         {
            case 1:
               this.centerButton(width,buttons[0]);
               break;
            case 2:
               this.twoButtons(width,buttons[0],buttons[1]);
               break;
            default:
               throw new IllegalOperationError("Currently unable to layout more than 2 buttons");
         }
      }
      
      private function centerButton(width:int, button:DisplayObject) : void
      {
         button.x = (width - button.width) * 0.5;
      }
      
      private function twoButtons(width:int, left:DisplayObject, right:DisplayObject) : void
      {
         left.x = (width - 2 * left.width) * 0.25;
         right.x = (3 * width - 2 * right.width) * 0.25;
      }
   }
}
