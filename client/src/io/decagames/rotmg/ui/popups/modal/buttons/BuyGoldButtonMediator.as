package io.decagames.rotmg.ui.popups.modal.buttons
{
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class BuyGoldButtonMediator extends Mediator
   {
       
      
      [Inject]
      public var closeSignal:CloseCurrentPopupSignal;
      
      [Inject]
      public var view:BuyGoldButton;
      
      public function BuyGoldButtonMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.clickSignal.addOnce(this.buyGoldHandler);
      }
      
      override public function destroy() : void
      {
         this.view.clickSignal.remove(this.buyGoldHandler);
      }
      
      private function buyGoldHandler(param1:BaseButton) : void
      {
         this.closeSignal.dispatch();
      }
   }
}
