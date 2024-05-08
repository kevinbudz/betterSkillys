package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.Panel;

import kabam.rotmg.Forge.components.ForgePanel;
import kabam.rotmg.StatNPC.components.StatNPCPanel;
import kabam.rotmg.market.MarketPanel;

public class MarketNPC extends GameObject implements IInteractiveObject {

    public function MarketNPC(xml:XML) {
        super(xml);
        this.isInteractive_ = true;
    }

    public function getPanel(gs:GameSprite):Panel {
        return new MarketPanel(gs);
    }
}
}
