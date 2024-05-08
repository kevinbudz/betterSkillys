package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.objects.Player;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class HUDMediator extends Mediator
   {
       
      
      [Inject]
      public var view:HUDView;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      public function HUDMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.updateHUD.addOnce(this.onInitializeHUD);
         this.updateHUD.add(this.onUpdateHUD);
      }
      
      override public function destroy() : void
      {
         this.updateHUD.remove(this.onUpdateHUD);
      }
      
      private function onUpdateHUD(player:Player) : void
      {
         this.view.draw();
      }
      
      private function onInitializeHUD(player:Player) : void
      {
         this.view.setPlayerDependentAssets(this.hudModel.gameSprite);
      }
   }
}
