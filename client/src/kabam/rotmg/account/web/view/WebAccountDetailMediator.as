package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebAccountDetailMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebAccountDetailDialog;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      public function WebAccountDetailMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.setUserInfo(this.account.getUserName());
         this.view.change.add(this.onChange);
         this.view.logout.add(this.onLogout);
         this.view.cancel.add(this.onDone);
      }
      
      override public function destroy() : void
      {
         this.view.change.remove(this.onChange);
         this.view.logout.remove(this.onLogout);
         this.view.cancel.remove(this.onDone);
      }
      
      private function onChange() : void
      {
         this.openDialog.dispatch(new WebChangePasswordDialog());
      }
      
      private function onLogout() : void
      {
         this.account.clear();
         this.openDialog.dispatch(new WebLoginDialog());
      }
      
      private function onDone() : void
      {
         this.closeDialog.dispatch();
      }
   }
}
