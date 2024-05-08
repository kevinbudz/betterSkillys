package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.assembleegameclient.screens.NewCharacterScreen;
   import flash.display.Sprite;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.classes.view.CharacterSkinView;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.BuyCharacterPendingSignal;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.PurchaseCharacterSignal;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.core.signals.UpdateNewCharacterScreenSignal;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NewCharacterMediator extends Mediator
   {
       
      
      [Inject]
      public var view:NewCharacterScreen;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var showTooltip:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltips:HideTooltipsSignal;
      
      [Inject]
      public var updateNewCharacterScreen:UpdateNewCharacterScreenSignal;
      
      [Inject]
      public var buyCharacterPending:BuyCharacterPendingSignal;
      
      [Inject]
      public var purchaseCharacter:PurchaseCharacterSignal;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      public function NewCharacterMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.selected.add(this.onSelected);
         this.view.close.add(this.onClose);
         this.view.tooltip.add(this.onTooltip);
         this.updateNewCharacterScreen.add(this.onUpdate);
         this.buyCharacterPending.add(this.onBuyCharacterPending);
         this.view.initialize(this.playerModel);
      }
      
      private function onBuyCharacterPending(objectType:int) : void
      {
         this.view.updateCreditsAndFame(this.playerModel.getCredits(),this.playerModel.getFame());
      }
      
      override public function destroy() : void
      {
         this.view.selected.remove(this.onSelected);
         this.view.close.remove(this.onClose);
         this.view.tooltip.remove(this.onTooltip);
         this.buyCharacterPending.remove(this.onBuyCharacterPending);
         this.updateNewCharacterScreen.remove(this.onUpdate);
      }
      
      private function onClose() : void
      {
         this.setScreen.dispatch(new CharacterSelectionAndNewsScreen());
      }
      
      private function onSelected(objectType:int) : void
      {
         this.classesModel.getCharacterClass(objectType).setIsSelected(true);
         this.setScreen.dispatch(new CharacterSkinView());
      }
      
      private function onTooltip(sprite:Sprite) : void
      {
         if(sprite)
         {
            this.showTooltip.dispatch(sprite);
         }
         else
         {
            this.hideTooltips.dispatch();
         }
      }
      
      private function onUpdate() : void
      {
         this.view.update(this.playerModel);
      }

   }
}
