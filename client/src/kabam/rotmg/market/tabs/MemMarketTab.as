package kabam.rotmg.market.tabs {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;

import kabam.rotmg.game.model.AddTextLineVO;

public class MemMarketTab extends Sprite
{

    public var gameSprite_:GameSprite;

    /* Not an actual tab, but provides the base variables and functions for each tab */
    public function MemMarketTab(gameSprite:GameSprite)
    {
        this.gameSprite_ = gameSprite;

        /* Draw vertical line */
        graphics.clear();
        graphics.lineStyle(2,6184542);
        graphics.moveTo(252,112);
        graphics.lineTo(252,525);
        graphics.lineStyle();
    }

    /* Clear */
    public function dispose() : void
    {
        this.gameSprite_ = null;

        /* Remove all children */
        for (var i:int = numChildren - 1; i >= 0; i--)
        {
            removeChildAt(i);
        }
    }
}
}
