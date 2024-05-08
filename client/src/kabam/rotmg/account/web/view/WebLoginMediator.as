package kabam.rotmg.account.web.view
{
import com.company.assembleegameclient.parameters.Parameters;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.signals.LoginSignal;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebLoginMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebLoginDialog;
      
      [Inject]
      public var login:LoginSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      public function WebLoginMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.signIn.add(this.onSignIn);
         this.view.register.add(this.onRegister);
         this.view.cancel.add(this.onCancel);
         this.view.forgot.add(this.onForgot);
         this.loginError.add(this.onLoginError);
      }
      
      override public function destroy() : void
      {
         this.view.signIn.remove(this.onSignIn);
         this.view.register.remove(this.onRegister);
         this.view.cancel.remove(this.onCancel);
         this.view.forgot.remove(this.onForgot);
         this.loginError.remove(this.onLoginError);
      }
      
      private function onSignIn(data:AccountData) : void
      {
         this.view.disable();
         this.login.dispatch(data);
      }
      
      private function onRegister() : void
      {
         this.openDialog.dispatch(new WebRegisterDialog());

//         if(Parameters.TESTING_SERVER){
//            this.openDialog.dispatch(new WebRegisterDialog());
//         }
//         else{
//            navigateToURL(new URLRequest("https://tkr.gg/register"),"_blank");
//         }
      }
      
      private function onCancel() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function onForgot() : void
      {
         this.openDialog.dispatch(new WebForgotPasswordDialog());
      }
      
      private function onLoginError(task:Task) : void
      {
         this.view.setError(task.error);
         this.view.enable();
      }
   }
}
