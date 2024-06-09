package kabam.rotmg.application.impl {
import com.company.assembleegameclient.parameters.Parameters;

import kabam.rotmg.application.api.ApplicationSetup;

public class
LocalhostSetup implements ApplicationSetup {
    private const LOCALHOST:String = "http://127.0.0.1:8080";
    private const BUILD_LABEL:String = "<font color=\"#4254d6\">localhost.</font>";

    public function getAppEngineUrl():String {
        return LOCALHOST;
    }

    public function getAppEngineUrlEncrypted():String {
        return LOCALHOST;
    }

    public function getBuildLabel():String {
        return BUILD_LABEL;
    }

    public function useProductionDialogs():Boolean {
        return true;
    }

    public function areErrorsReported():Boolean {
        return false;
    }

    public function isDebug():Boolean {
        return true;
    }
}
}