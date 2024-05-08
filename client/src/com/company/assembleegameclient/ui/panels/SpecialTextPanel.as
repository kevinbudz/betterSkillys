package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;


public class SpecialTextPanel extends ButtonPanel{

    public function SpecialTextPanel(gs:GameSprite){
        super(gs, "Special Chest Empty.", "");
        removeChild(this.button_);
    }

}
}
