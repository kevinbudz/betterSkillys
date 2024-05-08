package kabam.rotmg.ui.commands
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

import kabam.rotmg.account.core.Account;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.servers.api.ServerModel;
   import kabam.rotmg.ui.noservers.NoServersDialogFactory;
   
   public class EnterGameCommand
   {
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;

      [Inject]
      public var closeDialogsSignal:CloseDialogsSignal;

      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var noServersDialogFactory:NoServersDialogFactory;

      public function EnterGameCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(!this.servers.isServerAvailable())
         {
            this.showNoServersDialog();
         }
         else
         {
            if(!this.account.isRegistered())
            {
               this.launchGame();
            }
            else
            {
               this.showCurrentCharacterScreen();
            }
         }
      }
      
      private function showCurrentCharacterScreen() : void
      {
         this.setScreenWithValidData.dispatch(new CharacterSelectionAndNewsScreen());
      }
      
      private function launchGame() : void
      {
         this.playGame.dispatch(this.makeGameInitData());
      }
      
      private function makeGameInitData() : GameInitData
      {
         var data:GameInitData = new GameInitData();
         data.createCharacter = true;
         data.charId = this.model.getNextCharId();
         data.keyTime = -1;
         data.isNewGame = true;
         return data;
      }

      private function close(_arg1:Event):void
      {
         this.closeDialogsSignal.dispatch();
      }

      private function showNoServersDialog():void
      {
         var dialog:Dialog = this.noServersDialogFactory.makeDialog();
         dialog.addEventListener(Dialog.BUTTON1_EVENT, this.close);
         this.openDialog.dispatch(dialog);
      }
   }
}
