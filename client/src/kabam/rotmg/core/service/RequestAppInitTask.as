package kabam.rotmg.core.service
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.signals.AppInitDataReceivedSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class RequestAppInitTask extends BaseTask
   {
       
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var appInitConfigData:AppInitDataReceivedSignal;
      
      public function RequestAppInitTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/app/init", null);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.appInitConfigData.dispatch(XML(data));
         completeTask(isOK,data);
      }
   }
}
