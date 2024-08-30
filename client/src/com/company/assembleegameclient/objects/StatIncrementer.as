package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;

import com.company.assembleegameclient.ui.panels.Panel;

import kabam.rotmg.statIncrease.StatIncrementerPanel;

import kabam.rotmg.storage.PotionsPanel;


public class StatIncrementer extends GameObject implements IInteractiveObject {

    public function StatIncrementer(_arg1:XML) {
        super(_arg1);
        isInteractive_ = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return new StatIncrementerPanel(_arg1);
    }
}
}
