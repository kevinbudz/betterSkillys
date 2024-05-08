package kabam.rotmg.ui.view
{
   import flash.display.Sprite;
   import kabam.rotmg.ui.view.components.PotionSlotView;
   
   public class PotionInventoryView extends Sprite
   {
      
      private static const LEFT_BUTTON_CUTS:Array = [1,0,0,1];
      
      private static const RIGHT_BUTTON_CUTS:Array = [0,1,1,0];
      
      private static const BUTTON_SPACE:int = 4;
       
      
      private const cuts:Array = [LEFT_BUTTON_CUTS,RIGHT_BUTTON_CUTS];
      
      public function PotionInventoryView()
      {
         var psv:PotionSlotView = null;
         super();
         for(var i:int = 0; i < 2; i++)
         {
            psv = new PotionSlotView(this.cuts[i],i);
            psv.x = i * (PotionSlotView.BUTTON_WIDTH + BUTTON_SPACE);
            addChild(psv);
         }
      }
   }
}
