package io.decagames.rotmg.ui.popups.modal.buttons
{
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CancelButtonMediator extends Mediator
   {
       
      
      [Inject]
      public var closeSignal:CloseCurrentPopupSignal;
      
      [Inject]
      public var view:ClosePopupButton;
      
      public function CancelButtonMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.clickSignal.addOnce(this.onCancelHandler);
      }
      
      override public function destroy() : void
      {
         this.view.clickSignal.remove(this.onCancelHandler);
      }
      
      private function onCancelHandler(param1:BaseButton) : void
      {
         this.closeSignal.dispatch();
      }
   }
}
