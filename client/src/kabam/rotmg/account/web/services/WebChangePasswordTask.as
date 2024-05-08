package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.ChangePasswordTask;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebChangePasswordTask extends BaseTask implements ChangePasswordTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var data:ChangePasswordData;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebChangePasswordTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/changePassword",this.makeDataPacket());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.onChangeDone();
         completeTask(isOK,data);
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = {};
         obj.guid = this.account.getUserId();
         obj.password = this.data.currentPassword;
         obj.newPassword = this.data.newPassword;
         return obj;
      }
      
      private function onChangeDone() : void
      {
         this.account.updateUser(this.account.getUserId(),this.data.newPassword);
         completeTask(true);
      }
   }
}
