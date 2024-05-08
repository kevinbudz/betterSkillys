package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.services.SendPasswordReminderTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebSendPasswordReminderTask extends BaseTask implements SendPasswordReminderTask
   {
       
      
      [Inject]
      public var email:String;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebSendPasswordReminderTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/forgotPassword",{"guid":this.email});
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onForgotDone();
         }
         else
         {
            this.onForgotError(data);
         }
      }
      
      private function onForgotDone() : void
      {
         completeTask(true);
      }
      
      private function onForgotError(error:String) : void
      {
         completeTask(false,error);
      }
   }
}
