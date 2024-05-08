package kabam.rotmg.account.core.control
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.framework.api.IGuard;
   
   public class IsAccountRegisteredGuard implements IGuard
   {
      
      private static const REGISTER_TO_PURCHASE:String = "In order to make purchase requests you must be a registered user.";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function IsAccountRegisteredGuard()
      {
         super();
      }
      
      public function approve() : Boolean
      {
         var isApproved:Boolean = this.account.isRegistered();
         isApproved || this.enterRegisterFlow();
         return isApproved;
      }
      
      private function enterRegisterFlow() : void
      {
         this.openDialog.dispatch(new RegisterPromptDialog(REGISTER_TO_PURCHASE));
      }
   }
}
