package kabam.rotmg.application.impl
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.application.api.ApplicationSetup;

   public class ReleaseSetup implements ApplicationSetup
   {
      private const CDN_APPENGINE:String = "";
      private const CDN_APPENGINE_S:String = "";
      private const TESTING_CDN_APPENGINE:String = "";

      private const BUILD_LABEL:String = "<font color=\"#C8A2C8\">version:</font> v1.0";
      private const TESTING_BUILD_LABEL:String = "<font color=\"#C8A2C8\">testing:</font> v1.0";

      public function getAppEngineUrl() : String
      {
         return Parameters.TESTING_SERVER ? TESTING_CDN_APPENGINE : CDN_APPENGINE;
      }

      public function getAppEngineUrlEncrypted() : String
      {
         return Parameters.TESTING_SERVER ? TESTING_CDN_APPENGINE : CDN_APPENGINE_S;
      }

      public function getBuildLabel() : String
      {
         return (Parameters.TESTING_SERVER ? TESTING_BUILD_LABEL : BUILD_LABEL).replace("{VERSION}",Parameters.BUILD_VERSION).replace("{MINOR}",Parameters.MINOR_VERSION).replace("{PATCH}",Parameters.PATCH_VERSION);
      }

      public function useProductionDialogs() : Boolean
      {
         return true;
      }

      public function areErrorsReported() : Boolean
      {
         return false;
      }

      public function isDebug():Boolean {
         return false;
      }
   }
}
