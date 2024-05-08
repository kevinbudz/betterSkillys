package kabam.rotmg.ui
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import kabam.rotmg.game.model.AddTextLineVO;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PlayerGroupMenuMediator extends Mediator
   {
       
      
      [Inject]
      public var view:PlayerGroupMenu;
      
      [Inject]
      private var addTextLine:AddTextLineSignal;
      
      public function PlayerGroupMenuMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.unableToTeleport.add(this.onUnableToTeleport);
      }
      
      override public function destroy() : void
      {
         this.view.unableToTeleport.remove(this.onUnableToTeleport);
      }
      
      private function onUnableToTeleport() : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"No players are eligible for teleporting"));
      }
   }
}
