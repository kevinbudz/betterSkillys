package kabam.rotmg.application {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.system.Capabilities;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.application.impl.LocalhostSetup;
import kabam.rotmg.application.impl.ReleaseSetup;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.IConfig;

public class ApplicationConfig implements IConfig {
    [Inject]
    public var injector:Injector;
    [Inject]
    public var root:DisplayObjectContainer;
    [Inject]
    public var loaderInfo:LoaderInfo;

    public function configure():void {
        var _local1:ApplicationSetup;
        if(!Parameters.LOCAL_HOST)
            _local1 = new ReleaseSetup();
        else
            _local1 = new LocalhostSetup();
        this.injector.map(ApplicationSetup).toValue(_local1);
    }
}
}

