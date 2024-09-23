package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.ReconnectEvent;
   import com.company.assembleegameclient.objects.Player;
   import kabam.rotmg.core.model.MapModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.DisconnectGameSignal;
   import kabam.rotmg.game.signals.GameClosedSignal;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.game.signals.SetWorldInteractionSignal;
import kabam.rotmg.maploading.signals.ShowLoadingViewSignal;
import kabam.rotmg.ui.signals.HUDModelInitialized;
   import kabam.rotmg.ui.signals.HUDSetupStarted;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class GameSpriteMediator extends Mediator
   {
       
      
      [Inject]
      public var view:GameSprite;
      
      [Inject]
      public var setWorldInteraction:SetWorldInteractionSignal;
      
      [Inject]
      public var invalidate:InvalidateDataSignal;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var gameClosed:GameClosedSignal;
      
      [Inject]
      public var mapModel:MapModel;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var disconnect:DisconnectGameSignal;
      
      [Inject]
      public var hudSetupStarted:HUDSetupStarted;
      
      [Inject]
      public var updateHUDSignal:UpdateHUDSignal;
      
      [Inject]
      public var hudModelInitialized:HUDModelInitialized;

      [Inject]
      public var showLoadingViewSignal:ShowLoadingViewSignal;
      
      public function GameSpriteMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.showLoadingViewSignal.dispatch();
         this.setWorldInteraction.add(this.onSetWorldInteraction);
         addViewListener(ReconnectEvent.RECONNECT,this.onReconnect);
         this.view.modelInitialized.add(this.onGameSpriteModelInitialized);
         this.view.drawCharacterWindow.add(this.onStatusPanelDraw);
         this.hudModelInitialized.add(this.onHUDModelInitialized);
         this.disconnect.add(this.onDisconnect);
         this.view.closed.add(this.onClosed);
         this.view.mapModel = this.mapModel;
         this.view.connect();
      }

      override public function destroy() : void
      {
         this.setWorldInteraction.remove(this.onSetWorldInteraction);
         removeViewListener(ReconnectEvent.RECONNECT,this.onReconnect);
         this.view.modelInitialized.remove(this.onGameSpriteModelInitialized);
         this.view.drawCharacterWindow.remove(this.onStatusPanelDraw);
         this.hudModelInitialized.remove(this.onHUDModelInitialized);
         this.disconnect.remove(this.onDisconnect);
         this.view.closed.remove(this.onClosed);
         this.view.disconnect();
      }
      
      private function onDisconnect() : void
      {
         this.view.disconnect();
      }

      public function onSetWorldInteraction(value:Boolean) : void
      {
         this.view.mui_.setEnablePlayerInput(value);
      }
      
      private function onClosed() : void
      {
         this.closeDialogs.dispatch();
         if (!this.view.isEditor) { // Don't go back to char screen if we're in editor mode
            this.gameClosed.dispatch();
         }
      }
      
      private function onReconnect(event:ReconnectEvent) : void
      {
         if(this.view.isEditor)
         {
            return;
         }
         var data:GameInitData = new GameInitData();
         data.server = event.server_;
         data.gameId = event.gameId_;
         data.createCharacter = event.createCharacter_;
         data.charId = event.charId_;
         data.keyTime = event.keyTime_;
         data.key = event.key_;
         this.playGame.dispatch(data);
      }
      
      private function onGameSpriteModelInitialized() : void
      {
         this.hudSetupStarted.dispatch(this.view);
      }
      
      private function onStatusPanelDraw(player:Player) : void
      {
         this.updateHUDSignal.dispatch(player);
      }
      
      private function onHUDModelInitialized() : void
      {
         this.view.hudModelInitialized();
      }
   }
}
