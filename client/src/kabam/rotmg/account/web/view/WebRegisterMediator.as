package kabam.rotmg.account.web.view
{
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.signals.RegisterSignal;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.signals.SetWorldInteractionSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebRegisterMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebRegisterDialog;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var register:RegisterSignal;
      
      [Inject]
      public var registrationError:TaskErrorSignal;
      
      [Inject]
      public var setWorldInteraction:SetWorldInteractionSignal;
      
      public function WebRegisterMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.register.add(this.onRegister);
         this.view.signIn.add(this.onSignIn);
         this.view.cancel.add(this.onCancel);
         this.registrationError.add(this.onRegistrationError);
         this.setWorldInteraction.dispatch(false);
      }
      
      override public function destroy() : void
      {
         this.view.register.remove(this.onRegister);
         this.view.signIn.remove(this.onSignIn);
         this.view.cancel.remove(this.onCancel);
         this.registrationError.remove(this.onRegistrationError);
         this.setWorldInteraction.dispatch(true);
      }
      
      private function onRegister(data:AccountData) : void
      {
         this.view.disable();
         this.register.dispatch(data);
      }
      
      private function onCancel() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function onSignIn() : void
      {
         this.openDialog.dispatch(new WebLoginDialog());
      }
      
      private function onRegistrationError(task:Task) : void
      {
         this.view.displayServerError(task.error);
         this.view.enable();
      }
   }
}
