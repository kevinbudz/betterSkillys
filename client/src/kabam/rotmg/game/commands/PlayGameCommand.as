package kabam.rotmg.game.commands
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

import flash.utils.ByteArray;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.ui.noservers.NoServersDialogFactory;
import kabam.rotmg.ui.view.TitleView;

public class PlayGameCommand
   {
       
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var data:GameInitData;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var task:GetCharListTask;
      
      [Inject]
      public var monitor:TaskMonitor;

      [Inject]
      public var openDialog:OpenDialogSignal;

      [Inject]
      public var noServersDialogFactory:NoServersDialogFactory;

      [Inject]
      public var closeDialogsSignal:CloseDialogsSignal;

      public function PlayGameCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.recordCharacterUseInSharedObject();
         this.makeGameView();
      }
      
      private function recordCharacterUseInSharedObject() : void
      {
         Parameters.data_.charIdUseMap[this.data.charId] = new Date().getTime();
         Parameters.save();
      }

      private function closeDialog(_arg1:Event):void
      {
         this.setScreen.dispatch(new TitleView());
         this.closeDialogsSignal.dispatch();
      }

      private function showNoServersDialog():void
      {
         var dialog:Dialog = this.noServersDialogFactory.makeDialog();
         dialog.addEventListener(Dialog.BUTTON1_EVENT, this.closeDialog);
         this.openDialog.dispatch(dialog);
      }

      private function makeGameView() : void
      {
         if(!this.servers.isServerAvailable()){
            showNoServersDialog();
            return;
         }

         var server:Server = this.data.server || this.servers.getServer();
         var gameId:int = this.data.isNewGame ? -2 : this.data.gameId;
         var createCharacter:Boolean = this.data.createCharacter;
         var charId:int = this.data.charId;
         var keyTime:int = this.data.isNewGame? -1 : int(this.data.keyTime);
         var key:ByteArray = this.data.key;
         this.model.currentCharId = charId;
         this.setScreen.dispatch(new GameSprite(server,gameId,createCharacter,charId,keyTime,key,this.model,null));
      }
   }
}
