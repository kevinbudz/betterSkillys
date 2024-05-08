package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;

import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.panels.EnginePanel;

public class Engine extends GameObject implements IInteractiveObject {

    public var currentValue_:int;
    public var engineTime_:int;

    public function Engine(_arg1:XML) {
        super(_arg1);
        isInteractive_ = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return new EnginePanel(_arg1, this);
    }
}
}
