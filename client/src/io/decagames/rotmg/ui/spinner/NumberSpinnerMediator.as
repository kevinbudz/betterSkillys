package io.decagames.rotmg.ui.spinner
{
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NumberSpinnerMediator extends Mediator
   {
       
      
      [Inject]
      public var view:NumberSpinner;
      
      public function NumberSpinnerMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.upArrow.clickSignal.add(this.onUpClicked);
         this.view.downArrow.clickSignal.add(this.onDownClicked);
      }
      
      private function onUpClicked(param1:SliceScalingButton) : void
      {
         this.view.addToValue(this.view.step);
      }
      
      private function onDownClicked(param1:SliceScalingButton) : void
      {
         this.view.addToValue(-this.view.step);
      }
      
      override public function destroy() : void
      {
         this.view.upArrow.clickSignal.remove(this.onUpClicked);
         this.view.downArrow.clickSignal.remove(this.onDownClicked);
      }
   }
}
