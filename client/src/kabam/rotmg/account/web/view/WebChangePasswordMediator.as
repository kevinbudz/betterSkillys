package kabam.rotmg.account.web.view
{
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import kabam.rotmg.account.web.signals.WebChangePasswordSignal;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebChangePasswordMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebChangePasswordDialog;
      
      [Inject]
      public var change:WebChangePasswordSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      public function WebChangePasswordMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.change.add(this.onChange);
         this.view.cancel.add(this.onCancel);
         this.loginError.add(this.onError);
      }
      
      override public function destroy() : void
      {
         this.view.change.remove(this.onChange);
         this.view.cancel.remove(this.onCancel);
         this.loginError.remove(this.onError);
      }
      
      private function onCancel() : void
      {
         this.openDialog.dispatch(new WebAccountDetailDialog());
      }
      
      private function onChange() : void
      {
         var data:ChangePasswordData = null;
         if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified())
         {
            this.view.disable();
            data = new ChangePasswordData();
            data.currentPassword = this.view.password_.text();
            data.newPassword = this.view.newPassword_.text();
            this.change.dispatch(data);
         }
      }
      
      private function isCurrentPasswordValid() : Boolean
      {
         var isValid:Boolean = this.view.password_.text().length >= 5;
         if(!isValid)
         {
            this.view.password_.setError("Incorrect password");
         }
         return isValid;
      }
      
      private function isNewPasswordValid() : Boolean
      {
         var isValid:Boolean = this.view.newPassword_.text().length >= 5;
         if(!isValid)
         {
            this.view.newPassword_.setError("New password too short");
         }
         return isValid;
      }
      
      private function isNewPasswordVerified() : Boolean
      {
         var isValid:Boolean = this.view.newPassword_.text() == this.view.retypeNewPassword_.text();
         if(!isValid)
         {
            this.view.retypeNewPassword_.setError("Password does not match");
         }
         return isValid;
      }
      
      private function onError(task:Task) : void
      {
         this.view.setError(task.error);
         this.view.enable();
      }
   }
}
