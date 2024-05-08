package kabam.rotmg.errors.control
{
   import flash.events.ErrorEvent;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LogErrorCommand
   {
       
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var event:ErrorEvent;
      
      public function LogErrorCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.logger.error(this.event.text);
         if(this.event["error"] && this.event["error"] is Error)
         {
            this.logErrorObject(this.event["error"]);
         }
      }
      
      private function logErrorObject(error:Error) : void
      {
         this.logger.error(error.message);
         this.logger.error(error.getStackTrace());
      }
   }
}
