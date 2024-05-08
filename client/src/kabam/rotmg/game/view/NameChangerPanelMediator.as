package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.account.ui.ChooseNameFrame;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NameChangerPanelMediator extends Mediator
   {
      
      private static const TEXT:String = "In order to choose an account name, you must be registered";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var view:NameChangerPanel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      public function NameChangerPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.chooseName.add(this.onChooseName);
         this.nameChanged.add(this.onNameChanged);
      }
      
      override public function destroy() : void
      {
         this.view.chooseName.remove(this.onChooseName);
         this.nameChanged.remove(this.onNameChanged);
      }
      
      private function onChooseName() : void
      {
         if(this.account.isRegistered())
         {
            this.openDialog.dispatch(new ChooseNameFrame(this.view.gs_,this.view.buy_));
         }
         else
         {
            this.openDialog.dispatch(new RegisterPromptDialog(TEXT));
         }
      }
      
      private function onNameChanged(name:String) : void
      {
         this.view.updateName(name);
      }
   }
}
