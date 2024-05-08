package kabam.rotmg.game.view
{
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class MoneyChangerPanelMediator extends Mediator
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var view:MoneyChangerPanel;
      
      public function MoneyChangerPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.triggered.add(this.onTriggered);
      }
      
      override public function destroy() : void
      {
         this.view.triggered.remove(this.onTriggered);
      }
      
      private function onTriggered() : void
      {
      }
   }
}
