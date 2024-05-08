package kabam.rotmg.application.api
{
   public interface ApplicationSetup extends DebugSetup
   {
      function getBuildLabel() : String;

      function getAppEngineUrl() : String;
      function getAppEngineUrlEncrypted() : String;

      function useProductionDialogs() : Boolean;
      
      function areErrorsReported() : Boolean;
   }
}
