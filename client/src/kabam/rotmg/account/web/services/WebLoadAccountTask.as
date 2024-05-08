package kabam.rotmg.account.web.services
{
   import com.company.assembleegameclient.util.GUID;
   import flash.net.SharedObject;
   import kabam.lib.tasks.BaseTask;
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LoadAccountTask;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebLoadAccountTask extends BaseTask implements LoadAccountTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      private var data:AccountData;
      
      public function WebLoadAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.getAccountData();
         if(this.data.username)
         {
            this.runLoginTaskThenComplete();
         }
         else
         {
            this.setGuestPasswordAndComplete();
         }
      }
      
      private function getAccountData() : void
      {
         var rotmg:SharedObject = null;
         this.data = new AccountData();
         try
         {
            rotmg = SharedObject.getLocal("OSRotMG","/");
            rotmg.data["GUID"] && (this.data.username = rotmg.data["GUID"]);
            rotmg.data["Password"] && (this.data.password = rotmg.data["Password"]);
            if (rotmg.data.hasOwnProperty("Name")){
               this.data.name = rotmg.data["Name"];
            }
         }
         catch(error:Error)
         {
            data.username = null;
            data.password = null;
         }
      }
      
      private function runLoginTaskThenComplete() : void
      {
         var login:WebLoginTask = new WebLoginTask();
         login.account = this.account;
         login.client = this.client;
         login.data = this.data;
         login.finished.addOnce(this.onLoginVerified);
         login.start();
      }
      
      private function onLoginVerified(task:Task, isOK:Boolean, error:String = "") : void
      {
         completeTask(true);
      }
      
      private function setGuestPasswordAndComplete() : void
      {
         this.account.updateUser(GUID.create(),null);
         completeTask(true);
      }
   }
}
