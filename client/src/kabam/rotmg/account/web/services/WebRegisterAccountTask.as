package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask
   {
       
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebRegisterAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/register",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = {};
         obj.guid = this.account.getUserId();
         obj.newGUID = this.data.username;
         obj.newPassword = this.data.password;
         obj.name = this.data.name;
         return obj;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.onRegisterDone();
         completeTask(isOK,data);
      }
      
      private function onRegisterDone() : void {
         if (this.data.name) {
            this.model.setName(this.data.name);
            this.model.isNameChosen = true;
         }
         this.account.updateUser(this.data.username, this.data.password);
      }
   }
}
