package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.options.Options;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.signals.HUDModelInitialized;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CharacterDetailsMediator extends Mediator
   {
       
      
      [Inject]
      public var view:CharacterDetailsView;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var initHUDModelSignal:HUDModelInitialized;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      public function CharacterDetailsMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.init(this.hudModel.getPlayerName(),this.hudModel.getButtonType());
         this.updateHUD.addOnce(this.onUpdateHUD);
         this.updateHUD.add(this.onDraw);
         this.nameChanged.add(this.onNameChange);
         this.view.gotoNexus.add(this.onGotoNexus);
         this.view.gotoOptions.add(this.onGotoOptions);
      }
      
      override public function destroy() : void
      {
         this.updateHUD.remove(this.onDraw);
         this.nameChanged.remove(this.onNameChange);
         this.view.gotoNexus.remove(this.onGotoNexus);
         this.view.gotoOptions.remove(this.onGotoOptions);
      }
      
      private function onGotoNexus() : void
      {
         this.hudModel.gameSprite.gsc_.escape();
      }
      
      private function onGotoOptions() : void
      {
         this.hudModel.gameSprite.mui_.clearInput();
         this.hudModel.gameSprite.forceScaledLayer.addChild(new Options(this.hudModel.gameSprite));
      }
      
      private function onUpdateHUD(player:Player) : void
      {
         this.view.update(player);
      }
      
      private function onDraw(player:Player) : void
      {
         this.view.draw(player);
      }
      
      private function onNameChange(name:String) : void
      {
         this.view.setName(name);
      }
   }
}
