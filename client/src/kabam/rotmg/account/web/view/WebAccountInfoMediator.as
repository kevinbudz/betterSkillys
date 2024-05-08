package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.LogoutSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebAccountInfoMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebAccountInfoView;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logout:LogoutSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function WebAccountInfoMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.login.add(this.onLoginToggle);
         this.view.register.add(this.onRegister);
      }
      
      override public function destroy() : void
      {
         this.view.login.remove(this.onLoginToggle);
         this.view.register.remove(this.onRegister);
      }
      
      private function onRegister() : void
      {
         this.openDialog.dispatch(new WebRegisterDialog());
      }
      
      private function onLoginToggle() : void
      {
         if(this.account.isRegistered())
         {
            this.onLogOut();
         }
         else
         {
            this.openDialog.dispatch(new WebLoginDialog());
         }
      }
      
      private function onLogOut() : void
      {
         this.logout.dispatch();
         this.view.setInfo("",false);
      }
   }
}
