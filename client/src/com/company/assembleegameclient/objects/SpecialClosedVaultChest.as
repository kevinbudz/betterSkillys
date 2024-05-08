package com.company.assembleegameclient.objects {

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.panels.SpecialTextPanel;
import com.company.assembleegameclient.ui.panels.TextPanel;

public class SpecialClosedVaultChest extends GameObject implements IInteractiveObject {

    public function SpecialClosedVaultChest(xml:XML){
        super(xml);
        isInteractive_ = false;
    }

    public function getPanel(param1:GameSprite):Panel {
        return new SpecialTextPanel(param1);
    }

}
}
