package kabam.rotmg.account.web.view
{
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.signals.SendPasswordReminderSignal;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebForgotPasswordMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebForgotPasswordDialog;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var failedToSend:TaskErrorSignal;

      [Inject]
      public var client:AppEngineClient;
      
      public function WebForgotPasswordMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.submit.add(this.onSubmit);
         this.view.register.add(this.onRegister);
         this.view.cancel.add(this.onCancel);
         this.failedToSend.add(this.onFailedToSend);
      }
      
      override public function destroy() : void
      {
         this.view.submit.remove(this.onSubmit);
         this.view.register.remove(this.onRegister);
         this.view.cancel.remove(this.onCancel);
         this.failedToSend.add(this.onFailedToSend);
      }
      
      private function onSubmit(email:String) : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/passwordRecovery",{
            "guid":email
         });
      }

      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.view.showComplete(data.toString());
            var timer:Timer = new Timer(1000, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
            timer.start();
         }
         else
         {
            this.view.showError(data.toString());
            this.view.enable();
            this.view.restartInput();
         }
      }

      private function onTimerComplete(evt:Event) : void
      {
         this.openDialog.dispatch(new WebLoginDialog());
      }

      private function onRegister() : void
      {
         this.openDialog.dispatch(new WebRegisterDialog());
      }
      
      private function onCancel() : void
      {
         this.openDialog.dispatch(new WebLoginDialog());
      }
      
      private function onFailedToSend(task:Task) : void
      {
         this.view.showError(task.error);
         this.view.enable();
      }
   }
}
