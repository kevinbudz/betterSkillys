package com.company.assembleegameclient.objects {

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.Panel;

import kabam.rotmg.Forge.components.ForgePanel;

public class Forge extends GameObject implements IInteractiveObject {


    public function Forge(arg1:XML) {
        super(arg1);
        this.isInteractive_ = true;
        this.setSize(150);
    }

    public function getPanel(gs:GameSprite) : Panel
    {
        return new ForgePanel(gs, this);
    }
}
}
