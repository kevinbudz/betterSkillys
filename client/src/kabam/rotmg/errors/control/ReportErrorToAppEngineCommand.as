package kabam.rotmg.errors.control
{
   import com.company.util.CapabilitiesUtil;
   import flash.events.ErrorEvent;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.application.api.ApplicationSetup;
   
   public class ReportErrorToAppEngineCommand
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var setup:ApplicationSetup;
      
      [Inject]
      public var event:ErrorEvent;
      
      private var error:*;
      
      public function ReportErrorToAppEngineCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.event.preventDefault();
         this.error = this.event["error"];
         this.getMessage();
         var output:Array = [];
         output.push("Build: " + this.setup.getBuildLabel());
         output.push("message: " + this.getMessage());
         output.push("stackTrace: " + this.getStackTrace());
         output.push(CapabilitiesUtil.getHumanReadable());
         this.client.setSendEncrypted(false);
         this.client.sendRequest("/clientError/add",{
            "text":output.join("\n"),
            "guid":this.account.getUserId()
         });
      }
      
      private function getMessage() : String
      {
         if(this.error is Error)
         {
            return this.error.message;
         }
         if(this.event != null)
         {
            return this.event.text;
         }
         if(this.error != null)
         {
            return this.error.toString();
         }
         return "(empty)";
      }
      
      private function getStackTrace() : String
      {
         return this.error is Error?Error(this.error).getStackTrace():"(empty)";
      }
   }
}
