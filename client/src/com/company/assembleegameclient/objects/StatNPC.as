package com.company.assembleegameclient.objects {

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.Panel;

import kabam.rotmg.Forge.components.ForgePanel;
import kabam.rotmg.StatNPC.components.StatNPCPanel;

public class StatNPC extends GameObject implements IInteractiveObject {



    public function StatNPC(arg1:XML) {
        super(arg1);
        this.isInteractive_ = true;

    }

    public function getPanel(gs:GameSprite) : Panel
    {
        return new StatNPCPanel(gs);
    }
}
}
