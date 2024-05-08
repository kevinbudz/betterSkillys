package kabam.rotmg.account.core.services
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.MoreObjectUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.CharListDataSignal;
import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetLoadingMessageSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetCharListTask extends BaseTask
   {
      
      private static const ONE_SECOND_IN_MS:int = 1000;
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var setLoadingMessage:SetLoadingMessageSignal;
      
      [Inject]
      public var charListData:CharListDataSignal;
      
      [Inject]
      public var logger:ILogger;
      
      private var requestData:Object;
      
      private var retryTimer:Timer;
      
      public function GetCharListTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.info("GetUserDataTask start");
         this.requestData = this.makeRequestData();
         this.sendRequest();
      }
      
      private function sendRequest() : void
      {
         this.client.setSendEncrypted(true);
         this.client.complete.addOnce(this.onComplete);
//         this.client.sendRequest(Parameters.LOCAL_HOST || Parameters.TESTING_SERVER ? "/char/list" : "/api/charList", this.requestData);
         this.client.sendRequest("/char/list", this.requestData);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onListComplete(data);
         }
         else
         {
            this.onTextError(data);
         }
      }
      
      public function makeRequestData() : Object
      {
         var params:Object = this.account.getCredentials();
         return params;
      }
      
      private function onListComplete(data:String) : void
      {
         var _local2:XML = new XML(data);
         this.charListData.dispatch(XML(data));
         WebAccount(this.account).userDisplayName = _local2.Account[0].Name;
         completeTask(true);
         if(this.retryTimer != null)
         {
            this.stopRetryTimer();
         }
      }
      
      private function onTextError(error:String) : void
      {
         this.setLoadingMessage.dispatch("<p align=\"center\">Load error, retrying</p>");
         if(error == "Account credentials not valid")
         {
            this.clearAccountAndReloadCharacters();
         }
         else
         {
            this.waitForASecondThenRetryRequest();
         }
      }
      
      private function clearAccountAndReloadCharacters() : void
      {
         this.client.setSendEncrypted(true);
         this.logger.info("GetUserDataTask invalid credentials");
         this.account.clear();
         this.client.complete.addOnce(this.onComplete);
//         this.client.sendRequest(Parameters.LOCAL_HOST || Parameters.TESTING_SERVER ? "/char/list" : "/api/charList", this.requestData);
         this.client.sendRequest("/char/list", this.requestData);
      }
      
      private function waitForASecondThenRetryRequest() : void
      {
         this.logger.info("GetUserDataTask error - retrying");
         this.retryTimer = new Timer(ONE_SECOND_IN_MS,1);
         this.retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
         this.retryTimer.start();
      }
      
      private function stopRetryTimer() : void
      {
         this.retryTimer.stop();
         this.retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
         this.retryTimer = null;
      }
      
      private function onRetryTimer(event:TimerEvent) : void
      {
         this.stopRetryTimer();
         this.sendRequest();
      }
   }
}
